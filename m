Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB55FC433DB
	for <linux-raid@archiver.kernel.org>; Wed, 30 Dec 2020 11:36:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86F2E21D94
	for <linux-raid@archiver.kernel.org>; Wed, 30 Dec 2020 11:36:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgL3Lg2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 30 Dec 2020 06:36:28 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:8692 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbgL3Lg2 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 30 Dec 2020 06:36:28 -0500
Received: from host86-158-105-41.range86-158.btcentralplus.com ([86.158.105.41] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kuZla-0001U5-DV; Wed, 30 Dec 2020 11:35:46 +0000
Subject: Re: [PATCH 1/4] block: introduce submit_bio_noacct_add_head
To:     John Stoffel <john@stoffel.org>, dannyshih <dannyshih@synology.com>
Cc:     axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com,
        dm-devel@redhat.com, song@kernel.org, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org
References: <1609233522-25837-1-git-send-email-dannyshih@synology.com>
 <1609233522-25837-2-git-send-email-dannyshih@synology.com>
 <24555.49943.411197.147225@quad.stoffel.home>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <d841085f-5fd7-bd5c-a40b-fbb953c80598@youngman.org.uk>
Date:   Wed, 30 Dec 2020 11:35:45 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <24555.49943.411197.147225@quad.stoffel.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 30/12/2020 00:00, John Stoffel wrote:
> dannyshih> From: Danny Shih<dannyshih@synology.com>
> dannyshih> Porvide a way for stacking block device to re-submit the bio
> dannyshih> which sholud be handled firstly.
> 
> You're spelling needs to be fixed in these messages.

   ^^^^^^

It is traditional, when correcting someone else's spelling, to make one 
of your own ... :-)

Sorry, but if we're being pedantic for furriners, it behoves us to be 
correct ourselves :-)

Cheers,
Wol
