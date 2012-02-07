From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 01/12] FIX: NULL pointer to strdup() can be passed
Date: Tue, 07 Feb 2012 15:03:03 +0100
Message-ID: <20120207140303.20627.43575.stgit@gklab-128-013.igk.intel.com>
References: <20120207135940.20627.33309.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120207135940.20627.33309.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com, lukasz.dorau@intel.com
List-Id: linux-raid.ids

When result from strchr() is NULL and it is assigned to subarray,
NULL pointer can be passed to strdup() function and coredump file
is generated.

Subarray is checked for NULL pointer, so it is assumed that it can
be NULL at this moment.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 util.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/util.c b/util.c
index e5f7a20..7abbff7 100644
--- a/util.c
+++ b/util.c
@@ -966,9 +966,10 @@ struct supertype *super_by_fd(int fd, char **subarrayp)
 		char *dev = verstr+1;
 
 		subarray = strchr(dev, '/');
-		if (subarray)
+		if (subarray) {
 			*subarray++ = '\0';
-		subarray = strdup(subarray);
+			subarray = strdup(subarray);
+		}
 		container = devname2devnum(dev);
 		if (sra)
 			sysfs_free(sra);

