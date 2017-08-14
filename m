From: Shaohua Li <shli@kernel.org>
Subject: [PATCH V2 0/9] nullb: extend nullb for destructive tests
Date: Mon, 14 Aug 2017 15:04:51 -0700
Message-ID: <cover.1502746933.git.shli@fb.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Cc: kernel-team@fb.com, Kyungchan Koh <kyungchan.koh@gmail.com>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

From: Shaohua Li <shli@fb.com>

In testing software RAID, I usually found it's hard to cover specific cases.
RAID is supposed to work even disk is in semi good state, for example, some
sectors are broken. Since we can't control the behavior of hardware, it's
difficult to create test suites to do the destructive tests. But we can control
the behavior of software, software based disk is an obvious choice for such
tests. While we already have several software based disks for testing (eg,
null_blk, scsi_debug), none is for destructive testing. Per Jens's request, we
extend null_blk to do the destructive testing.

To make this happen, we create new configfs interface for null_blk and added
some test features in null_blk:

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

To maintain compatibility, old null_blk module parameter interface is kept,
user can still create disks with it. Those disks aren't controlled by configfs
interface. Configfs interface will create/delete new disks. New features added
in the patchset will only be available with configfs interface.

While this is inspired by software raid testing, the interface  is very
flexible for extension. We can easily add new features into the driver. The
interface is configfs, which can be configured with a shell script. There is a
'features' attribute exposing all supported features. By checking this, we
don't need to worry about compability issues. For configuration details, please
check the second patch.

This is Kyungchan Koh's intern project. I made some changes and adopted to
null_blk, all errors are mine. You are more than welcomed to test and add new
features!

Thanks,
Shaohua

Shaohua Li (9):
  nullb: factor disk parameters
  nullb: add configfs interface
  nullb: add interface to power on disk
  nullb: use ida to manage index
  nullb: support memory backed store
  nullb: support discard
  nullb: bandwidth control
  nullb: emulate cache
  nullb: badbblocks support

 drivers/block/Kconfig    |    1 +
 drivers/block/null_blk.c | 1303 ++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 1214 insertions(+), 90 deletions(-)

-- 
2.9.5

