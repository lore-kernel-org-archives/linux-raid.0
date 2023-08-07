Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A602C3DA40
	for <linux-raid@archiver.kernel.org>; Mon,  7 Aug 2023 11:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbjHGLNx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 7 Aug 2023 07:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbjHGLNY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 7 Aug 2023 07:13:24 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3111FDA
        for <linux-raid@vger.kernel.org>; Mon,  7 Aug 2023 04:12:25 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1bb91c20602so9342265ad.0
        for <linux-raid@vger.kernel.org>; Mon, 07 Aug 2023 04:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1691406712; x=1692011512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ubpyp4SIhGXjO6/VTKiZvWjlRzyN8ANvKHVN5xSGnIw=;
        b=G6tJn+16QVti2qtu2hqYljseIE/XGpe1Yhsul4LFU6R/aCDAM7lceOlES83Z0B/Pue
         2irlih/PCzGRhADqlmxdT4ZmTPg/rDw2XT4QeZKx/Tui9xhVWAtyJogqiocaYi2mPJVJ
         JfsH0RSoKbpVavaYBWWtyo/mJh8W+H0WFTE4SVefHn6UoqHLIS8l90Z//i2iVib88cLh
         SO8x9HJ9eijOF2Obr6A8OaZNG3N0xetNtsejNB5r0CVLeObeV8ZzJa8r4m2G8/H610tO
         JRFiieD8eIQL4G+uzuFBv5AMDY6TbkMqFwB+fegzuV4xQGReerwz1d1NP8JNZHZ17Zsd
         g+Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691406712; x=1692011512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ubpyp4SIhGXjO6/VTKiZvWjlRzyN8ANvKHVN5xSGnIw=;
        b=GpPCH8fqcAKYUVWTiyl9TDOQWcfcpdjtaV6fa62PJkblQZX8YeNHrNuq5l975zdbAH
         gmc91P6dH64U9fZJLIEy6mUq9b67DCVrhtf2mwp8KMdEj9V74szp6MjK96akwJblSkqz
         SyXU4tSZaW3Xgzq/Il7mX8x1S1BznqreU4duyU6gVnQ+GLQ3+XJhqpWEbthOE+pZ+fze
         kcPIVZU6ARzu/tblFh4tQJ0u3gaGuxA0iOwyqv/IRy1c85Dc3VhA0/RsF9iiwG1g4sZ2
         YmATMc1aZHwZkhRKMuB1nPUt7yCmQRpHB5dquO9Abdzy3AhmX2EBSJa9QlHShomRmoBI
         9Giw==
X-Gm-Message-State: ABy/qLY7tzAJmjkht7WBfzN6dlIb5qcSbu1SfswC5Ir+SKPhtSgQ4fNQ
        HwV+2oU6R/PtJSy1CLmTOp5yzQ==
X-Google-Smtp-Source: APBJJlGAdl0ewhYUg6UhJdRJKXIwq0U3XoR/AJshcbF16xE0A4mgQC4Umc8PgwnpC/Hq6tl8ikCZEw==
X-Received: by 2002:a17:902:ea04:b0:1b8:17e8:547e with SMTP id s4-20020a170902ea0400b001b817e8547emr32460173plg.1.1691406712196;
        Mon, 07 Aug 2023 04:11:52 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id y13-20020a17090aca8d00b0025be7b69d73sm5861191pjt.12.2023.08.07.04.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 04:11:51 -0700 (PDT)
From:   Qi Zheng <zhengqi.arch@bytedance.com>
To:     akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
        vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
        brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
        steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
        yujie.liu@intel.com, gregkh@linuxfoundation.org,
        muchun.song@linux.dev, simon.horman@corigine.com,
        dlemoal@kernel.org
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
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 09/48] erofs: dynamically allocate the erofs-shrinker
Date:   Mon,  7 Aug 2023 19:08:57 +0800
Message-Id: <20230807110936.21819-10-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Use new APIs to dynamically allocate the erofs-shrinker.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 fs/erofs/utils.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/erofs/utils.c b/fs/erofs/utils.c
index cc6fb9e98899..6e1a828e6ca3 100644
--- a/fs/erofs/utils.c
+++ b/fs/erofs/utils.c
@@ -270,19 +270,25 @@ static unsigned long erofs_shrink_scan(struct shrinker *shrink,
 	return freed;
 }
 
-static struct shrinker erofs_shrinker_info = {
-	.scan_objects = erofs_shrink_scan,
-	.count_objects = erofs_shrink_count,
-	.seeks = DEFAULT_SEEKS,
-};
+static struct shrinker *erofs_shrinker_info;
 
 int __init erofs_init_shrinker(void)
 {
-	return register_shrinker(&erofs_shrinker_info, "erofs-shrinker");
+	erofs_shrinker_info = shrinker_alloc(0, "erofs-shrinker");
+	if (!erofs_shrinker_info)
+		return -ENOMEM;
+
+	erofs_shrinker_info->count_objects = erofs_shrink_count;
+	erofs_shrinker_info->scan_objects = erofs_shrink_scan;
+	erofs_shrinker_info->seeks = DEFAULT_SEEKS;
+
+	shrinker_register(erofs_shrinker_info);
+
+	return 0;
 }
 
 void erofs_exit_shrinker(void)
 {
-	unregister_shrinker(&erofs_shrinker_info);
+	shrinker_free(erofs_shrinker_info);
 }
 #endif	/* !CONFIG_EROFS_FS_ZIP */
-- 
2.30.2

