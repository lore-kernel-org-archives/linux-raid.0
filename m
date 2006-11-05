From: Bill Cizek <cizek@rcn.com>
Subject: raid5 reshape bug with XFS
Date: Sat, 04 Nov 2006 19:59:57 -0600
Message-ID: <454D459D.4000003@rcn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Hi,

I'm setting up a raid 5 system and I ran across a bug when reshaping an 
array with a mounted XFS filesystem on it.  This is under linux 2.6.18.2 
and mdadm 2.5.5

I have a test array with 3 10 GB disks and a fourth 10 GB spare disk, 
and a mounted xfs filesystem on it:

root@localhost $ mdadm --detail /dev/md4
/dev/md4:
        Version : 00.90.03
  Creation Time : Sat Nov  4 18:58:59 2006
     Raid Level : raid5
     Array Size : 20964480 (19.99 GiB 21.47 GB)
    Device Size : 10482240 (10.00 GiB 10.73 GB)
   Raid Devices : 3
  Total Devices : 4
Preferred Minor : 4
    Persistence : Superblock is persistent
[snip]
------------------------------------
...I Grow it:

root@localhost $ mdadm -G /dev/md4 -n4
mdadm: Need to backup 384K of critical section..
mdadm: ... critical section passed.
root@localhost $ mdadm --detail /dev/md4
/dev/md4:
        Version : 00.91.03
  Creation Time : Sat Nov  4 18:58:59 2006
     Raid Level : raid5
     Array Size : 20964480 (19.99 GiB 21.47 GB)
    Device Size : 10482240 (10.00 GiB 10.73 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 4
    Persistence : Superblock is persistent
-----------------------------------

It goes along and reshapes fine (from /proc/mdstat):

md4 : active raid5 dm-67[3] dm-66[2] dm-65[1] dm-64[0]
      20964480 blocks super 0.91 level 5, 64k chunk, algorithm 2 [4/4] 
[UUUU]
      [====>................]  reshape = 22.0% (2314624/10482240) 
finish=16.7min
 speed=8128K/sec

------------------------------------

When the reshape completes, the full array size gets corrupted:
/proc/mdstat:
md4 : active raid5 dm-67[3] dm-66[2] dm-65[1] dm-64[0]
      31446720 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

- looks good, but-

root@localhost $ mdadm --detail /dev/md4
/dev/md4:
        Version : 00.90.03
  Creation Time : Sat Nov  4 18:58:59 2006
     Raid Level : raid5
 >>
 >>    Array Size : 2086592 (2038.03 MiB 2136.67 MB)
 >>
    Device Size : 10482240 (10.00 GiB 10.73 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 4
    Persistence : Superblock is persistent

(2086592 != 31446720 -- Bad, much too small)

---------------------------------
xfs_growfs /dev/md4 barfs horribly - something about reading past the 
end of the device.

If I unmount the XFS filesystem, things work ok:

root@localhost $ umount /dev/md4

root@localhost $ mdadm --detail /dev/md4
/dev/md4:
        Version : 00.90.03
  Creation Time : Sat Nov  4 18:58:59 2006
     Raid Level : raid5
     Array Size : 31446720 (29.99 GiB 32.20 GB)
    Device Size : 10482240 (10.00 GiB 10.73 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 4
    Persistence : Superblock is persistent

(31446720 == 31446720 -- Good)

If I remount the fs, I can use xfs_growfs with no ill effects.

It's a pretty easy work-around to not have the fs mounted during the 
resize, but it doesn't seem right for the array size to get borked like 
this. If there's anything I can provide to debug this let me know.

Thanks,
Bill





