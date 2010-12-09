From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 22/29] FIX: mdstat doesn't read chunk size correctly
Date: Thu, 09 Dec 2010 16:21:43 +0100
Message-ID: <20101209152143.26876.12662.stgit@gklab-170-024.igk.intel.com>
References: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Chunk size mdstat entry is recognized by first letter in parsed string.
This is wrong behavior and it is corrected by this patch.

Probably check for 'check' string instead current condition.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdstat.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mdstat.c b/mdstat.c
index 47d81d4..6307ddb 100644
--- a/mdstat.c
+++ b/mdstat.c
@@ -247,7 +247,8 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 				else
 					ent->resync = 0;
 			} else if (ent->percent == -1 &&
-				   (w[0] == 'r' || w[0] == 'c')) {
+				   (w[0] == 'r' || w[0] == 'c') &&
+				   strncmp(w, "chunk", 5) != 0) {
 				if (strncmp(w, "resync", 4)==0)
 					ent->resync = 1;
 				if (strncmp(w, "reshape", 7)==0)

