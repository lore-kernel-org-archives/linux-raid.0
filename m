From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 02/13] imsm: FIX: allow for container reshape any unset size
	value
Date: Mon, 10 Jan 2011 12:27:42 +0100
Message-ID: <20110110112742.10776.5211.stgit@gklab-128-013.igk.intel.com>
References: <20110110110950.10776.75218.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110110110950.10776.75218.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Any request for no size change has to be accepted.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index d70a7df..58a776e 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6322,7 +6322,7 @@ static int imsm_reshape_is_allowed_on_container(struct supertype *st,
 		"st->devnum = (%i)\n",
 		st->devnum);
 
-	if (geo->size != -1 ||
+	if (geo->size >= 0 ||
 	    geo->level != UnSet ||
 	    geo->layout != UnSet ||
 	    geo->chunksize != 0 ||

