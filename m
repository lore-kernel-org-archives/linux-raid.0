From: "John Stoffel" <stoffel@lucent.com>
Subject: Re: Half of RAID1 array missing on 2.6.7-rc3
Date: Thu, 5 Aug 2004 15:38:07 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16658.35999.308999.766527@gargle.gargle.HOWL>
References: <16658.16220.904470.117836@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16658.16220.904470.117836@gargle.gargle.HOWL>
To: John Stoffel <stoffel@lucent.com>
Cc: linux-raid@vger.kernel.org, stoffel@sekrit.inse.lucent.com
List-Id: linux-raid.ids


Hi folks,

I think I've found the problem.  At least there are a couple of
problems here.

1. When the md code tries to run the various hot-add scripts, it gives
   back a fairly useless error.  It should instead tell you that the
   device is locked by some other user and hopefully tell you WHAT
   that user is.

I finally started poking around at device mapper stuff as well, and I
ran the command:

   # dmsetup status
   sdb3: 0 33061770 linear 
   sdb2: 0 1992060 linear 
   data_vg-local_lv: 0 62914560 linear 
   data_vg-local_lv: 62914560 10485760 linear 
   sdb1: 0 497952 linear 
   data_vg-home_lv: 0 83886080 linear 
   data_vg-home_lv: 83886080 23068672 linear 
   sdc2: 0 97656048 linear 
   sdc1: 0 117186993 linear 
   hdg1: 0 234436482 linear 

Notice how hdg1 is listed as a LINEAR device.  I certainly didn't do
that by default, god knows how it gets picked up.  But once I did:

   # dmsetup remove hdg1

It was removed!!  

   # dmsetup status
   sdb3: 0 33061770 linear 
   sdb2: 0 1992060 linear 
   data_vg-local_lv: 0 62914560 linear 
   data_vg-local_lv: 62914560 10485760 linear 
   sdb1: 0 497952 linear 
   data_vg-home_lv: 0 83886080 linear 
   data_vg-home_lv: 83886080 23068672 linear 
   sdc2: 0 97656048 linear 
   sdc1: 0 117186993 linear 

So now I was able to do:

   # mdadm /dev/md0 --force -a /dev/hdg1
   mdadm: hot added /dev/hdg1

Which was great to see.  

   # cat /proc/mdstat 
   Personalities : [linear] [raid0] [raid1] [raid5] 
   md0 : active raid1 hdg1[2] hde1[0]
	 117218176 blocks [2/1] [U_]
	 [>....................]  recovery =  0.5% (673664/117218176) finish=49.0min speed=39627K/sec
   unused devices: <none>

And now it's re-building the mirror properly.  So now I need to see
how I can stop the Device Mapper stuff from taking over and
controlling various devices.  The /dev/sdb? and the /dev/sdc? ones are
also problematic, since those are just a second SCSI disk and a USB
storage device.  Hmm... I wonder if I remove the usb-storage device
from device mapper I'll be able to finally write all the data to it
without locking up the system.  Gotta try that out.

I do appreciate the people who gave suggestions, even though it didn't
turn out to be the right solution in the end.  

Now to figure out how to make device mapper only look at /dev/md*
devices in the future.

John

