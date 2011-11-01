From: Jes.Sorensen@redhat.com
Subject: [PATCH 03/19] Incremental(): Check return value of dev_open() before trying to use it
Date: Tue,  1 Nov 2011 16:09:19 +0100
Message-ID: <1320160175-18976-4-git-send-email-Jes.Sorensen@redhat.com>
References: <1320160175-18976-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320160175-18976-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Incremental.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 3596739..bc5e9d0 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -386,6 +386,12 @@ int Incremental(char *devname, int verbose, int runstop,
 			sprintf(dn, "%d:%d", sra->devs->disk.major,
 				sra->devs->disk.minor);
 			dfd2 = dev_open(dn, O_RDONLY);
+			if (dfd2 < 0) {
+				fprintf(stderr, Name
+					": unable to open %s\n", devname);
+				rv = 2;
+				goto out_unlock;
+			}
 			st2 = dup_super(st);
 			if (st2->ss->load_super(st2, dfd2, NULL) ||
 			    st->ss->compare_super(st, st2) != 0) {
-- 
1.7.6.4

