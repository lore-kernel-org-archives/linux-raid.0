From: AndyLiebman@aol.com
Subject: Serial ATA cards
Date: Tue, 4 May 2004 15:17:16 EDT
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <d7.99d8d9d.2dc9463c@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Does anyone have any experience with an 8-port (or higher) Serial ATA Host 
Adapter card? I'm looking for something that will JUST give me access to the 
SATA disks, and NOT give me hardware (or pseudo-hardware) RAID. Can anybody 
suggest a card that can be used for Linux Software RAID? 

I had great luck with the on-board Silicon Image-based SATA ports that came 
on a SuperMicro motherboard. But I need up to 16-ports so I'm going to need 
ports on a PCI-X card. 

I have just tried two cards with little success. A 3ware Escolade 8506 and a 
new Promise SATA II 150 SX8 card (I got a pre-production sample). I can't get 
the 3ware card to show up the individual drives within Linux. I'm now making a 
hardware RAID before booting up; hopefully Linux will see that.  

I have a similar problem with the Promise card. The Promise card uses a new 
"block device" driver called Carmel. The drives show up in my Kernel log -- see 
below -- but because they are just seen as generic devices, I'm told I may 
have to create devices with 'mknod' in order to access them. I have no idea how 
to do that. Can someone explain the process. I know the "major" number has to 
be 160. But how about the minor numbers? And what exactly do I have to enter 
for each device? 

I think the Promise card has great promise (no pun intended) for software 
RAID. It's relatively cheap (US $250) and doesn't contain any on-board 
processing. It's just a host adapter meant for software RAID. But I'm stumped as to how 
to get access to the drives. 

By the way, I'm using the 2.6.6 kernel with Mandrake 10. 

Here are my kernel logs: 

May  5 01:00:54 localhost kernel: carmel version 0.8
May  5 01:00:54 localhost kernel: carmel(0000:05:01.0): found 8
interesting devices
May  5 01:00:54 localhost kernel: carmel(0000:05:01.0): port 0 device
490234752 sectors
May  5 01:00:54 localhost kernel: carmel(0000:05:01.0): port 0 device
"Maxtor 7Y250M0"
May  5 01:00:54 localhost kernel: carmel(0000:05:01.0): port 1 device
490234752 sectors
May  5 01:00:54 localhost kernel: carmel(0000:05:01.0): port 1 device
"Maxtor 7Y250M0"
May  5 01:00:54 localhost kernel: carmel(0000:05:01.0): port 2 device
490234752 sectors
May  5 01:00:54 localhost kernel: carmel(0000:05:01.0): port 2 device
"Maxtor 7Y250M0"
May  5 01:00:54 localhost kernel: carmel(0000:05:01.0): port 3 device
490234752 sectors
May  5 01:00:54 localhost kernel: carmel(0000:05:01.0): port 3 device
"Maxtor 7Y250M0"
May  5 01:00:54 localhost kernel: carmel(0000:05:01.0): port 4 device
490234752 sectors
May  5 01:00:54 localhost kernel: carmel(0000:05:01.0): port 4 device
"Maxtor 7Y250M0"
May  5 01:00:54 localhost kernel: carmel(0000:05:01.0): port 5 device
490234752 sectors
May  5 01:00:54 localhost kernel: carmel(0000:05:01.0): port 5 device
"Maxtor 7Y250M0"
May  5 01:00:54 localhost kernel: carmel(0000:05:01.0): port 6 device
490234752 sectors
May  5 01:00:54 localhost kernel: carmel(0000:05:01.0): port 6 device
"Maxtor 7Y250M0"
May  5 01:00:54 localhost kernel: carmel(0000:05:01.0): port 7 device
490234752 sectors
May  5 01:00:54 localhost kernel: carmel(0000:05:01.0): port 7 device
"Maxtor 7Y250M0"
May  5 01:00:55 localhost kernel:  /dev/carmel/0_0: unknown partition
table
May  5 01:00:55 localhost kernel:  /dev/carmel/0_1: unknown partition
table
May  5 01:00:55 localhost kernel:  /dev/carmel/0_2: unknown partition
table
May  5 01:00:55 localhost kernel:  /dev/carmel/0_3: unknown partition
table
May  5 01:00:55 localhost kernel:  /dev/carmel/0_4: unknown partition
table
May  5 01:00:55 localhost kernel:  /dev/carmel/0_5: unknown partition
table
May  5 01:00:55 localhost kernel:  /dev/carmel/0_6: unknown partition
table
May  5 01:00:55 localhost kernel:  /dev/carmel/0_7: unknown partition
table
May  5 01:00:55 localhost kernel: carmel(0000:05:01.0): 8 ports
activated
May  5 01:00:55 localhost kernel: carmel0: pci 0000:05:01.0, ports 8, io
fc400000, irq 96, major 160
May  5 01:00:55 localhost kernel: SCSI subsystem initialized

Regards, 
Andy Liebman
