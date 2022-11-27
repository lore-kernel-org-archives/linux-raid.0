Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1838C4321E
	for <linux-raid@archiver.kernel.org>; Sun, 27 Nov 2022 19:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiK0Tw7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 27 Nov 2022 14:52:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiK0Tw6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 27 Nov 2022 14:52:58 -0500
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8920DEE0
        for <linux-raid@vger.kernel.org>; Sun, 27 Nov 2022 11:52:57 -0800 (PST)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4NKzm46nXNzXLf;
        Sun, 27 Nov 2022 20:52:52 +0100 (CET)
Message-ID: <88f24778-4721-ffad-9143-3d6e69d2e0e3@thelounge.net>
Date:   Sun, 27 Nov 2022 20:52:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: how do i fix these RAID5 arrays?
Content-Language: en-US
To:     Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc:     John Stoffel <john@stoffel.org>,
        Wols Lists <antlists@youngman.org.uk>,
        David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
References: <fd543697-14a6-0868-82a1-be61790e07f3@thelounge.net>
 <20221123220736.GD19721@jpo> <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <f58964da-4ded-61a8-bd6a-e2391557b38a@youngman.org.uk>
 <25474.28874.952381.412636@quad.stoffel.home>
 <0c7ad6eff626c8440734909300ebc50d9b1bf615@nexgo.de>
 <4379b4f4-9e7f-a7dc-fc29-6c22b12bf3ea@thelounge.net>
 <Y4O8YimjIgXIaudh@lazy.lzy>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <Y4O8YimjIgXIaudh@lazy.lzy>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 27.11.22 um 20:37 schrieb Piergiorgio Sartor:
> On Sun, Nov 27, 2022 at 07:21:16PM +0100, Reindl Harald wrote:
>>> You cannot consider the amount of data in the
>>> array as parameter for reliability
>>>
>>> If the array is 99% full, MD or ZFS/BTRFS have
>>> same behaviour, in terms of reliability.
>>> If the array is 0% full, as well
>>
>> you completly miss the point!
>>
>> if your mdadm-array is built with 6 TB drivres wehn you replace a drive you
>> need to sync 6 TB no matter if 10 MB or 5 TB are actually used
> 
> I'm not missing the point, you're not
> understanding the consequences of
> your way of thinking.
> 
> If the ZFS/BTRFS is 99% full, how much
> time will it need to be synched?
> 
> The same (more or less) of MD

for the sake of god the point was that mdadm don't know aynthing about 
the filesystem because it's a "dumb" block layer

at the end of the days that means when a 6 TB drive fails the full 6 TB 
needs to be re-synced no matter how much space is used on the FS on top
