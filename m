From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 recovery dramas.
Date: Fri, 27 Jun 2008 20:28:40 +1000
Message-ID: <18532.49368.984453.933541@notabene.brown>
References: <48608E9B.6080904@curly.ii.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mark Davies on Tuesday June 24
Sender: linux-raid-owner@vger.kernel.org
To: Mark Davies <mark@curly.ii.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday June 24, mark@curly.ii.net wrote:
> Hi all,
> 
> Hoping to find some information to help me recover my software raid5 array.

You are in a rather stick situation.

Neither  sdd1 or sde1 know where they belong in the array.  If they
did, then  "mdadm --assemble --force" would probably be able to help
you (I should test that).  But they don't.

Do you have any boot logs from before you started the reshape that
show which device fills which slot in the array?

sdd1 has an event count of 0.  That is really odd.  Any idea how that
happened?  Did you remove it from the array and try to add it back?
That wouldn't have been a good idea.

I'm at a bit of a loss as to what to suggest.  The data is mostly
there, but getting it back is tricky.

What you need to do is 
   choose one of sdd and sde which you think is device  '3'
     (sdc is 0, sdb is 1, sda is 2).
   rewrite the metadata to assert this fact
   assemble the array read-only with sd[abc] and the one you choose
   read the data to make sure it is all where
   switch to read-write so the reshape competes, leaving you with
    a degraded array
   add the other drive and let it recover.

The early steps in particular are not easy.

I'll try to find some time to experiment, but I cannot promise
anything.

If you can remember everything you tried to do (maybe in
.bash_history) that might help.

NeilBrown



> 
> Some background information first (excuse the hostname)
> 
> uname -a
> Linux Fuckyfucky3 2.6.18-4-686 #1 SMP Wed May 9 23:03:12 UTC 2007 i686 
> GNU/Linux
> 
> 
> It's a debian box that initially had 4 disks in a software raid5 array.
> 
> The problem started when I attempted to add another disk and grow the 
> array.  I'd already done this from 3-4 disks using the instruction on 
> this page:  "http://scotgate.org/?p=107".
> 
> However this time I unmounted the volume, but didn't do a fsck before 
> starting.  I also discovered that for some reason mdadm wasn't 
> monitoring the array.
> 
> Bad mistakes obviously - and I hope I've learnt from them.
> 
> Short version is that two of the disks had errors on them, and so mdadm 
> disabled those disks about 50MB into the reshape.  Both failed SMART 
> tests subsequently.
> 
> I bought two new disks, and used dd-recue to make copies of them, which 
> seemed to work well.
> 
> Now however I can't restart the array.
> 
> I can see all 5 superblocks:
> 
> :~# mdadm --examine /dev/sd?1
> /dev/sda1:
>            Magic : a92b4efc
>          Version : 01
>      Feature Map : 0x4
>       Array UUID : 43eff327:8d1aa506:c0df2849:005c003f
>             Name : 'Fuckyfucky3':1
>    Creation Time : Sun Dec 23 01:28:08 2007
>       Raid Level : raid5
>     Raid Devices : 5
> 
>      Device Size : 976767856 (465.76 GiB 500.11 GB)
>       Array Size : 3907069952 (1863.04 GiB 2000.42 GB)
>        Used Size : 976767488 (465.76 GiB 500.10 GB)
>     Super Offset : 976767984 sectors
>            State : clean
>      Device UUID : 5b38c5a2:798c6793:91ad6d1e:9cfee153
> 
>    Reshape pos'n : 143872 (140.52 MiB 147.32 MB)
>    Delta Devices : 1 (4->5)
> 
>      Update Time : Fri May 16 23:55:29 2008
>         Checksum : 5354498d - correct
>           Events : 1420762
> 
>           Layout : left-symmetric
>       Chunk Size : 128K
> 
>      Array Slot : 3 (failed, 1, failed, 2, failed, 0)
>     Array State : uuU__ 3 failed
> /dev/sdb1:
>            Magic : a92b4efc
>          Version : 01
>      Feature Map : 0x4
>       Array UUID : 43eff327:8d1aa506:c0df2849:005c003f
>             Name : 'Fuckyfucky3':1
>    Creation Time : Sun Dec 23 01:28:08 2007
>       Raid Level : raid5
>     Raid Devices : 5
> 
>      Device Size : 976767856 (465.76 GiB 500.11 GB)
>       Array Size : 3907069952 (1863.04 GiB 2000.42 GB)
>        Used Size : 976767488 (465.76 GiB 500.10 GB)
>     Super Offset : 976767984 sectors
>            State : clean
>      Device UUID : 673ba6d4:6c46fd55:745c9c93:3fa8bf21
> 
>    Reshape pos'n : 143872 (140.52 MiB 147.32 MB)
>    Delta Devices : 1 (4->5)
> 
>      Update Time : Fri May 16 23:55:29 2008
>         Checksum : 8ad75f10 - correct
>           Events : 1420762
> 
>           Layout : left-symmetric
>       Chunk Size : 128K
> 
>      Array Slot : 1 (failed, 1, failed, 2, failed, 0)
>     Array State : uUu__ 3 failed
> /dev/sdc1:
>            Magic : a92b4efc
>          Version : 01
>      Feature Map : 0x4
>       Array UUID : 43eff327:8d1aa506:c0df2849:005c003f
>             Name : 'Fuckyfucky3':1
>    Creation Time : Sun Dec 23 01:28:08 2007
>       Raid Level : raid5
>     Raid Devices : 5
> 
>      Device Size : 976767856 (465.76 GiB 500.11 GB)
>       Array Size : 3907069952 (1863.04 GiB 2000.42 GB)
>        Used Size : 976767488 (465.76 GiB 500.10 GB)
>     Super Offset : 976767984 sectors
>            State : clean
>      Device UUID : 99b87c50:a919bd63:599a135f:9af385ba
> 
>    Reshape pos'n : 143872 (140.52 MiB 147.32 MB)
>    Delta Devices : 1 (4->5)
> 
>      Update Time : Fri May 16 23:55:29 2008
>         Checksum : 78ab38c3 - correct
>           Events : 1420762
> 
>           Layout : left-symmetric
>       Chunk Size : 128K
> 
>      Array Slot : 5 (failed, 1, failed, 2, failed, 0)
>     Array State : Uuu__ 3 failed
> /dev/sdd1:
>            Magic : a92b4efc
>          Version : 01
>      Feature Map : 0x4
>       Array UUID : 43eff327:8d1aa506:c0df2849:005c003f
>             Name : 'Fuckyfucky3':1
>    Creation Time : Sun Dec 23 01:28:08 2007
>       Raid Level : raid5
>     Raid Devices : 5
> 
>      Device Size : 976767856 (465.76 GiB 500.11 GB)
>       Array Size : 3907069952 (1863.04 GiB 2000.42 GB)
>        Used Size : 976767488 (465.76 GiB 500.10 GB)
>     Super Offset : 976767984 sectors
>            State : clean
>      Device UUID : 89201477:8e950d20:9193016d:f5c9deb0
> 
>    Reshape pos'n : 143872 (140.52 MiB 147.32 MB)
>    Delta Devices : 1 (4->5)
> 
>      Update Time : Fri May 16 23:55:29 2008
>         Checksum : 5fc43e52 - correct
>           Events : 0
> 
>           Layout : left-symmetric
>       Chunk Size : 128K
> 
>      Array Slot : 6 (failed, 1, failed, 2, failed, 0)
>     Array State : uuu__ 3 failed
> /dev/sde1:
>            Magic : a92b4efc
>          Version : 01
>      Feature Map : 0x4
>       Array UUID : 43eff327:8d1aa506:c0df2849:005c003f
>             Name : 'Fuckyfucky3':1
>    Creation Time : Sun Dec 23 01:28:08 2007
>       Raid Level : raid5
>     Raid Devices : 5
> 
>      Device Size : 976767856 (465.76 GiB 500.11 GB)
>       Array Size : 3907069952 (1863.04 GiB 2000.42 GB)
>        Used Size : 976767488 (465.76 GiB 500.10 GB)
>     Super Offset : 976767984 sectors
>            State : clean
>      Device UUID : 89b53542:d1d820bc:f2ece884:4785869a
> 
>    Reshape pos'n : 143872 (140.52 MiB 147.32 MB)
>    Delta Devices : 1 (4->5)
> 
>      Update Time : Fri May 16 23:55:29 2008
>         Checksum : c89dd220 - correct
>           Events : 1418968
> 
>           Layout : left-symmetric
>       Chunk Size : 128K
> 
>      Array Slot : 6 (failed, 1, failed, 2, failed, 0)
>     Array State : uuu__ 3 failed
> 
> 
> 
> 
> When I try to start the array, I get:
> 
> ~# mdadm --assemble --verbose /dev/md1 /dev/sda1 /dev/sdb1 /dev/sdc1 
> /dev/sdd1 /dev/sde1
> mdadm: looking for devices for /dev/md1
> mdadm: /dev/sda1 is identified as a member of /dev/md1, slot 2.
> mdadm: /dev/sdb1 is identified as a member of /dev/md1, slot 1.
> mdadm: /dev/sdc1 is identified as a member of /dev/md1, slot 0.
> mdadm: /dev/sdd1 is identified as a member of /dev/md1, slot -1.
> mdadm: /dev/sde1 is identified as a member of /dev/md1, slot -1.
> mdadm: added /dev/sdb1 to /dev/md1 as 1
> mdadm: added /dev/sda1 to /dev/md1 as 2
> mdadm: no uptodate device for slot 3 of /dev/md1
> mdadm: no uptodate device for slot 4 of /dev/md1
> mdadm: added /dev/sdd1 to /dev/md1 as -1
> mdadm: failed to add /dev/sde1 to /dev/md1: Device or resource busy
> mdadm: added /dev/sdc1 to /dev/md1 as 0
> mdadm: /dev/md1 assembled from 3 drives and -1 spares - not enough to 
> start the array.
> 
> 
> 
> 
> Any help would be much appreciated.   If I can provide any more 
> information, just ask.
> 
> As to why /dev/sde1 is busy, I don't know.  lsof shows no files open.
> 
> 
> Regards,
> 
> 
> Mark.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
