function create-branch(){
    Param(
          [parameter(
                position=0
            )]
          $name)

    git checkout -b $name
    git push -u origin $name
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

    echo "deleted remote"

    git branch -d $name

    echo "delete local"
}