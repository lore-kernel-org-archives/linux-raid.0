From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH 0/2] md: Add support for Multiple PPLs
Date: Wed, 16 Aug 2017 17:13:44 +0200
Message-ID: <20170816151346.23382-1-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, Pawel Baldysiak <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

Current Partial Parity Log implementation allows only single PPL to be
written to particular member drive. In such case PPL entry is
overwritten by every write as it's stored at the same sector of a drive.
Such approach is suboptimal for SSD drives as it leads to increased
write amplification factor due to write-after-write limitations.

This patchset changes the implementation by extending PPL area to 1MB.
PPL is not stored at fixed location but multiple PPLs are written in a
circular buffer. There is at most one valid PPL at any time (latest
one). Recovery algorithm stays the same. The main benefits of this
approach are increased drive lifespan and in some cases improved
performance. 

Pawel Baldysiak (2):
  md: Runtime support for multiple ppls
  raid5-ppl: Recovery support for multiple partial parity logs

 drivers/md/md.c                |  16 +++-
 drivers/md/md.h                |   1 +
 drivers/md/raid0.c             |   3 +-
 drivers/md/raid1.c             |   3 +-
 drivers/md/raid5-ppl.c         | 171 +++++++++++++++++++++++++++++++----------
 drivers/md/raid5.c             |   1 +
 include/uapi/linux/raid/md_p.h |   4 +-
 7 files changed, 152 insertions(+), 47 deletions(-)

-- 
2.13.4

