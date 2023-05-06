Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1025BC77B73
	for <linux-raid@archiver.kernel.org>; Sat,  6 May 2023 21:59:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjEFV73 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 6 May 2023 17:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjEFV71 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 6 May 2023 17:59:27 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7181F4B1
        for <linux-raid@vger.kernel.org>; Sat,  6 May 2023 14:59:25 -0700 (PDT)
Received: from host86-157-72-252.range86-157.btcentralplus.com ([86.157.72.252] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1pvPw3-0007HC-Bh;
        Sat, 06 May 2023 22:59:23 +0100
Message-ID: <90efe591-999e-93b4-5c52-440fe4aff161@youngman.org.uk>
Date:   Sat, 6 May 2023 22:59:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Raid5 to raid6 grow interrupted, mdadm hangs on assemble command
To:     Jove <jovetoo@gmail.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <CAFig2csUV2QiomUhj_t3dPOgV300dbQ6XtM9ygKPdXJFSH__Nw@mail.gmail.com>
 <63d92097-5299-2ae8-9697-768c52678578@huaweicloud.com>
 <CAFig2ct4BJZ0A9BKuXn8RM71+KrUzB8vKGQY0fSjNZiNenQZBg@mail.gmail.com>
 <c71c8381-f26e-f7de-c6f5-3c4411f08b15@huaweicloud.com>
 <d159161d-a5eb-8790-49c4-b7013e66ba65@youngman.org.uk>
 <6f391690-992f-1196-3109-6d422b3522f7@huaweicloud.com>
 <CAFig2ct+ZbHYEho7p9eubaz-kozGR+GkSJ1tVL+LGaciUBixyw@mail.gmail.com>
 <bc698b03-446b-a42e-cf0c-5c1b3cb62559@huaweicloud.com>
 <CAFig2csN8qSEafSehM5oN-kO3FsK=6+vvyEeiYcbvqRkmoiN7Q@mail.gmail.com>
Content-Language: en-GB
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <CAFig2csN8qSEafSehM5oN-kO3FsK=6+vvyEeiYcbvqRkmoiN7Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 06/05/2023 14:07, Jove wrote:
> Hi Kuai,
> 
> Just to confirm, the array seems fine after the reshape. Copying files now.
> 
> Would it be best if I scrap this array and create a new one or is this
> array safe to use in the long term? It had to use the --invalid-backup
> flag to get it to reshape, so there might be corruption before that
> resume point?
> 
> I have to do a reshape anyway, to 5 raid devices.
> 
I wouldn't think it necessary to scrap the array, but if you've backed 
it up and are happier doing so ...

AIUI it was an external program squeezing in where it shouldn't that 
(quite literally) threw a spanner in the works and jammed things up. The 
array itself should be perfectly okay.

As for the "invalid backup" problem, you should never have given it a 
backup in the first place, and (while I don't know the code) I very much 
expect it ignored the option completely. You have superblock 1.2, which 
has a chunk of space "reserved for internal use", one of which is to 
provide this backup.

The only real good reason I can think of for scrapping and recreating 
the array is that it will give you a clean array, with ALL THE CURRENT 
DEFAULTS. This is important if anything goes wrong in future, if you 
have an array with a known creation date, that has not been "messed 
about" with since, it's easier to recover if you're really stupid and 
damage it and lose your records of the layout. Once an array goes 
through reshapes, it can be a lot harder to work out the layout if you 
have to rescue the array by recreating it.

Cheers,
Wol
