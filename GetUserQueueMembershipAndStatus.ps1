# run this once to connect to MS Teams
Connect-MicrosoftTeams

# Configure the user we're looking up
$upn = "user@domain.com"

# Perform search for user and collect all queues
$user = Get-CsOnlineUser -Identity $upn
$allQueues = Get-CsCallQueue -WarningAction:SilentlyContinue

# Build a list of queues this user is a member of.
$membershipArray = @()
foreach ($queue in $allQueues)
{
    foreach ($agent in $queue.Agents)
    {
        if($user.Identity -eq $agent.ObjectId)
        {
            $membershipArray += New-object  PSObject -Property([ordered]@{Queue = $queue.Name; OptedIn = $agent.OptIn})
        }
    }
}

# Output the list of queues
if($membershipArray.Count -eq 0)
{
    Write-Host "User $upn has no queue membership"
}
else
{
    $membershipArray
}