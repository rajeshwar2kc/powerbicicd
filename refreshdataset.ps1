$datasetname = "OpportunitiesReportDynamic365V2"
$workspacename = $env:dev_workspacename

$clientsec = "$(client_secret)" | ConvertTo-SecureString -AsPlainText -Force

$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:client_id, $clientsec
Connect-PowerBIServiceAccount -ServicePrincipal -Credential $credential -TenantID $env:tenant_id

$workspace = Get-PowerBIWorkspace -Name $workspacename

$DatasetRespone = Invoke-PowerBIRestMethod -Url "groups/$($workspace.id)/datasets" -Method Get | ConvertFrom-Json

$datasets = $DatasetRespone.value

foreach($dataset in $datasets){
    if($dataset.name -eq $datasetname){
        $datasetid = $dataset.id;
        break;
    }
}

Invoke-PowerBIRestMethod -Url "groups/$($workspace.id)/datasets/$($datasetid)/Default.TakeOver" -Method POST
Invoke-PowerBIRestMethod -Url "groups/$($workspace.id)/datasets/$($datasetid)/refreshes" –Method POST –Verbos