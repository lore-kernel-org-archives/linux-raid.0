Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD8AEC2BA4C
	for <linux-raid@archiver.kernel.org>; Wed, 26 Jan 2022 11:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240835AbiAZLmK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 26 Jan 2022 06:42:10 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:42885 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240832AbiAZLmJ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 26 Jan 2022 06:42:09 -0500
Received: from localhost.localdomain (ip5f5aecd1.dynamic.kabel-deutschland.de [95.90.236.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 17FF261EA191E;
        Wed, 26 Jan 2022 12:42:08 +0100 (CET)
From:   Paul Menzel <pmenzel@molgen.mpg.de>
To:     Song Liu <song@kernel.org>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-raid@vger.kernel.org,
        Matt Brown <matthew.brown.dev@gmail.com>
Subject: [PATCH 2/3] lib/raid6: Include <asm/ppc-opcode.h> for `VPERMXOR`
Date:   Wed, 26 Jan 2022 12:41:43 +0100
Message-Id: <20220126114144.370517-2-pmenzel@molgen.mpg.de>
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

    gcc -I.. -I ../../../include -g -O2                      -I../../../arch/powerpc/include -DCONFIG_ALTIVEC -c -o vpermxor1.o vpermxor1.c
    vpermxor1.c: In function ‘raid6_vpermxor1_gen_syndrome_real’:
    vpermxor1.c:64:29: error: expected string literal before ‘VPERMXOR’
       64 |                         asm(VPERMXOR(%0,%1,%2,%3):"=v"(wq0):"v"(gf_high), "v"(gf_low), "v"(wq0));
          |                             ^~~~~~~~
    make: *** [Makefile:58: vpermxor1.o] Error 1

So, include the header `asm/ppc-opcode.h` defining this macro also when
not building the Linux kernel but only this too.

Cc: Matt Brown <matthew.brown.dev@gmail.com>
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
---
 lib/raid6/vpermxor.uc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/raid6/vpermxor.uc b/lib/raid6/vpermxor.uc
index 10475dc423c1..1bfb127fbfe8 100644
--- a/lib/raid6/vpermxor.uc
+++ b/lib/raid6/vpermxor.uc
@@ -24,9 +24,9 @@
 #ifdef CONFIG_ALTIVEC
 
 #include <altivec.h>
+#include <asm/ppc-opcode.h>
 #ifdef __KERNEL__
 #include <asm/cputable.h>
-#include <asm/ppc-opcode.h>
 #include <asm/switch_to.h>
 #endif
 
-- 
2.34.1

