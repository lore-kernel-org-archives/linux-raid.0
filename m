From: Jes.Sorensen@redhat.com
Subject: [PATCH 7/8] Manage: Manage_subdevs() fix file descriptor leak
Date: Tue,  8 Mar 2016 12:30:51 -0500
Message-ID: <1457458252-20203-8-git-send-email-Jes.Sorensen@redhat.com>
References: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, gqjiang@suse.com, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Manage.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Manage.c b/Manage.c
index 9d2e0d0..808c2cb 100644
--- a/Manage.c
+++ b/Manage.c
@@ -1511,9 +1511,10 @@ int Manage_subdevs(char *devname, int fd,
 		} else {
 			struct stat stb;
 			tfd = dev_open(dv->devname, O_RDONLY);
-			if (tfd >= 0)
+			if (tfd >= 0) {
 				fstat(tfd, &stb);
-			else {
+				close(tfd);
+			} else {
 				int open_err = errno;
 				if (stat(dv->devname, &stb) != 0) {
 					pr_err("Cannot find %s: %s\n",
-- 
2.5.0

