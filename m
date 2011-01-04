From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 02/34] FIX: Change size condition in
	imsm_reshape_is_allowed_on_container
Date: Tue, 04 Jan 2011 15:35:54 +0100
Message-ID: <20110104143554.6697.63473.stgit@gklab-128-013.igk.intel.com>
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

From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>

Size has to be "0" when imsm_reshape_is_allowed_on_container
function is called.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---

 super-intel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 17737cf..06b795e 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6149,7 +6149,7 @@ static int imsm_reshape_is_allowed_on_container(struct supertype *st,
 		"st->devnum = (%i)\n",
 		st->devnum);
 
-	if (geo->size != -1 ||
+	if (geo->size != 0 ||
 	    geo->level != UnSet ||
 	    geo->layout != UnSet ||
 	    geo->chunksize != 0 ||

