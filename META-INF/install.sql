CREATE TABLE {0}_task_definition (
  task_id int(11) NOT NULL default 0,
  name varchar(500) NOT NULL default '',
  description text NOT NULL,
  consent text,
  stimuli_order int(11) NOT NULL default 0,
  active int(1) NOT NULL default 0,
  PRIMARY KEY  (task_id)
);

CREATE TABLE {0}_participant_attribute_definition (
 task_id int(11) NOT NULL default 0,
 attribute VARCHAR(50) NOT NULL DEFAULT '',
 type VARCHAR(100) NOT NULL DEFAULT '',
 style VARCHAR(20) NOT NULL DEFAULT '',
 label VARCHAR(250) NOT NULL DEFAULT '',
 description VARCHAR(500) NOT NULL DEFAULT '',
 display_order INTEGER UNSIGNED NOT NULL DEFAULT 0,
 PRIMARY KEY(task_id, attribute)
);

CREATE TABLE {0}_participant_attribute_option (
 task_id int(11) NOT NULL default 0,
 attribute VARCHAR(50) NOT NULL DEFAULT '',
 value varchar(200) NOT NULL DEFAULT '',
 description VARCHAR(500) NOT NULL DEFAULT '',
 list_order INTEGER NOT NULL DEFAULT 0,
 PRIMARY KEY(task_id, attribute, value)
);

CREATE TABLE {0}_question_definition (
 task_id int(11) NOT NULL default 0,
 question VARCHAR(50) NOT NULL DEFAULT '',
 type VARCHAR(100) NOT NULL DEFAULT '',
 style VARCHAR(20) NOT NULL DEFAULT '',
 label VARCHAR(250) NOT NULL DEFAULT '',
 description VARCHAR(500) NOT NULL DEFAULT '',
 display_order INTEGER UNSIGNED NOT NULL DEFAULT 0,
 PRIMARY KEY(task_id, question)
);

CREATE TABLE {0}_question_option (
 task_id int(11) NOT NULL default 0,
 question VARCHAR(50) NOT NULL DEFAULT '',
 value varchar(200) NOT NULL DEFAULT '',
 description VARCHAR(500) NOT NULL DEFAULT '',
 list_order INTEGER NOT NULL DEFAULT 0,
 PRIMARY KEY(task_id, question, value)
);

CREATE TABLE {0}_stimulus_definition (
 task_id int(11) NOT NULL default 0,
 stimulus_id int(11) NOT NULL default 0,
 label VARCHAR(100) NOT NULL DEFAULT '',
 list_order int(11) NOT NULL default 0,
 PRIMARY KEY(task_id, stimulus_id)
);

CREATE TABLE {0}_experiment (
  experiment_id int(11) NOT NULL AUTO_INCREMENT,
  task_id int(11) NOT NULL default 0,
  signature VARCHAR(250) NOT NULL DEFAULT '',
  started DATETIME NULL,
  finished DATETIME NULL,
  PRIMARY KEY  (experiment_id)
);

CREATE TABLE {0}_experiment_participant_attribute (
  experiment_id int(11) NOT NULL default 0,
  attribute varchar(50) NOT NULL DEFAULT '',
  value TEXT,
  PRIMARY KEY(experiment_id, attribute)
);

CREATE TABLE {0}_experiment_stimulus (
  experiment_id int(11) NOT NULL default 0,
  stimulus_id int(11) NOT NULL default 0,
  stimulus_ordinal varchar(50) NOT NULL DEFAULT 0,
  started DATETIME NULL,
  PRIMARY KEY(experiment_id, stimulus_id)
);

CREATE TABLE {0}_experiment_stimulus_answer (
  experiment_id int(11) NOT NULL default 0,
  stimulus_id int(11) NOT NULL default 0,
  question VARCHAR(50) NOT NULL DEFAULT '',
  answer TEXT,
  PRIMARY KEY(experiment_id, stimulus_id, question)
);

/* version 0.2 */
ALTER TABLE {0}_participant_attribute_definition 
      ADD COLUMN required INTEGER UNSIGNED NOT NULL DEFAULT 0;

/* version 0.3 */
ALTER TABLE {0}_task_definition ADD COLUMN comment text;
ALTER TABLE {0}_task_definition ADD COLUMN finished text;

/* version 0.31 */
ALTER TABLE {0}_experiment ADD COLUMN comment text;

/* version 0.42 */
ALTER TABLE {0}_task_definition MODIFY COLUMN description text NULL;
ALTER TABLE {0}_task_definition MODIFY COLUMN consent text NULL;

/* version 0.51 */
ALTER TABLE {0}_task_definition ADD COLUMN email  varchar(500) NOT NULL default '';

/* version 0.53 */
ALTER TABLE {0}_experiment_stimulus MODIFY COLUMN stimulus_ordinal INTEGER NOT NULL DEFAULT 0;

/* version 0.56 */
ALTER TABLE {0}_participant_attribute_definition
 MODIFY COLUMN style VARCHAR(100) NOT NULL DEFAULT '';
ALTER TABLE {0}_question_definition
 MODIFY COLUMN style VARCHAR(100) NOT NULL DEFAULT '';

/* version 0.571 */
ALTER TABLE {0}_question_definition 
      ADD COLUMN required INTEGER UNSIGNED NOT NULL DEFAULT 0;

/* version 0.573 */
ALTER TABLE {0}_question_definition 
      ADD COLUMN scored INTEGER UNSIGNED NOT NULL DEFAULT 0;

/* version 0.575 */
CREATE TABLE {0}_stimulus_answer (
 stimulus_id int(11) NOT NULL default 0,
 task_id int(11) NOT NULL default 0,
 question VARCHAR(50) NOT NULL DEFAULT '',
 answer VARCHAR(100) NOT NULL DEFAULT '',
 PRIMARY KEY(stimulus_id,task_id,question)
);

/* version 0.576 */

ALTER TABLE {0}_task_definition ADD COLUMN valid_signature_pattern VARCHAR(50) NOT NULL DEFAULT '';
ALTER TABLE {0}_task_definition ADD COLUMN before_start text NULL;

/* version 0.577 */

ALTER TABLE {0}_task_definition ADD COLUMN stimulus_preamble text NULL;
