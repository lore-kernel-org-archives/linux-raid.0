Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87742EEB58B
	for <linux-raid@archiver.kernel.org>; Sat,  9 Sep 2023 11:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345376AbjIILyE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 9 Sep 2023 07:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345341AbjIILyD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 9 Sep 2023 07:54:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD05E47
        for <linux-raid@vger.kernel.org>; Sat,  9 Sep 2023 04:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694260395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2Brd09ChjlGcm33tn5aaPV7Dgfxku3U91yIO+34U0Xs=;
        b=abACNV+LktnyZ6U4SX8mTvQgLzUtMAwgzIomXYXwGca7ffHh+9/eKydMw1KBVG+8R+EXoH
        IzL1f3fR3PCVqUlCv6tF0GjMgCrOU06dPTbZ3tdICNYrrQ6QeP1s9abiwPVSU1tb9LkcDA
        /z92MdTdq+mhvgS2LLai94kbim/p3Ow=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-144-pMuuetLOMA2cjQitv6S13g-1; Sat, 09 Sep 2023 07:53:13 -0400
X-MC-Unique: pMuuetLOMA2cjQitv6S13g-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-76e015eb1c9so295361585a.3
        for <linux-raid@vger.kernel.org>; Sat, 09 Sep 2023 04:53:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694260392; x=1694865192;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2Brd09ChjlGcm33tn5aaPV7Dgfxku3U91yIO+34U0Xs=;
        b=cEaGtXgXNXatRkawwFGhJhhnWb+WQPXBZnrl7m1jvo+KIiQf55pfcDGYjVBr6z+866
         Y4uu/i9PniihASy3wvB+jl3fpg0Q5YCNnYvwYF3mWYFwyss/8CByhopcD+D2dtlK8iRH
         7g4y1ZGejpjS+epbUs44VRpKawpzjVrsjw8cm3Z8I7oAWShc14D1YVnjtbn09YrpjSGC
         EGsi+ALf2MTUKvNsWK883Rf980rawo+tMY+m4rF6TqK2qu1Rvd6dYmehKTmGrhJ2eBap
         i+/GO+1VKGmbkogwJRbCyc5cbV0XfnJ4RPp8TaoeVHXlnWKDtWPAQp1y+U2RPf2uHTk7
         eM7w==
X-Gm-Message-State: AOJu0Yzkpij2WvS41VJKBuKkyU5DWzdM4fcLgAuqFn27T91tOGhFDS2B
        xVHpGHzP6QLoZiHX93I9uT0LbOUfsyGxnFrCh92J0FqlzrLrfUMFlaZ0Hpa0OHG4kC8ANJuqEob
        8Qcs4CurpBVhIsG2lL/5S+w==
X-Received: by 2002:a05:620a:3d1:b0:767:96e2:a9cb with SMTP id r17-20020a05620a03d100b0076796e2a9cbmr4880710qkm.38.1694260392554;
        Sat, 09 Sep 2023 04:53:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzaPjdqQmtJK0AQn4B8TqeeRtKxwtYxBagaljOo1lDC4D12dp4dP61e64rcoFNOk8YVLcX7g==
X-Received: by 2002:a05:620a:3d1:b0:767:96e2:a9cb with SMTP id r17-20020a05620a03d100b0076796e2a9cbmr4880699qkm.38.1694260392288;
        Sat, 09 Sep 2023 04:53:12 -0700 (PDT)
Received: from [192.168.50.193] ([134.195.185.129])
        by smtp.gmail.com with ESMTPSA id d5-20020a05620a136500b0076f206cf16fsm1250131qkl.89.2023.09.09.04.53.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Sep 2023 04:53:11 -0700 (PDT)
Message-ID: <46d929d0-2aab-4cf2-b2bf-338963e8ba5a@redhat.com>
Date:   Sat, 9 Sep 2023 07:53:10 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     song@kernel.org, yukuai1@huaweicloud.com,
        Zhang Shurong <zhang_shurong@foxmail.com>
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        yukuai3@huawei.com
From:   Nigel Croxon <ncroxon@redhat.com>
Subject: [PATCH] raid1: fix error: ISO C90 forbids mixed declarations
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

There is a compile error when this commit is added:
md: raid1: fix potential OOB in raid1_remove_disk()

drivers/md/raid1.c: In function 'raid1_remove_disk':
drivers/md/raid1.c:1844:9: error: ISO C90 forbids mixed declarations
and code [-Werror=declaration-after-statement]
1844 |         struct raid1_info *p = conf->mirrors + number;
      |         ^~~~~~

That's because the new code was inserted before the struct.
The change is move the struct command above this commit.

Fixes: md: raid1: fix potential OOB in raid1_remove_disk()
commit 8b0472b50bcf

Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
---
  drivers/md/raid1.c | 4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a5453b126aab..4f1483bb708b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1846,11 +1846,11 @@ static int raid1_remove_disk(struct mddev 
*mddev, struct md_rdev *rdev)
      int err = 0;
      int number = rdev->raid_disk;

+    struct raid1_info *p = conf->mirrors + number;
+
      if (unlikely(number >= conf->raid_disks))
          goto abort;

-    struct raid1_info *p = conf->mirrors + number;
-
      if (rdev != p->rdev)
          p = conf->mirrors + conf->raid_disks + number;

-- 
2.31.1

