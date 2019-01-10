#This is a slightly hacky powershell script
#It will wait until docker has started, and attempt to correctly build the MDS app
$timeout_minutes = 10
function Check-Port {
    param (
        [int]$port
    )
    $result = Test-Connection -ComputerName localhost -Port $port
    $result.TcpTestSucceeded
}
function Port-Wait {
    param (
        [int]$port
    )
    $count = 0
    $open = Check-Port $port
    while($open -ne $true){
        if($count -ge $timeout_minutes){
            write-host 'Timeout!'
            Exit-PSSession
        }
        write-host 'Waiting for port $port (This may take a while)'
        Start-Sleep -seconds 60
        $open = Check-Port $port
        $count++
    }
    
}


$ServiceName = 'com.docker.service'
$DockerService = Get-Service -Name $ServiceName

$Running = $DockerService.Status -eq 'Running'
$count = 0

while ($Running -ne $true) {
    if($count -ge $timeout_minutes){
        write-host 'Timeout!'
        Exit-PSSession
    }
    write-host 'Waiting for Docker to start... (this may take a while)'
    Start-Sleep -seconds 60
    $DockerService = Get-Service -Name $ServiceName
    $Running = $DockerService.Status -eq 'Running'
    $count++
}
write-host 'Docker started...'
write-host 'Cleaning...'
make clean
write-host 'Building...'
docker-compose build --force-rm
write-host 'Spinning up containers...'
docker-compose up -d
write-host 'Waiting for keycloak server...'
Port-Wait 8080
write-host 'Creating admin user... (admin/admin)'
docker exec -it mds_keycloak /tmp/keycloak-local-user.sh
write-host 'frontend will be available at http://localhost:3000'
write-host 'backend will be available at http://localhost:5000'
write-host 'Postgresql will be available at http://localhost:5432'
write-host 'Wait up to 5min or longer for MDS webapp to be available.'
write-host 'If it loads with errors, wait longer for the backend to become available and refresh.'
