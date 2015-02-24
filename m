From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/5] Grow.c: Fix classic readlink() buffer overflow
Date: Tue, 24 Feb 2015 16:00:36 -0500
Message-ID: <1424811640-26569-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1424811640-26569-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1424811640-26569-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: artur.paszkiewicz@intel.com, linux-raid@vger.kernel.org, Jes Sorensen <Jes.Sorensen@redhat.com>
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The buffer passed on to readlink() needs to contain space for the
terminating \0. See 'man 3 readlink' for details.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Grow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Grow.c b/Grow.c
index b78d063..a8bbf2b 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3319,7 +3319,7 @@ started:
 		bul = make_backup(sra->sys_name);
 		if (bul) {
 			char buf[1024];
-			int l = readlink(bul, buf, sizeof(buf));
+			int l = readlink(bul, buf, sizeof(buf) - 1);
 			if (l > 0) {
 				buf[l]=0;
 				unlink(buf);
-- 
2.1.0

