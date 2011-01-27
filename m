From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] WORKAROUND: mdadm hangs during reshape (PART #2)
Date: Thu, 27 Jan 2011 15:44:39 +0100
Message-ID: <20110127144439.6462.35136.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

After loop can occurs that due to 0 value reported by kernel
we have 0 in completed variable.
This is wrong. we are interested in real completed point.
0 value means that we reached sync point set in md,
so we can set completed variable to just reached point.
this point value is stored in max_progress variable.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index bc015c6..c7e40c0 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2466,6 +2466,12 @@ int progress_reshape(struct mdinfo *info, struct reshape *reshape,
 			goto check_progress;
 		}
 	}
+	/* Some kernels reset 'sync_completed' to zero,
+	 * we need to have real point we are in md
+	 */
+	if (completed == 0)
+		completed = max_progress;
+
 	/* some kernels can give an incorrectly high 'completed' number */
 	completed /= (info->new_chunk/512);
 	completed *= (info->new_chunk/512);

