Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 150E8C2BA4C
	for <linux-raid@archiver.kernel.org>; Wed, 26 Jan 2022 11:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240841AbiAZLmS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 26 Jan 2022 06:42:18 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:60575 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240838AbiAZLmL (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 26 Jan 2022 06:42:11 -0500
Received: from localhost.localdomain (ip5f5aecd1.dynamic.kabel-deutschland.de [95.90.236.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 076D661EA1922;
        Wed, 26 Jan 2022 12:42:10 +0100 (CET)
From:   Paul Menzel <pmenzel@molgen.mpg.de>
To:     Song Liu <song@kernel.org>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-raid@vger.kernel.org,
        Matt Brown <matthew.brown.dev@gmail.com>
Subject: [PATCH 3/3] lib/raid6/test: Rename variable to avoid `raid6_call` name clash
Date:   Wed, 26 Jan 2022 12:41:44 +0100
Message-Id: <20220126114144.370517-3-pmenzel@molgen.mpg.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126114144.370517-1-pmenzel@molgen.mpg.de>
References: <20220126114144.370517-1-pmenzel@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Ubuntu 21.10 (ppc64le) building `raid6test` with gcc (Ubuntu
11.2.0-7ubuntu2) 11.2.0 fails with the error below.

    $ cd lib/raid6/test
    $ make
    […]
    gcc -I.. -I ../../../include -g -O2                      -I../../../arch/powerpc/include -DCONFIG_ALTIVEC -o raid6test test.c raid6.a
    /usr/bin/ld: raid6.a(algos.o):/dev/shm/linux/lib/raid6/test/algos.c:28: multiple definition of `raid6_call'; /scratch/local/ccHnUnID.o:/dev/shm/linux/lib/raid6/test/test.c:22: first defined here
    collect2: error: ld returned 1 exit status
    make: *** [Makefile:74: raid6test] Error 1

Renaming the variable in `test.c` to `raid6_call2` works around that.

The resulting binary terminates with a segmentation fault:

    $ ./raid6test
    using recovery intx1
    Segmentation fault (core dumped)
    $ dmesg | tail -3
    [75519.758988] raid6test[1891185]: segfault (11) at 0 nip 0 lr 708aa3fe197c code 1 in libc.so.6[708aa3ca0000+260000]
    [75519.759006] raid6test[1891185]: code: XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
    [75519.759024] raid6test[1891185]: code: XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX

Cc: Matt Brown <matthew.brown.dev@gmail.com>
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
---
 lib/raid6/test/test.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/lib/raid6/test/test.c b/lib/raid6/test/test.c
index a3cf071941ab..937d2a8bb294 100644
--- a/lib/raid6/test/test.c
+++ b/lib/raid6/test/test.c
@@ -19,7 +19,7 @@
 #define NDISKS		16	/* Including P and Q */
 
 const char raid6_empty_zero_page[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
-struct raid6_calls raid6_call;
+struct raid6_calls raid6_call2;
 
 char *dataptrs[NDISKS];
 char data[NDISKS][PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
@@ -71,7 +71,7 @@ static int test_disks(int i, int j)
 		erra = errb = 0;
 	} else {
 		printf("algo=%-8s  faila=%3d(%c)  failb=%3d(%c)  %s\n",
-		       raid6_call.name,
+		       raid6_call2.name,
 		       i, disk_type(i),
 		       j, disk_type(j),
 		       (!erra && !errb) ? "OK" :
@@ -107,30 +107,30 @@ int main(int argc, char *argv[])
 			if ((*algo)->valid && !(*algo)->valid())
 				continue;
 
-			raid6_call = **algo;
+			raid6_call2 = **algo;
 
 			/* Nuke syndromes */
 			memset(data[NDISKS-2], 0xee, 2*PAGE_SIZE);
 
 			/* Generate assumed good syndrome */
-			raid6_call.gen_syndrome(NDISKS, PAGE_SIZE,
+			raid6_call2.gen_syndrome(NDISKS, PAGE_SIZE,
 						(void **)&dataptrs);
 
 			for (i = 0; i < NDISKS-1; i++)
 				for (j = i+1; j < NDISKS; j++)
 					err += test_disks(i, j);
 
-			if (!raid6_call.xor_syndrome)
+			if (!raid6_call2.xor_syndrome)
 				continue;
 
 			for (p1 = 0; p1 < NDISKS-2; p1++)
 				for (p2 = p1; p2 < NDISKS-2; p2++) {
 
 					/* Simulate rmw run */
-					raid6_call.xor_syndrome(NDISKS, p1, p2, PAGE_SIZE,
+					raid6_call2.xor_syndrome(NDISKS, p1, p2, PAGE_SIZE,
 								(void **)&dataptrs);
 					makedata(p1, p2);
-					raid6_call.xor_syndrome(NDISKS, p1, p2, PAGE_SIZE,
+					raid6_call2.xor_syndrome(NDISKS, p1, p2, PAGE_SIZE,
                                                                 (void **)&dataptrs);
 
 					for (i = 0; i < NDISKS-1; i++)
-- 
2.34.1

