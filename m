Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16613C4321E
	for <linux-raid@archiver.kernel.org>; Sun, 27 Nov 2022 12:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiK0MGa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 27 Nov 2022 07:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiK0MG3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 27 Nov 2022 07:06:29 -0500
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DE2F017
        for <linux-raid@vger.kernel.org>; Sun, 27 Nov 2022 04:06:27 -0800 (PST)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4NKnPr6d7rzXLK;
        Sun, 27 Nov 2022 13:06:24 +0100 (CET)
Message-ID: <7316d29a-bab6-b8a2-5c77-803af8de378b@thelounge.net>
Date:   Sun, 27 Nov 2022 13:06:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: how do i fix these RAID5 arrays?
Content-Language: en-US
To:     Wols Lists <antlists@youngman.org.uk>,
        John Stoffel <john@stoffel.org>
Cc:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
References: <20221123220736.GD19721@jpo> <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <f58964da-4ded-61a8-bd6a-e2391557b38a@youngman.org.uk>
 <25474.28874.952381.412636@quad.stoffel.home>
 <fd543697-14a6-0868-82a1-be61790e07f3@thelounge.net>
 <62b72b4e-8461-e616-1227-4dcef8853143@youngman.org.uk>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <62b72b4e-8461-e616-1227-4dcef8853143@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 27.11.22 um 12:52 schrieb Wols Lists:
> On 27/11/2022 11:46, Reindl Harald wrote:
>>
>>
>> Am 26.11.22 um 21:02 schrieb John Stoffel:
>>> I call it a failure of the layering model.  If you want RAID, use MD.
>>> If you want logical volumes, then put LVM on top.  Then put
>>> filesystems into logical volumes.
>>>
>>> So much simpler...
>>
>> have you ever replaced a 6 TB drive and waited for the resync of mdadm 
>> in the hope in all that hours no other drive goes down?
>>
>> when your array is 10% used it's braindead
>> when your array is new and empty it's braindead
>>
>> ZFS/BTRFS don't neeed to mirror/restore 90% nulls
> 
> This is why you have trim. 

besides that such large disks are typically HDD trim has nothing to do 
with the fact that after a drive replacement linux raid knows *nothing* 
about trim and does a full resync

you are long enough on this list that you should know that

> Although I don't know if raid supports that 

surely - but you miss the topic

