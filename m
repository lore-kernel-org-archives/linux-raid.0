Return-Path: <SRS0=mN13=CW=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=BAYES_20,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D186CC433E2
	for <linux-raid@archiver.kernel.org>; Sun, 13 Sep 2020 20:48:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BAC621655
	for <linux-raid@archiver.kernel.org>; Sun, 13 Sep 2020 20:48:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=lease-up.com header.i=@lease-up.com header.b="iQnsL+cs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbgIMUsC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 13 Sep 2020 16:48:02 -0400
Received: from letbox-vps.us-core.com ([144.172.68.95]:60718 "EHLO
        letbox-vps.us-core.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgIMUsA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 13 Sep 2020 16:48:00 -0400
X-Greylist: delayed 1398 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Sep 2020 16:48:00 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=lease-up.com; s=2017; h=Content-Type:To:Subject:Message-ID:Date:From:
        MIME-Version:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CwIbL6Z1TcBR/t3Y8gmT/syVo0Z5FTG+Nts4bfFWW1Q=; b=iQnsL+csOQ8S80KjfSC1SzzVtO
        yS17zd5agmtF2fcNnljT3ZuKjJMnMeHd0GoPQaq3TyPv+kYcD2Kmq1UHv+CsyJxOkoXDQo1dtx4Mf
        ROBvmblJTPbeplMYyFwVtnIXZNsEqSSOE1K3iGq7SSOMi1tC4qh+eQL58e6D5F8CaT2M=;
Received: from mail-io1-f43.google.com ([209.85.166.43])
        by letbox-vps.us-core.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <felix.lechner@lease-up.com>)
        id 1kHYYC-003FAr-Qo
        for linux-raid@vger.kernel.org; Sun, 13 Sep 2020 13:24:40 -0700
Received: by mail-io1-f43.google.com with SMTP id r25so17140114ioj.0
        for <linux-raid@vger.kernel.org>; Sun, 13 Sep 2020 13:24:40 -0700 (PDT)
X-Gm-Message-State: AOAM530QTk4++IULaE6scocRBSbARpqVq4HRjjVwR/UV0LiyxVkQoer7
        51r2/RtN5rIetTfQOMUDKnNem88jE0wFZz3qE1A=
X-Google-Smtp-Source: ABdhPJwdxOgXQISP5EWDneHpRSe4cW4YD14Kxu1mhKgIhIDlRg2nfWxjJDbnyheGe77ZSqAWmcaEQz7S0CCuYohFEGc=
X-Received: by 2002:a02:234c:: with SMTP id u73mr10533021jau.141.1600028680326;
 Sun, 13 Sep 2020 13:24:40 -0700 (PDT)
MIME-Version: 1.0
From:   Felix Lechner <felix.lechner@lease-up.com>
Date:   Sun, 13 Sep 2020 13:24:03 -0700
X-Gmail-Original-Message-ID: <CAFHYt55wZfb66zMjGG96OVeXjfVga-kJew=HQqnNBKD2ZXQiFQ@mail.gmail.com>
Message-ID: <CAFHYt55wZfb66zMjGG96OVeXjfVga-kJew=HQqnNBKD2ZXQiFQ@mail.gmail.com>
Subject: Recommendation for a stable commit in mdadm
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

I recently assumed maintenance of mdadm in Debian and would like to
reduce the number of cherry-picked feature patches in our package.
Would you please recommend a stable commit I could use in lieu of a
4.2 release?

I am subscribed to the mailing list. Thanks!

Kind regards
Felix Lechner
