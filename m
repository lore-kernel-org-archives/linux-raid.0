From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/5] FIX: Pass container name to reshape array for external
	meta data
Date: Mon, 28 Feb 2011 16:07:11 +0100
Message-ID: <20110228150711.14670.10258.stgit@gklab-128-013.igk.intel.com>
References: <20110228145815.14670.56597.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110228145815.14670.56597.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When calling reshape_array() for external metadata 'container name'
parameter have to be passed.
Find and pass container name in external metadata case.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index e4fa196..cb52cc5 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3323,10 +3323,18 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt
 int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
 		  char *backup_file)
 {
+	char buf[40];
+	char *container = NULL;
 	int err = sysfs_set_str(info, NULL, "array_state", "readonly");
 	if (err)
 		return err;
-	return reshape_array(NULL, mdfd, "array", st, info, 1, backup_file, 0, 0, 1);
+
+	if (st->ss->external) {
+		fmt_devname(buf, st->container_dev);
+		container = buf;
+	}
+	return reshape_array(container, mdfd, "array", st, info, 1,
+			     backup_file, 0, 0, 1);
 }
 
 

