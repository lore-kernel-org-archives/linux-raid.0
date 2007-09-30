From: "martin f. krafft" <madduck@debian.org>
Subject: [PATCH] Fix segfault on assembly on amd64 with v1 superblocks
Date: Sun, 30 Sep 2007 13:22:56 +0100
Message-ID: <1191154976-12311-2-git-send-email-madduck@debian.org>
References: 20070930113456.GA8924@lapse.madduck.net
 <1191154976-12311-1-git-send-email-madduck@debian.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1191154976-12311-1-git-send-email-madduck@debian.org>
In-Reply-To: <20070930113456.GA8924@lapse.madduck.net>
References: <20070930113456.GA8924@lapse.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: 444682-submitter@bugs.debian.org, "martin f. krafft" <madduck@debian.org>
List-Id: linux-raid.ids

Commit a40b4fe introduced a temporary supertype variable tst, instead of
manipulating st directly. However, it was forgotton to pass &tst into the
recursive load_super1 call, causing an infinite recursion.

Signed-off-by: martin f. krafft <madduck@debian.org>
---
 super1.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/super1.c b/super1.c
index 52783e7..06c2655 100644
--- a/super1.c
+++ b/super1.c
@@ -1001,7 +1001,7 @@ static int load_super1(struct supertype *st, int fd, void **sbp, char *devname)
 		/* guess... choose latest ctime */
 		tst.ss = &super1;
 		for (tst.minor_version = 0; tst.minor_version <= 2 ; tst.minor_version++) {
-			switch(load_super1(st, fd, sbp, devname)) {
+			switch(load_super1(&tst, fd, sbp, devname)) {
 			case 0: super = *sbp;
 				if (bestvers == -1 ||
 				    bestctime < __le64_to_cpu(super->ctime)) {
-- 
1.5.3.1

