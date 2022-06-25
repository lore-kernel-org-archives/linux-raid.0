Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9913FC43334
	for <linux-raid@archiver.kernel.org>; Sat, 25 Jun 2022 13:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbiFYN7D (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 25 Jun 2022 09:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbiFYN7C (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 25 Jun 2022 09:59:02 -0400
X-Greylist: delayed 1387 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 25 Jun 2022 06:59:01 PDT
Received: from pott.psjt.org (pott.psjt.org [46.38.234.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7FB1403D
        for <linux-raid@vger.kernel.org>; Sat, 25 Jun 2022 06:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=psjt.org;
        s=psjt01; h=Content-Type:MIME-Version:Message-ID:In-Reply-To:Date:References:
        Subject:To:From:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=R0jvq6OXnw4c5ETfg89+ECkWtGR09+Ibkr+mc+YUy+c=; b=41E0eH0vkJeDrYfv9XXAJrOeNq
        0Tn3ttedBVrBvSQE2NAKTyipS9BeWu4tLgnPIWVhb5jMqwgNS+7wOFgZ1BIxZtSa5D6ZuP76aM3SV
        qc2t0oP6xZQBU53IxSqvJgRn8sLhQrD4JukNJShsxII1DRyoQ/BzGHq6X1YRifBjOqdta2b+rp86j
        5v3tgTvCZj1asjfzrs0G+M3WmG3bRgeEvw4J4/HkO9SvGqWL/R29/RrDTC65SbZ8M/FGBQdefOT3i
        en88sEuIneHWQTcTHxHcsdffyxjBkvay2PvKZaUgA4NyZQsxnW3r1EJJ5JI5EB9sb0Jah3NJvLffJ
        Rk0+SQgQ==;
Received: from [10.1.1.3] (helo=malachite.psjt.org)
        by pott.psjt.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <stephan@psjt.org>)
        id 1o55x1-0008Jm-ME
        for linux-raid@vger.kernel.org; Sat, 25 Jun 2022 15:35:52 +0200
Received: from blaulicht.dmz.brux ([10.1.1.10])
        by malachite.psjt.org with esmtp (Exim 4.95)
        (envelope-from <stephan@psjt.org>)
        id 1o55x1-0005pS-V0;
        Sat, 25 Jun 2022 15:35:51 +0200
Received: from stephan by blaulicht.dmz.brux with local (Exim 4.95)
        (envelope-from <stephan@psjt.org>)
        id 1o55x1-0008NR-UF;
        Sat, 25 Jun 2022 15:35:51 +0200
From:   Stephan <linux@psjt.org>
To:     Linux-RAID <linux-raid@vger.kernel.org>
Subject: Re: Upgrading motherboard + CPU
References: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
        <81c50899-7edb-e629-3bbc-16cfa8f17e34@youngman.org.uk>
        <b777865e-b265-1e83-dae0-f89654e86332@plouf.fr.eu.org>
        <5cbd9dd1-73fc-ce11-4a9d-8752f7bea979@youngman.org.uk>
        <1de4bf1f-242b-7d02-23dc-a6d05893db81@plouf.fr.eu.org>
        <20220624232049.502a541e@nvm>
        <dab2fe0a-c49e-5da7-5df3-4d01c86a65a7@shenkin.org>
        <20220624234453.43cf4c74@nvm>
        <22102e4b-4738-672d-0d00-bbeccb54fe84@shenkin.org>
        <d85093a4-be3e-d4f2-eca0-e20882584bab@youngman.org.uk>
        <b664e4ce-6ebe-86c6-78d9-d5606c0f6555@shenkin.org>
        <5cb8d159-be2a-aa6c-888a-fcb9ed4555c1@youngman.org.uk>
        <20220625030833.3398d8a4@nvm>
        <ae2288f4-ad06-65af-d30c-4aef6d478f27@plouf.fr.eu.org>
Date:   Sat, 25 Jun 2022 15:35:51 +0200
In-Reply-To: <ae2288f4-ad06-65af-d30c-4aef6d478f27@plouf.fr.eu.org> (Pascal
        Hambourg's message of "Sat, 25 Jun 2022 09:54:08 +0200")
Message-ID: <s6nh748amrs.fsf@blaulicht.dmz.brux>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Pascal Hambourg <pascal@plouf.fr.eu.org> writes:

> Why 0.90 ? It is obsolete. If you need RAID metadata at the end of
> RAID members for whatever ugly reason, you can use metadata 1.0
> instead. 

Does mdraid with metadata 1 work on the root filesystem w/o initramfs?

-- 
Stephan
