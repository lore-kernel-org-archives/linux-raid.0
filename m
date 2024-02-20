Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB8669D01
	for <linux-raid@vger.kernel.org>; Tue, 20 Feb 2024 16:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708447923; cv=none; b=S1zHsfmRvi4BuHHsbnIrwoVYzbhpwsDDsxjZgsR6laH8AaYs0eEeCVESMmJfQipWFAwkDcx7CriqX2VU4Dt9L3N7uW4uJCZMPB2qei+bpI5UHtrjmsiPijOd/rMyW2G3RBSzhhUzCc5qA/v1JMeRZ5DTFwND4p/KR6DypmgfWyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708447923; c=relaxed/simple;
	bh=6loKMXCqA5GyrDYnRqb3vWlRjREi5xmLbXglJ2S0zyM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OZ+CvltEGYTN1CT4Lid3IuDTMsiQwhQBFAo0+Aam8r9O9cFERkxMCLnva99pNxhVpWlaca53T8CJjnzJxFctlv+xTFfcSeR4fss0iZjy3KMyeOBwUM95BVvI1Zn6lZbGZjLKzk0jd7oR5wbaB5IiDcDS8BGgWKETGUB0RzGP20w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KuYgHEZ9; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KuYgHEZ9"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6e46e07ff07so1330970b3a.3
        for <linux-raid@vger.kernel.org>; Tue, 20 Feb 2024 08:52:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708447921; x=1709052721; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bxwRAQ6H5qag2XAXmi8U7PmzsBqq1xYv2z1Fhs1fx48=;
        b=KuYgHEZ9oyPnEix+gdutkKNgdLIICU/UgSdYdMV3AEjMtAAi0Pf1aoDId3E3hvhskq
         VaD48c6DatVEiOIGLEY0DaWl+vIw0f9aJtp4FfwCOe47rjgpuX90zGnWdywd5TfdSDBZ
         JBaNAbSpVl4qdJjpC+p94joKCNA8OCweNH2wx/Kw6FpFy4Hs9ozvhdSV+7ildnRX8Qft
         OlVN0ln367z3CjH1EtdqmCBU6D2Dm9eLk+J1iAhxsc/9ULvZLwpjl7nvOkj/ht5CcML1
         9wNvREnZwha+bhHSPdaYYMjDhezvPQyqhbCuhWHKwYOWwF2icGZD1N8ha9VoNV0heQ44
         1qog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708447921; x=1709052721;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bxwRAQ6H5qag2XAXmi8U7PmzsBqq1xYv2z1Fhs1fx48=;
        b=Ja9EaaYfn/hTr3uB9E39n7Q30tgkfrou16vq4n3QVWwHH0hFqmJ/EeE49IS0Via2t1
         Set81k87KLfxXDPmT8smki3xUC70TGQdo+gZ/Vb4g2i/GvFrK+VG2BzBierh+PQUnncN
         82O0rBv/43ldPKuTYtdtj447oZp2MaVYLf0H7egsdqrK0Gyl6M7A5fzPw0hBbstHQtp6
         zjwIkPEYr3AmfbRo3HuK2Ku6+ePQ97xIHItYqHfNL7vVq+lLbz4ZuEnXtJ5eW2IMLesO
         hnE/VoMkw9sYK1Bhg69RyaWa/rwuqGOsUea67xuCPVnNoEWDI6/qOaT4KuY3bYJRpJCA
         qNKg==
X-Gm-Message-State: AOJu0Yz0DeC7CSB1RMMZolcCP/Bc0EdenX7U4VtHzFnrBT//tXkBKwnk
	DhxSjSzwQZCHfaY7Z2evJP6hoDV3W/bsZ0WQbZ14r1nFtGmLGR2UZC3lWEnucvA=
X-Google-Smtp-Source: AGHT+IHAnXJgl4HNAx4I4ryK8rUHcteKvbqm3CLcps3eM8wpqmeJV6mJY9L6vqCGS68ocn/g8MKGHg==
X-Received: by 2002:aa7:84d8:0:b0:6e2:497f:abb6 with SMTP id x24-20020aa784d8000000b006e2497fabb6mr7514091pfn.0.1708447921228;
        Tue, 20 Feb 2024 08:52:01 -0800 (PST)
Received: from apollo.hsd1.ca.comcast.net ([2601:646:9d80:4380::696f])
        by smtp.gmail.com with ESMTPSA id o23-20020a056a001b5700b006e466369645sm3838328pfv.132.2024.02.20.08.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 08:52:00 -0800 (PST)
From: Khem Raj <raj.khem@gmail.com>
To: linux-raid@vger.kernel.org,
	mariusz.tkaczyk@linux.intel.com
Cc: Khem Raj <raj.khem@gmail.com>
Subject: [PATCH] restripe.c: Use _FILE_OFFSET_BITS to enable largefile support
Date: Tue, 20 Feb 2024 08:51:58 -0800
Message-ID: <20240220165158.3521874-1-raj.khem@gmail.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of using the lseek64 and friends, its better to enable it via
the feature macro _FILE_OFFSET_BITS = 64 and let the C library deal with
the width of types

Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
 restripe.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/restripe.c
+++ b/restripe.c
@@ -22,6 +22,9 @@
  *    Email: <neilb@suse.de>
  */
 
+/* Enable largefile support */
+#define _FILE_OFFSET_BITS 64
+
 #include "mdadm.h"
 #include <stdint.h>
 
@@ -581,7 +584,7 @@ int save_stripes(int *source, unsigned l
 				       raid_disks, level, layout);
 			if (dnum < 0) abort();
 			if (source[dnum] < 0 ||
-			    lseek64(source[dnum],
+			    lseek(source[dnum],
 				    offsets[dnum] + offset, 0) < 0 ||
 			    read(source[dnum], buf+disk * chunk_size,
 				 chunk_size) != chunk_size) {
@@ -754,8 +757,8 @@ int restore_stripes(int *dest, unsigned
 					   raid_disks, level, layout);
 			if (src_buf == NULL) {
 				/* read from file */
-				if (lseek64(source, read_offset, 0) !=
-					 (off64_t)read_offset) {
+				if (lseek(source, read_offset, 0) !=
+					 (off_t)read_offset) {
 					rv = -1;
 					goto abort;
 				}
@@ -816,7 +819,7 @@ int restore_stripes(int *dest, unsigned
 		}
 		for (i=0; i < raid_disks ; i++)
 			if (dest[i] >= 0) {
-				if (lseek64(dest[i],
+				if (lseek(dest[i],
 					 offsets[i]+offset, 0) < 0) {
 					rv = -1;
 					goto abort;
@@ -866,7 +869,7 @@ int test_stripes(int *source, unsigned l
 		int disk;
 
 		for (i = 0 ; i < raid_disks ; i++) {
-			if ((lseek64(source[i], offsets[i]+start, 0) < 0) ||
+			if ((lseek(source[i], offsets[i]+start, 0) < 0) ||
 			    (read(source[i], stripes[i], chunk_size) !=
 			     chunk_size)) {
 				free(q);
--- a/raid6check.c
+++ b/raid6check.c
@@ -22,6 +22,9 @@
  *    Based on "restripe.c" from "mdadm" codebase
  */
 
+/* Enable largefile support */
+#define _FILE_OFFSET_BITS 64
+
 #include "mdadm.h"
 #include <stdint.h>
 #include <signal.h>
@@ -279,9 +282,9 @@ int manual_repair(int chunk_size, int sy
 	}
 
 	int write_res1, write_res2;
-	off64_t seek_res;
+	off_t seek_res;
 
-	seek_res = lseek64(source[fd1],
+	seek_res = lseek(source[fd1],
 			   offsets[fd1] + start * chunk_size, SEEK_SET);
 	if (seek_res < 0) {
 		fprintf(stderr, "lseek failed for failed_disk1\n");
@@ -289,7 +292,7 @@ int manual_repair(int chunk_size, int sy
 	}
 	write_res1 = write(source[fd1], blocks[failed_slot1], chunk_size);
 
-	seek_res = lseek64(source[fd2],
+	seek_res = lseek(source[fd2],
 			   offsets[fd2] + start * chunk_size, SEEK_SET);
 	if (seek_res < 0) {
 		fprintf(stderr, "lseek failed for failed_disk2\n");
@@ -374,7 +377,7 @@ int check_stripes(struct mdinfo *info, i
 			goto exitCheck;
 		}
 		for (i = 0 ; i < raid_disks ; i++) {
-			off64_t seek_res = lseek64(source[i], offsets[i] + start * chunk_size,
+			off_t seek_res = lseek(source[i], offsets[i] + start * chunk_size,
 						   SEEK_SET);
 			if (seek_res < 0) {
 				fprintf(stderr, "lseek to source %d failed\n", i);
--- a/swap_super.c
+++ b/swap_super.c
@@ -1,3 +1,6 @@
+/* Enable largefile support */
+#define _FILE_OFFSET_BITS 64
+
 #include <unistd.h>
 #include <stdlib.h>
 #include <fcntl.h>
@@ -16,8 +19,6 @@
 
 #define MD_NEW_SIZE_SECTORS(x)		((x & ~(MD_RESERVED_SECTORS - 1)) - MD_RESERVED_SECTORS)
 
-extern long long lseek64(int, long long, int);
-
 int main(int argc, char *argv[])
 {
 	int fd, i;
@@ -38,8 +39,8 @@ int main(int argc, char *argv[])
 		exit(1);
 	}
 	offset = MD_NEW_SIZE_SECTORS(size) * 512LL;
-	if (lseek64(fd, offset, 0) < 0LL) {
-		perror("lseek64");
+	if (lseek(fd, offset, 0) < 0LL) {
+		perror("lseek");
 		exit(1);
 	}
 	if (read(fd, super, 4096) != 4096) {
@@ -68,8 +69,8 @@ int main(int argc, char *argv[])
 		super[32*4+10*4 +i] = t;
 	}
 
-	if (lseek64(fd, offset, 0) < 0LL) {
-		perror("lseek64");
+	if (lseek(fd, offset, 0) < 0LL) {
+		perror("lseek");
 		exit(1);
 	}
 	if (write(fd, super, 4096) != 4096) {
