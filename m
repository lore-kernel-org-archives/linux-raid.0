From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH] util: fix seg-fault when trying to kill-subarray in a
 non-existing container
Date: Mon, 5 Sep 2011 14:17:02 +0000
Message-ID: <F9123E44003394499FDD2B17C60621D401BDD9@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

open_subarray returns valid fd to a container. In case of error shall return
negative value.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 util.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/util.c b/util.c
index ce03239..1680d6b 100644
--- a/util.c
+++ b/util.c
@@ -1370,7 +1370,7 @@ int open_subarray(char *dev, char *subarray, struct supertype *st, int quiet)
 		if (!quiet)
 			fprintf(stderr, Name ": Couldn't open %s, aborting\n",
 				dev);
-		return 2;
+		return -2;
 	}
 
 	st->devnum = fd2devnum(fd);
-- 
1.6.4.2

