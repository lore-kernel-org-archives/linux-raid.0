From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 18/22] imsm: Apply checkpoint metadata update for general
	migration
Date: Thu, 02 Jun 2011 16:50:41 +0200
Message-ID: <20110602145041.27355.46160.stgit@gklab-128-111.igk.intel.com>
References: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Adam Kwolek <adam.kwolek@intel.com>

mdmon has to update checkpoint information in metadata during
general migration according to received metadata update.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 super-intel.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index fa4e15d..b6369c6 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6920,6 +6920,24 @@ static void imsm_process_update(struct supertype *st,
 	mpb = super->anchor;
 
 	switch (type) {
+	case update_general_migration_checkpoint: {
+		struct intel_dev *id;
+		struct imsm_update_general_migration_checkpoint *u =
+							(void *)update->buf;
+
+		dprintf("imsm: process_update() "
+			"for update_general_migration_checkpoint called\n");
+
+		/* find device under general migration */
+		for (id = super->devlist ; id; id = id->next) {
+			if (is_gen_migration(id->dev)) {
+				id->dev->vol.curr_migr_unit =
+					__cpu_to_le32(u->curr_migr_unit);
+				super->updates_pending++;
+			}
+		}
+		break;
+	}
 	case update_takeover: {
 		struct imsm_update_takeover *u = (void *)update->buf;
 		if (apply_takeover_update(u, super, &update->space_list)) {
@@ -7257,6 +7275,10 @@ static void imsm_prepare_update(struct supertype *st,
 	size_t len = 0;
 
 	switch (type) {
+	case update_general_migration_checkpoint:
+		dprintf("imsm: prepare_update() "
+			"for update_general_migration_checkpoint called\n");
+		break;
 	case update_takeover: {
 		struct imsm_update_takeover *u = (void *)update->buf;
 		if (u->direction == R0_TO_R10) {

