Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52530C47082
	for <linux-raid@archiver.kernel.org>; Sat,  5 Jun 2021 22:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2648C61241
	for <linux-raid@archiver.kernel.org>; Sat,  5 Jun 2021 22:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbhFEWkS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 5 Jun 2021 18:40:18 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:40687 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229998AbhFEWkS (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 5 Jun 2021 18:40:18 -0400
Received: from host86-157-72-169.range86-157.btcentralplus.com ([86.157.72.169] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1lpew0-000CKG-Ap; Sat, 05 Jun 2021 23:38:28 +0100
Subject: Re: [Bug Report] Discard bios cannot be correctly merged in blk-mq
To:     Wang Shanker <shankerwangmiao@gmail.com>,
        linux-block@vger.kernel.org
Cc:     linux-raid@vger.kernel.org
References: <85F98DA6-FB28-4C1F-A47D-C410A7C22A3D@gmail.com>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <6c407281-ee90-f577-d6db-d36211b1fdc0@youngman.org.uk>
Date:   Sat, 5 Jun 2021 23:38:28 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <85F98DA6-FB28-4C1F-A47D-C410A7C22A3D@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 05/06/2021 21:54, Wang Shanker wrote:
> You may wonder the importance of merging discard operations. In the
> implementation of RAID456, bios are committed in 4k trunks (they call
> them as stripes in the code and the size is determined by DEFAULT_STRIPE_SIZE).
> The proper merging of the bios is of vital importance for a reasonable
> operating performance of RAID456 devices.

Note that I have seen reports (I'm not sure where or how true they are), 
that even when requests are sent as 512k or whatever, certain upper 
layers break them into 4k's, presumably expecting lower layers to merge 
them again.

You might have better luck looking for and suppressing the breaking up 
of large chunks.

Cheers,
Wol
