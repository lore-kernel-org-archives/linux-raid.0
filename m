From: "Johan Tufberg" <tufberg@home.se>
Subject: Linear raid and superblock update time inconsistency
Date: Mon, 8 Dec 2003 19:30:06 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00aa01c3bdb9$4e4c0470$6400a8c0@tubbitwinxp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello

I have a question concerning Linear RAID and superblock update time
inconsistency. My server came to a sudden breakdown when the power was lost.
When i tried to start the machine i get the errors pasted below on my Linear
RAID device. What should I do, mkraid --force /dev/mdo, will de data be
intact?

Regards
/Johan


_____ DMESG_______________START
md: marking sb clean...
md: md0 stopped.
md: unbind<hdh1,3>
md: export_rdev(hdh1)
md: unbind<hdg1,2>
md: export_rdev(hdg1)
md: unbind<hdf1,1>
md: export_rdev(hdf1)
md: unbind<hde1,0>
md: export_rdev(hde1)
 [events: 0000002a]
 [events: 0000002a]
 [events: 0000001c]
 [events: 0000002c]
md: autorun ...
md: considering hdh1 ...
md:  adding hdh1 ...
md:  adding hdg1 ...
md:  adding hdf1 ...
md:  adding hde1 ...
md: created md0
md: bind<hde1,1>
md: bind<hdf1,2>
md: bind<hdg1,3>
md: bind<hdh1,4>
md: running: <hdh1><hdg1><hdf1><hde1>
md: hdh1's event counter: 0000002c
md: hdg1's event counter: 0000001c
md: hdf1's event counter: 0000002a
md: hde1's event counter: 0000002a
md: superblock update time inconsistency -- using the most recent one
md: freshest: hdh1
md: kicking non-fresh hdg1 from array!
md: unbind<hdg1,3>
md: export_rdev(hdg1)
md: kicking non-fresh hdf1 from array!
md: unbind<hdf1,2>
md: export_rdev(hdf1)
md: kicking non-fresh hde1 from array!
md: unbind<hde1,1>
md: export_rdev(hde1)
md0: former device hde1 is unavailable, removing from array!
md0: former device hdf1 is unavailable, removing from array!
md0: former device hdg1 is unavailable, removing from array!
md0: max total readahead window set to 124k
md0: 1 data-disks, max readahead per data-disk: 124k
md: md0, array needs 4 disks, has 1, aborting.
linear: disks are not ordered, aborting!
md: pers->run() failed ...
md :do_md_run() returned -22
md: md0 stopped.
md: unbind<hdh1,0>
md: export_rdev(hdh1)
md: ... autorun DONE.
__________________________END

___________RAIDTAB_______________
raiddev /dev/md0
           raid-level              linear
           nr-raid-disks           4
           persistent-superblock   1
           chunk-size              8

           device                  /dev/hde1
           raid-disk               0
           device                  /dev/hdf1
           raid-disk               1
           device                  /dev/hdg1
           raid-disk               2
           device                  /dev/hdh1
           raid-disk               3

