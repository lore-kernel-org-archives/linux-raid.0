From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 3/6] Unfreeze for non re-striping transitions
Date: Thu, 13 Jan 2011 16:32:44 +0100
Message-ID: <20110113153244.20266.59989.stgit@gklab-128-111.igk.intel.com>
References: <20110113152722.20266.24174.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110113152722.20266.24174.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

For non re-striping transitions array must be unfrozen
before end of processing.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 Grow.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index 47a8fb8..c0f9419 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1751,7 +1751,7 @@ static int reshape_array(char *container, int cfd, int fd, char *devname,
 				printf("chunk size for %s set to %d\n",
 				       devname, info->array.chunk_size);
 		}
-
+		unfreeze(st);
 		return rv;
 	}
 

