Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E67D3C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 23 Sep 2021 21:35:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD2C961090
	for <linux-raid@archiver.kernel.org>; Thu, 23 Sep 2021 21:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243322AbhIWVhB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Sep 2021 17:37:01 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:22293 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243303AbhIWVhA (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 23 Sep 2021 17:37:00 -0400
Received: from host86-157-192-80.range86-157.btcentralplus.com ([86.157.192.80] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antmbox@youngman.org.uk>)
        id 1mTWNK-0006Re-68; Thu, 23 Sep 2021 22:35:27 +0100
Subject: Re: Question for a kernel developer "in the know" - RE: [Non-DoD
 Source] Re: Can't get RAID5/RAID6 NVMe randomread IOPS - AMD ROME what am I
 missing?????
To:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>,
        "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
References: <5EAED86C53DED2479E3E145969315A23858782D6@UMECHPA7B.easf.csd.disa.mil>
From:   anthony <antmbox@youngman.org.uk>
Message-ID: <6104f4f5-d5aa-9785-7a3e-af4ba00d8cbf@youngman.org.uk>
Date:   Thu, 23 Sep 2021 22:35:24 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <5EAED86C53DED2479E3E145969315A23858782D6@UMECHPA7B.easf.csd.disa.mil>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 23/09/2021 22:05, Finlayson, James M CIV (USA) wrote:
> All,
> I have a question and this is silly but I have to share.   I'm well beyond the age to now dive into kernel code to diff it, but I have a question for those "in the know".
> 
> We switched from the 5.14rc4 kernel and rc6 (I believe) to the stock 5.14.0 kernel and my >84GB/s sustained bandwidth is now hovering at 100GB/s with no changes whatsoever by me in any tuning of the mdraid or the SSDs.   My question revolves around when there are "rc" kernels, is their extra debugging tracing or any other built in "inefficiencies" in release candidates that get configured out of the released kernels?
> 
> I'm puzzled by the performance gain of > 20% when I did nothing that I can take credit for.

Bear in mind the whole point of rc is to shake out minor glitches. Linus 
takes a whole bunch of "improvements" into rc1, and they get shaken down 
over the following rcs. So I guess someone put in a load of improvements 
that got selected for rc1.

They may not initially have worked as well as planned, and other people 
would have spotted problems. I get the impression there's a lot of room 
for improvement, and I think Christoph Hellwig has been working hard on 
this. So there's a good chance some of his stuff got into rc1, and he's 
kept tweaking it through the next rcs. And you've benefited!

Cheers,
Wol
