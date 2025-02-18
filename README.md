# Easy Voting Script for FiveM (Easy_Voting)

This FiveM script allows you to conduct an election within your server. Players can cast their votes for a party, and the results will be released at a later time. The script uses a MySQL database to store players' votes and manage the election.

## Features

- **Voting**: Players can vote for a party while the election period is active.
- **Time-bound Voting**: The election can only take place between a specified start and end date.
- **Results**: Election results are only revealed after the election period has ended.
- **Multilingual Support**: The script supports multiple languages such as English and German.
- **Debug Mode**: There is an optional debug mode that outputs detailed information to the console.

## Installation

1. **Set up MySQL Database**:
    - The script requires a MySQL database. Make sure you have a working MySQL connection.
    - Add the following table to your MySQL database:

    ```sql
    CREATE TABLE IF NOT EXISTS votes (
        id INT AUTO_INCREMENT PRIMARY KEY,
        identifier VARCHAR(50) NOT NULL,
        party VARCHAR(50) NOT NULL
    );
    ```

2. **Install the Script**:
    - Upload the script to your `resources` directory.
    - Ensure you are using `mysql-async` or `oxmysql` to communicate with the MySQL database.

3. **Configuration**:
    - Open the `config.lua` file and configure the election parameters:

    ```lua
    Config = {
        VoteStartDate = "20.02.2025",  -- Start date of the election
        ResultsDate = "22.02.2025",    -- Date when results will be released
        Parties = {                    -- List of parties players can vote for
            {name = "Party A", label = "Party A"},
            {name = "Party B", label = "Party B"},
        },
        Debug = true,                  -- Enable debug mode (optional)
        Language = "en",               -- Language: "de" for German, "en" for English
    }

    Config = {}

    Config.Parties = {  -- List of parties players can vote for
        {name = "ParteiA", description = "Description A"},
        {name = "ParteiB", description = "Description B"},
        {name = "ParteiC", description = "Description C"}
    }

    Config.VoteLocations = {
        vector3(-545.4446, -203.8230, 38.2152)
    }

    Config.Language = "en"  -- Language: "de" for German, "en" for English

    -- Date in Format TT.MM.JJJJ
    Config.VoteStartDate = "18.02.2025"    -- Start date of the election
    Config.ResultsDate   = "20.02.2025"    -- Date when results will be released

    Config.Debug = false -- -- Enable debug mode (optional)
    ```

4. **Start the Script**:
    - Add the script to your `server.cfg`:

    ```bash
    start Easy_Voting
    ```

## Usage

- Players can cast their vote for a party using the command `/vote`.
- A player can only vote once. If they try to vote multiple times, a notification will appear informing them that they have already voted.
- Election results will only be available after the set election period ends.

## Example

1. A player casts their vote for "Party A" by typing `/vote`.
2. The script stores the vote in the database.
3. After the election period ends, the results can be viewed on a marker.

## Events

- **`wahl:checkVoteStatus`**: Checks whether the election is currently active.
- **`wahl:vote`**: Allows a player to vote for a party.
- **`wahl:checkResultsAvailability`**: Checks if the election results are available.
- **`wahl:showResults`**: Displays the election results.

## Language

The script currently supports both German and English. You can change the language in the `config.lua` file under `Config.Language`.

**Available Texts**:
- `vote_not_started` – Message when the election has not yet started.
- `vote_ended` – Message when the election has ended.
- `already_voted` – Message when a player has already voted.
- `vote_success` – Message when the vote is successfully cast.
- `vote_failure` – Message when there is an error in voting.

## Troubleshooting

- **Error: "attempt to index a nil value"**: This error occurs when the start or results date is not set correctly. Ensure that the date values in `Config.VoteStartDate` and `Config.ResultsDate` are in the "DD.MM.YYYY" format.
  
- **Votes not being saved**: Check if your MySQL database is set up correctly and ensure that the connection to `mysql-async` or `oxmysql` is working.

## License

This script is licensed under the MIT License. See [LICENSE](LICENSE) for more details.

## Contact

- Developer: [Your Name or GitHub Profile]
- GitHub: [Your GitHub Link]
