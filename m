Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A563C77B6E
	for <linux-raid@archiver.kernel.org>; Wed, 12 Apr 2023 10:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbjDLKXH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 Apr 2023 06:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbjDLKWz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 12 Apr 2023 06:22:55 -0400
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E197ABD
        for <linux-raid@vger.kernel.org>; Wed, 12 Apr 2023 03:22:52 -0700 (PDT)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4PxJgW6VbfzXKx;
        Wed, 12 Apr 2023 12:22:47 +0200 (CEST)
Message-ID: <14ccbf12-0254-b0b8-4c9a-8949c947a63c@thelounge.net>
Date:   Wed, 12 Apr 2023 12:22:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: Recover data from accidentally created raid5 over raid1
Content-Language: en-US
To:     Wol <antlists@youngman.org.uk>, John Stoffel <john@stoffel.org>,
        Moritz Rosin <moritz.rosin@itrosinen.de>
Cc:     linux-raid@vger.kernel.org, Phil Turmel <philip@turmel.org>,
        NeilBrown <neilb@suse.com>
References: <c0a9e08b91e86c86038be889907f0796@itrosinen.de>
 <25653.47458.489415.933722@quad.stoffel.home>
 <21b0a1ef-6389-8851-f6f9-17f3ca6d96c0@youngman.org.uk>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <21b0a1ef-6389-8851-f6f9-17f3ca6d96c0@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 12.04.23 um 02:18 schrieb Wol:
> A two-disk raid-5 is the same as a 2-disk mirror

this is completly nonsense like it was nonsense that a RAID10 of 4 
drives after remove two drives is the same as a RAID1 and just a 
metadata update should be enough

why are you doing that always?

the problem is there are people out there which believe what you are 
pretending here and spread that nonsense over the web as there isn't 
enough wrong information already out there

