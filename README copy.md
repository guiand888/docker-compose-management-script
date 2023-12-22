# Docker Compose Management Script (docker-mgmt.sh)

This script helps to manage a small server running a series of Docker Compose projects. It is a time-saver when rebooting or updating projects, eliminating the need to iterate through directories or type in commands one by one with the `-f projectX/docker-compose.yml` argument.

## Key Features

- Automatically detects Docker Compose project directories and offers to manage them individually or collectively.
- Simplifies the Docker Compose command execution.
- Handles special container dependencies, like the `swag` container, which should start last and stop first.

## Setup and Usage

Place the script (`docker-mgmt.sh`) at the root of your Docker Compose projects' directory structure. For instance:

```
| docker
|___ docker-mgmt.sh
|___ project1
|___ project2
|___ project3
|___ etc.
```

Each project should have its own directory with a standard named Docker Compose file (`docker-compose.yml`).

To run the script, navigate to the root directory (`docker` in the example above) and run:

```bash
./docker-mgmt.sh
```

The script will then prompt you with a series of options for managing your Docker Compose projects. 

## Customization

The script takes special care of the `swag` container. In my infrastructure, this container needs to be started last and stopped first due to dependencies on other projects' subnetworks. 

If you do not use `swag` or if it does not need to be treated differently, no change is needed; the script will handle it like any other container. If your setup includes another container that needs similar special handling, you can replace `swag` with the name of that container in the script.
  
## Contributions

Contributions to this script are welcome. Feel free to submit issues or pull requests on the GitHub repository. 

Please note that this script is provided "as is", without warranty of any kind, express or implied.

Sure, here's the updated license paragraph:

## License

This script is provided under the terms of the GNU General Public License v3.0. See the `LICENSE` file in the repository for more information.

