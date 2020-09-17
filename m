Return-Path: <SRS0=RAIN=C2=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED01C43461
	for <linux-raid@archiver.kernel.org>; Thu, 17 Sep 2020 17:21:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6842221E3
	for <linux-raid@archiver.kernel.org>; Thu, 17 Sep 2020 17:21:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="oaLH/ENO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgIQRVU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 17 Sep 2020 13:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgIQRUt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 17 Sep 2020 13:20:49 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22072C06174A
        for <linux-raid@vger.kernel.org>; Thu, 17 Sep 2020 10:20:40 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id e11so4888707wme.0
        for <linux-raid@vger.kernel.org>; Thu, 17 Sep 2020 10:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/W2tWpMILIr072M8aCIG+3DmK9mlRTEehMci+PZlong=;
        b=oaLH/ENOpODbDud2+IrLF/6srfkZprhfXncYgUeZr1MBHeCXpzy1rJ20ILxMZR7ZYG
         fuopn11Hj5P37rGevjTOXZRLFKGVhNE+DZF1N1IQq5XtCc0MS7JHboGHQ4JPUNNeci3x
         IaTiXRJi5F5fjsVmrTEx1MomEX6g1RTKZnzaEJRD1F2QR9NhekPywesDKCpzs0eCMPsF
         EKy7C5LXjk/zF30Q+DplpHy3HeCtXFtwb/xtGotWZSbWk8Wnes0gTVT4Edv3CIp/4lfW
         MWWUQT/jC2AdMXPGTsRuNH9avnWnq0sDyahXurhlheTWes5TAL1/hkvSd28a1lG9AjKA
         qC4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/W2tWpMILIr072M8aCIG+3DmK9mlRTEehMci+PZlong=;
        b=ZNSXjB6kOeFbW3KgX20EpZVQ9A7QuLwDazL+8TAVmP4xMZwD4w1sAIcKiahk44qpWK
         IhwBulbGIixgQuZal3xZpiw4yewy2moOLWvQwKGPeS9xPU9GvGaBjkdeMCcLGtmFqOff
         hfPc6C+6rZYwzVYcjLPY+lil1iRv1nEcQkoJOKRBlL4ht7IWyKXlnYEpY56LWvH7DQez
         FUKQ7EYqj+VduiZS6iZ9o6doDKkvC02dnfUiCPGqJ24o6f3eMze5MMZ0CJHwLCG2tT5H
         7C5aPIUzN0bQCUX9ik5s6nyiGUCFTA1q9kt71TmzkoiYFw3egfGD3AW9yxSXUGVOI344
         dLuA==
X-Gm-Message-State: AOAM532+zDK/rr/IQYMew0eiwH5nLtHJ5bjlJhe6lcbu9ng6KiUQOuRG
        QC/vPu3G5ckOMvbLJqOA2LVJDtn1iXnTcC7MoN85o3fcTJIjWw==
X-Google-Smtp-Source: ABdhPJzytTCRcWz9qGzIbIDLoQ+VSgx6tXvDUwPXts9wdrJ51N9lc2vtdgW4fJCuiq+8WvvkpMPsMa7osFuuhgRwi/4=
X-Received: by 2002:a7b:cd08:: with SMTP id f8mr10940224wmj.124.1600363238888;
 Thu, 17 Sep 2020 10:20:38 -0700 (PDT)
MIME-Version: 1.0
References: <d3fced3f-6c2b-5ffa-fd24-b24ec6e7d4be@xmyslivec.cz>
 <CAJCQCtSfz+b38fW3zdcHwMMtO1LfXSq+0xgg_DaKShmAumuCWQ@mail.gmail.com>
 <29509e08-e373-b352-d696-fcb9f507a545@xmyslivec.cz> <CAJCQCtRx7NJP=-rX5g_n5ZL7ypX-5z_L6d6sk120+4Avs6rJUw@mail.gmail.com>
 <695936b4-67a2-c862-9cb6-5545b4ab3c42@xmyslivec.cz> <CAJCQCtQWNSd123OJ_Rp8NO0=upY2Mn+SE7pdMqmyizJP028Yow@mail.gmail.com>
 <2f2f1c21-c81b-55aa-6f77-e2d3f32d32cb@xmyslivec.cz> <CAJCQCtTQN60V=DEkNvDedq+usfmFB+SQP2SBezUaSeUjjY46nA@mail.gmail.com>
 <4b0dd0aa-f77b-16c8-107b-0182378f34e6@xmyslivec.cz> <CAJCQCtQWh2JBAL_SDRG-gMd9Z1TXad7aKjZVUGdY1Akj7fn5Qg@mail.gmail.com>
 <5e79d1f8-7632-48ef-de56-9e79cba87434@xmyslivec.cz> <CAJCQCtTYAg-uNpk2WYv0QDWH+prfnDN5oKyKmvTVHjARu_w0Kw@mail.gmail.com>
In-Reply-To: <CAJCQCtTYAg-uNpk2WYv0QDWH+prfnDN5oKyKmvTVHjARu_w0Kw@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 17 Sep 2020 11:20:23 -0600
Message-ID: <CAJCQCtTkgaoOTHnUDHNUxZXtOumPaq903=84r1-6LT5c3UP2nQ@mail.gmail.com>
Subject: Re: Linux RAID with btrfs stuck and consume 100 % CPU
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Vojtech Myslivec <vojtech@xmyslivec.cz>,
        Song Liu <songliubraving@fb.com>,
        Michal Moravec <michal.moravec@logicworks.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Linux-RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The iostat isn't particularly revealing, I don't see especially high
%util for any device. SSD write MB/s gets up to 42 which is
reasonable.


--
Chris Murphy
