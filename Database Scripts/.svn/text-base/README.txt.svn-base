Regrowing the GPI database from an acorn.

Step 0: Export data out of existing database.

Step 1: Run delete script to delete all data from the database. Alternatively, if possible, drop the database, by running drop_gpidb*.sql.

Step 2: Run C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727\aspnet_regsql.exe, with the -W switch, to create the membership database.

Step 3: If the database was dropped, recreate the database with the create_gpidb*.sql script. Then, run the script assign_gpiuser2gpidb*.sql to set up the user. Else, go to next step.

Step 4: Import data into blank database.