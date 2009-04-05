From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: rebuilding raided root partition
Date: Sun, 05 Apr 2009 08:54:21 +0200
Message-ID: <871vs7h9pe.fsf@frosties.localdomain>
References: <49D81804.6070102@traversetechnologies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49D81804.6070102@traversetechnologies.com> (Miles Fidelman's
	message of "Sat, 04 Apr 2009 22:31:32 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Miles Fidelman <mfidelman@traversetechnologies.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Miles Fidelman <mfidelman@traversetechnologies.com> writes:

> Hi Folks,
>
> I've been busily recovering from a bad crash (strangely enough, a
> single disk drive failure that brought down an entire raided
> environment, with spares).
>
> I've pretty much recovered and rebuilt everything, EXCEPT....
>
> my root partition is raided, and is now running only on its single
> spare drive:
>
> -----
> server1:~# more /proc/mdstat   md2 : inactive sdd3[0] sdb3[2]
>     195318016 blocks
>
> server1:~# mdadm --detail /dev/md2  [details omitted]
> /dev/md2:
>    Raid Level : raid1
>   Device Size : 97659008 (93.13 GiB 100.00 GB)
>  Raid Devices : 2
> Total Devices : 2
> Preferred Minor : 2
>   Persistence : Superblock is persistent
>
>        State : active, degraded
> Active Devices : 0
> Working Devices : 2
> Failed Devices : 0
> Spare Devices : 2
>
>   Number   Major   Minor   RaidDevice State
>      0       8       51        0      spare rebuilding   /dev/sdd3
>      1       0        0        -      removed
>
>      2       8       19        -      spare   /dev/sdb3

You have 0 active devices and only spare devices. So there is nothing
to rebuild from. Looks like on top of your one drive failing you also
have a second drive that failed in that array or wasn't added to the
raid. Or the raid was running degraded before your drive failure.


> note the line "spare rebuilding" - that's the result of: mdadm --add
> /dev/md2 /dev/sdd3
> unfortunately, it doesn't seem to really be doing anything - it's been
> saying "rebuilding" for several hours
>
> now for another mirror device, doing an mdadm --add, kicked off a
> resync (as indicated by cat /proc/mdstat) that concluded just fine
> with a rebuilt mirror array
>
> but for this array, it just shows "active, degraged, and rebuilding"
> in mdadm --detail, and "inactive" in /proc/mdstat
>
> about the only difference I can see, is that the array that rebuilt
> started with one primary drive, to which I added a 2nd drive, and then
> a spare; the one that's hanging is running on a spare, and it thinks
> I'm adding another spare  (note: both serve as physical volumes
> underlying LVM)

It is not running, it is inactive. There is nothing left to run.

> so..... on to questions:
>
> 1. What's going on?
>
> 2. Any suggestions on how to reassemble the array?  mdadm --assemble
> /dev/md2 tells me I need to deactivate the device, but then, it's my /
> volume - which leaves me a little stumped

Ar you sure your / is actualy /dev/md2? Maybe you booted from
/dev/sda3 or /dev/sdc3? I recommend booting a rescue/life CD and
then look for a partition containing an active drive for md2 so you
can rebuild your raid.


Also did you know that you can run a raid1 with 3 active drives? That
way you are potected against 2 drive failures and don't need to wait
for the spare drive to resync before having fault tolerance if one
drive fails.

> Thanks very much,
>
> Miles Fidelman

MfG
        Goswin
