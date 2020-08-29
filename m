Return-Path: <SRS0=8aTj=CH=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0BC8C433E6
	for <linux-raid@archiver.kernel.org>; Sat, 29 Aug 2020 15:34:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7EE820791
	for <linux-raid@archiver.kernel.org>; Sat, 29 Aug 2020 15:34:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgH2Pe7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 29 Aug 2020 11:34:59 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:11923 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728196AbgH2Pe6 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 29 Aug 2020 11:34:58 -0400
Received: from host86-136-163-47.range86-136.btcentralplus.com ([86.136.163.47] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kC2sa-000B64-Ea; Sat, 29 Aug 2020 16:34:56 +0100
Subject: Re: Best way to add caching to a new raid setup.
To:     Ram Ramesh <rramesh2400@gmail.com>, Roman Mamedov <rm@romanrm.net>,
        "R. Ramesh" <rramesh@verizon.net>
Cc:     Linux Raid <linux-raid@vger.kernel.org>
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
 <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
 <20200828224616.58a1ad6c@natsu>
 <448afb39-d277-445f-cc42-2dfc5210da7b@gmail.com>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <6a9fc5ae-1cae-a3d6-6dc3-d1a93dc1e38e@youngman.org.uk>
Date:   Sat, 29 Aug 2020 16:34:56 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <448afb39-d277-445f-cc42-2dfc5210da7b@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 28/08/2020 21:39, Ram Ramesh wrote:
> One thing about LVM that I am not clear. Given the choice between 
> creating /mirror LV /on a VG over simple PVs and /simple LV/ over raid1 
> PVs, which is preferred method? Why?

Simplicity says have ONE raid, with ONE PV on top of it.

The other way round is you need TWO SEPARATE (at least) PV/VG/LVs, which 
you then stick a raid on top.

Basically, it's just KISS.

Cheers,
Wol
