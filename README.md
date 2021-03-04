# README

This project is done for the coding test with the recruitment agency Sterning, the root page was set to the import page.
Once the data was imported via selecting csv in the root page or the /users/import page, it would then display a button that would take the user to the data table.
in the /users/table page, it displays the data in a table with a search box, pagination and sort functionality.

##setup
1. clone the repository.
2. runs ```docker-compose up --build```
3. runs ```docker exec -it sentia_coding_test_web_1 npm install```
4. runs ```docker exec -it sentia_coding_test_web_1 rails db:create db:migrate```