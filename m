From: Przemyslaw Czarnowski
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 3/5] Skip domain check for spare-same-slot
Date: Thu, 23 Dec 2010 17:03:39 +0100
Message-ID: <20101223160339.5562.40006.stgit@gklab-170-211.igk.intel.com>
References: <20101223155614.5562.4773.stgit@gklab-170-211.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101223155614.5562.4773.stgit@gklab-170-211.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

If lost disk was the only one that belonged to particular domain, array
won't match with that domain any longer. We can achieve this by moving
domain check below the 'target' test.
---
 Incremental.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 137bd75..8d9f825 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -954,15 +954,6 @@ static int array_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 					devname, mp->path);
 			goto next;
 		}
-		dl = domain_from_array(sra, st2->ss->name);
-		if (!domain_test(dl, pol, st2->ss->name)) {
-			/* domain test fails */
-			if (verbose > 1)
-				fprintf(stderr, Name ": not adding %s to %s as it is not in a compatible domain\n",
-					devname, mp->path);
-
-			goto next;
-		}
 		/* test against target.
 		 * If 'target' is set and 'bare' is false, we only accept
 		 * arrays/containers that match 'target'.
@@ -990,6 +981,15 @@ static int array_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 				goto next;
 		}
 
+		dl = domain_from_array(sra, st2->ss->name);
+		if (!domain_test(dl, pol, st2->ss->name)) {
+			/* domain test fails */
+			if (verbose > 1)
+				fprintf(stderr, Name ": not adding %s to %s as it is not in a compatible domain\n",
+					devname, mp->path);
+
+			goto next;
+		}
 		/* all tests passed, OK to add to this array */
 		if (!chosen) {
 			chosen = sra;

