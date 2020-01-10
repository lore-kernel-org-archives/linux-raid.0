From: Kinga Tanska <kinga.tanska@intel.com>
Subject: [PATCH, v2] Change warning message
Date: Fri, 10 Jan 2020 12:10:26 +0100
Message-ID: <20200110111026.1734-1-kinga.tanska@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com
List-Id: linux-raid.ids

In commit 039b7225e6 ("md: allow creation of mdNNN arrays via
md_mod/parameters/new_array") support for name like mdNNN
was added. Special warning, when kernel is unable to handle
request, was added in commit 7105228e19
("mdadm/mdopen: create new function create_named_array for
writing to new_array"), but it was not adequate enough,
because in this situation mdadm tries to do it in old way.
This commit changes warning to be more relevant when
creating RAID container with "/dev/mdNNN" name and mdadm
back to old approach.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 mdopen.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mdopen.c b/mdopen.c
index 98c54e4..245be53 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -120,7 +120,8 @@ int create_named_array(char *devnm)
 		close(fd);
 	}
 	if (fd < 0 || n != (int)strlen(devnm)) {
-		pr_err("Fail create %s when using %s\n", devnm, new_array_file);
+		pr_err("Fail to create %s when using %s, fallback to creation via node\n",
+			devnm, new_array_file);
 		return 0;
 	}
 
-- 
2.16.4
