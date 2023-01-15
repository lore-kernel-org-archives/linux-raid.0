Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38129C3DA78
	for <linux-raid@archiver.kernel.org>; Sun, 15 Jan 2023 12:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbjAOMNp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 15 Jan 2023 07:13:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbjAOMNo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 15 Jan 2023 07:13:44 -0500
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE113EC68
        for <linux-raid@vger.kernel.org>; Sun, 15 Jan 2023 04:13:43 -0800 (PST)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4NvvFb01XwzXKm;
        Sun, 15 Jan 2023 13:13:38 +0100 (CET)
Message-ID: <dbca2904-1200-a81f-cc6d-300e8def6a96@thelounge.net>
Date:   Sun, 15 Jan 2023 13:13:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: What does TRIM/discard in RAID do ?
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>,
        linux-raid <linux-raid@vger.kernel.org>
References: <f8531fc8-6928-5300-b43e-1cad0a4ab03b@plouf.fr.eu.org>
Content-Language: en-US
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <f8531fc8-6928-5300-b43e-1cad0a4ab03b@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 15.01.23 um 13:00 schrieb Pascal Hambourg:
> Linux RAID supports TRIM/discard, but what does it do exactly ?
> Does it only pass-through TRIM/discard information to the underlying 
> devices or can it also store information about which blocks contain 
> valid data in the superblock metadata?

pass-through TRIM/discard

it makes no sense to store that on the RAID layer - if someone is th 
eposition to store the information to reduce the fstrim load after a 
reboot it's the filesystem on-top

"filesystem -> luks -> lvm -> mdadm -> device" is a possible discard 
chain so why should mdadm store that information

if the filesystem knows "i notified that the blocks for deleteded file X 
are no longer in use" it can store that somewhere and none of the other 
layers would need to know because there won't be any discard request in 
the future
