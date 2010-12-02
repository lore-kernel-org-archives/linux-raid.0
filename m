From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 07/10] FIX: Do not use layout for raid4 and raid0 while geo
	map computing
Date: Thu, 02 Dec 2010 09:19:35 +0100
Message-ID: <20101202081935.4639.12285.stgit@gklab-170-024.igk.intel.com>
References: <20101202080818.4639.38119.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101202080818.4639.38119.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

After takeover layout has no matter for computing geo map for raid0 and raid4.
Set layout to 0 for such cases.
It can happen after takeover operation when not whole array information is reread.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 restripe.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/restripe.c b/restripe.c
index 3074693..dcce3cc 100644
--- a/restripe.c
+++ b/restripe.c
@@ -43,6 +43,11 @@ static int geo_map(int block, unsigned long long stripe, int raid_disks,
 	 */
 	int pd;
 
+	/* layout has no matter for raid0 and raid4 */
+	if ((level == 0) ||
+	    (level == 4))
+		layout = 0;
+
 	switch(level*100 + layout) {
 	case 000:
 	case 400:

