From: EJ Vincent <ej@ejane.org>
Subject: Re: Upgrade from Ubuntu 10.04 to 12.04 broken raid6.
Date: Sun, 30 Sep 2012 05:30:48 -0400
Message-ID: <50681148.20901@ejane.org>
References: <loom.20120930T105755-205@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20120930T105755-205@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/30/2012 5:21 AM, EJ wrote:
> Greetings,
>
> I hope that I'm posting this in the right place, if not my apologies.
>
> Up until several hours ago, my system was running Ubuntu 10.04 LTS, using the
> stock version of mdadm--unfortunately I have no idea which version it was.
>
> Fast forward to now, I've upgraded the system to 12.04 LTS and have lost access
> to my array. The array itself is a nine (9) disk raid6 managed by mdadm.
>
> I'm not sure this is pertinent information, but trying to get 12.04 LTS to boot
> was an exercise in patience.  There was some sort of race condition possibly
> happening between the disks of the array initializing and 12.04's udev. It would
> constantly drop me to a busybox shell, trying to degrade the known-working
> array.
>
> Eventually, I had to go into /usr/share/initramfs-tools/scripts/mdadm-functions
> and type "exit 1" into both degraded_arrays() and mountroot_fail() so that my
> system could at the very least boot.  I fear that the constant rebooting and
> 12.04's aggressive initramfs scripting has somehow damaged my array.
>
> Ok back to the array itself, here's some raw command data:
>
> # mdadm --assemble /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1
> /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1
> mdadm: superblock on /dev/sdc1 doesn't match others - assembly aborted
>
> I also tried # mdadm --auto-detect and found this in dmesg:
>
> [  676.998212] md: Autodetecting RAID arrays.
> [  676.998426] md: invalid raid superblock magic on sdc1
> [  676.998458] md: sdc1 does not have a valid v0.90 superblock, not importing!
> [  676.998870] md: invalid raid superblock magic on sde1
> [  676.998911] md: sde1 does not have a valid v0.90 superblock, not importing!
> [  676.999474] md: invalid raid superblock magic on sdb1
> [  676.999495] md: sdb1 does not have a valid v0.90 superblock, not importing!
> [  676.999703] md: invalid raid superblock magic on sdd1
> [  676.999732] md: sdd1 does not have a valid v0.90 superblock, not importing!
> [  677.000137] md: invalid raid superblock magic on sdf1
> [  677.000163] md: sdf1 does not have a valid v0.90 superblock, not importing!
> [  677.000566] md: invalid raid superblock magic on sdg1
> [  677.000586] md: sdg1 does not have a valid v0.90 superblock, not importing!
> [  677.000940] md: invalid raid superblock magic on sdh1
> [  677.000960] md: sdh1 does not have a valid v0.90 superblock, not importing!
> [  677.001356] md: invalid raid superblock magic on sdi1
> [  677.001375] md: sdi1 does not have a valid v0.90 superblock, not importing!
> [  677.001841] md: invalid raid superblock magic on sdj1
> [  677.001871] md: sdj1 does not have a valid v0.90 superblock, not importing!
> [  677.001933] md: Scanned 9 and added 0 devices.
> [  677.001938] md: autorun ...
> [  677.001941] md: ... autorun DONE.
>
> Here are the disks themselves:
>
> # mdadm -E /dev/sdb1
> /dev/sdb1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : 321fc20c:997e9a1a:bb67ffde:9de489f5
>             Name : ruby:6  (local to host ruby)
>    Creation Time : Mon Apr 11 19:40:25 2011
>       Raid Level : raid6
>     Raid Devices : 9
>
>   Avail Dev Size : 3907026672 (1863.02 GiB 2000.40 GB)
>       Array Size : 27349181440 (13041.11 GiB 14002.78 GB)
>    Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>      Data Offset : 272 sectors
>     Super Offset : 8 sectors
>            State : clean
>      Device UUID : a6fd99b2:7bb75287:5d844ec5:822b6d8a
>
>      Update Time : Sun Sep 30 04:34:27 2012
>         Checksum : 760485cb - correct
>           Events : 2474296
>
>           Layout : left-symmetric
>       Chunk Size : 512K
>
>     Device Role : Active device 5
>     Array State : AAAAAAAAA ('A' == active, '.' == missing)
>
> # mdadm -E /dev/sdc1
> /dev/sdc1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : 321fc20c:997e9a1a:bb67ffde:9de489f5
>             Name : ruby:6  (local to host ruby)
>    Creation Time : Mon Apr 11 19:40:25 2011
>       Raid Level : -unknown-
>     Raid Devices : 0
>
>   Avail Dev Size : 3907026672 (1863.02 GiB 2000.40 GB)
>      Data Offset : 272 sectors
>     Super Offset : 8 sectors
>            State : active
>      Device UUID : f3f72549:8543972f:1f4a655d:fa9416bd
>
>      Update Time : Sun Sep 30 07:26:43 2012
>         Checksum : 7e955e4e - correct
>           Events : 1
>
>
>     Device Role : spare
>     Array State :  ('A' == active, '.' == missing)
>
> # mdadm -E /dev/sdd1
> /dev/sdd1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : 321fc20c:997e9a1a:bb67ffde:9de489f5
>             Name : ruby:6  (local to host ruby)
>    Creation Time : Mon Apr 11 19:40:25 2011
>       Raid Level : -unknown-
>     Raid Devices : 0
>
>   Avail Dev Size : 3907026672 (1863.02 GiB 2000.40 GB)
>      Data Offset : 272 sectors
>     Super Offset : 8 sectors
>            State : active
>      Device UUID : 9c908e4b:ad7d8af8:ff5d2ab6:50b013e5
>
>      Update Time : Sun Sep 30 07:26:43 2012
>         Checksum : cab36055 - correct
>           Events : 1
>
>
>     Device Role : spare
>     Array State :  ('A' == active, '.' == missing)
>
> # mdadm -E /dev/sde1
> /dev/sde1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : 321fc20c:997e9a1a:bb67ffde:9de489f5
>             Name : ruby:6  (local to host ruby)
>    Creation Time : Mon Apr 11 19:40:25 2011
>       Raid Level : -unknown-
>     Raid Devices : 0
>
>   Avail Dev Size : 3907026672 (1863.02 GiB 2000.40 GB)
>      Data Offset : 272 sectors
>     Super Offset : 8 sectors
>            State : active
>      Device UUID : 321368f6:9f38bc16:76f787c3:4b3d398d
>
>      Update Time : Sun Sep 30 07:26:43 2012
>         Checksum : 4941c455 - correct
>           Events : 1
>
>
>     Device Role : spare
>     Array State :  ('A' == active, '.' == missing)
>
> # mdadm -E /dev/sdf1
> /dev/sdf1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : 321fc20c:997e9a1a:bb67ffde:9de489f5
>             Name : ruby:6  (local to host ruby)
>    Creation Time : Mon Apr 11 19:40:25 2011
>       Raid Level : -unknown-
>     Raid Devices : 0
>
>   Avail Dev Size : 3907026672 (1863.02 GiB 2000.40 GB)
>      Data Offset : 272 sectors
>     Super Offset : 8 sectors
>            State : active
>      Device UUID : 6190765b:200ff748:d50a75e3:597405c4
>
>      Update Time : Sun Sep 30 07:26:43 2012
>         Checksum : 37446270 - correct
>           Events : 1
>
>
>     Device Role : spare
>     Array State :  ('A' == active, '.' == missing)
>
> # mdadm -E /dev/sdg1
> /dev/sdg1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : 321fc20c:997e9a1a:bb67ffde:9de489f5
>             Name : ruby:6  (local to host ruby)
>    Creation Time : Mon Apr 11 19:40:25 2011
>       Raid Level : -unknown-
>     Raid Devices : 0
>
>   Avail Dev Size : 3907026672 (1863.02 GiB 2000.40 GB)
>      Data Offset : 272 sectors
>     Super Offset : 8 sectors
>            State : active
>      Device UUID : 7d707598:a8881376:531ae0c6:aac82909
>
>      Update Time : Sun Sep 30 07:26:43 2012
>         Checksum : c9ef1fe9 - correct
>           Events : 1
>
>
>     Device Role : spare
>     Array State :  ('A' == active, '.' == missing)
>
> # mdadm -E /dev/sdh1
> /dev/sdh1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : 321fc20c:997e9a1a:bb67ffde:9de489f5
>             Name : ruby:6  (local to host ruby)
>    Creation Time : Mon Apr 11 19:40:25 2011
>       Raid Level : -unknown-
>     Raid Devices : 0
>
>   Avail Dev Size : 3907026672 (1863.02 GiB 2000.40 GB)
>      Data Offset : 272 sectors
>     Super Offset : 8 sectors
>            State : active
>      Device UUID : 179691a0:fd201c2d:49c73803:409a0a9c
>
>      Update Time : Sun Sep 30 07:26:43 2012
>         Checksum : 584d5c61 - correct
>           Events : 1
>
>
>     Device Role : spare
>     Array State :  ('A' == active, '.' == missing)
>
> # mdadm -E /dev/sdi1
> /dev/sdi1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : 321fc20c:997e9a1a:bb67ffde:9de489f5
>             Name : ruby:6  (local to host ruby)
>    Creation Time : Mon Apr 11 19:40:25 2011
>       Raid Level : raid6
>     Raid Devices : 9
>
>   Avail Dev Size : 3907026672 (1863.02 GiB 2000.40 GB)
>       Array Size : 27349181440 (13041.11 GiB 14002.78 GB)
>    Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>      Data Offset : 272 sectors
>     Super Offset : 8 sectors
>            State : clean
>      Device UUID : 9d53248b:1db27ffc:a2a511c3:7176a7eb
>
>      Update Time : Sun Sep 30 04:34:27 2012
>         Checksum : 22b9429c - correct
>           Events : 2474296
>
>           Layout : left-symmetric
>       Chunk Size : 512K
>
>     Device Role : Active device 8
>     Array State : AAAAAAAAA ('A' == active, '.' == missing)
>
> # mdadm -E /dev/sdj1
> /dev/sdj1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : 321fc20c:997e9a1a:bb67ffde:9de489f5
>             Name : ruby:6  (local to host ruby)
>    Creation Time : Mon Apr 11 19:40:25 2011
>       Raid Level : raid6
>     Raid Devices : 9
>
>   Avail Dev Size : 3907026672 (1863.02 GiB 2000.40 GB)
>       Array Size : 27349181440 (13041.11 GiB 14002.78 GB)
>    Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>      Data Offset : 272 sectors
>     Super Offset : 8 sectors
>            State : clean
>      Device UUID : 880ed7fb:b9c673de:929d14c5:53f9b81d
>
>      Update Time : Sun Sep 30 04:34:27 2012
>         Checksum : a9748cf3 - correct
>           Events : 2474296
>
>           Layout : left-symmetric
>       Chunk Size : 512K
>
>     Device Role : Active device 7
>     Array State : AAAAAAAAA ('A' == active, '.' == missing)
>
> I find it odd that the raid levels for some of the disks would register as
> "unknown" and that their device roles would be shifted to "spare".
>
> Current system:
>
> Linux ruby 3.2.0-23-generic #36-Ubuntu SMP Tue Apr 10 20:39:51 UTC 2012 x86_64
> x86_64 x86_64 GNU/Linux
>
> Mdadm version:
>
> mdadm - v3.2.3 - 23rd December 2011
>
> I hope I've provided enough information. I would be more than happy to elaborate
> or provide additional data if need be. Again, this array was functioning
> normally up until a few hours ago. Am I able to salvage my data?
>
> Thank you.
>
> -EJ
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hello again, a quick follow-up, I've rebooted the server and 
/proc/mdstat now looks like this:

$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md6 : inactive sdh1[8](S) sdf1[4](S) sdg1[11](S) sde1[6](S) sdc1[1](S) 
sdd1[0](S)
       11721080016 blocks super 1.2

$ mdadm -D /dev/md6
mdadm: md device /dev/md6 does not appear to be active.

Although I'm still not sure how to proceed-- I thought it best to 
include this information to the list.

Thanks again,

-EJ
