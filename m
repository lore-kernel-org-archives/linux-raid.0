Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2663EC433F5
	for <linux-raid@archiver.kernel.org>; Fri, 21 Jan 2022 19:37:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiAUThX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 Jan 2022 14:37:23 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:30112 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231739AbiAUThJ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 21 Jan 2022 14:37:09 -0500
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1nAzib-0003rh-FP;
        Fri, 21 Jan 2022 19:37:06 +0000
Message-ID: <7257db8b-080c-b49b-5013-29df65b946d5@youngman.org.uk>
Date:   Fri, 21 Jan 2022 19:37:04 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: PANIC OVER! Re: The mysterious case of the disappearing
 superblock ...
Content-Language: en-GB
To:     Nix <nix@esperi.org.uk>
Cc:     NeilBrown <neilb@suse.de>, anthony <antmbox@youngman.org.uk>,
        Linux RAID <linux-raid@vger.kernel.org>,
        Phil Turmel <philip@turmel.org>
References: <2fa7a4a8-b6c2-ac2f-725b-31620984efce@youngman.org.uk>
 <164254680952.24166.7553126422166310408@noble.neil.brown.name>
 <cfea15f4-228e-4a38-5567-9b710b6dc5c2@youngman.org.uk>
 <87o84428j2.fsf@esperi.org.uk>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <87o84428j2.fsf@esperi.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 21/01/2022 19:28, Nix wrote:
> rsync works by rename-then-rewrite on a whole-file basis (it doesn't
> just modify changed bits of files), so I'm afraid it's going to be
> terribly inefficient for large slightly-changed files, with many
> unchanging blocks CoWed nonetheless.

You're almost certainly right as the default.

I need to investigate, but I'm sure I've been told it does have an 
option to only update-in-place stuff that's been changed. Specifically 
for updates like I want to do :-)

Cheers,
Wol
