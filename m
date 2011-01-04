From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 21/34] FIX: Initialize subarray variable in reshape_array
Date: Tue, 04 Jan 2011 15:38:23 +0100
Message-ID: <20110104143823.6697.85242.stgit@gklab-128-013.igk.intel.com>
References: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

subarray variable was not initialized in reshape_array()

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index dae9bbf..1c10889 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1616,7 +1616,7 @@ static int reshape_array(char *container, int fd, char *devname,
 	struct mdu_array_info_s array;
 	char *c;
 	int rv = 0;
-	char *subarray = NULL;
+	char *subarray = strchr(info->text_version+1, '/') + 1;
 
 	int *fdlist;
 	unsigned long long *offsets;

