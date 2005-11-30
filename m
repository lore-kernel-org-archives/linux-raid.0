From: Matt Darcy <kernel-lists@projecthugo.co.uk>
Subject: Linux Raid boot - stuck in a raid start loop - Advice
Date: Wed, 30 Nov 2005 09:41:54 +0000
Message-ID: <438D73E2.70502@projecthugo.co.uk>
Reply-To: kernel-lists@projecthugo.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

this is not a bug, this is a tricky situation due to a few bad choices 
on my part.

I am using a 8 port Sata controller (MV88SX5081 8-port SATA I PCI-X 
Controller) with the 2.6.12.6 kernel.

I am using the 3rd party sata_mv drivers as the sata_mv drivers included 
in the 2.6.15 kernel are not stable enough yet - This problem will go 
away when these drivers become stable. The 3rd party driver limits me to 
2.6.12.6.

The 3rd party driver can only be built as a module, and not directly 
into the kernel - just making that clear before people suggest building 
it into the kernel.

I have 6 Sata disks hanging off this controller that I am trying to put 
into a raid 5 configurations, which can then be included into LVM2.

I am using mdadm to try to migrate away from raidtools.

The problem I have is that the kernel boots sees the sata raid boot 
disks (on a diffect controller) and raid starts them - sysfs sees the 
raid devices as block devices and advertises them to udev - which then 
creates the /dev/md* entried (1 - 5) for the root disks, the file system 
is mounted and the init scripts run - which then loads the 3rd party 
module for the sata controller - which then makes the 6 sata disks 
visable, but becase the kernel was not aware of these disks at boot/raid 
time it does not start the raid array - which does not allow /dev/md6 to 
be created.

I then have to manuall create /dev/md6 - but even then my attempt to 
start the existing raid device fails (I believe this is because the 
kernel is not aware of these disks as raid devices). I can however 
recreate the raid device (mdadm --create) but this obviously wipes all 
the data - but it does however prove the the /dev/md6 device is 
functioning correctly.

Any advice on a process to get around this poor loop would be most 
appriciated, I have tested against the 2.6.15-rc2 kernel using the 
inbuild drivers and this problem goes away, /dev/md6 is created and the 
raid5 device is started and running well. The machine just becomes 
unstable when accessing the raid5 device using the driver from 2.6.15-rc2.

Many thanks,

Matt




