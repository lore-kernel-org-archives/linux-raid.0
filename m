From: "John Stoffel" <john@stoffel.org>
Subject: zeroing old superblocks & upgrading...
Date: Thu, 6 Jul 2006 18:22:31 -0400
Message-ID: <17581.36135.379062.709693@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Luca Berra <bluca@comedia.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Neil,

First off, thanks for all your hard work on this software, it's really
a great thing to have.

But I've got some interesting issues here.  Though not urgent.  As
I've said in other messages, I've got a pair of 120gb HDs mirrored.
I'm using MD across partitions, /dev/hde1 and /dev/hdg1.  Works
nicely.

But I see that I have an old superblock sitting around on /dev/hde
(notice, no partition here!) which I'd like to clean up.

    # mdadm -E /dev/hde
    /dev/hde:
	      Magic : a92b4efc
	    Version : 00.90.00
	       UUID : 9835ebd0:5d02ebf0:907edc91:c4bf97b2
      Creation Time : Fri Oct 24 19:11:02 2003
	 Raid Level : raid1
	Device Size : 117220736 (111.79 GiB 120.03 GB)
	 Array Size : 117220736 (111.79 GiB 120.03 GB)
       Raid Devices : 2
      Total Devices : 2
    Preferred Minor : 0

	Update Time : Fri Oct 24 19:21:59 2003
	      State : clean
     Active Devices : 1
    Working Devices : 1
     Failed Devices : 1
      Spare Devices : 0
	   Checksum : 79d2a6fd - correct
	     Events : 0.2


	  Number   Major   Minor   RaidDevice State
    this     0       3        0        0      active sync   /dev/hda

       0     0       3        0        0      active sync   /dev/hda
       1     1       0        0        1      faulty


Here's the correct ones:

    # mdadm -E /dev/hde1
    /dev/hde1:
	      Magic : a92b4efc
	    Version : 00.90.00
	       UUID : 2e078443:42b63ef5:cc179492:aecf0094
      Creation Time : Fri Oct 24 19:23:41 2003
	 Raid Level : raid1
	Device Size : 117218176 (111.79 GiB 120.03 GB)
	 Array Size : 117218176 (111.79 GiB 120.03 GB)
       Raid Devices : 2
      Total Devices : 2
    Preferred Minor : 0

	Update Time : Thu Jul  6 18:21:08 2006
	      State : clean
     Active Devices : 2
    Working Devices : 2
     Failed Devices : 0
      Spare Devices : 0
	   Checksum : 210069e5 - correct
	     Events : 0.7762540


	  Number   Major   Minor   RaidDevice State
    this     0      33        1        0      active sync   /dev/hde1

       0     0      33        1        0      active sync   /dev/hde1
       1     1      34        1        1      active sync   /dev/hdg1


I can't seem to zero it out:

  # mdadm --misc --zero-superblock /dev/hde
  mdadm: Couldn't open /dev/hde for write - not zeroing

Should I just ignore this, or should I break off /dev/hde from the
array and scrub the disk and then re-add it back in?

Also, can I upgrade my superblock to the latest version with out any
problems?

Thanks,
John
