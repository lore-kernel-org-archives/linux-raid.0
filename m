From: "John Stoffel" <john@stoffel.org>
Subject: Re: Accidentally resized array to 9
Date: Fri, 29 Sep 2017 08:38:56 -0400
Message-ID: <22990.16096.295333.439814@quad.stoffel.home>
References: <0e59cefd-662f-bf77-0c32-49424d504c77@benshoshan.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0e59cefd-662f-bf77-0c32-49424d504c77@benshoshan.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eli Ben-Shoshan <eli@benshoshan.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Eli" == Eli Ben-Shoshan <eli@benshoshan.com> writes:

Eli> I need to add another disk to my array (/dev/md128) when I accidentally 
Eli> did an array resize to 9 with the following command:

Eli> First I add the disk to the array with the following:

Eli> mdadm --manage /dev/md128 --add /dev/sdl

Eli> This was a RAID6 with 8 devices. Instead of using --grow with 
Eli> --raid-devices set to 9, I did the following:

Eli> mdadm --grow /dev/md128 --size 9

Eli> This happily returned without any errors so I went to go look at 
Eli> /proc/mdstat and did not see a resize operation going. So I shook my 
Eli> head and read the output of --grow --help and did the right thing which is:

Eli> mdadm --grow /dev/md128 --raid-devices=9

Eli> Right after that everything hit the fan. dmesg reported a lot of 
Eli> filesystem errors. I quickly stopped all processes that were using this 
Eli> device and unmounted the filesystems. I then, stupidly, decided to 
Eli> reboot before looking around.


I think you *might* be able to fix this with just a simple:

   mdadm --grow /dev/md128 --size max

And then try to scan for your LVM configuration, then fsck your volume
on there.  I hope you had backups.

And maybe there should be a warning when re-sizing raid array elements
without a --force option if going smaller than the current size?  

Eli> I am now booted and can assemble this array but it seems like there is 
Eli> no data there. Here is the output of --misc --examine:



Eli> ganon raid # cat md128
Eli> /dev/md128:
Eli>          Version : 1.2
Eli>    Creation Time : Sat Aug 30 22:01:09 2014
Eli>       Raid Level : raid6
Eli>    Used Dev Size : unknown
Eli>     Raid Devices : 9
Eli>    Total Devices : 9
Eli>      Persistence : Superblock is persistent

Eli>      Update Time : Thu Sep 28 19:44:39 2017
Eli>            State : clean, Not Started
Eli>   Active Devices : 9
Eli> Working Devices : 9
Eli>   Failed Devices : 0
Eli>    Spare Devices : 0

Eli>           Layout : left-symmetric
Eli>       Chunk Size : 512K

Eli>             Name : ganon:ganon - large raid6  (local to host ganon)
Eli>             UUID : 2b3f41d5:ac904000:965be496:dd3ae4ae
Eli>           Events : 84345

Eli>      Number   Major   Minor   RaidDevice State
Eli>         0       8       32        0      active sync   /dev/sdc
Eli>         1       8       48        1      active sync   /dev/sdd
Eli>         6       8      128        2      active sync   /dev/sdi
Eli>         3       8       96        3      active sync   /dev/sdg
Eli>         4       8       80        4      active sync   /dev/sdf
Eli>         8       8      160        5      active sync   /dev/sdk
Eli>         7       8       64        6      active sync   /dev/sde
Eli>         9       8      112        7      active sync   /dev/sdh
Eli>        10       8      176        8      active sync   /dev/sdl

Eli> You will note that the "Used Dev Size" is unknown. The output of --misc 
Eli> --examine on each disk looks similar to this:

Eli> /dev/sdc:
Eli>            Magic : a92b4efc
Eli>          Version : 1.2
Eli>      Feature Map : 0x0
Eli>       Array UUID : 2b3f41d5:ac904000:965be496:dd3ae4ae
Eli>             Name : ganon:ganon - large raid6  (local to host ganon)
Eli>    Creation Time : Sat Aug 30 22:01:09 2014
Eli>       Raid Level : raid6
Eli>     Raid Devices : 9

Eli>   Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
Eli>       Array Size : 0
Eli>    Used Dev Size : 0
Eli>      Data Offset : 239616 sectors
Eli>     Super Offset : 8 sectors
Eli>     Unused Space : before=239528 sectors, after=3906789552 sectors
Eli>            State : clean
Eli>      Device UUID : b1bd681a:36849191:b3fdad44:22567d99

Eli>      Update Time : Thu Sep 28 19:44:39 2017
Eli>    Bad Block Log : 512 entries available at offset 72 sectors
Eli>         Checksum : bca7b1d5 - correct
Eli>           Events : 84345

Eli>           Layout : left-symmetric
Eli>       Chunk Size : 512K

Eli>     Device Role : Active device 0
Eli>     Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == 
Eli> replacing)

Eli> I followed directions to create overlays and I tried to re-create the 
Eli> array with the following:

Eli> mdadm --create /dev/md150 --assume-clean --metadata=1.2 
Eli> --data-offset=117M --level=6 --layout=ls --chunk=512 --raid-devices=9 
Eli> /dev/mapper/sdc /dev/mapper/sdd /dev/mapper/sdi /dev/mapper/sdg 
Eli> /dev/mapper/sdf /dev/mapper/sdk /dev/mapper/sde /dev/mapper/sdh 
Eli> /dev/mapper/sdl

Eli> while this creates a /dev/md150, it is basically empty. There should be 
Eli> an LVM PV label on this disk but pvck returns:

Eli>    Could not find LVM label on /dev/md150

Eli> The output of --misc --examine looks like this with the overlay:

Eli> /dev/md150:
Eli>          Version : 1.2
Eli>    Creation Time : Fri Sep 29 00:22:11 2017
Eli>       Raid Level : raid6
Eli>       Array Size : 13673762816 (13040.32 GiB 14001.93 GB)
Eli>    Used Dev Size : 1953394688 (1862.90 GiB 2000.28 GB)
Eli>     Raid Devices : 9
Eli>    Total Devices : 9
Eli>      Persistence : Superblock is persistent

Eli>    Intent Bitmap : Internal

Eli>      Update Time : Fri Sep 29 00:22:11 2017
Eli>            State : clean
Eli>   Active Devices : 9
Eli> Working Devices : 9
Eli>   Failed Devices : 0
Eli>    Spare Devices : 0

Eli>           Layout : left-symmetric
Eli>       Chunk Size : 512K

Eli>             Name : ganon:150  (local to host ganon)
Eli>             UUID : 84098bfe:74c1f70c:958a7d8a:ccb2ef74
Eli>           Events : 0

Eli>      Number   Major   Minor   RaidDevice State
Eli>         0     252       11        0      active sync   /dev/dm-11
Eli>         1     252        9        1      active sync   /dev/dm-9
Eli>         2     252       16        2      active sync   /dev/dm-16
Eli>         3     252       17        3      active sync   /dev/dm-17
Eli>         4     252       10        4      active sync   /dev/dm-10
Eli>         5     252       14        5      active sync   /dev/dm-14
Eli>         6     252       12        6      active sync   /dev/dm-12
Eli>         7     252       13        7      active sync   /dev/dm-13
Eli>         8     252       15        8      active sync   /dev/dm-15

Eli> What do you think? Am I hosed here? Is there any way I can get my data back?
Eli> --
Eli> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
Eli> the body of a message to majordomo@vger.kernel.org
Eli> More majordomo info at  http://vger.kernel.org/majordomo-info.html
