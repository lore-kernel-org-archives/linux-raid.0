Return-Path: <SRS0=wQ6l=CG=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CA74C433E6
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 16:05:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 021592075B
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 16:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgH1QFK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Aug 2020 12:05:10 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:38480 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgH1QFH (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 28 Aug 2020 12:05:07 -0400
Received: from host86-157-102-164.range86-157.btcentralplus.com ([86.157.102.164] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kBgGS-0005oK-Dl; Fri, 28 Aug 2020 16:26:07 +0100
Subject: Re: Best way to add caching to a new raid setup.
To:     "R. Ramesh" <rramesh@verizon.net>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
 <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <dc91cc7d-02c4-66ee-21b4-bda69be3bbd9@youngman.org.uk>
Date:   Fri, 28 Aug 2020 16:26:12 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 28/08/2020 03:31, R. Ramesh wrote:
> I want to build new raid using the 16/14tb drives. Since I am building 
> new raid, I thought I could explore caching options. I see a mention of 
> LVM cache and few other bcache/xyzcache etc.
> 
> Is anyone of them better than other or no cache is safer. Since I 
> switched over to NVME boot drives, I have quite a few SATA SSDs lying 
> around that I can put to good use, if I cache using them.

Sounds like a fun idea. Just make sure you're getting CMR not SMR 
drives, but I'm not aware of SMR that large ...

Hopefully I'm going to do some work on it soon, but look at dm-integrity 
to make sure you don't get a dodgy mirror. You can add dm-integrity 
retrospectively, so if you leave a bit of unused space on the drive, I 
think you can tell dm-integrity where to put its checksums.

Cheers,
Wol
