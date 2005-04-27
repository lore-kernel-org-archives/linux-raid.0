From: bernd@rhm.de
Subject: raidstart fails at boot
Date: Wed, 27 Apr 2005 14:12:51 +0200 (MESZ)
Message-ID: <200504271212.OAA27495@node130.rhm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

just a question to some messages at boot telling raidstart failed although 
the system works ok. We find these messages in /var/log/boot.msg on
SuSE 9.3 (kernel 2.6.11). The arrays are assambled as expected, but then 
raidstart fails. We use RAID1, md0 is swap, md1 is root and md2 is data.
Can we safely ignore the messages from raidstart?

Thanks in advance.
Bernd Rieke

.....
<6>md: Autodetecting RAID arrays.
<6>md: autorun ...
<6>md: considering sdd1 ...
<6>md:  adding sdd1 ...
<4>md: sdc2 has different UUID to sdd1
<4>md: sdc1 has different UUID to sdd1
<6>md:  adding sdb1 ...
<4>md: sda2 has different UUID to sdd1
<4>md: sda1 has different UUID to sdd1
<6>md: created md2
<6>md: bind<sdb1>
<6>md: bind<sdd1>
<6>md: running: <sdd1><sdb1>
<6>raid1: raid set md2 active with 2 out of 2 mirrors
<6>md: considering sdc2 ...
<6>md:  adding sdc2 ...
<4>md: sdc1 has different UUID to sdc2
<6>md:  adding sda2 ...
<4>md: sda1 has different UUID to sdc2
<6>md: created md1
<6>md: bind<sda2>
<6>md: bind<sdc2>
<6>md: running: <sdc2><sda2>
<6>raid1: raid set md1 active with 2 out of 2 mirrors
<6>md: considering sdc1 ...
<6>md:  adding sdc1 ...
<6>md:  adding sda1 ...
<6>md: created md0
<6>md: bind<sda1>
<6>md: bind<sdc1>
<6>md: running: <sdc1><sda1>
<6>raid1: raid set md0 active with 2 out of 2 mirrors
<6>md: ... autorun DONE.
<5>ReiserFS: md1: found reiserfs format "3.6" with standard journal
<5>ReiserFS: md1: using ordered data mode
<4>reiserfs: using flush barriers
<5>ReiserFS: md1: journal params: device md1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
<5>ReiserFS: md1: checking transaction log (md1)
<5>ReiserFS: md1: Using r5 hash to sort names
<6>Adding 2104376k swap on /dev/md0.  Priority:42 extents:1

<4>md: raidstart(pid 2437) used deprecated START_ARRAY ioctl. This will not be supported beyond 2.6
<3>md: could not bd_claim sda1.
<4>md: autostart failed!
<6>device-mapper: 4.4.0-ioctl (2005-01-12) initialised: dm-devel@redhat.com
<4>md: raidstart(pid 2437) used deprecated START_ARRAY ioctl. This will not be supported beyond 2.6
<3>md: could not bd_claim sda2.
<4>md: autostart failed!
<4>md: raidstart(pid 2437) used deprecated START_ARRAY ioctl. This will not be supported beyond 2.6
<3>md: could not bd_claim sdb1.
<4>md: autostart failed!
<6>md: Autodetecting RAID arrays.
<6>md: autorun ...
<6>md: ... autorun DONE.
....
