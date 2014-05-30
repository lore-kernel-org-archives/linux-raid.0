From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH] imsm: retry load_and_parse_mpb if we suspect mdmon has made modifications
Date: Fri, 30 May 2014 15:18:33 +0200
Message-ID: <1401455913-28657-1-git-send-email-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

If the checksum verification fails in mdadm and mdmon is running, retry
the load to get a consistent snapshot of the mpb.

Based on db575f3b

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Reviewed-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 super-intel.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/super-intel.c b/super-intel.c
index f0a7ab5..037c018 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4422,6 +4422,7 @@ static int load_super_imsm(struct supertype *st, int fd, char *devname)
 {
 	struct intel_super *super;
 	int rv;
+	int retry;
 
 	if (test_partition(fd))
 		/* IMSM not allowed on partitions */
@@ -4444,6 +4445,22 @@ static int load_super_imsm(struct supertype *st, int fd, char *devname)
 	}
 	rv = load_and_parse_mpb(fd, super, devname, 0);
 
+	/* retry the load if we might have raced against mdmon */
+	if (rv == 3) {
+		struct mdstat_ent *mdstat = mdstat_by_component(fd2devnm(fd));
+
+		if (mdmon_running(mdstat->devnm) && getpid() != mdmon_pid(mdstat->devnm)) {
+			for (retry = 0; retry < 3; retry++) {
+				usleep(3000);
+				rv = load_and_parse_mpb(fd, super, devname, 0);
+				if (rv != 3)
+					break;
+			}
+		}
+
+		free_mdstat(mdstat);
+	}
+
 	if (rv) {
 		if (devname)
 			pr_err("Failed to load all information "
-- 
1.8.4.5

