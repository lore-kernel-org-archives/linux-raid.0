From: Przemyslaw Czarnowski
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 2/2] fix: incremental for bare disks returns invalid value
Date: Fri, 17 Dec 2010 15:18:05 +0100
Message-ID: <20101217141805.4219.45226.stgit@gklab-170-211.igk.intel.com>
References: <20101217141641.4219.88151.stgit@gklab-170-211.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101217141641.4219.88151.stgit@gklab-170-211.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

return value should remain the same as result of Manage_Subdevs (last
significant operation). Right now it is inverted what results in
error status for successful operation.
---
 Incremental.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index abd7b81..09c3c41 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1002,7 +1002,7 @@ static int array_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 		}
 		sysfs_free(chosen);
 	}
-	return rv ? 0 : 1;
+	return rv;
 }
 
 static int partition_try_spare(char *devname, int *dfdp, struct dev_policy *pol,

