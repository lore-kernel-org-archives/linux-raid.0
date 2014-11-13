From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Disks never stop spinning
Date: Thu, 13 Nov 2014 14:05:58 +0000
Message-ID: <21604.47814.651762.246947@tree.ty.sabi.co.uk>
References: <54610788.6060103@gautschi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54610788.6060103@gautschi.net>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> I've got an array (on kubuntu 14.10) with 5 WD-RED drives and
> would like them to stop rotating when there is no access for
> 10 minutes. I used hdparm -S 120

That works here for 6 disks on which I have created various
types of MD sets for holding data or for testing.

  #  cat /proc/mdstat 
  Personalities : [raid6] [raid5] [raid4] [raid10] [linear] [multipath] [raid0] [raid1] 
  md1 : active raid10 sde3[6] sdd3[4] sdb3[0] sdc3[5]
	486538976 blocks super 1.0 16K chunks 2 near-copies [4/4] [UUUU]

  md4 : active raid6 sde4[3] sdb4[0] sdg4[7] sdd4[2] sdf4[6] sdc4[1]
	973077760 blocks super 1.0 level 6, 64k chunk, algorithm 2 [6/6] [UUUUUU]

  md2 : active raid5 sde2[2] sdg2[5] sdf2[3] sdc2[0] sdd2[1]
	486538752 blocks super 1.0 level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]

  md0 : active raid10 sde1[3] sdb1[0] sdg1[5] sdf1[4] sdc1[1] sdd1[2]
	364904208 blocks super 1.0 16K chunks 2 near-copies [6/6] [UUUUUU]

  unused devices: <none>

  #  hddtemp /dev/sd[bcdef]
  /dev/sdb: SAMSUNG HD103UJ: drive is sleeping
  /dev/sdc: WDC WD10EZEX-22RKKA0: drive is sleeping
  /dev/sdd: ST1000DM003-9YN162: drive is sleeping
  /dev/sde: SAMSUNG HD103SJ: drive is sleeping
  /dev/sdf: WDC WD10EZEX-22RKKA0: drive is sleeping

> for all of them but they keep on running. [ ... ]

That means something else is waking up those disks. To verify
this use something like:

  sudo iostat -dkxz 1

or use something like:

  sudo sysctl vm/block_dump=1; sleep 120; sudo sysctl vm/block_dump=0

and then look at the debug log to see which inodes get hit.
