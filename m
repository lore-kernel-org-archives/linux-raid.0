Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D40AC433F5
	for <linux-raid@archiver.kernel.org>; Wed, 17 Nov 2021 21:08:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 242556324B
	for <linux-raid@archiver.kernel.org>; Wed, 17 Nov 2021 21:08:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238069AbhKQVLX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 Nov 2021 16:11:23 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:17842 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240952AbhKQVJ7 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 17 Nov 2021 16:09:59 -0500
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1mnS8u-0009R1-AZ; Wed, 17 Nov 2021 21:06:56 +0000
Message-ID: <09043959-a649-05ba-0e92-b393f6f04420@youngman.org.uk>
Date:   Wed, 17 Nov 2021 21:06:56 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: Failed Raid 5 - one Disk possibly Out of date - 2nd disk damaged
Content-Language: en-GB
To:     Martin Thoma <thomamartin1985@googlemail.com>,
        Wols Lists <antlists@youngman.org.uk>
Cc:     linux-raid@vger.kernel.org
References: <CAFPgooeJrvrNQcOQXUD82oc52rgB3DvH=JFzDVDMnfc+gs7nDg@mail.gmail.com>
 <06b0f87c-2d06-3f94-f0b3-19d631968fa0@youngman.org.uk>
 <CAFPgoofZWN8d9O6LQ0LtKaOnU9yofvNAYO6AKxjrztqzod+doQ@mail.gmail.com>
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <CAFPgoofZWN8d9O6LQ0LtKaOnU9yofvNAYO6AKxjrztqzod+doQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 17/11/2021 18:10, Martin Thoma wrote:
> Thanks a lot.
> Will try to get some new drives and do a dd and then will try to
> assemble the Raid again.
> 
> The Drives are CMR Drives, a few Western Digital and Seagate drives.

Are they "raid friendly" though? What does "smartctl" tell you? Are the 
Seagates Barracudas (I hope not)?

Whether before or after the copy, I'd look at the smartctl for the dodgy 
drives - they may have just been addled by the power fail but will be 
fine for backups, or they may have been on the way out and the power 
fail tipped them over the edge.

Cheers,
Wol
