From: David Favro <dfavro@meta-dynamic.com>
Subject: [PATCH] mdadm: detect too-small device: error rather than underflow/crash
Date: Fri, 15 May 2020 16:40:41 -0400
Message-ID: <20200516035020.ABA6D19801B5@minderbinder.meta-dynamic.com>
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

My apologies that this is so late, but would be nice if it could
make it into the release.

In trying to test the behavior of mdadm under various circumstances,
I was experimenting with creating a test array of very small
loopback devices, when I observed some strange behavior from mdadm
(died with floating-point-exception signal).  Turning on --verbose
showed enormous volume sizes, and I eventually tracked down exactly
what one might guess is happening, integer underflow.

I prepared a patch, which follows the scissors line -- while it's
obviously not likely to come up frequently in "real life", corner
cases have a way of occurring and should be properly handled, not
left to crash at a later time in parts unknown.

There are two places in the code for 1.x metadata where the same
problem occurs, depending on 1.0 vs. 1.1+: I used the same
error-message code for both, via a goto (which I prefer to
replicating code, although a good optimizing compiler might combine
replicated code to generate the same goto); I know that goto offends
the sensibilities of some, but I noticed that it is already used
elsewhere in existing mdadm codebase.

A preexisting too-small-device check is removed both because it is
inadequate to properly detect the condition, and because it is made
redundant by the proper check (after the size of reserved space is
computed).

I wrote a small shell script which nicely demonstrates the bug and
the patch's fix using loopback devices, will send in a separate
email.

As an aside, the follow-on hardware fault that I got was the result
of a divide-by-0 on a little-endian 64-bit architecture after some
word-size conversions on enormous integer values; it may manifest
differently on machines with a different byte-ordering or word-size,
perhaps attempting to create a garbage array rather than crashing,
but it's not really relevant: the real fix is not to proceed with
the invalid devices, as this patch prevents.

-- David Favro


8< --------------------------------------------------

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
