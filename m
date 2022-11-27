Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23BDAC4321E
	for <linux-raid@archiver.kernel.org>; Sun, 27 Nov 2022 19:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiK0TaR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 27 Nov 2022 14:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiK0TaQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 27 Nov 2022 14:30:16 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B22A65C6
        for <linux-raid@vger.kernel.org>; Sun, 27 Nov 2022 11:30:14 -0800 (PST)
Received: from host86-138-24-20.range86-138.btcentralplus.com ([86.138.24.20] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1ozNLw-0004d9-Bi;
        Sun, 27 Nov 2022 19:30:12 +0000
Message-ID: <93df4fec-8057-c49e-f96e-d857542896fa@youngman.org.uk>
Date:   Sun, 27 Nov 2022 19:30:06 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: how do i fix these RAID5 arrays?
Content-Language: en-GB
To:     Reindl Harald <h.reindl@thelounge.net>,
        John Stoffel <john@stoffel.org>
Cc:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
References: <20221123220736.GD19721@jpo> <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <f58964da-4ded-61a8-bd6a-e2391557b38a@youngman.org.uk>
 <25474.28874.952381.412636@quad.stoffel.home>
 <fd543697-14a6-0868-82a1-be61790e07f3@thelounge.net>
 <62b72b4e-8461-e616-1227-4dcef8853143@youngman.org.uk>
 <7316d29a-bab6-b8a2-5c77-803af8de378b@thelounge.net>
 <fd6a2f41-405a-7ec7-e8f1-c970e32973c4@youngman.org.uk>
 <c0fe518d-f9c1-70ca-ea67-89b82f60c048@thelounge.net>
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <c0fe518d-f9c1-70ca-ea67-89b82f60c048@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 27/11/2022 18:23, Reindl Harald wrote:
>> In other words, if the filesystem is only using 10% of the disk, 
>> supporting trim means that raid knows which 10% is being used and only 
>> bothers syncing that!
> 
> this is nonsense and don't reflect reality
> 
> the only thing trim does is tell the underlying device which blocks can 
> be used for wear-leveling
> 
Then why do some linux block devices THAT HAVE NOTHING TO DO WITH 
HARDWARE support trim? (Sorry I can't name them, I've come across them).

And are you telling me that you're happy with a block device trashing 
your live data because the filesystem or whatever trimmed it? If the 
file system sends a TRIM command, it's saying "I am no longer using this 
space". What the underlying block layer does with it is up that layer. 
An SSD might use it for wear leveling, I'm pretty certain 
thin-provisioning uses it to release space (oh there's my block layer 
that isn't hardware).

AND THERE IS ABSOLUTELY NO REASON why md-raid shouldn't flag it as "this 
doesn't need recovery". Okay, it would need some sort of bitmap to say 
"these stripes are/aren't in use, which would chew up some disk space, 
but it's perfectly feasible.

Cheers,
Wol
