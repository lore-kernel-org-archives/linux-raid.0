Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34630C433B4
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 08:09:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C3E261353
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 08:09:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244494AbhESIKo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 May 2021 04:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244503AbhESIKk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 19 May 2021 04:10:40 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC4BC061760
        for <linux-raid@vger.kernel.org>; Wed, 19 May 2021 01:09:21 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id 69so6575713plc.5
        for <linux-raid@vger.kernel.org>; Wed, 19 May 2021 01:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=AnQBgPR1ckhZreoSwDpl/jVbnGMPOCuwgre2h7ADTQ8=;
        b=PX5BZmMrobvIBbAxD2tm0km4nZrDIg0Zu8X37Ph31WX1dSovVQXvh1jdiC9TtsuirA
         l9mMaNqlt/u5I1mvoaO5V6UER51H/uTxjCbJJhuLqzIsFjLeoDAtqdKnLbbxc17QL+3L
         uPljdgotTRC8AB+Im3w0tMk/G5WVoE1ewJDxgVNWxS7+CvA6wxOdcIW2+zjNWeW7rE+9
         tnSqz/Ug2OrnLq7yLUps+jLcK9SzLmg1w3nO/HtPE2qYpAJpqn7QqBs077ojHrQqIz2+
         YDXCQR2l1uOSyKD/ZcZoHeIyTKlrZznJ+htrVPYNYWVNYzw8emS5v5vq/1TJuOzRarom
         /UcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=AnQBgPR1ckhZreoSwDpl/jVbnGMPOCuwgre2h7ADTQ8=;
        b=gNRwy4sNLxj/g5HS+DIrq7VWs9ku1EqNIU69mkPWAeY0E7o3lux0/yE99BNjO5fmGG
         gIVitUSGKZxrKRV2e3X977JbUenYdLecEw0ExyXnpYrCrTOOTuGBt3lyzZi8pg7w7stg
         g/o47TMKnE//ZPTniBrjT2166kCFgn3iUa1+QncI5gcHf6v5j7JAiB48Av3KiLEB8nll
         QKgQ23vBbXA/GXUosS469bE8XM28KxqNlOnjWBILiXUHjw//AIaeFtoOIZFjxI/ShVHH
         kgdDwKfcUwz00GCVZWq1XK0svqu6S1w9Pj9g+yjafpYON/omeHfR1UM37ren2QvQRD//
         IvrQ==
X-Gm-Message-State: AOAM532jd5RAX3cyE1UqZJOq/Dk93c2FqyDweQT3ZTM9nzoFgqJ6E8AL
        DJJOyXeXvzPJyypaWE6Gde3TpypDRBVMFA==
X-Google-Smtp-Source: ABdhPJya+aJxjlzcGotL+sSy6/6Fk2yCM5kPNuYDsvxSXnxTiUphkYDK6W2/E5OIME+7o9jIpGJGQg==
X-Received: by 2002:a17:90a:b116:: with SMTP id z22mr10154342pjq.113.1621411761028;
        Wed, 19 May 2021 01:09:21 -0700 (PDT)
Received: from [10.6.1.203] ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id h8sm8303455pfv.60.2021.05.19.01.09.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 May 2021 01:09:20 -0700 (PDT)
Subject: Re: [PATCH 2/5] md: the latest try for improve io stats accounting
To:     Artur Paszkiewicz <artur.paszkiewicz@intel.com>, song@kernel.org
Cc:     linux-raid@vger.kernel.org, Guoqing Jiang <jiangguoqing@kylinos.cn>
References: <20210518053225.641506-1-jiangguoqing@kylinos.cn>
 <20210518053225.641506-3-jiangguoqing@kylinos.cn>
 <2887bc44-dd0b-0b24-ee97-b0a95f0c4936@intel.com>
 <2bfe7f2b-5b5b-634d-3996-3c4ed77e74ff@gmail.com>
 <d788bc1f-3fd9-a293-2f2a-6047fdd45625@intel.com>
From:   Guoqing Jiang <jgq516@gmail.com>
Message-ID: <c63b1793-e83e-f729-cd97-2f34b43166dd@gmail.com>
Date:   Wed, 19 May 2021 16:09:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <d788bc1f-3fd9-a293-2f2a-6047fdd45625@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/19/21 3:26 PM, Artur Paszkiewicz wrote:
> On 19.05.2021 03:30, Guoqing Jiang wrote:
>> Hmm, raid0 allocates split bio from mddev->bio_set, but raid5 is
>> different, it splits bio from r5conf->bio_split. So either let raid5 also
>> splits bio from mddev->bio_set, or add an additional checking for
>> raid5. Thoughts?
> It looks like raid5 has a different bio set for that because it uses
> mddev->bio_set for something else - allocating a bio for rdev. So I
> think it can be changed to split from mddev->bio_set and have a private
> bio set for the rdev bio allocation.


Instead of add a flag, I tried this way:

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index e5d7411cba9b..d309b639b5d9 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -748,6 +748,19 @@ static void raid0_quiesce(struct mddev *mddev, int 
quiesce)
  {
  }

+/*
+ * Don't account the bio if it was split from mddev->bio_set.
+ */
+static bool raid0_accounting_bio(struct mddev *mddev, struct bio *bio)
+{
+       bool ret = true;
+
+       if (bio->bi_pool == &mddev->bio_set)
+               ret = false;
+
+       return ret;
+}
+
  static struct md_personality raid0_personality=
  {
         .name           = "raid0",
@@ -760,6 +773,7 @@ static struct md_personality raid0_personality=
         .size           = raid0_size,
         .takeover       = raid0_takeover,
         .quiesce        = raid0_quiesce,
+       .accounting_bio = raid0_accounting_bio,
  };

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 841e1c1aa5e6..070ccf55c534 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8596,6 +8596,20 @@ static void *raid6_takeover(struct mddev *mddev)
         return setup_conf(mddev);
  }

+/*
+ * Don't account the bio if it was split from r5conf->bio_split.
+ */
+static bool raid5_accounting_bio(struct mddev *mddev, struct bio *bio)
+{
+       bool ret = true;
+       struct r5conf *conf = mddev->private;
+
+       if (bio->bi_pool == &conf->bio_split)
+               ret = false;
+
+       return ret;
+}
+
  static int raid5_change_consistency_policy(struct mddev *mddev, const 
char *buf)
  {
         struct r5conf *conf;
@@ -8687,6 +8701,7 @@ static struct md_personality raid6_personality =
         .finish_reshape = raid5_finish_reshape,
         .quiesce        = raid5_quiesce,
         .takeover       = raid6_takeover,
+       .accounting_bio = raid5_accounting_bio,

Thanks,
Guoqing
