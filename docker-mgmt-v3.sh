#!/bin/bash

function prompt_command() {
  clear
  echo "Which command do you want to execute?"
  echo "1. up -d"
  echo "2. down"
  echo "3. pull"
  echo "4. pull && down && up -d"
  echo "5. restart"
  echo "6. down all projects"
  echo "7. exit"
  read command
}

prompt_command

while [[ $command -ne 7 ]]; do
  # Decide on the command to run
  case $command in
    1)
      cmd="up -d"
      ;;
    2)
      cmd="down"
      ;;
    3)
      cmd="pull"
      ;;
    4)
      cmd="pull"
      cmd2="down"
      cmd3="up -d"
      ;;
    5)
      cmd="restart"
      ;;
    6)
      cmd="down"
      downAllProjects="true"
      ;;
    *)
      echo "Invalid option"
      prompt_command
      continue
      ;;
  esac

  function prompt_mode() {
  clear
    # Prompt for how to proceed
    if [ "$downAllProjects" != "true" ]; then
      echo "How do you want to proceed?"
      echo "1. List mode"
      echo "2. Prompt mode"
      echo "3. back"
      read mode
    else
      mode=1
    fi
  }

  prompt_mode

  while [[ $mode -ne 3 ]]; do
    # Iterate through each directory in the current location
    dirs=(*/)
    case $mode in
      1)
        # List mode
        if [ "$downAllProjects" = "true" ]; then
          eval "docker compose -f swag/docker-compose.yml $cmd"
          for dir in "${dirs[@]}"; do
            if [ "$dir" != "swag/" ]; then
              eval "docker compose -f ${dir}docker-compose.yml $cmd"
              if [ "$command" -eq 4 ]; then
                eval "docker compose -f ${dir}docker-compose.yml $cmd2"
                eval "docker compose -f ${dir}docker-compose.yml $cmd3"
              fi
            fi
          done
        else
          while true; do
            echo "Select a project to execute:"
            select dir in "${dirs[@]}" "Back" "Quit"; do
              if [[ "${dir}" == "Back" ]]; then
                break 2
              elif [[ $REPLY = $(( ${#dirs[@]}+2 )) ]] || [[ "${dir}" == "Quit" ]]; then
                clear
                echo "Exiting."
                exit
              elif ((REPLY > 0 && REPLY <= ${#dirs[@]})); then
                eval "docker compose -f ${dir}docker-compose.yml $cmd"
                if [ "$command" -eq 4 ]; then
                  eval "docker compose -f ${dir}docker-compose.yml $cmd2"
                  eval "docker compose -f ${dir}docker-compose.yml $cmd3"
                fi
                break
              else
                echo "Invalid option"
              fi
            done
          done
        fi
        break
        ;;
      2)
        # Prompt mode
        for dir in "${dirs[@]}"; do
          if [ "$cmd" == "up -d" ] && [ "$dir" == "swag/" ]; then
            continue
          fi
          if [ "$cmd" == "down" ] && [ "$dir" == "swag/" ]; then
            eval "docker compose -f ${dir}docker-compose.yml $cmd"
            break
          fi
          echo "Do you want to execute the project $dir? (Y/n/back)"
          read answer
          # Default to "Yes" if no answer is given
          if [ -z "$answer" ]; then
            answer="y"
          fi
          if [ "$answer" = "back" ]; then
            break 2
          elif [ "$answer" = "y" ]; then
            # Run docker compose on the yml file within the directory
            eval "docker compose -f ${dir}docker-compose.yml $cmd"
            if [ "$command" -eq 4 ]; then
              eval "docker compose -f ${dir}docker-compose.yml $cmd2"
              eval "docker compose -f ${dir}docker-compose.yml $cmd3"
            fi
          fi
        done
        if [ "$answer" != "back" ] && [ "$cmd" == "up -d" ]; then
          eval "docker compose -f swag/docker-compose.yml $cmd"
        fi
        break
        ;;
      *)
        echo "Invalid option"
        prompt_mode
        continue
        ;;
    esac
  done
  prompt_command
done

