From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 18/23] FIX: Raid0 takeover has to start monitoring Raid5
Date: Wed, 9 Jun 2010 15:40:34 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D11EECE8F2@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

(Online Capacity Expansion for IMSM)
When performing takeover raid0->raid5, Raid5 monitoring has to be started.
This is required to perform metadata updates when disks will be added.
update_super("update_level") return code determines flushing update only.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Grow.c b/Grow.c
index 4431b64..85d7fe0 100644
--- a/Grow.c
+++ b/Grow.c
@@ -875,11 +875,6 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 				st->update_tail = &st->updates;
 				err = st->ss->update_super(st, sra, "update_level",
 							   ext_sra.name, 0, 0, NULL);
-				if (err != 0) {
-					/* no need to perform any updates with mdmon */
-					rv = 0;
-					goto release;
-				}
 				/* if raid0 was takeovered by any other
 				 * personality start mdmon */
 				if (level > 0 && orig.level == 0) { @@ -887,7 +882,12 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 						start_mdmon(dn);
 					ping_monitor(devnum2devname(dn));
 				}
-				flush_metadata_updates(st);
+				if (err == 0) {
+					/* perform any updates with mdmon
+					 * if required
+					 */
+					flush_metadata_updates(st);
+				}
 			}
 		}
 	}

