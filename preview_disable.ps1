# Thanks to AveYo for his Powershell Script Snippet to change Registry Key Owner: https://github.com/AveYo/LeanAndMean/blob/main/reg_own.ps1

function reg_own { param ( $key, $recurse='', $user='S-1-5-32-544', $owner='', $acc='Allow', $perm='FullControl', [switch]$list )
  $D1=[uri].module.gettype('System.Diagnostics.Process')."GetM`ember"('SetPrivilege',42)[0]; $u=$user; $o=$owner; $p=524288
  'SeSecurityPrivilege','SeTakeOwnershipPrivilege','SeBackupPrivilege','SeRestorePrivilege' |% {$D1.Invoke($null, @("$_",2))}
  $reg=$key-split':?\\',2; $key=$reg-join'\'; $HK=gi -lit Registry::$($reg[0]) -force; $re=$recurse; $in=(1,0)[$re-eq'Inherit']
  $own=$o-eq''; if($own){$o=$u}; $sid=[Security.Principal.SecurityIdentifier]; $w='S-1-1-0',$u,$o |% {new-object $sid($_)}
  $r=($w[0],$p,1,0,0),($w[1],$perm,1,0,$acc) |% {new-object Security.AccessControl.RegistryAccessRule($_)}; function _own($k,$l) {
  $t=$HK.OpenSubKey($k,2,'TakeOwnership'); if($t) { try {$n=$t.GetAccessControl(4)} catch {$n=$HK.GetAccessControl(4)}
  $u=$n.GetOwner($sid); if($own-and $u) {$w[2]=$u}; $n.SetOwner($w[0]); $t.SetAccessControl($n); $d=$HK.GetAccessControl(2)
  $c=$HK.OpenSubKey($k,2,'ChangePermissions'); $b=$c.GetAccessControl(2); $d.RemoveAccessRuleAll($r[1]); $d.ResetAccessRule($r[0])
  $c.SetAccessControl($d); if($re-ne'') {$sk=$HK.OpenSubKey($k).GetSubKeyNames(); foreach($i in $sk) {_own "$k\$i" $false}}
  if($re-ne'') {$b.SetAccessRuleProtection($in,1)}; $b.ResetAccessRule($r[1]); if($re-eq'Delete') {$b.RemoveAccessRuleAll($r[1])}
  $c.SetAccessControl($b); $b,$n |% {$_.SetOwner($w[2])}; $t.SetAccessControl($n)}; if($l) {return $b|fl} }; _own $reg[1] $list
} # lean & mean snippet by AveYo, 2022.01.15

#######################
# .ps1 script content #
#######################

## Define TI sid (TrustedInstaller)
$TI = (sc.exe showsid TrustedInstaller)-split': '|?{$_-like'*S-1-*'}

## Define USER sid before asking for elevation since it gets replaced for limited accounts
if ($null -eq $USER) {$USER = ((whoami /user)-split' ')[-1]}

## Ask for elevation passing USER
$admin = fltmc; if ($LASTEXITCODE) {
  $arg = "-nop -c `$USER='$USER'; iex((gc '$($MyInvocation.MyCommand.Path-replace'''','''''')')-join'`n')"
  start powershell -verb runas -args $arg; exit
}


$key ="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PropertySystem\SystemPropertyHandlers"
reg_own -key $key -user $USER -acc Allow -perm FullControl -list
Rename-ItemProperty -Path $key -Name ".mov" -NewName ".mov_"

Rename-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PropertySystem\PropertyHandlers\.mov" -NewName ".mov_"

reg_own -key $key -user $USER -acc Allow -perm FullControl -list
Rename-ItemProperty -Path $key -Name ".ts" -NewName ".ts_"

Rename-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PropertySystem\PropertyHandlers\.ts" -NewName ".ts_"
