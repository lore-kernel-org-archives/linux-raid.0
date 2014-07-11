From: Florian Spickenreither <florian.spickenreither@gmail.com>
Subject: Fwd: Recovering RAID5 array from multiple disk failure with different
 partition sizes
Date: Fri, 11 Jul 2014 15:43:54 +0200
Message-ID: <CAK9uVk1z1_Mrozm2syo-t6JPYh3ECY_F-fUQ4Rj1GWCDB7Pycg@mail.gmail.com>
References: <CAK9uVk2tG073pDjpMA4QrHQVLm3y01L+WcxBzoPcTTC5DRoFTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK9uVk2tG073pDjpMA4QrHQVLm3y01L+WcxBzoPcTTC5DRoFTg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear all,

I have a 4-disk RAID-5 array running here. While exchanging one faulty
hard drive another harddisk failed about 18 hours later while the
arrays were still resyncing. While two arrays could be saved by using
the --assemble option, the 3rd of the three arrays running on these
disks could not be started using this option.
I then tried my luck with recreating the array using --create
--assume-clean as described in the RAID Wiki. It worked fine, however
the size of the array was off and of course mounting the filesystem
was not possible. After some analysis I found out that for what reason
ever, the partition used for the RAID array on the fourth disk is
smaller than the size of the partitions on disk 1 through 3. I then
went ahead and recreated the array leaving the fourth disk out. This
recreated the array with the correct array size and I was able to
mount the filesystem (read-only of course) and was able to see the
files. However this does not solve my problem as this does not allow
me complete access to the data as one of the three drives contains no
data as resyncing had not started yet on this array.

To make it easier to understand, here is some info:

Linux: Debian Wheezy, amd64
mdadm 3.2.5 (18th May 2012) and mdadm 3.1.4 is also available as this
was the version which was used to create the arrays originally.

Array: /dev/md/4
Drives and Partitions included in this configuration: /dev/sd[cdef]2
Capacity of the original array according to syslog:  md4: detected
capacity change from 0 to 1199996141568
Before the disk failure sd[cdf]2 were clean and sde2 was still blank
as the resync of this array had not started yet (md was busy resyncing
other arrays). The event counter was identical on all drives as during
the night nobody accesses this particular array.

Disk Info from sdc2 before I recreated the array:
/dev/sdc2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 92a30710:b2567ef3:c387497c:601fe640
           Name : spicki-srv:4  (local to host spicki-srv)
  Creation Time : Sat Jul  9 23:03:19 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 781247953 (372.53 GiB 400.00 GB)
     Array Size : 1171871232 (1117.58 GiB 1200.00 GB)
  Used Dev Size : 781247488 (372.53 GiB 400.00 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 797f3550:a270a06e:71a39feb:baffbeaa

    Update Time : Fri Jul 11 09:39:58 2014
       Checksum : c8238db2 - correct
         Events : 35869

         Layout : left-symmetric
     Chunk Size : 512K

Disk info from sdf2 after I recreated the array:
/dev/sdf2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : c7a7f792:6edfea45:94a0bf5c:484e5830
           Name : spicki-srv:4  (local to host spicki-srv)
  Creation Time : Fri Jul 11 14:23:48 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 780986368 (372.40 GiB 399.87 GB)
     Array Size : 1171478016 (1117.21 GiB 1199.59 GB)
  Used Dev Size : 780985344 (372.40 GiB 399.86 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : ff7125b7:84707301:f47365e2:58701a9d

    Update Time : Fri Jul 11 14:23:48 2014
       Checksum : 56b25b70 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

Unfortunately I was stupid enough not to save all info about the array
and the disks, but I know from memory that sdc2, sdd2 and sdf2 were
still marked as clean and the events counters were identical as well
when I executed --examine on these partitions.
As you can see the "Avail Dev Size" on sdf2 is less than on sd[cde]2
which is causing my headaches. If I recreate the array using sd[cdf]2
mdadm seems to use the smallest partition to calculate the size of the
array and the array is useless. If I recreate the array using sd[cde]2
the array size is identical to before the crash and I can mount the
filesystem, however I get garbage as soon as a file involves sde2
which is still not resynced.

Any ideas how I can recreate the array successfully? mdadm tolerated
the differences in size when I swapped sdf a long time ago and
re-added the missing drive into the array. Would it be an option to
increase the size of the partition sdf2 or is there another way?

Any help is greatly appreciated!
Thanks,
Florian
