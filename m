From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 4/5] FIX: Continue reshape in the background
Date: Mon, 28 Feb 2011 16:07:27 +0100
Message-ID: <20110228150727.14670.28042.stgit@gklab-128-013.igk.intel.com>
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

For external metadada, reshape will be continue in the background.
It is possible that background array reshape should be used for native
metadata also.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index e321a39..a5041de 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3334,7 +3334,19 @@ int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
 	} else {
 		fmt_devname(buf, st->container_dev);
 		container = buf;
+		switch (fork()) {
+		case -1:
+			fprintf(stderr, Name ": Cannot run child to "
+				"monitor reshape: %s\n", strerror(errno));
+			return 1;
+		default:
+			return 0;
+		case 0:
+			dprintf(Name ": Continue bacground reshape "
+				"after assemblation\n");
+		}
 	}
+
 	return reshape_array(container, mdfd, "array", st, info, 1,
 			     backup_file, 0, 0, 1);
 }

