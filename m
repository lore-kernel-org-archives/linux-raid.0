From: Jeff Baitis <baitisj@evolution.com>
Subject: raidreconf success raid0 -> raid5, 60051568kB
Date: Sat, 16 Aug 2003 03:15:45 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030816031544.B5582@luca.pas.lab>
Reply-To: baitisj@evolution.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!
Just had a success upgrading a RAID0 to RAID5. Details below.

Quick question: in my machine, hda and hdg are both the same model hard drives
with the same geometry; however, hde is a larger drive with different geometry.
Shouldn't all the raid 5 devices be the same size? If I lose hde3, will I have
missing 'holes' in my filesystem? Or is Linux smart about that?

Here is the output of raidreconf:

raidreconf -o raidtab.old -n raidtab.new -m /dev/md0
    Working (\) [00938304/00938304] [############################################] 
    Source drained, flushing sink.
    Reconfiguration succeeded, will update superblocks...
    Updating superblocks...
    handling MD device /dev/md0
    analyzing super-block
    disk 0: /dev/hda1, 60051568kB, raid superblock at 60051456kB
    disk 1: /dev/hde3, 60067035kB, raid superblock at 60066944kB
    disk 2: /dev/hdg1, 60051568kB, raid superblock at 60051456kB
    Array is updated with kernel.
    Disks re-inserted in array... Hold on while starting the array...
    Maximum friend-freeing depth:         2
    Total wishes hooked:             938304
    Maximum wishes hooked:             1047
    Total gifts hooked:              938304
    Maximum gifts hooked:              1047
    Congratulations, your array has been reconfigured,
    and no errors seem to have occured.

raidtab.old:
    raiddev /dev/md0
    raid-level 0
    persistent-superblock 1
    nr-raid-disks 2
    chunk-size 128
    nr-spare-disks 0
    device /dev/hdg1
    raid-disk 0
    device /dev/hda1
    raid-disk 1

raidtab.new:
    raiddev /dev/md0
    raid-level 5
    persistent-superblock 1
    nr-raid-disks 3
    parity-algorithm left-symmetric
    chunk-size 128
    nr-spare-disks 0

    device /dev/hda1
    raid-disk 0

    device /dev/hde3
    raid-disk 1

    device /dev/hdg1
    raid-disk 2

Thanks. I hope this information is useful to someone.

-- 
         Jeffrey Baitis - Associate Software Engineer

                    Evolution Robotics, Inc.
                     130 West Union Street
                       Pasadena CA 91103

 tel: 626.535.2776  |  fax: 626.535.2777  |  baitisj@evolution.com 

