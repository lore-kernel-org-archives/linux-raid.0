Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B26DC433B4
	for <linux-raid@archiver.kernel.org>; Wed, 14 Apr 2021 15:22:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01B2561158
	for <linux-raid@archiver.kernel.org>; Wed, 14 Apr 2021 15:22:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351971AbhDNPWh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Apr 2021 11:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232358AbhDNPWg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Apr 2021 11:22:36 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D65C061574
        for <linux-raid@vger.kernel.org>; Wed, 14 Apr 2021 08:22:15 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id h15so251712qvu.4
        for <linux-raid@vger.kernel.org>; Wed, 14 Apr 2021 08:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=FOVZwHsnTwZB3Eag/7SoyC6t+HwRXuLuKZPgASvf3xQ=;
        b=kWZnfP+P5E5hyE6BugAmQfViCt0TkXdofbiuxDdgKNtd+5+hgrHLImu2A2+EheZG2X
         5r/hC69Mk1R8mrLghyYeFldVlA8F6/sydFtEa9P3ROSGXPraZIDYmHvz6T4bi90jHCK0
         CNQs30kGWRhfatSgAfOLXUxE8+9WezupYC8Hu2akSkVwty0ymqXXVJHhSXCdi5k8Km44
         NfjXzsUR69iiaUSApuNVck2w5+tKsIIhJpiYf6vw3HOpfn7tx58EFdwEm/GPJpeMcKkl
         Jk9V54gMWXyObERsHqM3h616W/WASOCSIOhQPDXRxgtvtdQC9RlXfib1XsL6W4HSFci0
         5jxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=FOVZwHsnTwZB3Eag/7SoyC6t+HwRXuLuKZPgASvf3xQ=;
        b=Ga0GTfn0amtNbUUqOsPVh79YU9Jvuws63Q8mS1yAPAODd2Tv0B8CmLYmDF3POX6IqJ
         hnAL9iVTS2HujWlUPwQAGCUDXOSLg+X78Y4eu6nnnPcRks+4HdAFym4yV7VqzeBC+wYo
         Wc9sD0m3mL2K51CannwDaLAPhBKiXPSBfOpoP61jk0SE0gNHmGqJDspkQK6KE0JgP1M/
         vCnE/CaUeffYWzKsr3+/5NI1ZGGfM8W2ekJ68IU21zuYd9JQtjINy5HJZFKGer38vbUm
         S09cmBJCY4g1SOWP3wu4pjUW5498nfeSp/okVrv+jAfjry74GlqqY7jQw/Ae8dqRTQC9
         uurg==
X-Gm-Message-State: AOAM533ERo5NxdLqI+q0csbW0UBSM0X0suRpHbLihsnWlU9fZ4M9Cpya
        wXw3HQw4iTkXwlbhs7YqySg=
X-Google-Smtp-Source: ABdhPJwWKqcLnfgkJ4QsjUKpAs9Sq3pHkVGbVRqvevXo/ielD5TkXvAItMMBwZ1dwjVyEnF3Y8n4uA==
X-Received: by 2002:a0c:b294:: with SMTP id r20mr37963732qve.16.1618413734347;
        Wed, 14 Apr 2021 08:22:14 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:1102::1844? ([2620:10d:c091:480::1:1b53])
        by smtp.gmail.com with ESMTPSA id o189sm571759qkd.60.2021.04.14.08.22.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Apr 2021 08:22:13 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Subject: mdadm-4.2-rc1
Message-ID: <a1e3bf9d-0e92-c88e-13a1-7d2f6482fb01@gmail.com>
Date:   Wed, 14 Apr 2021 11:22:12 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I have pushed mdadm-4.2-rc1 to git and there should be binaries pushed
as well.

Note I had to fix checking the return value of get_dev_sector_size() in
super-intel.c. I think I got it right, but I don't have a test machine
with IMSM at the moment, so please test I didn't break it.

Thanks,
Jes

