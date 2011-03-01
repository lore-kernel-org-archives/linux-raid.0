From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/7] FIX: Verify Backup file name before reshape
Date: Tue, 01 Mar 2011 15:56:50 +0100
Message-ID: <20110301145650.10678.1741.stgit@gklab-128-013.igk.intel.com>
References: <20110301144932.10678.20916.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110301144932.10678.20916.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When reshape is continued backup_file is required for user data safety.
Grow_continue() has to verify if any file name is passed in.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 47b8809..1470a91 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3332,6 +3332,11 @@ int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
 	char *container = NULL;
 	int err;
 
+	if (backup_file == NULL) {
+		fprintf(stderr, Name ": Backup file name has to be specified "
+			"for reshape continuation.\n");
+		return 1;
+	}
 	if (!st->ss->external) {
 		err = sysfs_set_str(info, NULL, "array_state", "readonly");
 		if (err)

