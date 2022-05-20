Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3AFEC433F5
	for <linux-raid@archiver.kernel.org>; Fri, 20 May 2022 15:41:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235711AbiETPlV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 20 May 2022 11:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350991AbiETPlJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 20 May 2022 11:41:09 -0400
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16EDB4D9C9
        for <linux-raid@vger.kernel.org>; Fri, 20 May 2022 08:41:06 -0700 (PDT)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4L4WCf089rzXvQ;
        Fri, 20 May 2022 17:41:02 +0200 (CEST)
Message-ID: <06995c9b-2dc5-3c0b-9ba1-59be171a7de8@thelounge.net>
Date:   Fri, 20 May 2022 17:41:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: Failed adadm RAID array after aborted Grown operation
Content-Language: en-US
To:     Bob Brand <brand@wmawater.com.au>,
        Roger Heflin <rogerheflin@gmail.com>,
        Wols Lists <antlists@youngman.org.uk>
Cc:     Linux RAID <linux-raid@vger.kernel.org>,
        Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>
References: <00ae01d862de$1d336980$579a3c80$@wmawater.com.au>
 <f4e9c9f8-590d-49a4-39da-e31d81258ff3@youngman.org.uk>
 <00cf01d86327$9c5dd8a0$d51989e0$@wmawater.com.au>
 <3f84648b-29db-0819-e3ba-af52435a2aab@youngman.org.uk>
 <00d101d86329$a2a57130$e7f05390$@wmawater.com.au>
 <00d601d8632f$ac1f1300$045d3900$@wmawater.com.au>
 <00e401d86333$e75d8f60$b618ae20$@wmawater.com.au>
 <00eb01d86339$18cc0860$4a641920$@wmawater.com.au>
 <5931f716-008d-399b-2ea8-acbbc9c8d239@youngman.org.uk>
 <CAAMCDecTb69YY+jGzq9HVqx4xZmdVGiRa54BD55Amcz5yaZo1Q@mail.gmail.com>
 <04ed01d86c5c$2f632f50$8e298df0$@wmawater.com.au>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <04ed01d86c5c$2f632f50$8e298df0$@wmawater.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 20.05.22 um 17:13 schrieb Bob Brand:
> UPDATE:
> 
> The array finally finished the reshape process (after almost two weeks!) and
> I now have an array that's showing as clean with the original 30 disks.
> However, when I try to mount it, I get the message "mount: /dev/md125: can't
> read superblock".
> 
> Any suggestions as to what my next step should be? Note: it's still running
> from the rescue disk

restore from a backup - the array is one thing, the filesystem is a 
different layer and it seems to be heavily damag after all the things 
which happened
