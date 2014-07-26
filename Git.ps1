function create-branch(){
    Param(
          [parameter(
                position=0
            )]
          $name)

    git checkout -b $name
    git push -u origin $name
}

function delete-local-merged{
  $command = "git branch --merged | grep -v -E '\\*|develop|master'"

  echo "Will delete:"

  iex $command

  $response = Read-Host "continue? y/n"

  if($response -eq "y"){
    $command = $command + " | xargs git branch -D"

    iex $command 
    
    echo ""
    echo "--- current branches -- "
    echo ""

    iex "git branch"
  }
}

function delete-branch(){
    Param(
          [parameter(
                position=0
            )]
          $name)

    git checkout master

    echo "switched to master"

    git push origin :$name

    echo "deleted remote " $name

    git branch -d $name

    echo "delete local " $name
}

function git-add-all(){
	git add --all .
}
