Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A670EC7618A
	for <linux-raid@archiver.kernel.org>; Mon, 20 Mar 2023 08:35:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjCTIfI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Mar 2023 04:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjCTIfG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Mar 2023 04:35:06 -0400
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219051B329
        for <linux-raid@vger.kernel.org>; Mon, 20 Mar 2023 01:35:03 -0700 (PDT)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4Pg7Mn3cgdzXLN;
        Mon, 20 Mar 2023 09:35:01 +0100 (CET)
Message-ID: <86bd2ef7-64f8-70c9-96a2-47bd3915bea6@thelounge.net>
Date:   Mon, 20 Mar 2023 09:35:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: Renaming md raid and moving md raid to a different machine.
Content-Language: en-US
To:     Ram Ramesh <rramesh2400@gmail.com>, Wol <antlists@youngman.org.uk>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <f237651e-536a-e305-8c1c-475e4c14d906@gmail.com>
 <97945e22-f0d4-96d7-ef66-284ae6f8b016@gmail.com>
 <7037738d-05e3-b277-61ed-37f66cfdef7e@youngman.org.uk>
 <671da160-d5b3-8ed1-f7c1-672fa587ecad@gmail.com>
 <029ada0e-2b85-8999-007b-65f3bfdbc034@youngman.org.uk>
 <c4f58d3f-57a8-81ce-5a04-47744504a648@gmail.com>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <c4f58d3f-57a8-81ce-5a04-47744504a648@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 20.03.23 um 01:34 schrieb Ram Ramesh:
> Yes the names must be in the metadata of the md because I populate 
> mdadm.conf after every change by actually using the output from mdadm 
> --detail -scan. Since that comes up with md0/md1/md2, I assume somehow 
> mdadm simply finds them again and again with exact same name.
> 
> I do not ever get md127

no - your mdadm.conf is in the initrd because how else should the rootfs 
could live on the array containing mdadm.conf
