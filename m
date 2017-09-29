From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH 0/2] Two fixes for PPL recovery
Date: Fri, 29 Sep 2017 22:54:17 +0200
Message-ID: <20170929205419.16715-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

These patches fix some issues that can occur when array rebuild starts after
ppl recovery.

Artur Paszkiewicz (2):
  raid5-ppl: don't resync after rebuild
  raid5-ppl: check recovery_offset when performing ppl recovery

 drivers/md/raid5-ppl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
2.14.1

