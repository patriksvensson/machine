# Windows configuration

It's recommended to run this in two steps.

1. Install prereqs

There are some things that require a restart to work correctly,
so start by installing this.

```
> ./Install.ps1 -Prereqs
```

After everything have been done, restart the computer.
If the script ask you if you want to restart the computer, 
do that, and run the script again after reboot.

2. Install Apps and Ubuntu

```
> ./Install.ps1 -Apps -Ubuntu
```