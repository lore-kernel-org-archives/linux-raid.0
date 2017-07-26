From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH 1/1] super1: Always round data offset to 1M
Date: Wed, 26 Jul 2017 16:41:54 +0200
Message-ID: <20170726144154.31798-1-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Pawel Baldysiak <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

Currently if metadata requires more then 1M,
data offset will be rounded down to closest MB.
This is not correct, since less then required space is reserved.
Always round data offset up to multiple of 1M.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 super1.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/super1.c b/super1.c
index 86ec850d..b15a1c7a 100644
--- a/super1.c
+++ b/super1.c
@@ -2796,8 +2796,7 @@ static int validate_geometry1(struct supertype *st, int level,
 				headroom >>= 1;
 			data_offset = 12*2 + bmspace + headroom;
 			#define ONE_MEG (2*1024)
-			if (data_offset > ONE_MEG)
-				data_offset = (data_offset / ONE_MEG) * ONE_MEG;
+			data_offset = ROUND_UP(data_offset, ONE_MEG);
 			break;
 		}
 	if (st->data_offset == INVALID_SECTORS)
-- 
2.13.0

