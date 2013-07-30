From: mwilck@arcor.de
Subject: [PATCH 02/10] DDF: log disk status changes more nicely
Date: Tue, 30 Jul 2013 23:18:26 +0200
Message-ID: <1375219114-5626-3-git-send-email-mwilck@arcor.de>
References: <51F82D3B.6060104@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51F82D3B.6060104@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

From: Martin Wilck <mwilck@arcor.de>

In particular, include refnum for better tracking. This makes
it a little easier for humans to track what happened to which disk.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 46262ce..20f4cf4 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -4203,7 +4203,8 @@ static void ddf_set_disk(struct active_array *a, int n, int state)
 			ddf_set_updates_pending(ddf);
 	}
 
-	dprintf("ddf: set_disk %d to %x\n", n, state);
+	dprintf("ddf: set_disk %d (%08x) to %x\n", n,
+		be32_to_cpu(dl->disk.refnum), state);
 
 	/* Now we need to check the state of the array and update
 	 * virtual_disk.entries[n].state.
@@ -4803,7 +4804,9 @@ static struct mdinfo *ddf_activate_spare(struct active_array *a,
 				if (d2->state_fd >= 0 &&
 				    d2->disk.major == dl->major &&
 				    d2->disk.minor == dl->minor) {
-					dprintf("%x:%x already in array\n", dl->major, dl->minor);
+					dprintf("%x:%x (%08x) already in array\n",
+						dl->major, dl->minor,
+						be32_to_cpu(dl->disk.refnum));
 					break;
 				}
 			if (d2)
@@ -4883,8 +4886,9 @@ static struct mdinfo *ddf_activate_spare(struct active_array *a,
 			di->container_member = dl->pdnum;
 			di->next = rv;
 			rv = di;
-			dprintf("%x:%x to be %d at %llu\n", dl->major, dl->minor,
-				i, pos);
+			dprintf("%x:%x (%08x) to be %d at %llu\n",
+				dl->major, dl->minor,
+				be32_to_cpu(dl->disk.refnum), i, pos);
 
 			break;
 		}
@@ -4945,6 +4949,9 @@ static struct mdinfo *ddf_activate_spare(struct active_array *a,
 		}
 		vc->phys_refnum[i_prim] = ddf->phys->entries[dl->pdnum].refnum;
 		LBA_OFFSET(ddf, vc)[i_prim] = cpu_to_be64(di->data_offset);
+		dprintf("BVD %u gets %u: %08x at %llu\n", i_sec, i_prim,
+			be32_to_cpu(vc->phys_refnum[i_prim]),
+			be64_to_cpu(LBA_OFFSET(ddf, vc)[i_prim]));
 	}
 	*updates = mu;
 	return rv;
-- 
1.7.1
