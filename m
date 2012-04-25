From: Brian Candler <B.Candler@pobox.com>
Subject: RAID6 fails to assemble after unclean shutdown
Date: Wed, 25 Apr 2012 11:35:36 +0100
Message-ID: <20120425103536.GA9978@nsrc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a storage box (currently under test) which has two 12-drive RAID6
arrays, /dev/md/data1 and /dev/md/data2.

The box crashed for an unrelated reason, and when I brought it back up, only
one of the arrays assembled:

  root@storage1:~# cat /proc/mdstat
  Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
  md126 : active raid6 sdj[8] sdk[9] sdd[2] sde[3] sdi[7] sdm[11] sdg[5] sdc[1] sdb[0] sdl[10] sdh[6] sdf[4]
        29302650880 blocks super 1.2 level 6, 1024k chunk, algorithm 2 [12/12] [UUUUUUUUUUUU]
        
  md127 : inactive sdq[3](S) sdx[10](S) sdu[6](S) sdt[5](S) sds[4](S) sdv[8](S) sdp[2](S) sdy[11](S) sdo[1](S) sdn[0](S) sdw[9](S) sdr[7](S)
        35163186720 blocks super 1.2
         
  unused devices: <none>

So it looks like 12 of the disks have all become spares (S)!

An attempt to manually assemble the array failed:

  root@storage1:~# mdadm --stop /dev/md127
  mdadm: stopped /dev/md127
  root@storage1:~# mdadm --assemble /dev/md/disk2 /dev/sd{n..y}
  mdadm: /dev/md/disk2 assembled from 4 drives - not enough to start the array.

Since this is currently under test system I just forcibly recreated the
array, but I'm a bit worried about how I would handle this problem when I go
into production.

Here is how I recreated the array:

  root@storage1:~# mdadm --create /dev/md/disk2 -n 12 -c 1024 -l raid6 /dev/sd{n..y}
  mdadm: /dev/sdn appears to be part of a raid array:
      level=raid6 devices=12 ctime=Mon Mar 19 11:52:55 2012
  mdadm: /dev/sdo appears to be part of a raid array:
      level=raid6 devices=12 ctime=Mon Mar 19 11:52:55 2012
  mdadm: /dev/sdp appears to be part of a raid array:
      level=raid6 devices=12 ctime=Mon Mar 19 11:52:55 2012
  mdadm: /dev/sdq appears to be part of a raid array:
      level=raid6 devices=12 ctime=Mon Mar 19 11:52:55 2012
  mdadm: /dev/sdr appears to be part of a raid array:
      level=raid6 devices=12 ctime=Mon Mar 19 11:52:55 2012
  mdadm: /dev/sds appears to be part of a raid array:
      level=raid6 devices=12 ctime=Mon Mar 19 11:52:55 2012
  mdadm: /dev/sdt appears to be part of a raid array:
      level=raid6 devices=12 ctime=Mon Mar 19 11:52:55 2012
  mdadm: /dev/sdu appears to be part of a raid array:
      level=raid6 devices=12 ctime=Mon Mar 19 11:52:55 2012
  mdadm: /dev/sdv appears to be part of a raid array:
      level=raid6 devices=12 ctime=Mon Mar 19 11:52:55 2012
  mdadm: /dev/sdw appears to be part of a raid array:
      level=raid6 devices=12 ctime=Mon Mar 19 11:52:55 2012
  mdadm: /dev/sdx appears to be part of a raid array:
      level=raid6 devices=12 ctime=Mon Mar 19 11:52:55 2012
  mdadm: /dev/sdy appears to be part of a raid array:
  # /etc/fstab: static file system information.
      level=raid6 devices=12 ctime=Mon Mar 19 11:52:55 2012
  Continue creating array? y
  mdadm: Defaulting to version 1.2 metadata
  mdadm: array /dev/md/disk2 started.

So it seems like all the disks were known to be part of an array, but mdadm
was still unable to assemble more than 4.

Platform: Ubuntu 11.10 server x86_64, stock kernel:

  Linux storage1 3.0.0-16-server #29-Ubuntu SMP Tue Feb 14 13:08:12 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

Unfortunately I saw the same problem once before on a different test system,
and also had to forcibly rebuild the array.

So my questions are:

* Have I built the RAID array correctly in the first place? Are there some
options I could have given to mdadm to make it more robust?

* What should I have done when presented with an array which would not
assemble, to attempt to recover without losing data?

* Any ideas why mdadm only thought 4 of the drives were usable?

Thanks,

Brian.
