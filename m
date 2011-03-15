From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/4] FIX: Ping monitor when mdmon is running only
Date: Tue, 15 Mar 2011 14:48:24 +0100
Message-ID: <20110315134824.32643.2024.stgit@gklab-128-013.igk.intel.com>
References: <20110315134000.32643.1818.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110315134000.32643.1818.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When raid0 is created (no other monitored raid in container),
mdmon is not running. Ping is not necessary in such case.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Manage.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/Manage.c b/Manage.c
index 5996646..a032c08 100644
--- a/Manage.c
+++ b/Manage.c
@@ -896,7 +896,13 @@ int Manage_subdevs(char *devname, int fd,
 					sysfs_free(sra);
 					return 1;
 				}
-				ping_monitor(devnum2devname(devnum));
+				if (mdmon_running(devnum)) {
+					char *cont = devnum2devname(devnum);
+					if (cont) {
+						ping_monitor(cont);
+						free(cont);
+					}
+				}
 				sysfs_free(sra);
 				close(container_fd);
 			} else {

