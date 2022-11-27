Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F3C1C43217
	for <linux-raid@archiver.kernel.org>; Sun, 27 Nov 2022 18:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiK0SVW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 27 Nov 2022 13:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiK0SVU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 27 Nov 2022 13:21:20 -0500
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5D7BF4F
        for <linux-raid@vger.kernel.org>; Sun, 27 Nov 2022 10:21:19 -0800 (PST)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4NKxkN6kQ3zXLf;
        Sun, 27 Nov 2022 19:21:16 +0100 (CET)
Message-ID: <4379b4f4-9e7f-a7dc-fc29-6c22b12bf3ea@thelounge.net>
Date:   Sun, 27 Nov 2022 19:21:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: how do i fix these RAID5 arrays?
Content-Language: en-US
To:     piergiorgio.sartor@nexgo.de, John Stoffel <john@stoffel.org>,
        Wols Lists <antlists@youngman.org.uk>
Cc:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
References: <fd543697-14a6-0868-82a1-be61790e07f3@thelounge.net>
 <20221123220736.GD19721@jpo> <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <f58964da-4ded-61a8-bd6a-e2391557b38a@youngman.org.uk>
 <25474.28874.952381.412636@quad.stoffel.home>
 <0c7ad6eff626c8440734909300ebc50d9b1bf615@nexgo.de>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <0c7ad6eff626c8440734909300ebc50d9b1bf615@nexgo.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 27.11.22 um 15:10 schrieb piergiorgio.sartor@nexgo.de:
> November 27, 2022 at 12:46 PM, "Reindl Harald" <h.reindl@thelounge.net> wrote:
> 
>>
>> Am 26.11.22 um 21:02 schrieb John Stoffel:
>>
>>>
>>> I call it a failure of the layering model. If you want RAID, use MD.
>>>   If you want logical volumes, then put LVM on top. Then put
>>>   filesystems into logical volumes.
>>>   So much simpler...
>>>
>>
>> have you ever replaced a 6 TB drive and waited for the resync of mdadm in the hope in all that hours no other drive goes down?
>>
>> when your array is 10% used it's braindead
>> when your array is new and empty it's braindead
>>
>> ZFS/BTRFS don't neeed to mirror/restore 90% nulls
>>
> 
> You cannot consider the amount of data in the
> array as parameter for reliability
> 
> If the array is 99% full, MD or ZFS/BTRFS have
> same behaviour, in terms of reliability.
> If the array is 0% full, as well

you completly miss the point!

if your mdadm-array is built with 6 TB drivres wehn you replace a drive 
you need to sync 6 TB no matter if 10 MB or 5 TB are actually used
