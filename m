From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 4/8] imsm: FIX: old devices memory has to be released
Date: Wed, 12 Jan 2011 14:54:50 +0100
Message-ID: <20110112135450.15045.20961.stgit@gklab-128-013.igk.intel.com>
References: <20110112132954.15045.41564.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110112132954.15045.41564.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When process_update() replaces memory for bigger devices, old memory areas are collected in a list
and has to be assigned in to pointer in update for later release.

List created from old devices is created and attached to space_list for later releasing.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index de41702..c3ff365 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5744,6 +5744,8 @@ static int apply_reshape_container_disks_update(struct imsm_update_reshape *u,
 		*sp = tofree;
 		tofree = sp;
 	}
+	if (tofree)
+		*space_list = tofree;
 	ret_val = 1;
 
 update_reshape_exit:

