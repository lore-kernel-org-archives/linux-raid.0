Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F03C1C433FE
	for <linux-raid@archiver.kernel.org>; Mon, 15 Nov 2021 21:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D734B61ABA
	for <linux-raid@archiver.kernel.org>; Mon, 15 Nov 2021 21:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239195AbhKOVFq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 15 Nov 2021 16:05:46 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:51732 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345354AbhKOUKi (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 15 Nov 2021 15:10:38 -0500
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1mmiGS-0009Z9-7z; Mon, 15 Nov 2021 20:07:40 +0000
Message-ID: <afc770b3-3ded-5ff3-6794-263165fe8343@youngman.org.uk>
Date:   Mon, 15 Nov 2021 20:07:40 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] md: fix update super 1.0 on rdev size change
Content-Language: en-GB
To:     Markus Hochholdinger <Markus@hochholdinger.net>,
        Xiao Ni <xni@redhat.com>
Cc:     Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
References: <20211112142822.813606-1-markus@hochholdinger.net>
 <CALTww28689G2xbZ9sWFpviXLwB1WKPfQL6Y1girjiBMEvWcQRw@mail.gmail.com>
 <181899007.qP1mJhO4kW@enterprise>
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <181899007.qP1mJhO4kW@enterprise>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 15/11/2021 18:39, Markus Hochholdinger wrote:
> (Because of other reasons, we have intentionally choosen the superblock at the
> end of the device.)
> 
> We change the device size of raid1 arrays, which are inside a VM, on a regular
> basis. And afterwards we grow the raid1 while the raid1 is online. Therefore,
> the superblock has to be moved.

A perfect example of this (although I can't see myself growing the 
partitions in this case) is a mirrored /boot.

Superblock 1.0 means that anything can read the partition without 
needing to know about raid. One less thing to go wrong. And I can raid-1 
an EFI partition - I just need to make sure I only modify it from within 
linux so it gets mirrored across both drives. I would want that as 
protection against my primary drive failing - then my EFI partition is 
mirrored letting me boot from the secondary.

Cheers,
Wol
