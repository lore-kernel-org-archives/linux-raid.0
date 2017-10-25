From: Erik Berg <erik.berg@digitalgarden.no>
Subject: [PATCH] mdadm/mdopen: check system("modprobe ...") return
Date: Wed, 25 Oct 2017 12:35:19 +0200
Message-ID: <f1f0eba1-d5d6-b128-5fa5-8531f5ea984a@digitalgarden.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Build system gives an error with warn_unused_result, this should fix
that.
---
 mdopen.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mdopen.c b/mdopen.c
index dcdc6f2..8cd8507 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -313,7 +313,10 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 			udev_block(devnm);
 		fd = open("/sys/module/md_mod/parameters/new_array", O_WRONLY);
 		if (fd < 0 && errno == ENOENT) {
-			system("modprobe md_mod");
+			if(system("modprobe md_mod")) {
+				pr_err("check modprobe md_mod results\n");
+				return -1;
+			}
 			fd = open("/sys/module/md_mod/parameters/new_array", O_WRONLY);
 		}
 		if (fd >= 0) {
-- 
2.14.1
