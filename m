Return-Path: <SRS0=wQ6l=CG=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C3C2C433E6
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 03:05:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE26C20786
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 03:05:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=sabi.unospace.net header.i=@sabi.unospace.net header.b="uA+OefOA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgH1DFR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 27 Aug 2020 23:05:17 -0400
Received: from azure.uno.uk.net ([95.172.254.11]:40998 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726972AbgH1DFQ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 27 Aug 2020 23:05:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sabi.unospace.net; s=default; h=From:References:In-Reply-To:Subject:To:Date
        :Message-ID:Content-Transfer-Encoding:Content-Type:MIME-Version:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=L7ZbwlTr9Y25NTYWApgN+6UDjupaGsVUqBP5cdV0wIQ=; b=uA+OefOAX7CR53F28TThxul5rE
        T65RujJ48V3zWGU1Qi8IxJG6XzvoRbFlCJTAPCrOVKVgmUbLcpfssKRZOVmDin08Ybx/TJHcRe0Wm
        Ho6EoNsWUPbw7M9Uf/Oa8Ai51wwIgvtGSO7GIMmdzUtXkclm6VKVrRQfQVJGjQxTH6ryhMdXr11d1
        ufhF/vuQ2mXOoTwXM1tkrFsS+BlEZ0vqqvmQVEACAdkd9qxuHxF/gciLYuzZmP5aVTNRIBnnePije
        E7VVq3qnKhkGt572StyD02AJXd5E55riD+C/Cc6VszfchacmJtCO9D1djhemVQSxOSwiWdlQTzvqN
        BCBANDuQ==;
Received: from [95.172.224.50] (port=54258 helo=ty.sabi.co.UK)
        by azure.uno.uk.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1kBUhW-0002Y2-JA
        for linux-raid@vger.kernel.org; Fri, 28 Aug 2020 04:05:14 +0100
Received: from from [127.0.0.1] (helo=cyme.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)(Exim 4.93 5)
        id 1kBUhQ-00DVjZ-OZ
        for <linux-raid@vger.kernel.org>; Fri, 28 Aug 2020 04:05:08 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24392.29796.81915.842904@cyme.ty.sabi.co.uk>
Date:   Fri, 28 Aug 2020 04:05:08 +0100
To:     Linux Raid <linux-raid@vger.kernel.org>
Subject: Re: Best way to add caching to a new raid setup.
In-Reply-To: <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
        <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
X-Mailer: VM 8.2.0b under 26.3 (x86_64-pc-linux-gnu)
From:   pg@mdraid.list.sabi.co.UK (Peter Grandi)
X-Disclaimer: This message contains only personal opinions
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - azure.uno.uk.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - root.t00.sabi.co.uk
X-Get-Message-Sender-Via: azure.uno.uk.net: authenticated_id: sabity@sabi.unospace.net
X-Authenticated-Sender: azure.uno.uk.net: sabity@sabi.unospace.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> I have two raid6s running on mythbuntu 14.04. The are built on
> 6 enterprise drives. [...] want to build new raid using the
> 16/14tb drives. [...]

This may be the beginning of an exciting adventure into setting
up a RAID set with stunning rebuild times, minimizing IOPS-per-TB
and setting up filetrees that cannot be realistically 'fsck'ed.
Plenty of people seem to like that kind of exciting adventure :-).
