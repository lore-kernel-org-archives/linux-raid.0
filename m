Return-Path: <SRS0=PPQD=CX=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5576DC433E2
	for <linux-raid@archiver.kernel.org>; Mon, 14 Sep 2020 15:08:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C00420829
	for <linux-raid@archiver.kernel.org>; Mon, 14 Sep 2020 15:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgINPIx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Sep 2020 11:08:53 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:30672 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbgINPIh (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 14 Sep 2020 11:08:37 -0400
Received: from host86-136-163-47.range86-136.btcentralplus.com ([86.136.163.47] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kHq5o-0002WV-AV; Mon, 14 Sep 2020 16:08:32 +0100
Subject: Re: Best way to add caching to a new raid setup.
To:     Roger Heflin <rogerheflin@gmail.com>,
        Ram Ramesh <rramesh2400@gmail.com>
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
 <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
 <dc91cc7d-02c4-66ee-21b4-bda69be3bbd9@youngman.org.uk>
 <1310d10c-1b83-7031-58e3-0f767b1df71b@gmail.com>
 <101d4a60-916c-fe30-ae7c-994098fe2ebe@youngman.org.uk>
 <694be035-4317-26fd-5eaf-8fdc20019d9b@gmail.com>
 <CAAMCDecWsihd4oy1ZAvcVb4aPnntrit2PXx-Zn2uM5rQoKPU=g@mail.gmail.com>
 <d4d38059-eaaa-a577-963a-c348434c260e@verizon.net>
 <CACJz6QvRqq+WLmbOYR=YECNwHzpedUjJEAcoaHseEzEd2Bq8nQ@mail.gmail.com>
 <79c15e0e-5f34-2b1a-282c-8bb36f2e3e81@gmail.com>
 <87v9ggzivk.fsf@esperi.org.uk>
 <74d07a6c-799b-2ebb-cc7a-0d3ccd19150c@gmail.com>
 <CAAMCDecjgMvXPPwhWZKi5VmJEPeLzFkUuQ2M_EwxnDxd=ntSZA@mail.gmail.com>
Cc:     Nix <nix@esperi.org.uk>, Drew <drew.kay@gmail.com>,
        Linux Raid <linux-raid@vger.kernel.org>
From:   Wols Lists <antlists@youngman.org.uk>
Message-ID: <5F5F876F.8070306@youngman.org.uk>
Date:   Mon, 14 Sep 2020 16:08:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <CAAMCDecjgMvXPPwhWZKi5VmJEPeLzFkUuQ2M_EwxnDxd=ntSZA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 14/09/20 15:48, Roger Heflin wrote:
> It should be noted that mythtv is a badly behaved IO application, it
> does a lot of sync calls that effectively for the most part makes
> linux's write cache small.

Sounds like the devs need reminding of the early days of ext4. Iiuc, if
that ran on an early ext4 you wouldn't have got ANY successful
recordings AT ALL.

At an absolute minimum, that sort of behaviour needs to be configurable,
because if the user is running mythtv on anything other than a dedicated
machine then it's going to kill performance for anything else.

Cheers,
Wol
