Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1661CC48BC2
	for <linux-raid@archiver.kernel.org>; Wed, 23 Jun 2021 20:14:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF45F608FE
	for <linux-raid@archiver.kernel.org>; Wed, 23 Jun 2021 20:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhFWURM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Jun 2021 16:17:12 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:53676 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230001AbhFWURM (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 23 Jun 2021 16:17:12 -0400
Received: from host86-157-72-169.range86-157.btcentralplus.com ([86.157.72.169] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1lw9Gu-0004rZ-Fg; Wed, 23 Jun 2021 21:14:53 +0100
Subject: Re: Question: RAID cabinet for home use
To:     John Stoffel <john@stoffel.org>,
        Bill Hudacek <bill.hudacek@gmail.com>
Cc:     mdraid <linux-raid@vger.kernel.org>
References: <03ca5974-60ed-d596-7eff-cac44f4a6d62@gmail.com>
 <24787.28117.662584.586506@quad.stoffel.home>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <1986d43d-11e9-fbf0-7812-0aafc6568855@youngman.org.uk>
Date:   Wed, 23 Jun 2021 21:14:54 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <24787.28117.662584.586506@quad.stoffel.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 23/06/2021 18:22, John Stoffel wrote:
> If you have space inside your main computer, then I would look into an
> LSI Logic MTP Fusion SATA/SAS controller with 8 ports.  Then you can
> use some of the "IcyDock" expansion bays inside which turns two or
> three 5.25" bays into 4-5 3.5" bays.

If that's the route you're looking at, I'm trying to source a Cooler 
Master N300 case, which takes EIGHT 3.5" drives. Most of them are 
internal so hotswap is out of the question, though.

Dunno what's happened with the cases - have they dropped the line? Or 
has CoVid just exhausted current supplies?

Cheers,
Wol
