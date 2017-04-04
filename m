From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH 0/4] PPL fixes and improvements
Date: Tue,  4 Apr 2017 13:13:54 +0200
Message-ID: <20170404111358.14829-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

These are mostly fixes for possible deadlocks related to memory allocation and
one optimization.

Artur Paszkiewicz (4):
  raid5-ppl: use a single mempool for ppl_io_unit and header_page
  raid5-ppl: move no_mem_stripes to struct ppl_conf
  raid5-ppl: use resize_stripes() when enabling or disabling ppl
  raid5-ppl: partial parity calculation optimization

 drivers/md/raid5-log.h |   5 ++-
 drivers/md/raid5-ppl.c | 112 +++++++++++++++++++++++++++++++------------------
 drivers/md/raid5.c     |  94 ++++++++++++++++++-----------------------
 3 files changed, 115 insertions(+), 96 deletions(-)

-- 
2.11.0

