From: mwilck@arcor.de
Subject: [PATCH 3/6] DDF: container_content_ddf: set safe_mode_delay > 0
Date: Fri, 16 Aug 2013 20:21:57 +0200
Message-ID: <1376677320-12816-4-git-send-email-mwilck@arcor.de>
References: <1376677320-12816-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1376677320-12816-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Set safe_mode_delay to something >0, otherwise all container subarrays
assembled will have safe_mode_delay=0. That will break the assumption that
meta data becomes clean after running mdadm --wait-clean.

Use the same value as in getinfo_super_ddf_bvd. It would be cleaner
to call that directly from container_content_ddf, but I need to check
possible side effects first.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 013bb9d..d8fa654 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -3668,6 +3668,7 @@ static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray
 		this->array.md_minor      = -1;
 		this->array.major_version = -1;
 		this->array.minor_version = -2;
+		this->safe_mode_delay = 200;
 		cptr = (__u32 *)(vc->conf.guid + 16);
 		this->array.ctime         = DECADE + __be32_to_cpu(*cptr);
 		this->array.utime	  = DECADE +
-- 
1.7.3.4
