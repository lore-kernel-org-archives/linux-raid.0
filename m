From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 03/16] FIX: remove unnecessary load_super() call
Date: Mon, 13 Dec 2010 15:45:13 +0100
Message-ID: <20101213144513.4384.80149.stgit@gklab-170-024.igk.intel.com>
References: <20101213143604.4384.55544.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101213143604.4384.55544.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Code cleanup. Remove unnecessary load_super() call

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 6697257..0a27836 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -8159,14 +8159,6 @@ int imsm_manage_container_reshape(struct supertype *st, char *backup)
 			int array;
 
 			for (i = 0; i < mpb->num_raid_devs; i++) {
-				struct intel_super *super;
-
-				st->ss->load_super(st, fd, NULL);
-				if (st->sb == NULL) {
-					dprintf("cannot get sb\n");
-					ret_val = 1;
-					goto imsm_manage_container_reshape_exit;
-				}
 				info2.devs = NULL;
 				super = st->sb;
 				super->current_vol = i;

