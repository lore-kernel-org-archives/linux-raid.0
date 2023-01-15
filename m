Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E88C3DA78
	for <linux-raid@archiver.kernel.org>; Sun, 15 Jan 2023 13:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjAON6Y (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 15 Jan 2023 08:58:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjAON6W (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 15 Jan 2023 08:58:22 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852BD113C5
        for <linux-raid@vger.kernel.org>; Sun, 15 Jan 2023 05:58:20 -0800 (PST)
Received: from host86-138-24-20.range86-138.btcentralplus.com ([86.138.24.20] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1pH3Wc-0001vA-94;
        Sun, 15 Jan 2023 13:58:19 +0000
Message-ID: <e89b018d-e36f-2a62-0bff-4e1f62361283@youngman.org.uk>
Date:   Sun, 15 Jan 2023 13:58:17 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: What does TRIM/discard in RAID do ?
To:     Reindl Harald <h.reindl@thelounge.net>,
        Pascal Hambourg <pascal@plouf.fr.eu.org>,
        linux-raid <linux-raid@vger.kernel.org>
References: <f8531fc8-6928-5300-b43e-1cad0a4ab03b@plouf.fr.eu.org>
 <dbca2904-1200-a81f-cc6d-300e8def6a96@thelounge.net>
Content-Language: en-GB
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <dbca2904-1200-a81f-cc6d-300e8def6a96@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 15/01/2023 12:13, Reindl Harald wrote:
> Am 15.01.23 um 13:00 schrieb Pascal Hambourg:
>> Linux RAID supports TRIM/discard, but what does it do exactly ?
>> Does it only pass-through TRIM/discard information to the underlying 
>> devices or can it also store information about which blocks contain 
>> valid data in the superblock metadata?
> 
> pass-through TRIM/discard
> 
> it makes no sense to store that on the RAID layer - if someone is th 
> eposition to store the information to reduce the fstrim load after a 
> reboot it's the filesystem on-top

It makes EVERY sense to store it in the raid layer when you're doing a 
rebuild.

I would like to store it there for that exact reason - if you've lost a 
drive and are in a recovery situation, then you can ignore parts of the 
drive that don't contain filesystem data, because TRIM has told you they 
don't.

afaik, however, nobody has got round to coding that, because it's a lot 
of work and probably not financially worth doing. If someone wants to do 
it for the love of it, great!

Cheers,
Wol
