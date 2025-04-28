# import NtObjectManager
		
Import-Module NtObjectManager
$sym_path = "$env:SystemDrive\symbols"
	
# to help NtObjectManager parse RPC servers and resolve RPC procedures
	
# RPC interface for SCM is - 367ABB81-9844-35F1-AD32-98F038001003 and listens on \PIPE\svcctl
		
$server = Get-RpcServer C:\Windows\System32\services.exe -SymbolPath $sym_path | Where-Object { $_.InterfaceId -eq '367abb81-9844-35f1-ad32-98f038001003' }

# create a Client 
	
$client = Get-RpcClient $server
Connect-RpcClient -Client $client -EndpointPath "\pipe\svcctl" -ProtocolSequence ncacn_np -SecurityQualityOfService $(New-NtSecurityQualityOfService -ImpersonationLevel Impersonation)
			
# Create myserver Service 
	
$x = $client.ROpenSCManagerW([System.Net.Dns]::GetHostByName($env:computerName).HostName,"ServicesActive",[NtCoreLib.Win32.Service.ServiceControlManagerAccessRights]::CreateService)
	
$scmHandle = $x.p3
$BinaryPathName = '%COMSPEC% /C powershell -File C:\temp\service.ps1'
$y = $client.RCreateServiceW($scmHandle,'myserver','myserver',[NtCoreLib.Win32.Service.ServiceAccessRights]::All,[NtCoreLib.Win32.Service.ServiceType]::Win32OwnProcess,[NtCoreLib.Win32.Service.ServiceStartType]::Demand,[NtCoreLib.Win32.Service.ServiceErrorControl]::Normal,$BinaryPathName, $null, $null, $null, 0, 'LocalSystem',$null,0)
$ServiceCreationHandle = $y.p15
$client.RCloseServiceHandle($ServiceCreationHandle)

# start the newly created service 
			
$z = $client.ROpenServiceW($scmHandle,'myserver',[NtCoreLib.Win32.Service.ServiceAccessRights]::Start)
$OpenServiceHandle = $z.p3
$w = $client.RStartServiceW($OpenServiceHandle,$null,$null)
# RCloseServiceHandle (Opnum 0)
# $client.RCloseServiceHandle($OpenServiceHandle)