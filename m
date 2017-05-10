From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: Resync of the degraded RAID10 array
Date: Wed, 10 May 2017 16:00:44 +0200
Message-ID: <20170510140044.GA23565@proton.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I wonder what should be the resync behaviour for the degraded RAID10 array.

cat /proc/mdstat
Personalities : [raid10] 
md127 : active raid10 nvme3n1[3] nvme2n1[2] nvme1n1[1] nvme0n1[0]
      2097152 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
	  [==>..................]  resync = 11.0% (232704/2097152) finish=0.1min speed=232704K/sec

mdadm -If nvme3n1
mdadm: set nvme3n1 faulty in md127
mdadm: hot removed nvme3n1 from md127

cat /proc/mdstat
Personalities : [raid10] 
md127 : active (auto-read-only) raid10 nvme2n1[2] nvme1n1[1] nvme0n1[0]
      2097152 blocks super 1.2 512K chunks 2 near-copies [4/3] [UUU_]
	  resync=PENDING

cat /sys/block/md127/md/resync_start
465408

At the moment it stops the resync. When new disk is added to the array, the
recovery starts and completes, however no resync for the first 2 disks takes
place and array is reported as clean when it's really out-of-sync.

My kernel version is 4.11.

What is the expected behaviour? Shall resync continue on 3-disk RAID10 or
shall it be restarted when recovery completes?

Regards,

Tomek
