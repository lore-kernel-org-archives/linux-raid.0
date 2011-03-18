From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] FIX: Add spare throws exception
Date: Fri, 18 Mar 2011 08:51:27 +0100
Message-ID: <20110318075126.5820.75251.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

sync_metadata() requires st->sb to be loaded, otherwise exception is generated.
This fails expansion, because spares cannot be added.

Patch loads anchor before Manage.c reference to st->sb.

NOTE: This fixes Raid5 expansion, Raid0 expansion is still broken.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Manage.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/Manage.c b/Manage.c
index 5808557..6233257 100644
--- a/Manage.c
+++ b/Manage.c
@@ -895,6 +895,7 @@ int Manage_subdevs(char *devname, int fd,
 				int container_fd;
 				int devnum = fd2devnum(fd);
 				int dfd;
+				char container[40];
 
 				container_fd = open_dev_excl(devnum);
 				if (container_fd < 0) {
@@ -904,7 +905,9 @@ int Manage_subdevs(char *devname, int fd,
 					tst->ss->free_super(tst);
 					return 1;
 				}
-
+				fmt_devname(container, st->container_dev);
+				st->ss->load_container(st,
+						       container_fd, container);
 				dfd = dev_open(dv->devname, O_RDWR | O_EXCL|O_DIRECT);
 				if (mdmon_running(tst->container_dev))
 					tst->update_tail = &tst->updates;
@@ -912,12 +915,14 @@ int Manage_subdevs(char *devname, int fd,
 							  dv->devname)) {
 					close(dfd);
 					close(container_fd);
+					st->ss->free_super(st);
 					return 1;
 				}
 				if (st->update_tail)
 					flush_metadata_updates(st);
 				else
 					tst->ss->sync_metadata(st);
+				st->ss->free_super(st);
 
 				sra = sysfs_read(container_fd, -1, 0);
 				if (!sra) {

