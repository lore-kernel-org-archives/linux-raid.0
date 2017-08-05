From: Shaohua Li <shli@kernel.org>
Subject: [PATCH 0/5] block: a virtual block device driver for testing
Date: Sat,  5 Aug 2017 08:51:44 -0700
Message-ID: <cover.1501945859.git.shli@fb.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Cc: kernel-team@fb.com, Kyungchan Koh <kyungchan.koh@gmail.com>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

From: Shaohua Li <shli@fb.com>

In testing software RAID, I usually found it's hard to cover specific cases.
RAID is supposed to work even disk is in semi good state, for example, some
sectors are broken. Since we can't control the behavior of hardware, it's
difficult to create test suites to do destructive tests. But we can control the
behavior of software, software based disk is an obvious choice for such tests.
While we already have several software based disks for testing (eg, null_blk,
scsi_debug), none is for destructive testing, this is the reason we create a
new test block device.

Currently the driver can create disk with following features:
- Bandwidth control. A raid array consists of several disks. The disks could
  run in different speed, for example, one disk is SSD and the other is HD.
  Actually raid1 has a feature called write behind just for this. To test such
  raid1 feature, we'd like the disks speed could be controlled.
- Emulate disk cache. Software must flush disk cache to guarantee data is
  safely stored in media after a power failure. To verify if software works
  well, we can't simply use physical disk, because even software doesn't flush
  cache, the hardware probably will flush the cache. With a software
  implementation of disk cache, we can fully control how we flush disk cache in a
  power failure.
- Badblock. If only part of a disk is broken, software raid continues working.
  To test if software raid works well, disks must include some broken parts or
  bad blocks. Bad blocks can be easily implemented in software.

While this is inspired by software raid testing, the driver is very flexible
for extension. We can easily add new features into the driver. The interface is
configfs, which can be configured with a shell script. There is a 'features'
attribute exposing all supported features. By checking this, we don't need to
worry about compability issues. For configuration details, please check the
first patch.

This is William's intern project. I made some changes, all errors are mine. You
are more than welcomed to test and add new features!

Thanks,
Shaohua

Kyungchan Koh (4):
  testb: add interface
  testb: implement block device operations
  testb: implement bandwidth control
  testb: emulate disk cache

Shaohua Li (1):
  testb: badblock support

 drivers/block/Kconfig    |    8 +
 drivers/block/Makefile   |    2 +
 drivers/block/test_blk.c | 1294 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1304 insertions(+)
 create mode 100644 drivers/block/test_blk.c

-- 
2.9.3
