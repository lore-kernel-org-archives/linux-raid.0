From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/4] FIX: Write metadata when mdmon is not running
Date: Tue, 15 Mar 2011 14:48:32 +0100
Message-ID: <20110315134832.32643.57813.stgit@gklab-128-013.igk.intel.com>
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

For raid0 metadata has to be written.

It is possible that Manage.c:812 requires similar guard for mdmon running.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Manage.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/Manage.c b/Manage.c
index a032c08..f208d15 100644
--- a/Manage.c
+++ b/Manage.c
@@ -870,6 +870,12 @@ int Manage_subdevs(char *devname, int fd,
 					close(container_fd);
 					return 1;
 				}
+				if (!mdmon_running(devnum))
+					if (tst->ss->write_init_super(tst)) {
+						close(dfd);
+						close(container_fd);
+						return 1;
+					}
 				close(dfd);
 
 				sra = sysfs_read(container_fd, -1, 0);

