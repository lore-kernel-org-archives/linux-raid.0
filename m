From: "T. Ermlich" <pelegrine@gmx.net>
Subject: Re: Broken harddisk
Date: Sat, 29 Jan 2005 16:34:35 +0100
Message-ID: <41FBAD0B.2080408@gmx.net>
References: <41FAD73F.1070504@gmx.net> <Pine.LNX.4.56.0501291218200.25299@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0501291218200.25299@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'd like to say Thanks to everyone replied till now! :-)

Gordon Henderson scribbled on 29.01.2005 13:46:
> On Sat, 29 Jan 2005, T. Ermlich wrote:
> 
>>Hello there,
>>
>>I just got here from http://cgi.cse.unsw.edu.au/~neilb/Contact ...
>>Hopefully I'm more/less right here.
>>
>>Several month ago I set-up an raid1 using mdadm.
>>Two drives (/dev/sda & /dev/sdb, each one is an 160GB Samsung SATA
>>disks) are used, and provide now /dev/md0, /dev/md1, /dev/md2 &
>>/dev/md3. In november 2004 I upgraded to mdadm 1.8.1.
> 
> Drop 1.8.1 and get 1.8.0. I understand 1.8.1 has some experimental code
> and not designed to be used for real.
> 
>>This afternoon, about 9 hours ago, /dev/sda broke down ... no chnace to
>>get it working again .. :(
>>
>>My question now is: what does I have to do now?
> 
> Well, go through the procedure to remove the disk and put a new one back
> in...

Ok ... as the broken disks stops the system, and during boot procedure
the system hung, I had to remove it (disconnected the cables).

>>The system is up and running, so I'd do an actual backup of the most
>>important data ... but how to 'replace' the broken drive, and 'restore'
>>the data content there (sorry, as english is not my native language I
>>have no idea how to explain it correctly).
>>Is there a way to do so, or does I have to create an raid1 from scratch,
>>and copy all data from /dev/md0-3 there manually?
> 
> You should not have to copy it - thats the whole point of it all, however,
> RAID is not a substitute for proper backups, so make sure you do those
> backups now and regularly in the future.

Backups are done very night (3 am), so I just made a backup of the
latest changes (between ~3am and 15:30pm).

> OK - here are the basic steps - you may have to modify them as you haven't
> posted enough detail for me to work it out to your exact system.
> 
> I'm assuing that you have partitioned each disk with 4 partitions and both
> disks are partitioned identically and you are combining the same partition
> of each device into the md devices. (eg. /dev/md0 is made from /dev/sda1
> and /dev/sdb1) This is reasonably "sane" and I'm sure lots of people do it
> this way (I do, but I'm a small sample :) If you aren't doing it this way,
> then this won't work for you, but you may be able to adapt it for your
> needs.

That's right: each harddisk is partitioned absolutly identically, like:
     0 - 19456 - /dev/sda1 - extended partition
     1 - 6528  - /dev/sda5 - /dev/md0
  6529 - 9138  - /dev/sda6 - /dev/md1
  9139 - 16970 - /dev/sda7 - /dev/md2
16971 - 19456 - /dev/sda8 - /dev/md3
And after doing those partitionings I 'combined' them to act as raid1.

> Firstly, get mdadm 1.8.0 as I mentioned above.
> 
> Look at /proc/mdstat.
> 
> See if all 4 md devices have a failed device in it. If the disk is really
> dead, this is likely to be the case, if it's not, then you'll need to fail
> each partition in each md device:
> 
> So make make sure that each md device has the failed disk really failed,
> you can do:
> 
>   mdadm --fail /dev/md0 /dev/sda1
>   mdadm --fail /dev/md1 /dev/sda2
>   mdadm --fail /dev/md2 /dev/sda3
>   mdadm --fail /dev/md3 /dev/sda4
> 
> Next, you need to remove the failed disk from each array
> 
>   mdadm --remove /dev/md0 /dev/sda1
>   mdadm --remove /dev/md1 /dev/sda2
>   mdadm --remove /dev/md2 /dev/sda3
>   mdadm --remove /dev/md3 /dev/sda4
> 
> Strictly speaking, you don't have to do this - you can just power down and
> put a new disk in, but I feel this is "cleaner" and hopefully leaves the
> system in a stable and known state when you do power down.

Habven't done that, b/c the system was already down ...

> At this point you can power down the machine and physically remove the
> drive and replace it with a new, identical unit.

So I did: replaced the broken one (Samsung SP1614C) with an identical drive.

> Reboot your PC. If it would normally boot off sda, you have to persuade it
> to boot off sdb. You might need to alter the bios to do this, ot maybe
> not... All BIOSes and controllers have their own little ideas about how
> this is done.
> 
> If it boots off another drive (eg. an IDE drive) then you should be fine.
> If it does boot off sda, then I hope you used the raid-extra-boot command
> in lilo.conf (and tested it...) If you are using grub, I can't be of any
> assistance there as I don't use it.

I have two additional IDE drives in that system.
/dev/hda contains some data, and is the boot drive, /dev/hdb contains 
some less important data.

> You should now have the system running with the data intact on sdb and all
> the md devices working and mounted as normal.
> 
> Now you have to re-partition the new sda identical to sdb. If they are the
> same make and size, you can use this:
> 
>   sfdisk -d /dev/sdb | sfdisk /dev/sda

This didn't work proper, so I partitioned the new drive manually.

> Now, tell the raid code to re-mirror the drives:
> 
>   mdadm --add /dev/md0 /dev/sda1
>   mdadm --add /dev/md1 /dev/sda2
>   mdadm --add /dev/md2 /dev/sda3
>   mdadm --add /dev/md3 /dev/sda4

Now some new trouble starts ...?
'mdadm --add /dev/md0 /dev/sda1' started just fine - but exactly at 50% 
it started giving tons of errors, like:
[quote]
Jan 29 16:10:24 suse92 kernel: Additional sense: Unrecovered read error 
- auto reallocate failed
Jan 29 16:10:24 suse92 kernel: end_request: I/O error, dev sdb, sector 
52460420
Jan 29 16:10:25 suse92 kernel: ata2: status=0x51 { DriveReady 
SeekComplete Error }
Jan 29 16:10:25 suse92 kernel: ata2: error=0x40 { UncorrectableError }
Jan 29 16:10:25 suse92 kernel: scsi1: ERROR on channel 0, id 0, lun 0, 
CDB: Read (10) 00 03 20 7b 85 00 02 f9 00
Jan 29 16:10:25 suse92 kernel: Current sdb: sense key Medium Error
Jan 29 16:10:25 suse92 kernel: Additional sense: Unrecovered read error 
- auto reallocate failed
Jan 29 16:10:25 suse92 kernel: end_request: I/O error, dev sdb, sector 
52460421
Jan 29 16:10:26 suse92 kernel: ata2: status=0x51 { DriveReady 
SeekComplete Error }
Jan 29 16:10:26 suse92 kernel: ata2: error=0x40 { UncorrectableError }
Jan 29 16:10:26 suse92 kernel: scsi1: ERROR on channel 0, id 0, lun 0, 
CDB: Read (10) 00 03 20 7b 86 00 02 f8 00
Jan 29 16:10:26 suse92 kernel: Current sdb: sense key Medium Error
Jan 29 16:10:26 suse92 kernel: Additional sense: Unrecovered read error 
- auto reallocate failed
Jan 29 16:10:26 suse92 kernel: end_request: I/O error, dev sdb, sector 
52460422
Jan 29 16:10:27 suse92 kernel: ata2: status=0x51 { DriveReady 
SeekComplete Error }
Jan 29 16:10:27 suse92 kernel: ata2: error=0x40 { UncorrectableError }
Jan 29 16:10:27 suse92 kernel: scsi1: ERROR on channel 0, id 0, lun 0, 
CDB: Read (10) 00 03 20 7b 87 00 02 f7 00
Jan 29 16:10:27 suse92 kernel: Current sdb: sense key Medium Error
Jan 29 16:10:27 suse92 kernel: Additional sense: Unrecovered read error 
- auto reallocate failed
Jan 29 16:10:27 suse92 kernel: end_request: I/O error, dev sdb, sector 
52460423
[/quote]

> then run:
> 
>    watch -n1 cat /proc/mdstat
> 
> and wait for it to finish, however the system is fully usable all during
> this process.

[quote]
Every 1,0s: cat /proc/mdstat 
                              Sat Jan 29 16:08:50 2005

Personalities : [raid1]
md3 : active raid1 sdb8[1]
       19960640 blocks [2/1] [_U]

md2 : active raid1 sdb7[1]
       62910400 blocks [2/1] [_U]

md1 : active raid1 sdb6[1]
       20964672 blocks [2/1] [_U]

md0 : active raid1 sdb5[1] sda5[2]
       52436032 blocks [2/1] [_U]
       [==========>..........]  recovery = 50.0% (26230016/52436032) 
finish=121.7min speed=1050K/sec
unused devices: <none>
[/quote]

Can I stop that process for /dev/md0, and start with /dev/md1 (just to 
compare if its a problem with that partition only, or an general problem 
(so that eg. the second drive has problens, too)?

btw: does mdadm also format the partitions?

> If you can't power the machine down, and have hot-swappable drives in
> proper caddys, then there is a way to tell the kernel that you are
> removing the drive and adding a new one in, however it's probably safer if
> you can do it while powered down.
> 
> If this doesn't make sense, post back the output of /proc/mdstat and
> fdisk -l
> 
> Goos luck!
> 
> Gordon

Have a nice day
Torsten

