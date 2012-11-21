From: "George Spelvin" <linux@horizon.com>
Subject: Re: want-replacement got stuck?
Date: 21 Nov 2012 16:19:10 -0500
Message-ID: <20121121211910.22223.qmail@science.horizon.com>
References: <50AD29B4.9050004@shiftmail.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50AD29B4.9050004@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: joystick@shiftmail.org, linux-raid@vger.kernel.org, linux@horizon.com
List-Id: linux-raid.ids

Here are the results from your suggestions.  The check produced something
interesting: it halted almost instantly, rather than doing anything.

# for i in /dev/sd[a-e]2 ; do echo ; mdadm -X /dev/$i ; done

        Filename : /dev/sda2
           Magic : 6d746962
         Version : 4
            UUID : 69952341:376cf679:a23623b9:31f68afb
          Events : 8617657
  Events Cleared : 8617657
           State : OK
       Chunksize : 2 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 725591552 (691.98 GiB 743.01 GB)
          Bitmap : 354293 bits (chunks), 7421 dirty (2.1%)

        Filename : /dev/sdb2
           Magic : 6d746962
         Version : 4
            UUID : 69952341:376cf679:a23623b9:31f68afb
          Events : 8617657
  Events Cleared : 8617657
           State : OK
       Chunksize : 2 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 725591552 (691.98 GiB 743.01 GB)
          Bitmap : 354293 bits (chunks), 7421 dirty (2.1%)

        Filename : /dev/sdc2
           Magic : 6d746962
         Version : 4
            UUID : 69952341:376cf679:a23623b9:31f68afb
          Events : 8617655
  Events Cleared : 8617653
           State : OK
       Chunksize : 2 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 725591552 (691.98 GiB 743.01 GB)
          Bitmap : 354293 bits (chunks), 13 dirty (0.0%)

        Filename : /dev/sdd2
           Magic : 6d746962
         Version : 4
            UUID : 69952341:376cf679:a23623b9:31f68afb
          Events : 8617657
  Events Cleared : 8617657
           State : OK
       Chunksize : 2 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 725591552 (691.98 GiB 743.01 GB)
          Bitmap : 354293 bits (chunks), 7421 dirty (2.1%)

        Filename : /dev/sde2
           Magic : 6d746962
         Version : 4
            UUID : 69952341:376cf679:a23623b9:31f68afb
          Events : 8617657
  Events Cleared : 8617657
           State : OK
       Chunksize : 2 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 725591552 (691.98 GiB 743.01 GB)
          Bitmap : 354293 bits (chunks), 7421 dirty (2.1%)

# cat /sys/block/md5/md/mismatch_cnt
128
# cat /sys/block/md5/md/sync_action
idle
# echo check > /sys/block/md5/md/sync_action

	Unexpected news: does not appear to start!  Immediately after:

# cat /sys/block/md5/md/sync_action
idle

# !echo ; !cat
check
# tail /var/log/kern.log
Nov 21 20:45:09 science kernel: md: data-check of RAID array md5
Nov 21 20:45:09 science kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
Nov 21 20:45:09 science kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
Nov 21 20:45:09 science kernel: md: using 128k window, over a total of 725591552k.
Nov 21 20:45:09 science kernel: md: md5: data-check done.
Nov 21 20:45:45 science kernel: md: data-check of RAID array md5
Nov 21 20:45:45 science kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
Nov 21 20:45:45 science kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
Nov 21 20:45:45 science kernel: md: using 128k window, over a total of 725591552k.
Nov 21 20:45:45 science kernel: md: md5: data-check done.
# echo check > /sys/block/md5/md/sync_action ; cat /sys/block/md5/md/sync_action
check
# echo check > /sys/block/md5/md/sync_action ; sleep 0.1 ; cat /sys/block/md5/md/sync_action
idle

# cat /sys/block/md5/md/mismatch_cnt
0
# echo check > /sys/block/md5/md/sync_action ; cat /proc/mdstat /sys/block/md5/md/sync_action
Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] 
md5 : active raid10 sdd2[3](R) sdb2[1] sde2[2] sdc2[4](F) sda2[0]
      725591552 blocks 256K chunks 2 near-copies [4/4] [UUU_]
      [===================>.]  check = 99.9% (725591296/725591552) finish=0.2min speed=0K/sec
      bitmap: 99/173 pages [396KB], 2048KB chunk
      
unused devices: <none>
check

I read sectors 725591296+/-1000 with hdparm --read-sector on sdc2 and sdd2 (they were actually
reads of /dev/sdc and /dev/sdd with the aopprioriate partition offset, obviously), and saw no errors.
