From: Xiao Ni <xni@redhat.com>
Subject: [MDADM PATCH 2/2] Specify suitable size when write to buffer
Date: Wed,  1 Mar 2017 14:12:46 +0800
Message-ID: <1488348766-31087-3-git-send-email-xni@redhat.com>
References: <1488348766-31087-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1488348766-31087-1-git-send-email-xni@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@gmail.com, ncroxon@redhat.com
List-Id: linux-raid.ids

---
 Detail.c      | 2 +-
 super-intel.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Detail.c b/Detail.c
index 509b0d4..f4d4241 100644
--- a/Detail.c
+++ b/Detail.c
@@ -575,7 +575,7 @@ This is pretty boring
 			printf("  Member Arrays :");
 
 			while (dir && (de = readdir(dir)) != NULL) {
-				char path[200];
+				char path[320];
 				char vbuf[1024];
 				int nlen = strlen(sra->sys_name);
 				dev_t devid;
diff --git a/super-intel.c b/super-intel.c
index d5e9517..ea50265 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1811,7 +1811,7 @@ static void examine_super_imsm(struct supertype *st, char *homehost)
 	__u32 reserved = imsm_reserved_sectors(super, super->disks);
 	struct dl *dl;
 
-	snprintf(str, MPB_SIG_LEN, "%s", mpb->sig);
+	snprintf(str, MAX_SIGNATURE_LENGTH, "%s", mpb->sig);
 	printf("          Magic : %s\n", str);
 	snprintf(str, strlen(MPB_VERSION_RAID0), "%s", get_imsm_version(mpb));
 	printf("        Version : %s\n", get_imsm_version(mpb));
-- 
2.7.4

