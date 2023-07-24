Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF4C8C001DE
	for <linux-raid@archiver.kernel.org>; Mon, 24 Jul 2023 09:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbjGXJqr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Jul 2023 05:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbjGXJqI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Jul 2023 05:46:08 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888121994
        for <linux-raid@vger.kernel.org>; Mon, 24 Jul 2023 02:45:55 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1b867f9198dso8893395ad.0
        for <linux-raid@vger.kernel.org>; Mon, 24 Jul 2023 02:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690191955; x=1690796755;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jmPwAlPL0TnDBmalzCzATtOPmfxfqu3Q+7XaFZclAtg=;
        b=IZCH5tV1VdvhB0RXcuG+SL+gg1mEbPZMQJz8qUY1fWCpYBfjAR72/AnWbcPpstjQLI
         aFpv+l8Q67Kc3iJwSzziW/zZbsYehvkdZbQbXx8X8jR6oJCUrIFV8Qzo50G/FYmT9t2/
         w6ZN7N+ZviCRVJxyy+bucuBxrS6SRhon2EIiX0i15H4OrDXIvK+dChrAy0pj6MjsuwdC
         6yiqEWuw0/0mdj0SNL2xTjIsK+WXPpE1gw9KgQ4WCUpGSoFe6rXH0GXBficEqbQlrShV
         wc7SdQklmSH69kiwU3dxFC6F0qOnJE6NuoEe6VBjJkE5shAIs2KVw9Ha+vCxjUcFWX2y
         lSHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690191955; x=1690796755;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jmPwAlPL0TnDBmalzCzATtOPmfxfqu3Q+7XaFZclAtg=;
        b=LQPuMJ7eG40vjld7irPMNMpZ+ByFZ9AiaOz2EPNKVw03egJ+hwGe87BfOxN7jx69Bt
         kQBcv4rm4jW7kOjzjgpXBEGTGIiJ1T4qe/T4USf0FUeFGSOqVxRdE/YOEgiqB+bH7QNX
         I2J+SkjSjeQOGE3VMUE+loVywRErmXVg65HW3TI4ZHhcgD9UUm/8xKzFeCaUOl0ksZIm
         5re2jRMBDnvmjY97swgAxa4jKlaIN7d9appx0jzIKpftd2yzoL0VFof4N58kTXIxDiu8
         b7fQZyclG2cwK47GzBDPWYAPgxEXuAShrssgyGSy434Bdt2i/9HWDE/GpfLWiPkpEmlN
         DePA==
X-Gm-Message-State: ABy/qLZ9QQQZPXt2a7mM5qAYWVE71u9/CQH0OSxFbUBAqz96W3Rjih10
        w7GgtWj0580zNXgHBSkOi3kLVQ==
X-Google-Smtp-Source: APBJJlHDY1qhgSa+H4mr70oj6h44PLP3QUTUzXb3MsGg4I77oDNLLFWrtOaIhBAmIAnOXFQDdEVBFw==
X-Received: by 2002:a17:902:d4cb:b0:1b1:9272:55e2 with SMTP id o11-20020a170902d4cb00b001b1927255e2mr12365119plg.3.1690191954835;
        Mon, 24 Jul 2023 02:45:54 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902c18500b001bb20380bf2sm8467233pld.13.2023.07.24.02.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 02:45:54 -0700 (PDT)
From:   Qi Zheng <zhengqi.arch@bytedance.com>
To:     akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
        vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
        brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
        steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
        yujie.liu@intel.com, gregkh@linuxfoundation.org,
        muchun.song@linux.dev
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-erofs@lists.ozlabs.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-nfs@vger.kernel.org, linux-mtd@lists.infradead.org,
        rcu@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        dm-devel@redhat.com, linux-raid@vger.kernel.org,
        linux-bcache@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 04/47] kvm: mmu: dynamically allocate the x86-mmu shrinker
Date:   Mon, 24 Jul 2023 17:43:11 +0800
Message-Id: <20230724094354.90817-5-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Use new APIs to dynamically allocate the x86-mmu shrinker.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 arch/x86/kvm/mmu/mmu.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ec169f5c7dce..ab405e0a8954 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6847,11 +6847,7 @@ static unsigned long mmu_shrink_count(struct shrinker *shrink,
 	return percpu_counter_read_positive(&kvm_total_used_mmu_pages);
 }
 
-static struct shrinker mmu_shrinker = {
-	.count_objects = mmu_shrink_count,
-	.scan_objects = mmu_shrink_scan,
-	.seeks = DEFAULT_SEEKS * 10,
-};
+static struct shrinker *mmu_shrinker;
 
 static void mmu_destroy_caches(void)
 {
@@ -6984,10 +6980,16 @@ int kvm_mmu_vendor_module_init(void)
 	if (percpu_counter_init(&kvm_total_used_mmu_pages, 0, GFP_KERNEL))
 		goto out;
 
-	ret = register_shrinker(&mmu_shrinker, "x86-mmu");
-	if (ret)
+	mmu_shrinker = shrinker_alloc(0, "x86-mmu");
+	if (!mmu_shrinker)
 		goto out_shrinker;
 
+	mmu_shrinker->count_objects = mmu_shrink_count;
+	mmu_shrinker->scan_objects = mmu_shrink_scan;
+	mmu_shrinker->seeks = DEFAULT_SEEKS * 10;
+
+	shrinker_register(mmu_shrinker);
+
 	return 0;
 
 out_shrinker:
@@ -7009,7 +7011,7 @@ void kvm_mmu_vendor_module_exit(void)
 {
 	mmu_destroy_caches();
 	percpu_counter_destroy(&kvm_total_used_mmu_pages);
-	unregister_shrinker(&mmu_shrinker);
+	shrinker_unregister(mmu_shrinker);
 }
 
 /*
-- 
2.30.2

