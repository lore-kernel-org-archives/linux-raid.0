From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm 2.6.3 segfaults on assembly (v1 superblocks)
Date: Mon, 24 Sep 2007 14:28:28 +1000
Message-ID: <18167.15596.666216.853865@notabene.brown>
References: <20070907080901.GA16012@piper.oerlikon.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from martin f krafft on Friday September 7
Sender: linux-raid-owner@vger.kernel.org
To: martin f krafft <madduck@madduck.net>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Friday September 7, madduck@madduck.net wrote:
> 
> Neil, could this be a bug?
> 

Sure could.  Thanks for the report.

This patch (already in .git) should fix it.

NeilBrown

---------------------------
Don't corrupt 'supertype' when speculatively calling load_super1

When load_super1 is trying to see which sub-version of v1 superblock
is present, failure will cause it to clear st->ss, which is not good.

So use a temporary 'super_type' for the 'test if this version works'
calls, then copy that into 'st' on success.

### Diffstat output
 ./super1.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff .prev/super1.c ./super1.c
--- .prev/super1.c	2007-09-24 14:26:19.000000000 +1000
+++ ./super1.c	2007-09-24 14:23:11.000000000 +1000
@@ -996,34 +996,35 @@ static int load_super1(struct supertype 
 
 	if (st->ss == NULL || st->minor_version == -1) {
 		int bestvers = -1;
+		struct supertype tst;
 		__u64 bestctime = 0;
 		/* guess... choose latest ctime */
-		st->ss = &super1;
-		for (st->minor_version = 0; st->minor_version <= 2 ; st->minor_version++) {
+		tst.ss = &super1;
+		for (tst.minor_version = 0; tst.minor_version <= 2 ; tst.minor_version++) {
 			switch(load_super1(st, fd, sbp, devname)) {
 			case 0: super = *sbp;
 				if (bestvers == -1 ||
 				    bestctime < __le64_to_cpu(super->ctime)) {
-					bestvers = st->minor_version;
+					bestvers = tst.minor_version;
 					bestctime = __le64_to_cpu(super->ctime);
 				}
 				free(super);
 				*sbp = NULL;
 				break;
-			case 1: st->ss = NULL; return 1; /*bad device */
+			case 1: return 1; /*bad device */
 			case 2: break; /* bad, try next */
 			}
 		}
 		if (bestvers != -1) {
 			int rv;
-			st->minor_version = bestvers;
-			st->ss = &super1;
-			st->max_devs = 384;
+			tst.minor_version = bestvers;
+			tst.ss = &super1;
+			tst.max_devs = 384;
 			rv = load_super1(st, fd, sbp, devname);
-			if (rv) st->ss = NULL;
+			if (rv == 0)
+				*st = tst;
 			return rv;
 		}
-		st->ss = NULL;
 		return 2;
 	}
 	if (!get_dev_size(fd, devname, &dsize))
