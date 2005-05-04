From: Tyler <pml@dtbb.net>
Subject: Re: BUGREPORT: mdadm v2.0-devel - can't create array using version
 1 superblock, possibly related to previous bugreport
Date: Tue, 03 May 2005 22:08:59 -0700
Message-ID: <427858EB.4070501@dtbb.net>
References: <42775D47.4000805@dtbb.net>	<17016.3902.917012.297224@cse.unsw.edu.au>	<4278271B.1020408@dtbb.net> <17016.12489.9021.728737@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17016.12489.9021.728737@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

What kernel are you using Neil, and what patches to the kernel if any, 
and which patches to mdadm 2.0-devel?  I'm still having difficulty here. 
:(  I even tried compiling a 2.6.11-rc3-mm2 kernel like your 2.0-devel 
announce suggested, and put your patches from 02-18 against it, and 
still no love.  Included is some detailed output from trying this all 
over again with 2.6.11-rc3-mm2 with your patches, and mdadm 2.0-devel, 
plus the patch you put on this list a few messages ago, plus the 
suggested changes to include/linux/raid/md_p.h and super1.c sblayout-> 
layout instead of level from your reply below (no patch supplied), and I 
tried without the 96 to 100 change, and with the 96 -> 100 change, as 
the 2.6.11-rc3-mm2 kernel didn't have the bitmap offset patch.. which I 
am assuming would be there if I applied only patch you've got on your 
site that has come out since 2.0-devel, to include bitmap support (the 
patch only mentions bitmap for 0.90.0 support.. but that is neither here 
nor there).

root@localhost:~/dev/mdadm-2.0-devel-1# uname -a
Linux localhost 2.6.11-rc3-mm2 #1 SMP Wed May 4 04:57:08 CEST 2005 i686 
GNU/Linux

First I check the superblocks on each drive, then create a v0.90.0 
superblock based array successfully:

root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -E /dev/hdb
root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -E /dev/hdc
root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -E /dev/hdd
root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -C -l 5 -n 3 /dev/md0 
/dev/hdb /dev/hdc /dev/hdd
VERS = 9001
mdadm: array /dev/md0 started.

root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Wed May  4 05:06:04 2005
     Raid Level : raid5
     Array Size : 390721792 (372.62 GiB 400.10 GB)
    Device Size : 195360896 (186.31 GiB 200.05 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed May  4 05:06:04 2005
          State : clean, degraded, recovering
 Active Devices : 2
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

 Rebuild Status : 0% complete

           UUID : 3edff19d:53f64b6f:1cef039c:1f60b157
         Events : 0.1

    Number   Major   Minor   RaidDevice State
       0       3       64        0      active sync   /dev/hdb
       1      22        0        1      active sync   /dev/hdc
       2       0        0        -      removed

       3      22       64        2      spare rebuilding   /dev/hdd

root@localhost:~/dev/mdadm-2.0-devel-1# cat /proc/mdstat
Personalities : [raid5]
Event: 4                  
md0 : active raid5 hdd[3] hdc[1] hdb[0]
      390721792 blocks level 5, 64k chunk, algorithm 2 [3/2] [UU_]
      [>....................]  recovery =  0.2% (511944/195360896) 
finish=126.8min speed=25597K/sec
     
unused devices: <none>

I then stop the array, zero the superblocks (0.90.0 superblocks seem to 
erase okay, and there aren't any version 1 supeblocks on the devices 
yet, as shown above):

root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -S /dev/md0
root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm --zero-superblock /dev/hdb
root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm --zero-superblock /dev/hdb
mdadm: Unrecognised md component device - /dev/hdb

root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm --zero-superblock /dev/hdc
root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm --zero-superblock /dev/hdc
mdadm: Unrecognised md component device - /dev/hdc

root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm --zero-superblock /dev/hdd
root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm --zero-superblock /dev/hdd
mdadm: Unrecognised md component device - /dev/hdd

I then try creating the same array with a version 1 superblock 
unsuccessfully, but one difference now, with all the patches, is that it 
successfully writes a superblock to all three devices:

root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -C -l 5 -n 3 -e 1 
/dev/md0 /dev/hdb /dev/hdc /dev/hdd
VERS = 9001
mdadm: RUN_ARRAY failed: Input/output error
root@localhost:~/dev/mdadm-2.0-devel-1# cat /proc/mdstat
Personalities : [raid5]
Event: 6
unused devices: <none>

First we see the successful creation and then stopping of a v0.90.0 
superblock raid:

root@localhost:~/dev/mdadm-2.0-devel-1# dmesg |tail -55
md: bind<hdb>
md: bind<hdc>
md: bind<hdd>
raid5: device hdc operational as raid disk 1
raid5: device hdb operational as raid disk 0
raid5: allocated 3165kB for md0
raid5: raid level 5 set md0 active with 2 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:2 fd:1
 disk 0, o:1, dev:hdb
 disk 1, o:1, dev:hdc
RAID5 conf printout:
 --- rd:3 wd:2 fd:1
 disk 0, o:1, dev:hdb
 disk 1, o:1, dev:hdc
 disk 2, o:1, dev:hdd
.<6>md: syncing RAID array md0
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwith (but not more than 200000 
KB/sec) for reconstruction.
md: using 128k window, over a total of 195360896 blocks.
md: md0: sync done.
md: md0 stopped.
md: unbind<hdd>
md: export_rdev(hdd)
md: unbind<hdc>
md: export_rdev(hdc)
md: unbind<hdb>
md: export_rdev(hdb)

Then following that is the attempt with version 1 superblock:

md: bind<hdb>
md: bind<hdc>
md: bind<hdd>
md: md0: raid array is not clean -- starting background reconstruction
raid5: device hdc operational as raid disk 1
raid5: device hdb operational as raid disk 0
raid5: cannot start dirty degraded array for md0
RAID5 conf printout:
 --- rd:3 wd:2 fd:1
 disk 0, o:1, dev:hdb
 disk 1, o:1, dev:hdc
raid5: failed to run raid set md0
md: pers->run() failed ...
md: md0 stopped.
md: unbind<hdd>
md: export_rdev(hdd)
md: unbind<hdc>
md: export_rdev(hdc)
md: unbind<hdb>
md: export_rdev(hdb)

All three drives do show a version 1 superblock.. (further than before, 
where just the first drive got one):

root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -E /dev/hdb
/dev/hdb:
          Magic : a92b4efc
        Version : 01.00
     Array UUID : 8867ea01e1:8c59144b:b76f2ccb:52e94f
           Name :
  Creation Time : Wed May  4 05:15:24 2005
     Raid Level : raid5
   Raid Devices : 3

    Device Size : 390721952 (186.31 GiB 200.05 GB)
   Super Offset : 390721952 sectors
          State : active
    Device UUID : 8867ea01e1:8c59144b:b76f2ccb:52e94f
    Update Time : Wed May  4 05:15:24 2005
       Checksum : af8dc3da - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 64K

   Array State : Uu_ 380 spares 2 failed
root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -E /dev/hdc
/dev/hdc:
          Magic : a92b4efc
        Version : 01.00
     Array UUID : 8867ea01e1:8c59144b:b76f2ccb:52e94f
           Name :
  Creation Time : Wed May  4 05:15:24 2005
     Raid Level : raid5
   Raid Devices : 3

    Device Size : 390721952 (186.31 GiB 200.05 GB)
   Super Offset : 390721952 sectors
          State : active
    Device UUID : 8867ea01e1:8c59144b:b76f2ccb:52e94f
    Update Time : Wed May  4 05:15:24 2005
       Checksum : 695cc5cc - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 64K

   Array State : uU_ 380 spares 2 failed
root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -E /dev/hdd
/dev/hdd:
          Magic : a92b4efc
        Version : 01.00
     Array UUID : 8867ea01e1:8c59144b:b76f2ccb:52e94f
           Name :
  Creation Time : Wed May  4 05:15:24 2005
     Raid Level : raid5
   Raid Devices : 3

    Device Size : 390721952 (186.31 GiB 200.05 GB)
   Super Offset : 390721952 sectors
          State : active
    Device UUID : 8867ea01e1:8c59144b:b76f2ccb:52e94f
    Update Time : Wed May  4 05:15:24 2005
       Checksum : c71279d8 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 64K

   Array State : uu_ 380 spares 2 failed

The attempt to use zero-superblock fails to remove version 1 superblocks 
.. it should report that there was no superblock the second time you run 
zero-superblock on a device, like it did above.  (an mdadm -E /dev/hdX 
still shows the version 1 superblocks intact):

root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm --zero-superblock /dev/hdb
root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm --zero-superblock /dev/hdb
root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm --zero-superblock /dev/hdc
root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm --zero-superblock /dev/hdc
root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm --zero-superblock /dev/hdd
root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm --zero-superblock /dev/hdd

An mdadm -E on each drive shows the same info as the information just 
above, before the zero-superblock, and below is a sample after 
recreating a version 0.90.0 superblock array again, the bottom of the 
output seems very different than the version 1 superblock information.. 
giving alot more information about devices in the raid, etc, than the 
version 1 display does (not that the version 1 has successfully started 
mind you, and maybe the version 1 superblocks don't include all the same 
information, as they are smaller, correct?).

root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -E /dev/hdb
/dev/hdb:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 2ae086b7:780fa0af:5e5171e9:20ba5aa5
  Creation Time : Wed May  4 05:32:20 2005
     Raid Level : raid5
    Device Size : 195360896 (186.31 GiB 200.05 GB)
   Raid Devices : 3
  Total Devices : 4
Preferred Minor : 0

    Update Time : Wed May  4 05:32:20 2005
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 5bbdc17c - correct
         Events : 0.1

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       3       64        0      active sync   /dev/hdb

   0     0       3       64        0      active sync   /dev/hdb
   1     1      22        0        1      active sync   /dev/hdc
   2     2       0        0        2      faulty
   3     3      22       64        3      spare   /dev/hdd


So at this point, I feel I'm close... but still no cigar, sorry to be 
such a pain .. heh.

Thanks,
Tyler.

Neil Brown wrote:

>On Tuesday May 3, pml@dtbb.net wrote:
>  
>
>>Hi Neil,
>>
>>I've gotten past the device being busy using the patch, and onto a new 
>>error message and set of problems:
>>
>>root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -E /dev/hdb
>>root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -E /dev/hdc
>>root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -E /dev/hdd
>>root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -C -l 5 -n 3 -e 1 
>>/dev/md0 /dev/hdb /dev/hdc /dev/hdd
>>VERS = 9002
>>mdadm: ADD_NEW_DISK for /dev/hdb failed: Invalid argument
>>    
>>
>....
>  
>
>>And the following in Dmesg:
>>md: hdb has invalid sb, not importing!
>>md: md_import_device returned -22
>>
>>    
>>
>
>Hey, I got that too!
>You must be running an -mm kernel (I cannot remember what kernel you
>said you were using).
>
>Look in include/linux/md_p.h near line 205.
>If it has
>	__u32	chunksize;	/* in 512byte sectors */
>	__u32	raid_disks;
>	__u32	bitmap_offset;	/* sectors after start of superblock that bitmap starts
>				 * NOTE: signed, so bitmap can be before superblock
>				 * only meaningful of feature_map[0] is set.
>				 */
>	__u8	pad1[128-96];	/* set to 0 when written */
>
>then change the '96' to '100'.  (It should have been changed when
>bitmap_offset was added).
>
>You will then need to mdadm some more.  In super1.c near line 400,
>
>	sb->ctime = __cpu_to_le64((unsigned long long)time(0));
>	sb->level = __cpu_to_le32(info->level);
>	sb->layout = __cpu_to_le32(info->level);
>	sb->size = __cpu_to_le64(info->size*2ULL);
>
>notice that 'layout' is being set to 'level'.  This is wrong.  That
>line should be
>
>	sb->layout = __cpu_to_le32(info->layout);
>
>With these changes, I can create a 56 device raid6 array. (I only have
>14 drives, but I partitioned each into 4 equal parts!).
>
>I'll try to do another mdadm-2 release in the next week.
>
>Thanks for testing this stuff...
>
>NeilBrown
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>  
>

