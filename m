From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/8] FIX: put update in to queue for local meta update
Date: Wed, 12 Jan 2011 14:54:26 +0100
Message-ID: <20110112135426.15045.10442.stgit@gklab-128-013.igk.intel.com>
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

When mdmon is not active (raid0 case) update has to be applied locally by mdadm.
In such case during append_metadata_update() update_tail doesn't exist
and update can be directly put in to update for local processing.

After this reshape_super() can directly call prepare_update() and process_update()
to update anchor in the same way as mdmon does it. space list cleanup is required only.
sync_metadata() writes metadata to array (by mdadm)

When mdmon exists, local update is applied but not flushed to array, it is sent to mdmon
and from mdmon update is flushed to disk. This allows us to avoid anchor reloading.

It is recommended to use local updates in mdadm (without anchor reload) with mdmon blocked/array frozen/.
This makes us sure that there is no other changes that should be taken under consideration
during processing in mdadm.

For local updates single update queue is supported.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    7 ++++++-
 util.c |   10 ++++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/Grow.c b/Grow.c
index 898eb3e..c2e84f3 100644
--- a/Grow.c
+++ b/Grow.c
@@ -591,8 +591,13 @@ static void sync_metadata(struct supertype *st)
 		if (st->update_tail) {
 			flush_metadata_updates(st);
 			st->update_tail = &st->updates;
-		} else
+		} else {
 			st->ss->sync_metadata(st);
+			if (st->updates) {
+				free(st->updates);
+				st->updates = NULL;
+			}
+		}
 	}
 }
 
diff --git a/util.c b/util.c
index 10d2140..9e3f13f 100644
--- a/util.c
+++ b/util.c
@@ -1889,8 +1889,14 @@ void append_metadata_update(struct supertype *st, void *buf, int len)
 	mu->space = NULL;
 	mu->space_list = NULL;
 	mu->next = NULL;
-	*st->update_tail = mu;
-	st->update_tail = &mu->next;
+	if (st->update_tail) {
+		*st->update_tail = mu;
+		st->update_tail = &mu->next;
+	} else {
+		if (st->updates)
+			free(st->updates);
+		st->updates = mu;
+	}
 }
 #endif /* MDASSEMBLE */
 

