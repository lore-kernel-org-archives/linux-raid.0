From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/9] FIX: Cannot add spare to monitored container
Date: Tue, 11 Jan 2011 15:04:03 +0100
Message-ID: <20110111140403.13862.8338.stgit@gklab-128-013.igk.intel.com>
References: <20110111135227.13862.88465.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110111135227.13862.88465.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

This fix rolls backs some changes introduced by patch:
	"Add spares to raid0 in mdadm"

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Manage.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Manage.c b/Manage.c
index 4e6afb5..fa1b13f 100644
--- a/Manage.c
+++ b/Manage.c
@@ -800,16 +800,16 @@ int Manage_subdevs(char *devname, int fd,
 				if (dv->writemostly == 1)
 					disc.state |= 1 << MD_DISK_WRITEMOSTLY;
 				dfd = dev_open(dv->devname, O_RDWR | O_EXCL|O_DIRECT);
-				if (tst->ss->external &&
-				    mdmon_running(tst->container_dev))
-					tst->update_tail = &tst->updates;
 				if (tst->ss->add_to_super(tst, &disc, dfd,
 							  dv->devname)) {
 					close(dfd);
 					return 1;
 				}
 				/* write_init_super will close 'dfd' */
-				if (tst->ss->write_init_super(tst))
+				if (tst->ss->external)
+					/* mdmon will write the metadata */
+					close(dfd);
+				else if (tst->ss->write_init_super(tst))
 					return 1;
 			} else if (dv->re_add) {
 				/*  this had better be raid1.

