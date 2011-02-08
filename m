From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 3/6] FIX: Compare the same units
Date: Tue, 08 Feb 2011 14:30:53 +0100
Message-ID: <20110208133053.8787.21441.stgit@gklab-128-013.igk.intel.com>
References: <20110208131046.8787.1777.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110208131046.8787.1777.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

In condition blocks and kbytes are compared.
The same units have to be compared, otherwise comparison
is meaningless.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index 8229b4d..6a9e81e 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1829,7 +1829,7 @@ started:
 		fprintf(stderr, Name ": Need to backup %luK of critical "
 			"section..\n", blocks/2);
 
-	if (blocks >= sra->component_size/2) {
+	if (blocks >= sra->component_size) {
 		fprintf(stderr, Name ": %s: Something wrong"
 			" - reshape aborted\n",
 			devname);

