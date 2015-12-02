From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 09/17] Add --brief support to --enclosure
Date: Tue, 1 Dec 2015 16:25:25 -0800
Message-ID: <1449015933-255689-10-git-send-email-songliubraving@fb.com>
References: <1449015933-255689-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1449015933-255689-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, dan.j.williams@intel.com, shli@fb.com, Dan Williams <djbw@fb.com>, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

From: Dan Williams <djbw@fb.com>

Generate simple names to locally identify enclosures by id.  This is a
step towards defining enclosure names in the configuration file.

Ex:
ENCLOSURE enclosure0 id=0x5f80f41f1d6a60ff
ENCLOSURE enclosure1 id=0x5f80f41f1d6e80ff

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 Detail.c      |  6 +++++-
 enclosure.c   | 14 ++++++++++++++
 mdadm.c       |  5 ++++-
 mdadm.h       |  3 ++-
 super-intel.c | 14 +++++++++++++-
 5 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/Detail.c b/Detail.c
index 8fb61cc..03764ad 100644
--- a/Detail.c
+++ b/Detail.c
@@ -717,7 +717,7 @@ out:
 	return rv;
 }
 
-int Detail_Platform(const struct platform_ops *platform, int scan, int verbose, int export, char *hwdevice)
+int Detail_Platform(const struct platform_ops *platform, int scan, int verbose, int export, int brief, char *hwdevice)
 {
 	/* display platform capabilities
 	 * 'scan' in this context means iterate over all platform types
@@ -731,6 +731,8 @@ int Detail_Platform(const struct platform_ops *platform, int scan, int verbose,
 
 	if (platform && export)
 		err = platform->export_detail(verbose, hwdevice);
+	else if (platform && brief)
+		err = platform->brief_detail(verbose, hwdevice);
 	else if (platform)
 		err = platform->detail(verbose, 0, hwdevice);
 	else if (!scan) {
@@ -752,6 +754,8 @@ int Detail_Platform(const struct platform_ops *platform, int scan, int verbose,
 
 		if (export)
 			err |= (*p)->export_detail(verbose, hwdevice);
+		else if (brief)
+			err |= (*p)->brief_detail(verbose, hwdevice);
 		else
 			err |= (*p)->detail(verbose, 0, hwdevice);
 
diff --git a/enclosure.c b/enclosure.c
index 76ed30d..bb5e88e 100644
--- a/enclosure.c
+++ b/enclosure.c
@@ -307,8 +307,22 @@ static int export_detail_enclosure(int verbose, char *enclosure_name)
 	return 0;
 }
 
+static int brief_detail_enclosure(int verbose, char *enclosure_name)
+{
+	struct enclosure *e, *enclosure = parse_enclosures();
+	int i = 0;
+
+	for (e = enclosure; e; e = e->next)
+		printf("ENCLOSURE enclosure%d id=%s\n", i++, e->id);
+
+	free_enclosure(enclosure);
+	
+	return 0;
+}
+
 const struct platform_ops enclosure_platform = {
 	.detail = detail_platform_enclosure,
 	.export_detail = export_detail_enclosure,
+	.brief_detail = brief_detail_enclosure,
 	.name = "enclosure",
 };
diff --git a/mdadm.c b/mdadm.c
index 0e46177..7eeeb4f 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1511,7 +1511,8 @@ int main(int argc, char *argv[])
 
 			if (scan) {
 				rv = Detail_Platform(NULL, scan, c.verbose,
-						      c.export, controller);
+						     c.export, c.brief,
+						     controller);
 			} else {
 				/* metadata format specific details that
 				 * may be tied to a given controller
@@ -1520,6 +1521,7 @@ int main(int argc, char *argv[])
 					platform = ss->ss->platform;
 					rv = Detail_Platform(platform, scan,
 							     c.verbose, c.export,
+							     c.brief,
 							     controller);
 				}
 				/* detail given enclosure or scan all
@@ -1529,6 +1531,7 @@ int main(int argc, char *argv[])
 					platform = &enclosure_platform;
 					rv |= Detail_Platform(platform, scan,
 							      c.verbose, c.export,
+							      c.brief,
 							      c.enclosure);
 				}
 			}
diff --git a/mdadm.h b/mdadm.h
index 881c0fd..7ac0b95 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -699,6 +699,7 @@ struct reshape {
 extern const struct platform_ops {
 	int (*detail)(int verbose, int enumerate_only, char *hwdevice);
 	int (*export_detail)(int verbose, char *hwdevice);
+	int (*brief_detail)(int verbose, char *hwdevice);
 	char *name;
 } *platform_list[];
 
@@ -1281,7 +1282,7 @@ extern int Create(struct supertype *st, char *mddev,
 
 extern int Detail(char *dev, struct context *c);
 extern int Detail_Platform(const struct platform_ops *platform, int scan, int verbose,
-			   int export, char *controller_path);
+			   int export, int brief, char *controller_path);
 extern int Query(char *dev);
 extern int ExamineBadblocks(char *devname, int brief, struct supertype *forcest);
 extern int Examine(struct mddev_dev *devlist, struct context *c,
diff --git a/super-intel.c b/super-intel.c
index 4ce46ef..c4a8ac7 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1985,7 +1985,7 @@ static int detail_platform_imsm(int verbose, int enumerate_only, char *controlle
 	return result;
 }
 
-static int export_detail_platform_imsm(int verbose, char *controller_path)
+static int export_detail_print(int verbose, int print, char *controller_path)
 {
 	struct sys_dev *list, *hba;
 	int result=1;
@@ -2015,6 +2015,11 @@ static int export_detail_platform_imsm(int verbose, char *controller_path)
 	return result;
 }
 
+static int export_detail_platform_imsm(int verbose, char *controller_path)
+{
+	return export_detail_print(0, 1, controller_path);
+}
+
 #endif
 
 static int match_home_imsm(struct supertype *st, char *homehost)
@@ -10604,9 +10609,16 @@ abort:
 	return ret_val;
 }
 
+
+static int brief_detail_platform_imsm(int verbose, char *controller)
+{
+	return export_detail_print(verbose, 0, controller);
+}
+
 const struct platform_ops imsm_platform = {
 	.detail = detail_platform_imsm,
 	.export_detail = export_detail_platform_imsm,
+	.brief_detail = brief_detail_platform_imsm,
 	.name = "imsm",
 };
 #endif /* MDASSEMBLE */
-- 
2.4.6

