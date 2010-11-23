From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 13/21] imsm Fix: Core during rebuild on array details read
Date: Tue, 23 Nov 2010 13:41:24 +0100
Message-ID: <20101123124124.17770.59886.stgit@gklab-170-024.igk.intel.com>
References: <20101123123900.17770.75516.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101123123900.17770.75516.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

When rebuild/reshape is in progress, executing mdadm for read array details causes core dump.
This is due to not initialized devices list pointer in getinfo_super() call.
Initializing it to NULL value allows code to detect such situation.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/Detail.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mdadm/mdadm/Detail.c b/mdadm/mdadm/Detail.c
index 1f2dbf2..b355199 100644
--- a/mdadm/mdadm/Detail.c
+++ b/mdadm/mdadm/Detail.c
@@ -140,6 +140,7 @@ int Detail(char *dev, int brief, int export, int test, char *homehost)
 		close(fd2);
 		if (err)
 			continue;
+		info.devs = NULL;
 		st->ss->getinfo_super(st, &info);
 
 		if (array.raid_disks != 0 && /* container */

