Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C9C1C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 16 Nov 2021 16:41:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 589F1617E4
	for <linux-raid@archiver.kernel.org>; Tue, 16 Nov 2021 16:41:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235674AbhKPQoJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 16 Nov 2021 11:44:09 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:38905 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233238AbhKPQoJ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 16 Nov 2021 11:44:09 -0500
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1mn1WB-0007CH-3U; Tue, 16 Nov 2021 16:41:11 +0000
Subject: Re: [PATCH] md: fix update super 1.0 on rdev size change
To:     Markus Hochholdinger <Markus@hochholdinger.net>,
        Xiao Ni <xni@redhat.com>
Cc:     Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
References: <20211112142822.813606-1-markus@hochholdinger.net>
 <181899007.qP1mJhO4kW@enterprise>
 <CALTww2-wLq1wvTABUft0hBg1gC2Qx+a_fUX2TZMJg0vve2uLBw@mail.gmail.com>
 <3122218.nCYcmegLye@enterprise>
From:   Wols Lists <antlists@youngman.org.uk>
Message-ID: <79efe789-e018-686c-e6ac-554ad99c4866@youngman.org.uk>
Date:   Tue, 16 Nov 2021 16:41:10 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <3122218.nCYcmegLye@enterprise>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 16/11/2021 09:28, Markus Hochholdinger wrote:
> By using metadata 1.0, the super block is at the end on the logical volumes
> and you can easily do a snpashot of the logical volumes and mount the snapshot
> for backups without calculating or guessing an offset.

Dunno whether now is the time, but if you're moving superblocks, can we 
think about (a) moving superblocks to convert between 1.0, 1.1 and 1.2, 
and (b) possibly leaving backup copies lying around.

As I say, now might not to be the time to do it, but if you're thinking 
about it, an easy way to do it might just hit you in the face, and you 
won't leave any landmines if someone comes along later to do it.

(As maintainer of the raid wiki, backup superblocks assisting raid 
recovery might be a VERY useful tool !!!)

Cheers,
Wol
