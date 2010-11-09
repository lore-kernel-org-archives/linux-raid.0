From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 13/31] imsm: Do not accept messages sent by mdadm
Date: Tue, 9 Nov 2010 17:01:13 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174A1CA9D@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Messages update_reshape_cancel and update_reshape_set_slots ara intended to send by managemon.
If those message would be issued by mdadm prepare_message() is called in managemon for them.
In such cases set update_prepared to '-1' to indicate process_message() to not proceed such messages.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/super-intel.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/mdadm/mdadm/super-intel.c b/mdadm/mdadm/super-intel.c index fa5ab8c..3d14f1f 100644
--- a/mdadm/mdadm/super-intel.c
+++ b/mdadm/mdadm/super-intel.c
@@ -5402,6 +5402,13 @@ update_reshape_exit:
 			break;
 		}
 
+		/* do not accept this update type sent by mdadm
+		 */
+		if (u->update_prepared == -1) {
+			dprintf("imsm: message is sent by mdadm. cannot accept\n\n");
+			break;
+		}
+
 		if (imsm_reshape_array_set_slots(a) > -1)
 			super->updates_pending++;
 		break;
@@ -5425,6 +5432,13 @@ update_reshape_exit:
 		if (a == NULL)
 			break;
 
+		/* do not accept this update type sent by mdadm
+		 */
+		if (u->update_prepared == -1) {
+			dprintf("imsm: message is sent by mdadm. cannot accept\n\n");
+			break;
+		}
+
 		inst = a->info.container_member;
 		dev = get_imsm_dev(super, inst);
 		map_1 = get_imsm_map(dev, 0);
@@ -5881,9 +5895,19 @@ static void imsm_prepare_update(struct supertype *st,
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
 	case update_level: {

