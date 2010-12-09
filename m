From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 08/29] imsm: Do not accept messages sent by mdadm
Date: Thu, 09 Dec 2010 16:19:47 +0100
Message-ID: <20101209151947.26876.5450.stgit@gklab-170-024.igk.intel.com>
References: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Messages update_reshape_cancel and update_reshape_set_slots ara intended to send by managemon.
If those message would be issued by mdadm prepare_message() is called in managemon for them.
In such cases set update_prepared to '-1' to indicate process_message() to not proceed such messages.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 924e57a..7e61f52 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5451,6 +5451,13 @@ update_reshape_exit:
 			break;
 		}
 
+		/* do not accept this update type sent by mdadm
+		 */
+		if (u->update_prepared == -1) {
+			dprintf("imsm: message is not accepted\n");
+			break;
+		}
+
 		if (imsm_reshape_array_set_slots(a) > -1)
 			super->updates_pending++;
 		break;
@@ -5479,6 +5486,13 @@ update_reshape_exit:
 		if (a == NULL)
 			break;
 
+		/* do not accept this update type sent by mdadm
+		 */
+		if (u->update_prepared == -1) {
+			dprintf("imsm: message is not accepted\n");
+			break;
+		}
+
 		inst = a->info.container_member;
 		dev = get_imsm_dev(super, inst);
 		map_1 = get_imsm_map(dev, 0);
@@ -5927,9 +5941,19 @@ static void imsm_prepare_update(struct supertype *st,
 		break;
 	}
 	case update_reshape_set_slots: {
+		struct imsm_update_reshape *u = (void *)update->buf;
+
+		/* do not accept this update type sent by mdadm
+		 */
+		u->update_prepared = -1;
 		break;
 	}
 	case update_reshape_cancel: {
+		struct imsm_update_reshape *u = (void *)update->buf;
+
+		/* do not accept this update type sent by mdadm
+		 */
+		u->update_prepared = -1;
 		break;
 	}
 	case update_create_array: {

