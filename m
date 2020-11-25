Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6855C5519F
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 11:58:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52649206E0
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 11:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbgKYL6W convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 25 Nov 2020 06:58:22 -0500
Received: from relay0.allsecuredomains.com ([51.68.204.196]:45753 "EHLO
        relay0.allsecuredomains.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729141AbgKYL6W (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 25 Nov 2020 06:58:22 -0500
X-Greylist: delayed 1121 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Nov 2020 06:58:21 EST
Received: from [81.174.144.187] (helo=zebedee.buttersideup.com)
        by relay0.allsecuredomains.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <tim@buttersideup.com>)
        id 1kht97-00067W-Od; Wed, 25 Nov 2020 11:39:37 +0000
Received: from [IPv6:2001:470:1b4a::d98] (custard.lan [IPv6:2001:470:1b4a::d98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by zebedee.buttersideup.com (Postfix) with ESMTPSA id CA641A0C93;
        Wed, 25 Nov 2020 11:39:36 +0000 (UTC)
To:     Alex <mysqlstudent@gmail.com>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <CAB1R3sgQm2_-Bhbzned4y056XP5hM9oz1OnTZSfHH9+L5sdpFQ@mail.gmail.com>
From:   Tim Small <tim@buttersideup.com>
Subject: Re: Considering new SATA PCIe card
Message-ID: <c0b683d2-92a0-2fa5-a35a-0c0cf52a9d9b@buttersideup.com>
Date:   Wed, 25 Nov 2020 11:39:36 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CAB1R3sgQm2_-Bhbzned4y056XP5hM9oz1OnTZSfHH9+L5sdpFQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-GB
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 25/11/2020 02:20, Alex wrote:
>  I was just wondering if I
> could keep it running for a few more years with a faster SATA
> controller.


You don't say what the onboard controllers are, but in general, I
wouldn't expect any significant difference in throughput when using a
PCIe SATA add-in card vs. the onboard AHCI controller(s), except perhaps
when changing go a solution which uses battery-backed write cache
(depending on the workload).

If you need more I/O throughput from hard disk drives, then you might
want to look at something like bcache (especially if the alternative is
relying on the correct behaviour from proprietary raid implementations).

HTH,

Tim.


