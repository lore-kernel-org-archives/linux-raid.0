From: Mark Davies <mark@curly.ii.net>
Subject: Re: raid5 recovery dramas.
Date: Thu, 26 Jun 2008 10:43:22 +0800
Message-ID: <4863024A.4030909@curly.ii.net>
References: <48608E9B.6080904@curly.ii.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48608E9B.6080904@curly.ii.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

No takers?  Is there a different list anyone can suggest I repost this 
to, and any extra information I could include?

I found a link to a mdadm create/permutation script

http://linux-raid.osdl.org/index.php/Permute_array.pl

Would that appear to be useful in my situation?

My problematic array was created with mdadm version:

mdadm --version
mdadm - v2.5.6 - 9 November 2006

If I was to boot with a LiveCD (to get around this:

mdadm: failed to add /dev/sde1 to /dev/md1: Device or resource busy

error, would the version of mdadm have to be the same, or just more recent?

Oh, and I'm willing to send a sixpack of beer or whatever in thanks.  :)



Regards,


Mark.



Mark Davies wrote:
> Hi all,
> 
> Hoping to find some information to help me recover my software raid5 array.
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
>           Magic : a92b4efc
>         Version : 01
>     Feature Map : 0x4
>      Array UUID : 43eff327:8d1aa506:c0df2849:005c003f
>            Name : 'Fuckyfucky3':1
>   Creation Time : Sun Dec 23 01:28:08 2007
>      Raid Level : raid5
>    Raid Devices : 5
> 
>     Device Size : 976767856 (465.76 GiB 500.11 GB)
>      Array Size : 3907069952 (1863.04 GiB 2000.42 GB)
>       Used Size : 976767488 (465.76 GiB 500.10 GB)
>    Super Offset : 976767984 sectors
>           State : clean
>     Device UUID : 5b38c5a2:798c6793:91ad6d1e:9cfee153
> 
>   Reshape pos'n : 143872 (140.52 MiB 147.32 MB)
>   Delta Devices : 1 (4->5)
> 
>     Update Time : Fri May 16 23:55:29 2008
>        Checksum : 5354498d - correct
>          Events : 1420762
> 
>          Layout : left-symmetric
>      Chunk Size : 128K
> 
>     Array Slot : 3 (failed, 1, failed, 2, failed, 0)
>    Array State : uuU__ 3 failed
> /dev/sdb1:
>           Magic : a92b4efc
>         Version : 01
>     Feature Map : 0x4
>      Array UUID : 43eff327:8d1aa506:c0df2849:005c003f
>            Name : 'Fuckyfucky3':1
>   Creation Time : Sun Dec 23 01:28:08 2007
>      Raid Level : raid5
>    Raid Devices : 5
> 
>     Device Size : 976767856 (465.76 GiB 500.11 GB)
>      Array Size : 3907069952 (1863.04 GiB 2000.42 GB)
>       Used Size : 976767488 (465.76 GiB 500.10 GB)
>    Super Offset : 976767984 sectors
>           State : clean
>     Device UUID : 673ba6d4:6c46fd55:745c9c93:3fa8bf21
> 
>   Reshape pos'n : 143872 (140.52 MiB 147.32 MB)
>   Delta Devices : 1 (4->5)
> 
>     Update Time : Fri May 16 23:55:29 2008
>        Checksum : 8ad75f10 - correct
>          Events : 1420762
> 
>          Layout : left-symmetric
>      Chunk Size : 128K
> 
>     Array Slot : 1 (failed, 1, failed, 2, failed, 0)
>    Array State : uUu__ 3 failed
> /dev/sdc1:
>           Magic : a92b4efc
>         Version : 01
>     Feature Map : 0x4
>      Array UUID : 43eff327:8d1aa506:c0df2849:005c003f
>            Name : 'Fuckyfucky3':1
>   Creation Time : Sun Dec 23 01:28:08 2007
>      Raid Level : raid5
>    Raid Devices : 5
> 
>     Device Size : 976767856 (465.76 GiB 500.11 GB)
>      Array Size : 3907069952 (1863.04 GiB 2000.42 GB)
>       Used Size : 976767488 (465.76 GiB 500.10 GB)
>    Super Offset : 976767984 sectors
>           State : clean
>     Device UUID : 99b87c50:a919bd63:599a135f:9af385ba
> 
>   Reshape pos'n : 143872 (140.52 MiB 147.32 MB)
>   Delta Devices : 1 (4->5)
> 
>     Update Time : Fri May 16 23:55:29 2008
>        Checksum : 78ab38c3 - correct
>          Events : 1420762
> 
>          Layout : left-symmetric
>      Chunk Size : 128K
> 
>     Array Slot : 5 (failed, 1, failed, 2, failed, 0)
>    Array State : Uuu__ 3 failed
> /dev/sdd1:
>           Magic : a92b4efc
>         Version : 01
>     Feature Map : 0x4
>      Array UUID : 43eff327:8d1aa506:c0df2849:005c003f
>            Name : 'Fuckyfucky3':1
>   Creation Time : Sun Dec 23 01:28:08 2007
>      Raid Level : raid5
>    Raid Devices : 5
> 
>     Device Size : 976767856 (465.76 GiB 500.11 GB)
>      Array Size : 3907069952 (1863.04 GiB 2000.42 GB)
>       Used Size : 976767488 (465.76 GiB 500.10 GB)
>    Super Offset : 976767984 sectors
>           State : clean
>     Device UUID : 89201477:8e950d20:9193016d:f5c9deb0
> 
>   Reshape pos'n : 143872 (140.52 MiB 147.32 MB)
>   Delta Devices : 1 (4->5)
> 
>     Update Time : Fri May 16 23:55:29 2008
>        Checksum : 5fc43e52 - correct
>          Events : 0
> 
>          Layout : left-symmetric
>      Chunk Size : 128K
> 
>     Array Slot : 6 (failed, 1, failed, 2, failed, 0)
>    Array State : uuu__ 3 failed
> /dev/sde1:
>           Magic : a92b4efc
>         Version : 01
>     Feature Map : 0x4
>      Array UUID : 43eff327:8d1aa506:c0df2849:005c003f
>            Name : 'Fuckyfucky3':1
>   Creation Time : Sun Dec 23 01:28:08 2007
>      Raid Level : raid5
>    Raid Devices : 5
> 
>     Device Size : 976767856 (465.76 GiB 500.11 GB)
>      Array Size : 3907069952 (1863.04 GiB 2000.42 GB)
>       Used Size : 976767488 (465.76 GiB 500.10 GB)
>    Super Offset : 976767984 sectors
>           State : clean
>     Device UUID : 89b53542:d1d820bc:f2ece884:4785869a
> 
>   Reshape pos'n : 143872 (140.52 MiB 147.32 MB)
>   Delta Devices : 1 (4->5)
> 
>     Update Time : Fri May 16 23:55:29 2008
>        Checksum : c89dd220 - correct
>          Events : 1418968
> 
>          Layout : left-symmetric
>      Chunk Size : 128K
> 
>     Array Slot : 6 (failed, 1, failed, 2, failed, 0)
>    Array State : uuu__ 3 failed
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
