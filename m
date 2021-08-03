Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0576EC4338F
	for <linux-raid@archiver.kernel.org>; Tue,  3 Aug 2021 12:46:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D24EB60238
	for <linux-raid@archiver.kernel.org>; Tue,  3 Aug 2021 12:46:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236018AbhHCMqb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 3 Aug 2021 08:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235782AbhHCMqb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 3 Aug 2021 08:46:31 -0400
X-Greylist: delayed 2317 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 03 Aug 2021 05:46:20 PDT
Received: from letbox-vps.us-core.com (letbox-vps.us-core.com [IPv6:2a0b:ae40:2:4a0b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66ACDC061757
        for <linux-raid@vger.kernel.org>; Tue,  3 Aug 2021 05:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
        s=2017.lechner.user; h=Content-Type:Cc:To:Subject:Message-ID:Date:From:
        In-Reply-To:References:MIME-Version:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=n5KG2kBJjzme641aF1gYcJMoYxSsLFezndazXI0cdQY=; b=PmdWpyKmhl2XUeiNpopr5hzG4F
        zer0R7Mh1FHHmtlz9/iGhi3ld4YSGkj1fYDfPeKt4ItqOLpMAmNW37PDEnvMkkcFoz5tdZbZyPgt2
        GFP6oph4+TGYZAs1OQVLJKGSn6ILtBf705TKMRBVxaosohpniJwlREzMIF5KP6/R6D9Y=;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
        d=debian.org; s=2020.lechner.user; h=Content-Type:Cc:To:Subject:Message-ID:
        Date:From:In-Reply-To:References:MIME-Version:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=n5KG2kBJjzme641aF1gYcJMoYxSsLFezndazXI0cdQY=; b=PAh93/x35J899GcmRffeCTH/89
        Ivj40L98GE3YWZ9/lqYaVZQ79Siu61y1RaP3pbkCa2H412sexM/IXgykkOAQ==;
Received: from mail-oo1-f52.google.com ([209.85.161.52])
        by letbox-vps.us-core.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <lechner@debian.org>)
        id 1mAtCy-006uEf-1q
        for linux-raid@vger.kernel.org; Tue, 03 Aug 2021 05:07:42 -0700
Received: by mail-oo1-f52.google.com with SMTP id h7-20020a4ab4470000b0290263c143bcb2so5131777ooo.7
        for <linux-raid@vger.kernel.org>; Tue, 03 Aug 2021 05:07:42 -0700 (PDT)
X-Gm-Message-State: AOAM5326LLLZ1NTEItqErKwHFsoCUQknJ/nLKb0nltd8k9h4tOXxkwfR
        7eIhEc03KP1484FABxFkxaDfqzmdrlL3DDeWfxo=
X-Google-Smtp-Source: ABdhPJyxXwB6vOCewvz1yIQ0r69r5wdTAT5hfIVeUKgel/WhhM15/am3be1X6CDCUyxwQz5qz/KmDLMd1enLvvVlvoI=
X-Received: by 2002:a4a:e692:: with SMTP id u18mr744964oot.76.1627992461654;
 Tue, 03 Aug 2021 05:07:41 -0700 (PDT)
MIME-Version: 1.0
References: <23ff060b-0958-ffc5-7da6-64948ec3179c@trained-monkey.org>
In-Reply-To: <23ff060b-0958-ffc5-7da6-64948ec3179c@trained-monkey.org>
From:   Felix Lechner <lechner@debian.org>
Date:   Tue, 3 Aug 2021 05:07:05 -0700
X-Gmail-Original-Message-ID: <CAFHYt56dQ6NHL+q8vbFvF4+Dq0c7ui+p64fi0uUo=game-hRMw@mail.gmail.com>
Message-ID: <CAFHYt56dQ6NHL+q8vbFvF4+Dq0c7ui+p64fi0uUo=game-hRMw@mail.gmail.com>
Subject: Re: ANNOUNCE: mdadm 4.2-rc2 - A tool for managing md Soft RAID under Linux
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jes,

On Mon, Aug 2, 2021 at 10:14 AM Jes Sorensen <jes@trained-monkey.org> wrote:
>
> I am pleased to announce the availability of the second rc release of
> mdadm-4.2

Thanks for this! I package mdadm in Debian. Did you push your most
recent changes?

Could you furthermore tag the RC commits, please? For the previous
release candidate 4.2-rc1 I found commit c11b1c3c, but it was
untagged. In Debian, we replace the tilde with an underscore as
described here [1] to get around Git's tag name restrictions. It would
be great if you tag both commits in Git, please.

Finally, a question about procedure: Do you folks copy people
explicitly when replying even though they are on the list? Thank you
for all your hard work!

Kind regards
Felix Lechner

[1] https://dep-team.pages.debian.net/deps/dep14/
