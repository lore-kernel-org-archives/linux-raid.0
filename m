Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7868BC77B6E
	for <linux-raid@archiver.kernel.org>; Wed, 12 Apr 2023 12:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjDLMV1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 Apr 2023 08:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjDLMV0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 12 Apr 2023 08:21:26 -0400
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7732830F5
        for <linux-raid@vger.kernel.org>; Wed, 12 Apr 2023 05:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc
        :To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IS17R2yg70XPrr9Jk4kU/1cuN5inKEj2FWJEd/owxi8=; b=cxpckQApJ8c14NumoUsipfxbwu
        5WiQhgU1Vt/IoJvDkqHQrvTRJbUPI7i2aWSb0pbsu65oZJ00KWF+pdw8bQ1tbPYNU0C5IIs6ipMNe
        JKdo8A4yAzu8tCH1l+pA8eEgyUjD84b9ocjqGsVj7cgNxOSsEfNTVWeMP4N6Nq5aWVqkAIXIHK87N
        y5M1dXwvokXBDKvuM0C5T+xdxgMxLaLrqJVqPK0tmCl1+mLjCHtrhpl3y1c+O+cHKcMX33+Rgiq+j
        fc0qo/czkTTaDxsrg3SZfH1cexREPvXvp64+CZQcI3pLEl+dEtDBIJnH+IULaa7gysViHLTYtKQ1p
        AEOJQq/w==;
Received: from 108-70-166-50.lightspeed.tukrga.sbcglobal.net ([108.70.166.50] helo=[192.168.20.123])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1pmZTS-0002IB-Uu; Wed, 12 Apr 2023 12:21:18 +0000
Message-ID: <da9f8739-f923-de3f-2a4e-320c757f3139@turmel.org>
Date:   Wed, 12 Apr 2023 08:21:18 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: Recover data from accidentally created raid5 over raid1
To:     Reindl Harald <h.reindl@thelounge.net>,
        Wol <antlists@youngman.org.uk>, John Stoffel <john@stoffel.org>,
        Moritz Rosin <moritz.rosin@itrosinen.de>
Cc:     linux-raid@vger.kernel.org, NeilBrown <neilb@suse.com>
References: <c0a9e08b91e86c86038be889907f0796@itrosinen.de>
 <25653.47458.489415.933722@quad.stoffel.home>
 <21b0a1ef-6389-8851-f6f9-17f3ca6d96c0@youngman.org.uk>
 <14ccbf12-0254-b0b8-4c9a-8949c947a63c@thelounge.net>
Content-Language: en-US
From:   Phil Turmel <philip@turmel.org>
In-Reply-To: <14ccbf12-0254-b0b8-4c9a-8949c947a63c@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Reindl,

On 4/12/23 06:22, Reindl Harald wrote:
> 
> 
> Am 12.04.23 um 02:18 schrieb Wol:
>> A two-disk raid-5 is the same as a 2-disk mirror
> 
> this is completly nonsense like it was nonsense that a RAID10 of 4 
> drives after remove two drives is the same as a RAID1 and just a 
> metadata update should be enough
> 
> why are you doing that always?
> 
> the problem is there are people out there which believe what you are 
> pretending here and spread that nonsense over the web as there isn't 
> enough wrong information already out there
> 

What is nonsense?  A two-disk raid5 does have exactly the same content 
on both disks, just like a mirror.  The parity for any given single byte 
is that same byte.

Please, just once, limit yourself to *positive* contributions.

Phil
