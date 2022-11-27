Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA676C4332F
	for <linux-raid@archiver.kernel.org>; Sun, 27 Nov 2022 23:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiK0Xkx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 27 Nov 2022 18:40:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiK0Xkw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 27 Nov 2022 18:40:52 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE585BCA4
        for <linux-raid@vger.kernel.org>; Sun, 27 Nov 2022 15:40:50 -0800 (PST)
Received: from host86-138-24-20.range86-138.btcentralplus.com ([86.138.24.20] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1ozNDZ-0007ZZ-DZ;
        Sun, 27 Nov 2022 19:21:33 +0000
Message-ID: <2c013c78-99ca-df05-117a-2f58b237b595@youngman.org.uk>
Date:   Sun, 27 Nov 2022 19:21:31 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: how do i fix these RAID5 arrays?
Content-Language: en-GB
To:     Roman Mamedov <rm@romanrm.net>
Cc:     John Stoffel <john@stoffel.org>,
        David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
References: <20221123220736.GD19721@jpo> <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <f58964da-4ded-61a8-bd6a-e2391557b38a@youngman.org.uk>
 <25474.28874.952381.412636@quad.stoffel.home>
 <fd543697-14a6-0868-82a1-be61790e07f3@thelounge.net>
 <62b72b4e-8461-e616-1227-4dcef8853143@youngman.org.uk>
 <7316d29a-bab6-b8a2-5c77-803af8de378b@thelounge.net>
 <fd6a2f41-405a-7ec7-e8f1-c970e32973c4@youngman.org.uk>
 <20221127230828.3cfe728b@nvm>
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <20221127230828.3cfe728b@nvm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 27/11/2022 18:08, Roman Mamedov wrote:
> On Sun, 27 Nov 2022 14:33:37 +0000
> Wol <antlists@youngman.org.uk> wrote:
> 
>> If raid supports trim, that means it intercepts the trim commands, and
>> uses it to keep track of what's being used by the layer above.
>>
>> In other words, if the filesystem is only using 10% of the disk,
>> supporting trim means that raid knows which 10% is being used and only
>> bothers syncing that!
> 
> Not sure which RAID system you are speaking of, but that's not presently
> implemented in mdadm RAID. It does not use TRIM of the array to keep track of
> unused areas on the underlying devices, to skip those during rebuilds. And I
> am unaware of any other RAID that does. Would be nice to have though.
> 
Yup that's what I was saying - it would very much be a "nice to have".

Cheers,
Wol
