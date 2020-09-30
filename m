Return-Path: <SRS0=vpcD=DH=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E83E3C2D0A8
	for <linux-raid@archiver.kernel.org>; Wed, 30 Sep 2020 04:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F6E22087D
	for <linux-raid@archiver.kernel.org>; Wed, 30 Sep 2020 04:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgI3EDb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 30 Sep 2020 00:03:31 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:34238 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgI3EDb (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 30 Sep 2020 00:03:31 -0400
Received: from host86-157-96-171.range86-157.btcentralplus.com ([86.157.96.171] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kNTKz-00050j-5S; Wed, 30 Sep 2020 05:03:30 +0100
Subject: Re: RAID5->RAID6 reshape remains stuck at 0% (does nothing, not even
 start)
To:     David Madore <david+ml@madore.org>,
        Linux RAID mailing-list <linux-raid@vger.kernel.org>
References: <20200930014032.pd4csjwu3m7uihin@achernar.gro-tsen.net>
From:   Wols Lists <antlists@youngman.org.uk>
Message-ID: <5F740390.7050005@youngman.org.uk>
Date:   Wed, 30 Sep 2020 05:03:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <20200930014032.pd4csjwu3m7uihin@achernar.gro-tsen.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 30/09/20 02:40, David Madore wrote:
> I welcome any suggestions on how to investigate, work around, or fix
> this problem.

uname -a ???

mdadm --version ???

https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn

I'm guessing you're on an older version of Ubuntu / Debian ?

If I've guessed wrong (or even right :-) give us the requested info and
we can dig further.

Cheers,
Wol
