Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4DCBC77B60
	for <linux-raid@archiver.kernel.org>; Sun, 23 Apr 2023 19:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjDWTTv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 23 Apr 2023 15:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjDWTTr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 23 Apr 2023 15:19:47 -0400
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE1D10E3
        for <linux-raid@vger.kernel.org>; Sun, 23 Apr 2023 12:19:46 -0700 (PDT)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4Q4J3v5PBbzXKx;
        Sun, 23 Apr 2023 21:19:34 +0200 (CEST)
Message-ID: <81f8ff93-28be-c520-f497-aeefa5a6f879@thelounge.net>
Date:   Sun, 23 Apr 2023 21:19:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Raid5 to raid6 grow interrupted, mdadm hangs on assemble command
Content-Language: en-US
To:     Jove <jovetoo@gmail.com>, linux-raid@vger.kernel.org
References: <CAFig2csUV2QiomUhj_t3dPOgV300dbQ6XtM9ygKPdXJFSH__Nw@mail.gmail.com>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <CAFig2csUV2QiomUhj_t3dPOgV300dbQ6XtM9ygKPdXJFSH__Nw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 23.04.23 um 21:09 schrieb Jove:
> I've added two drives to my raid5 array and tried to migrate
> it to raid6 with the following command:
> 
> mdadm --grow /dev/md0 --raid-devices 4 --level 6
> --backup-file=/root/mdadm_raid6_backup.md
> 
> This may have been my first mistake, as there are only 5
> drives. it should have been --raid-devices 3, I think.

how do you come to the conclusion 3 when there are 5 drives? you tell it 
how much drives there are and pretty sure after "mdadm --add" you can 
skip "--raid-devices" entirely because it knows how many drives there are

https://raid.wiki.kernel.org/index.php/Growing
