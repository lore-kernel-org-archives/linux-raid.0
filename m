Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16BD2C433DB
	for <linux-raid@archiver.kernel.org>; Wed, 17 Feb 2021 10:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9FB264DA8
	for <linux-raid@archiver.kernel.org>; Wed, 17 Feb 2021 10:06:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbhBQKGI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 Feb 2021 05:06:08 -0500
Received: from SMTP.sabi.co.UK ([72.249.182.114]:40162 "EHLO sabi.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230045AbhBQKGF (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 17 Feb 2021 05:06:05 -0500
X-Greylist: delayed 337 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Feb 2021 05:05:46 EST
Received: from b2b-5-147-245-68.unitymedia.biz ([5.147.245.68] helo=sabi.co.uk)
        by sabi.co.uk with esmtpsa(Cipher TLS1.2:RSA_AES_256_CBC_SHA1:256)(Exim 4.82 id 1lCIsv-0006Di-L3        id 1lCIsv-0006Di-L3by authid <sabity>with cram
        for <linux-raid@vger.kernel.org>; Wed, 17 Feb 2021 09:12:37 +0000
Received: from [127.0.0.1] (helo=cyme.ty.sabi.co.uk)
        by sabi.co.uk with esmtps(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)(Exim 4.93 5)
        id 1lCISP-006d7O-Ao
        for <linux-raid@vger.kernel.org>; Wed, 17 Feb 2021 09:45:13 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24620.55192.588729.189939@cyme.ty.sabi.co.uk>
Date:   Wed, 17 Feb 2021 09:45:12 +0100
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: use ssd as write-journal or lvm-cache?
In-Reply-To: <20210217110923.62fd685f@natsu>
References: <CAC6SzHLHq9yX+dtcYwYyhfoTufFYohg_ZMmaSv6-HVt4e-m-hA@mail.gmail.com>
        <20210217110923.62fd685f@natsu>
X-Mailer: VM 8.2.0b under 26.3 (x86_64-pc-linux-gnu)
From:   pg@mdraid.list.sabi.co.UK (Peter Grandi)
X-Disclaimer: This message contains only personal opinions
X-Blacklisted-At: 
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>> [...] ps: my ssd is intel dc grade, so I think enable
>> write-back mode of cache is not problem. [...]

Not all "enterprise" grade flash SSD models have persistent
buffers though, so better check.

> In any case, in order to not add a single point of failure to
> the array, better rely not on SSD being a "datacenter" one
> (anything can fail), but use a RAID1 of two SSDs.

The main point of "enterprise" flash SSD models is (as the
original poster wrote) the ability to enable write-back (thus
much, much higher committed write rates), if they have
persistent buffering. Higher "endurance" and reliability are
secondary points. With redundant units having models with
persistent buffering is even more important too.
