From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID6 seemingly shrunk itself after hard power outage and rebuild
 with replacement disk
Date: Sat, 05 Mar 2011 11:57:58 -0500
Message-ID: <4D726B96.3010501@turmel.org>
References: <robbat2-20110304T221807-988505787Z@orbis-terrarum.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <robbat2-20110304T221807-988505787Z@orbis-terrarum.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, robbat2@gentoo.org
List-Id: linux-raid.ids

Hi Robin,

On 03/04/2011 06:27 PM, Robin H. Johnson wrote:
> (Please CC, not subscribed to linux-raid).
> 
> Problem summary:
> -------------------
> After a rebuild following disk replacement, the MD array (RAID6, 12 devices)
> appears to have shrunk by 10880KiB. Presumed at the start of the device, but no
> confirmation.

Sounds similar to a problem recently encountered by Simon McNeil...

> Background:
> -----------
> I got called in to help a friend with a data loss problem after a catastrophic
> UPS failure which killed at least one motherboards, and several disks. Almost
> all of which lead to no data loss, except for one system...
> 
> For the system in question, one disk died (cciss/c1d12), and was
> promptly replaced, and this problem started when the rebuild kicked in.
> 
> Prior to calling me, my friend had already tried a few things from a rescue
> env, and almost certainly contributed to making the problem worse, and doesn't
> have good logs of what he did.

I have a suspicion that 'mdadm --create --assume-clean' or some variant was one of those.  And that the rescue environment has a version of mdadm >= 3.1.2.  The default metadata alignment changed in that version.

> The MD array was portions of two very large LVM LVs (15TiB and ~20TiB
> respectively).  Specifically, the PV of the MD array was chunk in the middle of
> each of the two LVs.
> 
> The kernel version 2.6.35.4 did not change during the power outage.
> 
> Problem identification:
> -----------------------
> When bringing the system back online, LVM refused to make one LV accessible as
> it complained of a shrunk device. One other LV exhibited corruption.
> 
> The entry in /proc/partitions noted the array size of 14651023360KiB, while
> older LVM backups showed the usable size of the array to previously be
> 14651034240KiB, a difference of 10880KiB.
> 
> The first LV has inaccessible data for all files at or after the missing chunk.
> All files prior to that point are accessible.
> 
> LVM refused to bring the second LV online as it complained the physical device
> was now too small for all the extents. 
> 
> Prior to the outage, 800KiB of the collected devices was used for metadata, and
> post the outage, now 11680KiB is used (difference of 10880 KIB).
> 
> Questions:
> ----------
> Why did the array shrink? How can I get it back to the original size, or
> accurately identify the missing chunk size and offset, so that I can adjust the
> LVM definitions and recover the other data.

Please share mdadm -E for all of the devices in the problem array, and a sample of mdadm -E for some of the devices in the working arrays.  I think you'll find differences in the data offset.  Newer mdadm aligns to 1MB.  Older mdadm aligns to "superblock size + bitmap size".

"mdadm -E /dev/cciss/c1d{12..23}p1" should show us individual device details for the problem array.

> Collected information:
> ----------------------
> 
> Relevant lines from /proc/partitions:
> =====================================
>    9        3 14651023360 md3
>  105      209 1465103504 cciss/c1d13p1
>  ...
> 
> Line from mdstat right now:
> ===========================
> md3 : active raid6 cciss/c1d18p1[5] cciss/c1d17p1[4] cciss/c1d13p1[0]
> cciss/c1d21p1[8] cciss/c1d20p1[7] cciss/c1d19p1[6] cciss/c1d15p1[2]
> cciss/c1d12p1[12] cciss/c1d14p1[1] cciss/c1d23p1[10] cciss/c1d16p1[3]
> cciss/c1d22p1[9]
>       14651023360 blocks super 1.2 level 6, 64k chunk, algorithm 2
> 	  [12/12] [UUUUUUUUUUUU]
> 
> MDADM output:
> =============
> # mdadm --detail /dev/md3
> /dev/md3:
>         Version : 1.2
>   Creation Time : Wed Feb 16 19:53:05 2011
>      Raid Level : raid6
>      Array Size : 14651023360 (13972.30 GiB 15002.65 GB)
>   Used Dev Size : 1465102336 (1397.23 GiB 1500.26 GB)
>    Raid Devices : 12
>   Total Devices : 12
>     Persistence : Superblock is persistent
> 
>     Update Time : Fri Mar  4 17:19:43 2011
>           State : clean
>  Active Devices : 12
> Working Devices : 12
>  Failed Devices : 0
>   Spare Devices : 0
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>            Name : CENSORED:3  (local to host CENSORED)
>            UUID : efa04ecf:4dbd0bfa:820a5942:de8a234f
>          Events : 25
> 
>     Number   Major   Minor   RaidDevice State
>        0     105      209        0      active sync   /dev/cciss/c1d13p1
>        1     105      225        1      active sync   /dev/cciss/c1d14p1
>        2     105      241        2      active sync   /dev/cciss/c1d15p1
>        3     105      257        3      active sync   /dev/cciss/c1d16p1
>        4     105      273        4      active sync   /dev/cciss/c1d17p1
>        5     105      289        5      active sync   /dev/cciss/c1d18p1
>        6     105      305        6      active sync   /dev/cciss/c1d19p1
>        7     105      321        7      active sync   /dev/cciss/c1d20p1
>        8     105      337        8      active sync   /dev/cciss/c1d21p1
>        9     105      353        9      active sync   /dev/cciss/c1d22p1
>       10     105      369       10      active sync   /dev/cciss/c1d23p1
>       12     105      193       11      active sync   /dev/cciss/c1d12p1

The lowest device node is the last device role?  Any chance these are also out of order?

> LVM PV definition:
> ==================
>   pv1 {
>       id = "CENSORED"
>       device = "/dev/md3" # Hint only
>       status = ["ALLOCATABLE"]
>       flags = []
>       dev_size = 29302068480  # 13.6448 Terabytes
>       pe_start = 384 
>       pe_count = 3576912  # 13.6448 Terabytes
>   }   

It would be good to know where the LVM PV signature is on the problem array's devices, and which one has it.  LVM stores a text copy of the VG's configuration in its metadata blocks at the beginning of a PV, so you should find it on the true "Raid device 0", at the original MD data offset from the beginning of the device.

I suggest scripting a loop through each device, piping the first 1MB (with dd) to "strings -t x" to grep, looking for the PV uuid in clear text.

> LVM segments output:
> ====================
> 
> # lvs --units 1m --segments \
>   -o lv_name,lv_size,seg_start,seg_start_pe,seg_size,seg_pe_ranges \
>   vg/LV1 vg/LV2
>   LV    LSize     Start     Start   SSize    PE Ranges               
>   LV1   15728640m        0m       0 1048576m /dev/md2:1048576-1310719
>   LV1   15728640m  1048576m  262144 1048576m /dev/md2:2008320-2270463
>   LV1   15728640m  2097152m  524288 7936132m /dev/md3:1592879-3576911
>   LV1   15728640m 10033284m 2508321  452476m /dev/md4:2560-115678    
>   LV1   15728640m 10485760m 2621440 5242880m /dev/md4:2084381-3395100
>   LV2   20969720m        0m       0 4194304m /dev/md2:0-1048575      
>   LV2   20969720m  4194304m 1048576 1048576m /dev/md2:1746176-2008319
>   LV2   20969720m  5242880m 1310720  456516m /dev/md2:2270464-2384592
>   LV2   20969720m  5699396m 1424849  511996m /dev/md2:1566721-1694719
>   LV2   20969720m  6211392m 1552848       4m /dev/md2:1566720-1566720
>   LV2   20969720m  6211396m 1552849 6371516m /dev/md3:0-1592878      
>   LV2   20969720m 12582912m 3145728  512000m /dev/md2:1438720-1566719
>   LV2   20969720m 13094912m 3273728 7874808m /dev/md4:115679-2084380 
> 

If my suspicions are right, you'll have to use an old version of mdadm to redo an 'mdadm --create --assume-clean'.

HTH,

Phil
