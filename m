From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 01/13] Manage reshape process in manage_reshape vector.
Date: Mon, 10 Jan 2011 12:27:33 +0100
Message-ID: <20110110112733.10776.24185.stgit@gklab-128-013.igk.intel.com>
References: <20110110110950.10776.75218.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110110110950.10776.75218.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

The manage_reshape vector is intended to be be used as
reshape process supervisor for external metadata types.
Sometimes there is no need for separate control,
and main code for native meta can be used instead.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/Grow.c b/Grow.c
index 1222263..4cbe427 100644
--- a/Grow.c
+++ b/Grow.c
@@ -574,8 +574,7 @@ static int reshape_super(struct supertype *st, long long size, int level,
 	/* nothing extra to check in the native case */
 	if (!st->ss->external)
 		return 0;
-	if (!st->ss->reshape_super ||
-	    !st->ss->manage_reshape) {
+	if (!st->ss->reshape_super) {
 		fprintf(stderr, Name ": %s metadata does not support reshape\n",
 			st->ss->name);
 		return 1;
@@ -1940,7 +1939,7 @@ static int reshape_array(char *container, int fd, char *devname,
 	}
 
 	start_reshape(sra);
-	if (st->ss->external) {
+	if ((st->ss->external) && (st->ss->manage_reshape)) {
 		/* metadata handler takes it from here */
 		ping_manager(container);
 		st->ss->manage_reshape(st, backup_file);

