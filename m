From: NeilBrown <neilb@suse.com>
Subject: [PATCH 4/4] Don't use exit(ERANGE)
Date: Fri, 04 Aug 2017 15:30:02 +1000
Message-ID: <150182460226.25561.10146463474666518480.stgit@noble>
References: <150182450644.25561.9683614144764209335.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <150182450644.25561.9683614144764209335.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mdadm uses smaller exit codes like 0,1,2,3,4.
Using ERANGE is inconsistent and not helpful.
So change it to a more consistent number.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 mdadm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mdadm.c b/mdadm.c
index 70b16f2231b7..d80aab361264 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -619,7 +619,7 @@ int main(int argc, char *argv[])
 			c.homecluster = optarg;
 			if (strlen(c.homecluster) > 64) {
 				pr_err("Cluster name too big.\n");
-				exit(ERANGE);
+				exit(2);
 			}
 			continue;
 		case O(CREATE,'x'): /* number of spare (eXtra) disks */


