From: dfavro@meta-dynamic.com
Subject: [PATCH] Detect too-small device: error rather than underflow/crash
Date: Tue, 19 May 2020 14:58:12 -0400
Message-ID: <20200519185812.979553-2-dfavro@meta-dynamic.com>
References: <8c7c42f8-2040-859b-d558-0b523f7092d8@trained-monkey.org>
 <20200519185812.979553-1-dfavro@meta-dynamic.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200519185812.979553-1-dfavro@meta-dynamic.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org, David Favro <dfavro@meta-dynamic.com>
List-Id: linux-raid.ids

From: David Favro <dfavro@meta-dynamic.com>

For 1.x metadata, when the user requested creation of an array on
component devices that were too small even to hold the superblock,
an undetected integer wraparound (underflow) resulted in an enormous
computed size which resulted in various follow-on errors such as
floating-point exception.

This patch detects this condition, prints a reasonable diagnostic
message, and refuses to continue.

Signed-off-by: David Favro <dfavro@meta-dynamic.com>
---
 super1.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/super1.c b/super1.c
index e0d80be1..1e12198d 100644
--- a/super1.c
+++ b/super1.c
@@ -2785,10 +2785,6 @@ static int validate_geometry1(struct supertype *st, int level,
 	close(fd);
 
 	devsize = ldsize >> 9;
-	if (devsize < 24) {
-		*freesize = 0;
-		return 0;
-	}
 
 	/* creating:  allow suitable space for bitmap or PPL */
 	if (consistency_policy == CONSISTENCY_POLICY_PPL)
@@ -2829,15 +2825,27 @@ static int validate_geometry1(struct supertype *st, int level,
 	case 0: /* metadata at end.  Round down and subtract space to reserve */
 		devsize = (devsize & ~(4ULL*2-1));
 		/* space for metadata, bblog, bitmap/ppl */
-		devsize -= 8*2 + 8 + bmspace;
+		const unsigned long long required = 8*2 + 8 + bmspace;
+		if ( devsize < required ) /* detect underflow */
+			goto dev_too_small_err;
+		devsize -= required;
 		break;
 	case 1:
 	case 2:
+		if ( devsize < data_offset ) /* detect underflow */
+			goto dev_too_small_err;
 		devsize -= data_offset;
 		break;
 	}
 	*freesize = devsize;
 	return 1;
+
+	/* Error condition, device cannot even hold the overhead. */
+	dev_too_small_err:
+		fprintf( stderr, "device %s is too small (%lluK) for "
+				"required metadata!\n", subdev, devsize>>1 );
+		*freesize = 0;
+		return 0;
 }
 
 void *super1_make_v0(struct supertype *st, struct mdinfo *info, mdp_super_t *sb0)
-- 
2.26.2.593.gb9946226
