From: Mike Myers <mikesm559@yahoo.com>
Subject: Re: Need urgent help in fixing raid5 array
Date: Thu, 1 Jan 2009 22:19:00 -0800 (PST)
Message-ID: <344038.60917.qm@web30808.mail.mud.yahoo.com>
References: <451872.61166.qm@web30802.mail.mud.yahoo.com> <alpine.DEB.1.10.0901011039110.9903@p34.internal.lan> <467705.96388.qm@web30807.mail.mud.yahoo.com> <alpine.DEB.1.10.0901011328380.17888@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, john lists <john4lists@gmail.com>
List-Id: linux-raid.ids

Ok, the bad MPT board is out, replaced by a SI3132, and I rejiggered the drives around so that all the drives are connected.  It brought me back to the main problem.  md2 is running fine, md1 cannot assemble with only 5 drives out of the 7.

Here is the data you requested:

(none):~ # cat /etc/mdadm.conf
DEVICE partitions
ARRAY /dev/md0 level=raid0 UUID=9412e7e1:fd56806c:0f9cc200:95c7ed98
ARRAY /dev/md3 level=raid0 UUID=67999c69:4a9ca9f9:7d4d6b81:91c98b1f
ARRAY /dev/md1 level=raid5 UUID=b737af5c:7c0a70a9:99a648a0:7f693c7d
ARRAY /dev/md2 level=raid5 UUID=e70e0697:a10a5b75:941dd76f:196d9e4e
#ARRAY /dev/md2 level=raid0 UUID=658369ee:23081b79:c990e3a2:15f38c70
#ARRAY /dev/md3 level=raid0 UUID=e2c910ae:0052c38e:a5e19298:0d057e34
MAILADDR root

(md0 and md3 are old arrays that have since been removed - no disks with their uuids are in the system)

(none):~> mdadm -D /dev/md1
mdadm: md device /dev/md1 does not appear to be active.


(none):~> mdadm -D /dev/md2
/dev/md2:
        Version : 00.90.03
  Creation Time : Tue Aug 19 21:31:10 2008
     Raid Level : raid5
     Array Size : 5860559616 (5589.07 GiB 6001.21 GB)
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Thu Jan  1 21:59:20 2009
          State : clean
 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

           UUID : e70e0697:a10a5b75:941dd76f:196d9e4e
         Events : 0.1438838

    Number   Major   Minor   RaidDevice State
       0       8      209        0      active sync   /dev/sdn1
       1       8      129        1      active sync   /dev/sdi1
       2       8      177        2      active sync   /dev/sdl1
       3       8       17        3      active sync   /dev/sdb1
       4       8       33        4      active sync   /dev/sdc1
       5       8       65        5      active sync   /dev/sde1
       6       8      193        6      active sync   /dev/sdm1


(md1 is comprised of sdd1 sdf1 sdg1 sdh1 sdj1 sdk1 sdo1) 

(none):~> mdadm --examine /dev/sdd1 /dev/sdf1 /dev/sdg1 /dev/sdh1
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : b737af5c:7c0a70a9:99a648a0:7f693c7d
           Name : 1
  Creation Time : Fri Nov 23 12:15:39 2007
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 1953519728 (931.51 GiB 1000.20 GB)
     Array Size : 11721117696 (5589.06 GiB 6001.21 GB)
  Used Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
   Super Offset : 1953519984 sectors
          State : clean
    Device UUID : 8ea6369b:cfd1c103:845a1a65:d8b1f254

Internal Bitmap : -234 sectors from superblock
    Update Time : Wed Dec 31 22:43:01 2008
       Checksum : ce94ad09 - correct
         Events : 2295122

         Layout : left-symmetric
     Chunk Size : 128K

    Array Slot : 7 (0, failed, failed, failed, 3, 4, failed, 5, 6)
   Array State : u__uuUu 4 failed
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : b737af5c:7c0a70a9:99a648a0:7f693c7d
           Name : 1
  Creation Time : Fri Nov 23 12:15:39 2007
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 1953519728 (931.51 GiB 1000.20 GB)
     Array Size : 11721117696 (5589.06 GiB 6001.21 GB)
  Used Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
   Super Offset : 1953519984 sectors
          State : clean
    Device UUID : 50c2e80e:e36efc92:5ddac3b0:4d847236

Internal Bitmap : -234 sectors from superblock
    Update Time : Wed Dec 31 22:43:01 2008
       Checksum : feaab82b - correct
         Events : 2295122

         Layout : left-symmetric
     Chunk Size : 128K

    Array Slot : 5 (0, failed, failed, failed, 3, 4, failed, 5, 6)
   Array State : u__uUuu 4 failed
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : b737af5c:7c0a70a9:99a648a0:7f693c7d
           Name : 1
  Creation Time : Fri Nov 23 12:15:39 2007
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 1953519728 (931.51 GiB 1000.20 GB)
     Array Size : 11721117696 (5589.06 GiB 6001.21 GB)
  Used Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
   Super Offset : 1953519984 sectors
          State : clean
    Device UUID : c9809a0c:bd4eabbe:c110a056:0cdd3691

Internal Bitmap : -234 sectors from superblock
    Update Time : Fri Jan  2 17:30:13 2009
       Checksum : 28b13f46 - correct
         Events : 2295116

         Layout : left-symmetric
     Chunk Size : 128K

    Array Slot : 0 (0, 1, failed, failed, 3, 4, failed, 5, 6)
   Array State : Uu_uuuu 3 failed
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : b737af5c:7c0a70a9:99a648a0:7f693c7d
           Name : 1
  Creation Time : Fri Nov 23 12:15:39 2007
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 1953519728 (931.51 GiB 1000.20 GB)
     Array Size : 11721117696 (5589.06 GiB 6001.21 GB)
  Used Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
   Super Offset : 1953519984 sectors
          State : clean
    Device UUID : c9809a0c:bd4eabbe:c110a056:0cdd3691

Internal Bitmap : -234 sectors from superblock
    Update Time : Wed Dec 31 22:43:01 2008
       Checksum : 28abe59d - correct
         Events : 2295122

         Layout : left-symmetric
     Chunk Size : 128K

    Array Slot : 0 (0, failed, failed, failed, 3, 4, failed, 5, 6)
   Array State : U__uuuu 4 failed



(none):~> mdadm --examine /dev/sdj1 /dev/sdk1 /dev/sdo1
/dev/sdj1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : b737af5c:7c0a70a9:99a648a0:7f693c7d
           Name : 1
  Creation Time : Fri Nov 23 12:15:39 2007
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 1953519728 (931.51 GiB 1000.20 GB)
     Array Size : 11721117696 (5589.06 GiB 6001.21 GB)
  Used Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
   Super Offset : 1953519984 sectors
          State : clean
    Device UUID : c61e1d1a:b123f01a:4098ab5e:e8932eb6

Internal Bitmap : -234 sectors from superblock
    Update Time : Wed Dec 31 22:43:01 2008
       Checksum : bf7696f0 - correct
         Events : 2295122

         Layout : left-symmetric
     Chunk Size : 128K

    Array Slot : 8 (0, failed, failed, failed, 3, 4, failed, 5, 6)
   Array State : u__uuuU 4 failed
/dev/sdk1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : b737af5c:7c0a70a9:99a648a0:7f693c7d
           Name : 1
  Creation Time : Fri Nov 23 12:15:39 2007
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 1953519728 (931.51 GiB 1000.20 GB)
     Array Size : 11721117696 (5589.06 GiB 6001.21 GB)
  Used Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
   Super Offset : 1953519984 sectors
          State : clean
    Device UUID : f1417b9d:64d9c93d:c32d16e8:470ab7af

Internal Bitmap : -234 sectors from superblock
    Update Time : Wed Dec 31 22:43:01 2008
       Checksum : e8a17bad - correct
         Events : 2295122

         Layout : left-symmetric
     Chunk Size : 128K

    Array Slot : 4 (0, failed, failed, failed, 3, 4, failed, 5, 6)
   Array State : u__Uuuu 4 failed
/dev/sdo1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : b737af5c:7c0a70a9:99a648a0:7f693c7d
           Name : 1
  Creation Time : Fri Nov 23 12:15:39 2007
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 1953519728 (931.51 GiB 1000.20 GB)
     Array Size : 11721117696 (5589.06 GiB 6001.21 GB)
  Used Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
   Super Offset : 1953519984 sectors
          State : clean
    Device UUID : c9809a0c:bd4eabbe:c110a056:0cdd3691

Internal Bitmap : -234 sectors from superblock
    Update Time : Fri Jan  2 17:17:40 2009
       Checksum : 28b13bcd - correct
         Events : 2294980

         Layout : left-symmetric
     Chunk Size : 128K

    Array Slot : 0 (0, 1, failed, failed, 3, 4, failed, 5, 6)
   Array State : Uu_uuuu 3 failed


(none):~> cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md2 : active raid5 sdn1[0] sdm1[6] sde1[5] sdc1[4] sdb1[3] sdl1[2] sdi1[1]
      5860559616 blocks level 5, 128k chunk, algorithm 2 [7/7] [UUUUUUU]

md1 : inactive sdh1[0](S) sdj1[8](S) sdd1[7](S) sdf1[5](S) sdk1[4](S)
      4883799040 blocks super 1.0

unused devices: <none>


I'm not seeing any errors on boot - all the drives come up now.  It's just that md can't put md1 back together again.  Once that happens, then I can try with lvm and see if I can't get the filesystem online.

Anything else that would be helpful?

I am happy to attach the whole bootup log, but it's a little long...

thanks VERY much!

Mike




 



----- Original Message ----
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Mike Myers <mikesm559@yahoo.com>
Cc: linux-raid@vger.kernel.org; john lists <john4lists@gmail.com>
Sent: Thursday, January 1, 2009 10:29:15 AM
Subject: Re: Need urgent help in fixing raid5 array

I think some output would be pertinent here:

mdadm -D /dev/md0..1..2 etc

cat /proc/mdstat

dmesg/syslog of the errors you are seeing etc



On Thu, 1 Jan 2009, Mike Myers wrote:

> The disks that are problematic are still online as far as the OS can tell.  I can do a dd from them and pull off data at the normal speeds, so I don't understand if that's the case why the backplane would be a problem here.  I can try and move them to another slot however (I have a 20 slot SATA backplane in there) and see if that changes how md deals with it.
>
> The OS sees the drive, it inits fine, but md shows it as removed and won't let me add it back to the array because of the "device being busy".  I don't understand the criteria that md uses to add a drive I guess.  The uuid looks fine, and if the events is off, then the -f flag should take care of that.  I've never seen a "device busy" failure on an add before.
>
> thx
> mike
>
>
>
>
> ----- Original Message ----
> From: Justin Piszcz <jpiszcz@lucidpixels.com>
> To: Mike Myers <mikesm559@yahoo.com>
> Cc: linux-raid@vger.kernel.org; john lists <john4lists@gmail.com>
> Sent: Thursday, January 1, 2009 7:40:21 AM
> Subject: Re: Need urgent help in fixing raid5 array
>
>
>
> On Thu, 1 Jan 2009, Mike Myers wrote:
>
>> Well, thanks for all your help last month.  As i posted, things came
>> back up and I survived the failure.  Now, I have yet another problem.
>> :(  After 5 years of running a linux server as a dedicated NAS, I am
>> hitting some very weird problems.  This server started as an single
>> processor AMD system with 4 320GB drives, and has been upgraded
>> multiple times so that it is now a quad core Intel rackmounted 4U
>> system with 14 1 TB drives and I have never lost data in any of the
>> upgrades of CPU, motherboard and disk controller hardware and disk
>> drives.  Now after last month's near death experience I am faced with
>> another serious problem in less than a month.  Any help you guys could
>> give me would be most appreciated.  This is a sucky way to start the
>> new year.
>>
>> The array I had problems with last month (md2
>> comprised of 7 1 TB drives in a RAID5 config) is running just fine.
>> md1, which is built of 7 1 TB hitachi 7K1000 drives is now having
>> problems.  We returned from a 10 day family visit with everything
>> running just fine.  There ws a brief power outage today, abt 3 mins,
>> but I can't see how that could be related as the server is on a high
>> quality rackmount 3U APC UPS that handled the outage just fine.  I was
>> working on the system getting X to work again after a nvidia driver
>> update, and when that was working fine, checked the disks to discover
>> that md1 was in a degraded state, with /dev/sdl1 kicked out of the
>> array (removed).  I tried to do a dd from the drive to verify it's
>> location in the rack, but I got an i/o error.  This was most odd, and
>> so went to the rack and pulled the disk and reinserted it.  No system
>> log entries recorded the device being pulled or re-installed.  So I am
>> thinking that a cable somehow
>> has come loose.  I power the system
>> down, pull it out of the rack, look at the cable that goes to the
>> drive, everything looks fine.
>>
>> So I reboot the system, and now
>> the array won't come online because now in addition to the drive that
>> shows as (removed), one of the other drives shows as a faulty spare.
>> Well, learning from the last go around, I reassemble the array with the
>> --force option, and the array comes back up.  But LVM won't come back
>> up because it sees the physical volume that maps to md1 as missing.
>> Now I am very concerned.  After trying a bunch of things, I do a
>> pvcreate with the missing UUID on md1, restart the vg and the logical
>> volume comes back up.  I was thinking I may have told lvm to use an
>> array of bad data, but to my surprise, I mounted the filesystem and
>> everything looked intact!  Ok, sometimes you win.  So I do one more
>> reboot to get the system back up in multiuser so I can back up some of
>> the more important media stored on the volume (it's got about 10 Tb
>> used, but most of that is PVR recordings, but there is a lot of ripped
>> music and DVD's that I really don't
>> want to rerip) on a another server that has some space on it while I figure out what has been happening.
>>
>> The
>> reboot again fails because of a problem with md1.  This time, another
>> one of the drives shows as removed (/dev/sdm1), and I can't reassemble
>> the array with a --force option.  It is acting like /dev/sdl1 (the
>> other removed unit), and even though I can read from the drives fine,
>> their UUID is fine, etc..., md does not consider them as part of the
>> array.  /dev/sdo1 (which was the drive that looked like a faulty spare)
>> seems OK when trying to do the assemble.  sdm1 seemed just fine before
>> the reboot, and was showing no problems before.  They are not hooked up
>> on the same controller cable ( a SAS to SATA fanout), and the LSI MPT
>> controller card seems to talk to the other disks just fine.
>>
>> Anyways,
>> I have no idea as to what's going on.  When I try to add sdm1 or sdl1
>> back into the array, md complains the device is busy, which is very odd
>> because it's not part of another array or doing anything else in the
>> system.
>>
>> Any idea as to what could be happening here?  I am beyond frustrated.
>>
>> thanks,
>> Mike
>>
>>
>>
>
> If you are using a hotswap chasis, then it has some sort of
> sata-backplane.  I have seen backplanes go bad in the past, that would be
> my first replacement.
>
> Justin.
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



      
