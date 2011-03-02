From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/9] FIX: Array during reshape cannot be configured
Date: Wed, 02 Mar 2011 14:29:12 +0100
Message-ID: <20110302132912.24771.52010.stgit@gklab-128-013.igk.intel.com>
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

If this is reshape restart and array sysfs entry sync_action
is equal to "reshape" already.
This means that any configuration changes will return error (busy).
We cannot configure array here. It has to be configured earlier,
during assembly.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index d25b71d..ee75352 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1966,7 +1966,7 @@ started:
 		 * metadata, and for kernels before 2.6.38 we can
 		 * fail if we try.
 		 */
-	} else {
+	} else if (!restart) {
 		/* set them all just in case some old 'new_*' value
 		 * persists from some earlier problem.
 		 * We even set them when restarting in the middle.  They will

