From: "C.Lee Taylor" <leet@leenx.co.za>
Subject: Re: RAID as backup ...
Date: Mon, 23 Sep 2002 10:45:29 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D8ED4A9.7080203@leenx.co.za>
References: <Pine.LNX.3.96.1020920135652.11583A-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Alvin Oga <aoga@Maggie.Linux-Consulting.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alvin Oga wrote:
> hi ya lee
	Greetings ...

> - like the idea of using ide disks to backup other ide disks..
	Myself, IDE drives have become so cheap, that to purchase Tapes of the same 
size cost the same, plus if hardware ( tape drive ) is stolen ( whole 
server ) or destoried ( thinking of buring down the computer room ;-} ) you 
might have a problem replacing the Tape Drive and good tape drives also 
cost a fortune, which could easily put this inplace.  You backups then 
worth zero, and all the tapes big chunk of platic.

	If I use IDE drives, I can move these drives into workstations as bigger 
hard drives come out and put the newer bigger drives into my backup pool. 
Seems easy enough.

> - i would NOT use raid1 ( mirroring ) for backup data
> 	- i would rather have 2 backup servers with 2 sets of backup disks
> 	than one backup server w/ mirror disks
	Problem been, that to put down another server would cost large some of 
money, the idea behide RAID is inexpensive devices.

> - backup disks should be offline and unmountable except during the backup
>  process
> - if you use raid1, and take one disk and hide it, your backup is
>   basically rendered dead(no longer raid) till you put that disk back in
>   again to backup more data to the "raid1" backup system
> 	- just use the one disk in that same removable tray and
> 	you are more likely to have a suitable/usable backup system
	I throught about using hotplug scripts to backup the system when the drive 
is brought online, but this would be I would have to make sure that no 
files are open at the time we start the backup and then this could mean the 
server should not be used while this is happening, which means down time.

	Also, ( I am still testing so I am not 100% sure yet ), if running system 
dies, I could just put the last disk in as the primary drive and hope it 
boots ( as I said, not finished testing ), no install and restore.

> - always have different backup disks for daily backup, weekly backups
>   monthly backups and full backups... never use the same disks for it all
> 	( lose that disk, and you lose everything )
	Well, it up to the site on how many differant backups they want or can 
afford.  All that needs to be done, is the new disk need to be prepaired 
before use.

> http://www.Linux-Backup.net
> 	- free backup scripts
> 	- 8x 120GB ide disks in one 1U chassis --> lots of fun(pain)
	Will look at this site, thanks.


>>	I intend to use RAID IDE to replace old, slow and problematic tape backup.
>>
>>	This is just theory at the moment, and I would like you to help punch wholes 
>>in my idea ...
>>
>>	Using normal IDE drives (3), USB 2.0 and an external housing and 5.25" 
>>mobile racks (2), I am playing with creating a RAID 1 setup.
>>
>>	If I remove one of the IDE drives from my RAID system.  Could I put it way 
>>in a safe and use it as a backup?


Mailed
Lee

