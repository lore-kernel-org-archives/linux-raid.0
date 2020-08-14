Return-Path: <SRS0=QefQ=BY=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B05EC433DF
	for <linux-raid@archiver.kernel.org>; Fri, 14 Aug 2020 12:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF5292087D
	for <linux-raid@archiver.kernel.org>; Fri, 14 Aug 2020 12:46:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=sabi.unospace.net header.i=@sabi.unospace.net header.b="vpFrg1n9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgHNMqu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 14 Aug 2020 08:46:50 -0400
Received: from azure.uno.uk.net ([95.172.254.11]:39920 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbgHNMqu (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 14 Aug 2020 08:46:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sabi.unospace.net; s=default; h=From:References:In-Reply-To:Subject:To:Date
        :Message-ID:Content-Transfer-Encoding:Content-Type:MIME-Version:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=bfZgibklnAcMKf7c5AHMtW/5FCcTJkShUCLuBKPBe9I=; b=vpFrg1n9gxdBY2XF7jFYSw8EzY
        9UJe09wu+CzpIizULP1YAYM6Yp2gzFKeqGkB29YpKSo6U/iPKsHD0mIbePXHyrBpZS//DjPOTNr1F
        mUv5vqsM6HpiehOm0QgfzmhVe87W6aWDNNtG/KuiIp5N5FkgSFn8qrlzh8fqGlvLoHN0z4agUTly9
        fmIgyxAA1o5DXvhgEl6H/nrttHtXKRm5ie65nsYiitn2J4AV8wQnTR3jCJcMzizpSdJHkAJ/wWhWE
        XKijrTJmKeIAKvmXVY8Hwbr0cKvTKnvb9bw43cH/2dL9WPT4i/i29T4xDEsmHAsqsKBTvYLK4DFI6
        lOYDD/EQ==;
Received: from [95.172.224.50] (port=33602 helo=ty.sabi.co.UK)
        by azure.uno.uk.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1k6Z6d-0003Wc-Kw
        for linux-raid@vger.kernel.org; Fri, 14 Aug 2020 13:46:47 +0100
Received: from from [127.0.0.1] (helo=cyme.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)(Exim 4.93 5)
        id 1k6Z28-00AXst-0D
        for <linux-raid@vger.kernel.org>; Fri, 14 Aug 2020 13:42:08 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24374.34461.701046.450149@cyme.ty.sabi.co.uk>
Date:   Fri, 14 Aug 2020 13:42:05 +0100
To:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
Subject: Re: mdadm development?
In-Reply-To: <1637821313.22423838.1597320925127.JavaMail.zimbra@karlsbakk.net>
References: <1637821313.22423838.1597320925127.JavaMail.zimbra@karlsbakk.net>
X-Mailer: VM 8.2.0b under 26.3 (x86_64-pc-linux-gnu)
From:   pg@mdadm.list.sabi.co.UK (Peter Grandi)
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

> [...] the latest version of mdadm. It seems it's 4.1 from
> october 2018. I can't find anything newer. Has development of
> mdadm halted or is it declared "perfect" or something?

On a general note I think that "stability" when it comes to
widely used critical bits of sw is a good idea.

For example the JFS has got very few updates over the past (in
part because IBM stopped sponsoring its development many years
ago) and it is still very reliable and well behaved.

In some other projects instead there are many updates that may
not always be necessary, perhaps because if someone's job title
is "maintainer of X" it is difficult to hold back from doing
updates.
