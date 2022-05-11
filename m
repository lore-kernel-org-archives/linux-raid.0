Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 412E1C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 11 May 2022 12:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237031AbiEKMv7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 May 2022 08:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242826AbiEKMv4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 11 May 2022 08:51:56 -0400
X-Greylist: delayed 957 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 11 May 2022 05:51:49 PDT
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B54469CF5
        for <linux-raid@vger.kernel.org>; Wed, 11 May 2022 05:51:49 -0700 (PDT)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4KyvX53JTBzXMF;
        Wed, 11 May 2022 14:35:44 +0200 (CEST)
Message-ID: <4fc8c8b4-cfc2-81b2-40d6-13c9d8c940bb@thelounge.net>
Date:   Wed, 11 May 2022 14:35:44 +0200
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
 <019701d864f9$7c87ab90$759702b0$@wmawater.com.au>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <019701d864f9$7c87ab90$759702b0$@wmawater.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 11.05.22 um 07:39 schrieb Bob Brand:
> Do I understand that you would recommend upgrading our installation of Linux
> once the repair is complete or are advising downloading and compiling a new
> kernel as part of the repair?  Or are you suggesting that it was the fact
> that we’re on such an old version of CentOS that caused this mess?  I ask
> because once this is repaired (assuming it does complete successfully), I
> would like to extend the array to the full 45 drives of which this server is
> capable

you where adivised doing thatg with a live-iso of whatever distribution 
with a recent kernel and recent mdadm and leave your installed os alone
