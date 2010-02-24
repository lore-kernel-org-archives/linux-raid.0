From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [mdadm PATCH 3/11] Enable OLCE for external IMSM metadata
Date: Wed, 24 Feb 2010 07:46:05 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D1016F65C7@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From 11bca78b438701451546575c7ff28f96bcba322f Mon Sep 17 00:00:00 2001
From: Adam Kwolek <adam.kwolek@intel.com>
Date: Thu, 18 Feb 2010 11:06:27 +0100
Subject: [PATCH] OLCE: abuf, bbuf buffer managment fix

Changes to be committed:
	modified:   Grow.c

FIXED: Usage of abuf and bbuf in Grow.c leads to exception

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 Grow.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/Grow.c b/Grow.c
index 9db851b..e6624d1 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1538,7 +1538,7 @@ static void fail(char *msg)
 	exit(1);
 }
 
-static char *abuf, *bbuf;
+static char *abuf = NULL, *bbuf = NULL;
 static int abuflen;
 static void validate(int afd, int bfd, unsigned long long offset)
 {
@@ -1568,13 +1568,16 @@ static void validate(int afd, int bfd, unsigned long long offset)
 		unsigned long long len = __le64_to_cpu(bsb2.length)*512;
 
 		if (abuflen < len) {
-			free(abuf);
-			free(bbuf);
+			if (abuf) free(abuf);
+			if (bbuf) free(bbuf);
 			abuflen = len;
 			posix_memalign((void**)&abuf, 4096, abuflen);
 			posix_memalign((void**)&bbuf, 4096, abuflen);
 		}
 
+		if ((abuf==NULL) || (bbuf==NULL))
+			fail("Cannot get memory");
+
 		lseek64(bfd, offset, 0);
 		if (read(bfd, bbuf, len) != len) {
 			printf("len %llu\n", len);
@@ -1599,13 +1602,16 @@ static void validate(int afd, int bfd, unsigned long long offset)
 		unsigned long long len = __le64_to_cpu(bsb2.length2)*512;
 
 		if (abuflen < len) {
-			free(abuf);
-			free(bbuf);
+			if (abuf) free(abuf);
+			if (bbuf) free(bbuf);
 			abuflen = len;
 			abuf = malloc(abuflen);
 			bbuf = malloc(abuflen);
 		}
 
+		if ((abuf==NULL) || (bbuf==NULL))
+			fail("cannoit get memory");
+
 		lseek64(bfd, offset+__le64_to_cpu(bsb2.devstart2)*512, 0);
 		if (read(bfd, bbuf, len) != len)
 			fail("read second backup failed");
-- 
1.6.0.2

