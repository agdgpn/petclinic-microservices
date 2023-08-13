#!/bin/bash
# Data initialization for customer, vets and visits services after starting mysql container.
customers_path=${PETCLINIC_HOME}/spring-petclinic-customers-service/src/main/resources/db/mysql
vets_path=$PETCLINIC_HOME/spring-petclinic-vets-service/src/main/resources/db/mysql
visits_path=$PETCLINIC_HOME/spring-petclinic-visits-service/src/main/resources/db/mysql
mysql --defaults-extra-file=my.cnf  < $customers_path/schema.sql
mysql --defaults-extra-file=my.cnf  < $customers_path/data.sql
mysql --defaults-extra-file=my.cnf  < $vets_path/schema.sql
mysql --defaults-extra-file=my.cnf  < $vets_path/data.sql
mysql --defaults-extra-file=my.cnf  < $visits_path/schema.sql
mysql --defaults-extra-file=my.cnf  < $visits_path/data.sql
