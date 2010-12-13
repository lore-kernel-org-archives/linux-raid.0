From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 15/16] imsm Fix: Core during rebuild on array details read
Date: Mon, 13 Dec 2010 15:47:01 +0100
Message-ID: <20101213144701.4384.44908.stgit@gklab-170-024.igk.intel.com>
References: <20101213143604.4384.55544.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101213143604.4384.55544.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When rebuild/reshape is in progress, executing mdadm for read array details causes core dump.
This is due to not initialized devices list pointer in getinfo_super() call.
Initializing it to NULL value allows code to detect such situation.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Detail.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/Detail.c b/Detail.c
index 9415628..836f153 100644
--- a/Detail.c
+++ b/Detail.c
@@ -147,7 +147,10 @@ int Detail(char *dev, int brief, int export, int test, char *homehost)
 			info = st->ss->container_content(st, subarray);
 		else {
 			info = malloc(sizeof(*info));
-			st->ss->getinfo_super(st, info, NULL);
+			if (info) {
+				info->devs = NULL;
+				st->ss->getinfo_super(st, info, NULL);
+			}
 		}
 		if (!info)
 			continue;

