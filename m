From: Janos Farkas <chexum+dev@gmail.com>
Subject: mdadm -X bitmap status off by 2^16
Date: Tue, 18 Jul 2006 08:46:13 +0200
Message-ID: <priv$efbe06145625$36d67b3763@200607.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

Another pseudo-problem :) I've just set up a RAID5 array by creating a
three-disk one from two disks, and later adding the third.  Everything
seems normal, but the mdadm (2.5.2) -X output:

        Filename : /dev/hda3
           Magic : 6d746962
         Version : 4
            UUID : 293ceee6.d1811fb1.a8b316e6.b54abcc7
          Events : 12
  Events Cleared : 12
           State : OK
       Chunksize : 1 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 292784512 (279.22 GiB 299.81 GB)
          Bitmap : 285923 bits (chunks), 65536 dirty (22.9%)

# for i in hdb3 hdd3 hda3 ; mdadm -X /dev/$i|grep map
          Bitmap : 285923 bits (chunks), 0 dirty (0.0%)
          Bitmap : 285923 bits (chunks), 0 dirty (0.0%)
          Bitmap : 285923 bits (chunks), 65536 dirty (22.9%)
# for i in hdb3 hdd3 hda3 ; mdadm -X /dev/$i|grep map
          Bitmap : 285923 bits (chunks), 1 dirty (0.0%)
          Bitmap : 285923 bits (chunks), 1 dirty (0.0%)
          Bitmap : 285923 bits (chunks), 65537 dirty (22.9%)
# for i in hdb3 hdd3 hda3 ; mdadm -X /dev/$i|grep map
          Bitmap : 285923 bits (chunks), 7 dirty (0.0%)
          Bitmap : 285923 bits (chunks), 7 dirty (0.0%)
          Bitmap : 285923 bits (chunks), 65543 dirty (22.9%)
# for i in hdb3 hdd3 hda3 ; mdadm -X /dev/$i|grep map
          Bitmap : 285923 bits (chunks), 0 dirty (0.0%)
          Bitmap : 285923 bits (chunks), 0 dirty (0.0%)
          Bitmap : 285923 bits (chunks), 65536 dirty (22.9%)

# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md0 : active raid5 hdd3[2] hdb3[0] hda3[1]
      585569024 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
      bitmap: 0/140 pages [0KB], 1024KB chunk

Is this going to bite me later on, or just a harmless display problem?

Janos
