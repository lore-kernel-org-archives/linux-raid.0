From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 6/9] FIX: Verify Backup file name before reshape
Date: Wed, 02 Mar 2011 14:29:43 +0100
Message-ID: <20110302132943.24771.22209.stgit@gklab-128-013.igk.intel.com>
References: <20110302132426.24771.99191.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110302132426.24771.99191.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When reshape is continued in the background, backup_file is required
for user data safety. reshape_array() makes backup_file verification,
but for container operation it will be done in forked code, so check
result will be unknown for assemble.
Grow_continue() has to verify if any file name is passed in.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 5176425..a1e6091 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3339,8 +3339,15 @@ int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
 		if (err)
 			return err;
 	} else {
+		if (backup_file == NULL) {
+			fprintf(stderr, Name ": Backup file name has to be "
+				"specified for reshape continuation.\n");
+			return 1;
+		}
+
 		fmt_devname(buf, st->container_dev);
 		container = buf;
+
 		switch (fork()) {
 		case -1:
 			fprintf(stderr, Name ": Cannot run child to "

