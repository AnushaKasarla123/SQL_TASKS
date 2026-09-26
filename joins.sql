CREATE DATABASE  JointSystemDB;
USE JointSystemDB;

CREATE TABLE Bodies (
    body_id INT PRIMARY KEY AUTO_INCREMENT,
    body_name VARCHAR(100) NOT NULL,
    world_x DOUBLE DEFAULT 0,
    world_y DOUBLE DEFAULT 0,
    world_z DOUBLE DEFAULT 0
);

CREATE TABLE Joints (
    joint_id INT PRIMARY KEY AUTO_INCREMENT,
    joint_type VARCHAR(20) NOT NULL,
    parent_body_id INT,
    child_body_id INT,
    FOREIGN KEY (parent_body_id) REFERENCES Bodies(body_id),
    FOREIGN KEY (child_body_id) REFERENCES Bodies(body_id)
);

CREATE TABLE RevoluteJoints (
    joint_id INT PRIMARY KEY,
    axis_x DOUBLE NOT NULL,
    axis_y DOUBLE NOT NULL,
    axis_z DOUBLE NOT NULL,
    current_angle DOUBLE DEFAULT 0,
    min_angle DOUBLE,
    max_angle DOUBLE,
    FOREIGN KEY (joint_id) REFERENCES Joints(joint_id)
    ON DELETE CASCADE
);

CREATE TABLE PrismaticJoints (
    joint_id INT PRIMARY KEY,
    axis_x DOUBLE NOT NULL,
    axis_y DOUBLE NOT NULL,
    axis_z DOUBLE NOT NULL,
    current_displacement DOUBLE DEFAULT 0,
    min_displacement DOUBLE,
    max_displacement DOUBLE,
    FOREIGN KEY (joint_id) REFERENCES Joints(joint_id)
    ON DELETE CASCADE
);

CREATE TABLE KinematicChain (
    chain_id INT PRIMARY KEY AUTO_INCREMENT,
    chain_name VARCHAR(100) NOT NULL
);

CREATE TABLE ChainJoints (
    chain_id INT,
    joint_id INT,
    joint_order INT,
    PRIMARY KEY (chain_id, joint_id),
    FOREIGN KEY (chain_id) REFERENCES KinematicChain(chain_id)
    ON DELETE CASCADE,
    FOREIGN KEY (joint_id) REFERENCES Joints(joint_id)
    ON DELETE CASCADE
);

INSERT INTO Bodies (body_name)
VALUES
('Base'),
('Arm1'),
('Arm2'),
('Arm3');

INSERT INTO Joints
(joint_type, parent_body_id, child_body_id)
VALUES
('REVOLUTE', 1, 2),
('PRISMATIC', 2, 3),
('REVOLUTE', 3, 4);

INSERT INTO RevoluteJoints
(joint_id, axis_x, axis_y, axis_z, current_angle, min_angle, max_angle)
VALUES
(1, 0, 0, 1, 30, -180, 180),
(3, 0, 1, 0, 45, -90, 90);

INSERT INTO PrismaticJoints
(joint_id, axis_x, axis_y, axis_z, current_displacement, min_displacement, max_displacement)
VALUES
(2, 1, 0, 0, 5, 0, 10);

INSERT INTO KinematicChain (chain_name)
VALUES
('Robot Arm Chain');

INSERT INTO ChainJoints
(chain_id, joint_id, joint_order)
VALUES
(1, 1, 1),
(1, 2, 2),
(1, 3, 3);

SELECT * FROM Bodies;

SELECT * FROM Joints;

SELECT * FROM RevoluteJoints;

SELECT * FROM PrismaticJoints;

SELECT * FROM KinematicChain;

SELECT * FROM ChainJoints;

SELECT
    cj.joint_order,
    j.joint_id,
    j.joint_type,
    p.body_name AS parent_body,
    c.body_name AS child_body
FROM ChainJoints cj
JOIN Joints j
    ON cj.joint_id = j.joint_id
JOIN Bodies p
    ON j.parent_body_id = p.body_id
JOIN Bodies c
    ON j.child_body_id = c.body_id
WHERE cj.chain_id = 1
ORDER BY cj.joint_order;

SELECT
    j.joint_id,
    j.joint_type,
    p.body_name AS parent_body,
    c.body_name AS child_body,
    r.axis_x,
    r.axis_y,
    r.axis_z,
    r.current_angle,
    r.min_angle,
    r.max_angle
FROM Joints j
JOIN RevoluteJoints r
    ON j.joint_id = r.joint_id
JOIN Bodies p
    ON j.parent_body_id = p.body_id
JOIN Bodies c
    ON j.child_body_id = c.body_id;

SELECT
    j.joint_id,
    j.joint_type,
    p.body_name AS parent_body,
    c.body_name AS child_body,
    pj.axis_x,
    pj.axis_y,
    pj.axis_z,
    pj.current_displacement,
    pj.min_displacement,
    pj.max_displacement
FROM Joints j
JOIN PrismaticJoints pj
    ON j.joint_id = pj.joint_id
JOIN Bodies p
    ON j.parent_body_id = p.body_id
JOIN Bodies c
    ON j.child_body_id = c.body_id;

UPDATE RevoluteJoints
SET current_angle = 60
WHERE joint_id = 1;

UPDATE PrismaticJoints
SET current_displacement = 7
WHERE joint_id = 2;

SELECT
    j.joint_id,
    j.joint_type,
    r.current_angle AS angle,
    NULL AS displacement
FROM Joints j
JOIN RevoluteJoints r
    ON j.joint_id = r.joint_id

UNION ALL

SELECT
    j.joint_id,
    j.joint_type,
    NULL AS angle,
    p.current_displacement AS displacement
FROM Joints j
JOIN PrismaticJoints p
    ON j.joint_id = p.joint_id

ORDER BY joint_id;

SELECT
    kc.chain_name,
    cj.joint_order,
    j.joint_type,
    p.body_name AS parent_body,
    c.body_name AS child_body
FROM KinematicChain kc
JOIN ChainJoints cj
    ON kc.chain_id = cj.chain_id
JOIN Joints j
    ON cj.joint_id = j.joint_id
JOIN Bodies p
    ON j.parent_body_id = p.body_id
JOIN Bodies c
    ON j.child_body_id = c.body_id
ORDER BY cj.joint_order;