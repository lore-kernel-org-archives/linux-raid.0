Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D6FC32793
	for <linux-raid@archiver.kernel.org>; Wed, 18 Jan 2023 09:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbjARJQ5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 18 Jan 2023 04:16:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbjARJPW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 18 Jan 2023 04:15:22 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFE532E55
        for <linux-raid@vger.kernel.org>; Wed, 18 Jan 2023 00:32:41 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id u1-20020a17090a450100b0022936a63a21so1577517pjg.4
        for <linux-raid@vger.kernel.org>; Wed, 18 Jan 2023 00:32:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aAt8vYvFpuU5EjfB4jlEceiDAqRZ2QoRY4fZCQ7Irks=;
        b=okdvZY/DHtevE31r6J8/ym7F/22jL70aoGM7rMeq4p8ehcY3sA85jH/pdzM+sowRZs
         n/dWnffeK4UIM6muxsJCjzdwHzv/6QXkQsv/hp+X/RF83wa/eHacFUH7UeifvY7yV0GJ
         SVjf/D9fr6z05aoK+pCzBGk7nLTukiKgPYCI/saewUk8dkdgiC6aXDvteUqD3qn4tlgR
         k51Wfik7KqyBJvrHNew2hDL1vKT7bWrWLO9US1JwyYPVTzCEWxYhV2EOWOc2LlEcnnRW
         FlMnmkAv9A5KVeZrf+C9iCt8AKpHQFjnord4dZZTTwD40M27n67jnKJZE35ea/AqSpwo
         23/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aAt8vYvFpuU5EjfB4jlEceiDAqRZ2QoRY4fZCQ7Irks=;
        b=592/bDBAIvKpmTN2urMuH66NqcTytO9arCdrxqXLMVThpcnpe1UAIyYPO8UBpu4KiK
         ustjpbV2ebPydyg9LA8inuy2wwfSuxs84WuzAcySjJFV+AD+mritvWyylu/X8TS0EiMq
         PNidRFVgrfDDHn+gBDPKKrtndpDBiVmAY5Zo59BLHgadlaqsdO3HOPu5mEZTiQeu+ZyN
         GLu50vmvXsaloRipcjwTAdLQocb5JzlDCPkMrf6lhXFkr+xgbURlnwhif/VXOgAy4eft
         iTGnMfC9r57mGiGGKuANTE5gXw8Znjw8gYbfcLKcfQzUwXkQ4dpT24X+UDn/4V80zSiG
         E1DQ==
X-Gm-Message-State: AFqh2kpoF0Tr2VSx3MZteWiA2Z+E1G1MNuf6FRiTsKhf0GekzsIw5Fs6
        hemlnMT5sDyIufwUgpIYtgTWhA4DzYqdTg==
X-Google-Smtp-Source: AMrXdXsSXlrlcLbUkNpe2HRF1Akd1EwUOrCBiF2oRS+M8RtwP6q8QLuTD73DnT9APt66VJ3H/ZL7PQ==
X-Received: by 2002:a17:90a:9bc8:b0:229:36dc:a945 with SMTP id b8-20020a17090a9bc800b0022936dca945mr6516064pjw.23.1674030760157;
        Wed, 18 Jan 2023 00:32:40 -0800 (PST)
Received: from apollo.hsd1.ca.comcast.net ([2601:646:9181:1cf0::b940])
        by smtp.gmail.com with ESMTPSA id i7-20020a17090a2ac700b00219025945dcsm802605pjg.19.2023.01.18.00.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 00:32:39 -0800 (PST)
From:   Khem Raj <raj.khem@gmail.com>
To:     linux-raid@vger.kernel.org
Cc:     Khem Raj <raj.khem@gmail.com>
Subject: [PATCH] Define alignof using _Alignof when using C11 or newer
Date:   Wed, 18 Jan 2023 00:32:36 -0800
Message-Id: <20230118083236.24418-1-raj.khem@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

WG14 N2350 made very clear that it is an UB having type definitions
within "offsetof" [1]. This patch enhances the implementation of macro
alignof_slot to use builtin "_Alignof" to avoid undefined behavior on
when using std=c11 or newer

clang 16+ has started to flag this [2]

Fixes build when using -std >= gnu11 and using clang16+

Older compilers gcc < 4.9 or clang < 8 has buggy _Alignof even though it
may support C11, exclude those compilers too

[1] https://www.open-std.org/jtc1/sc22/wg14/www/docs/n2350.htm
[2] https://reviews.llvm.org/D133574

Upstream-Status: Pending
Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
 sha1.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/sha1.c b/sha1.c
index 89b32f4..1e4ad5d 100644
--- a/sha1.c
+++ b/sha1.c
@@ -229,7 +229,17 @@ sha1_process_bytes (const void *buffer, size_t len, struct sha1_ctx *ctx)
   if (len >= 64)
     {
 #if !_STRING_ARCH_unaligned
-# define alignof(type) offsetof (struct { char c; type x; }, x)
+/* GCC releases before GCC 4.9 had a bug in _Alignof.  See GCC bug 52023
+   <https://gcc.gnu.org/bugzilla/show_bug.cgi?id=52023>.
+   clang versions < 8.0.0 have the same bug.  */
+# if (!defined __STDC_VERSION__ || __STDC_VERSION__ < 201112 \
+      || (defined __GNUC__ && __GNUC__ < 4 + (__GNUC_MINOR__ < 9) \
+   && !defined __clang__) \
+      || (defined __clang__ && __clang_major__ < 8))
+#  define alignof(type) offsetof (struct { char c; type x; }, x)
+# else
+#  define alignof(type) _Alignof(type)
+# endif
 # define UNALIGNED_P(p) (((size_t) p) % alignof (sha1_uint32) != 0)
       if (UNALIGNED_P (buffer))
 	while (len > 64)
-- 
2.39.0

