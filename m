From: Caspar Smit <c.smit@truebit.nl>
Subject: Re: Missing superblocks from almost all my drives
Date: Tue, 25 Mar 2014 09:54:12 +0100
Message-ID: <CAKFseUNH=GNj2GUf-twb5tFa6MTeFeHVj8iFH9UR4wQGod4ECw@mail.gmail.com>
References: <5CF8E6CF-6A14-4AFA-A265-766134B7A381@rightthisminute.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5CF8E6CF-6A14-4AFA-A265-766134B7A381@rightthisminute.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Munoz <mark.munoz@rightthisminute.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Mark,

I think i have hit the same a few days back.
I created a RAID6, added LVM and FS. Everything worked perfectly until
i rebooted and all my md superblocks were gone.

In the end i narrowed it down to that i created GPT partition tables
on all my disks (which were 3TB so i figured a GPT partition table
should be added)
To create the tables i did: parted /dev/sdX mklabel gpt

Then i used the WHOLE devices as MD devices (so no partitions)

What I found out is that when creating a GPT partition table the MBR
becomes 'protective'
You can check this with the gdisk (GPT fdisk) utility:

gdisk /dev/sdX will show something like:

Partition table scan:
  MBR: Protective
  BSD: not present
  APM: not present
  GPT: Present

I could be completely wrong but my guess is that the MD superblock
will be written (partly) in the MBR area (which is protective in the
GPT case and will be lost after a reboot)
Also note that mdadm gives a warning that a partition table will be
lost or unusable after using the whole device and mdadm finds a
partition table!

I tried several methods to recover the array to no avail and since
there was no data on it (luckily it was a test MD) i re-created the MD
from scratch (after removing the GPT table offcourse)

Maybe someone will know a way to recover your arrays (if possible)

Hope this helps,
Caspar
Met vriendelijke groet,

Caspar Smit
Systemengineer
True Bit
Dorsvlegelstraat 13
1445 PA Purmerend

e: c.smit@truebit.nl
t: +31(0)299 410 410
w: www.truebit.nl

KvK: 577 256 64
Bank: NL26 INGB 0008 0044 77


2014-03-24 23:55 GMT+01:00 Mark Munoz <mark.munoz@rightthisminute.com>:
> Hello!
>
> I have a rather complex setup.  I have 1 RAID 6 array with 128k blocks 1.2 metadata with 25 drives 1 of which is a hot spare and is md0.
> I have a a second RAID 6 array with 128k blocks 1.2 metadata with 20 drives 1 of which is a hot spare is md1
> I then have a striped RAID set made up from md0 and md1 which makes md2.  All 128k block size and 1.2 metadata.
>
> Earlier this week two drives in md1 failed back to back within moments of each other.  I let it rebuild over the weekend to get it have only 1 degraded disk before I took out the two bad drives and attempting to get the array to clean and another hot spare.  It all shut down properly but on reboot md0 rebuilt as normal but md1 didn't, which is what I sort of expected as it was degraded.  However I was having a tough time trying to figure which of my two new drives were what device because according the mdstat it partially assembled the array but it was short 3 drives instead of just 2.  I then stopped md1 and was going to walk through each device with examine and see what was what.  However after stopping md1 all the drives display this:
>
> [root@kingpin ~]# mdadm --examine /dev/sdad
> /dev/sdad:
>    MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)
>
>
> Getting examine info on the md0 drives reported everything fine.  So I shut down again thinking it may be smart to write down the serials of the two new drives and then just --assemble --force it without the two new drives.
>
> Now when it boots all but 3 of my drives have missing superblock information.  I have read rebooting sometimes brings it back but I have rebooted about 6 times with no luck.  I have rebooted with just my known good drives, I have rebooted putting back in the bad drives, booted with new blank drives as well and each time I am getting the same output as above on examine.
>
> The way these drives boots is fairly predictable so I am fairly certain /dev/sd[b-z] belong to md0 and /dev/sda[a-t] belong to md1 but since md1 has had failed drives I think the order is now out of whack.
>
> Are my options to now --create --assume-clean then just test a bunch of different device orders until I get the correct setup?  I am running CentOS 6.4 Final and mdadm v3.2.5 and Linux version 2.6.32-358.el6.x86_64 (mockbuild@c6b8.bsys.dev.centos.org) (gcc version 4.4.7 20120313 (Red Hat 4.4.7-3) (GCC) ) #1 SMP Fri Feb 22 00:31:26 UTC 2013
>
> Here at the commands I used to create all three arrays initially:
>
> mdadm --create --verbose /dev/md0 --chunk=128 --level=6 --raid-devices=24 /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl /dev/sdm /dev/sdn /dev/sdo /dev/sdp /dev/sdq /dev/sdr /dev/sds /dev/sdt /dev/sdu /dev/sdv /dev/sdw /dev/sdx /dev/sdy --spare-devices=1 /dev/sdz
>
> mdadm --create --verbose /dev/md1 --chunk=128 --level=6 --raid-devices=19 /dev/sdaa /dev/sdab /dev/sdac /dev/sdad /dev/sdae /dev/sdaf /dev/sdag /dev/sdah /dev/sdai /dev/sdaj /dev/sdak /dev/sdal /dev/sdam /dev/sdan /dev/sdao /dev/sdap /dev/sdaq /dev/sdar /dev/sdas --spare-devices=1 /dev/sdat
>
> mdadm --create --verbose /dev/md2 --chunk=128 --level=0 --raid-devices=2 /dev/md0 /dev/md1
>
> Thanks so much for your help!
>
> Mark Munoz--
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
