From: Alvin Oga <aoga@Maggie.Linux-Consulting.com>
Subject: Re: RAID as backup ...
Date: Fri, 20 Sep 2002 14:01:51 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.3.96.1020920135652.11583A-100000@Maggie.Linux-Consulting.com>
References: <3D8B201B.1040602@leenx.co.za>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3D8B201B.1040602@leenx.co.za>
To: "C.Lee Taylor" <leet@leenx.co.za>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


hi ya lee

- like the idea of using ide disks to backup other ide disks..

- i would NOT use raid1 ( mirroring ) for backup data
	- i would rather have 2 backup servers with 2 sets of backup disks
	than one backup server w/ mirror disks

- backup disks should be offline and unmountable except during the backup
 process

- if you use raid1, and take one disk and hide it, your backup is
  basically rendered dead(no longer raid) till you put that disk back in
  again to backup more data to the "raid1" backup system
	- just use the one disk in that same removable tray and
	you are more likely to have a suitable/usable backup system

- always have different backup disks for daily backup, weekly backups
  monthly backups and full backups... never use the same disks for it all
	( lose that disk, and you lose everything )

http://www.Linux-Backup.net
	- free backup scripts
	- 8x 120GB ide disks in one 1U chassis --> lots of fun(pain)

c ya
alvin

> 	I intend to use RAID IDE to replace old, slow and problematic tape backup.
> 
> 	This is just theory at the moment, and I would like you to help punch wholes 
> in my idea ...
> 
> 	Using normal IDE drives (3), USB 2.0 and an external housing and 5.25" 
> mobile racks (2), I am playing with creating a RAID 1 setup.
> 
> 	If I remove one of the IDE drives from my RAID system.  Could I put it way 
> in a safe and use it as a backup?
> 
> Mailed
> Lee
> 

