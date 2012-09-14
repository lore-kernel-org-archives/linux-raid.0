From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] fix: adjust parse_size() to the unsigned size variable
Date: Fri, 14 Sep 2012 16:12:45 +0200
Message-ID: <20120914141245.18725.59647.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

An error in parse_size() should be reported by 0, not -1,
because -1 is changed to the max value of unsigned long long
during calculations of size (e.g. at mdadm.c:412).

A negative value of size should be reported as error
(e.g. size equal -1 has been changed to the max value of
unsigned long long so far).

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 mdadm.h |    2 +-
 util.c  |    9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 9feccc6..f202ffa 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1156,7 +1156,7 @@ extern unsigned long bitmap_sectors(struct bitmap_super_s *bsb);
 extern int md_get_version(int fd);
 extern int get_linux_version(void);
 extern int mdadm_version(char *version);
-extern long long parse_size(char *size);
+extern unsigned long long parse_size(char *size);
 extern int parse_uuid(char *str, int uuid[4]);
 extern int parse_layout_10(char *layout);
 extern int parse_layout_faulty(char *layout);
diff --git a/util.c b/util.c
index a92a663..c63a232 100644
--- a/util.c
+++ b/util.c
@@ -188,13 +188,13 @@ int mdadm_version(char *version)
 	return (a*1000000)+(b*1000)+c;
 }
 
-long long parse_size(char *size)
+unsigned long long parse_size(char *size)
 {
 	/* parse 'size' which should be a number optionally
 	 * followed by 'K', 'M', or 'G'.
 	 * Without a suffix, K is assumed.
 	 * Number returned is in sectors (half-K)
-	 * -1 returned on error.
+	 * 0 returned on error.
 	 */
 	char *c;
 	long long s = strtoll(size, &c, 10);
@@ -214,9 +214,10 @@ long long parse_size(char *size)
 			s *= 1024 * 1024 * 2;
 			break;
 		}
-	}
+	} else
+		s = 0;
 	if (*c)
-		s = -1;
+		s = 0;
 	return s;
 }
 

