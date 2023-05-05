Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F0E2C77B7D
	for <linux-raid@archiver.kernel.org>; Fri,  5 May 2023 06:58:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbjEEG6R (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 5 May 2023 02:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjEEG6Q (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 5 May 2023 02:58:16 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545A41AE
        for <linux-raid@vger.kernel.org>; Thu,  4 May 2023 23:58:14 -0700 (PDT)
Received: from host86-157-72-252.range86-157.btcentralplus.com ([86.157.72.252] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1pupOO-0007qX-4k;
        Fri, 05 May 2023 07:58:12 +0100
Message-ID: <d159161d-a5eb-8790-49c4-b7013e66ba65@youngman.org.uk>
Date:   Fri, 5 May 2023 07:58:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Raid5 to raid6 grow interrupted, mdadm hangs on assemble command
To:     Yu Kuai <yukuai1@huaweicloud.com>, Jove <jovetoo@gmail.com>
Cc:     linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <CAFig2csUV2QiomUhj_t3dPOgV300dbQ6XtM9ygKPdXJFSH__Nw@mail.gmail.com>
 <63d92097-5299-2ae8-9697-768c52678578@huaweicloud.com>
 <CAFig2ct4BJZ0A9BKuXn8RM71+KrUzB8vKGQY0fSjNZiNenQZBg@mail.gmail.com>
 <c71c8381-f26e-f7de-c6f5-3c4411f08b15@huaweicloud.com>
Content-Language: en-GB
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <c71c8381-f26e-f7de-c6f5-3c4411f08b15@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 05/05/2023 02:34, Yu Kuai wrote:
>> I have had one case in which mdadm didn't hang and in which the
>> reshape continued. Sadly, I was using sparse overlay files and the
>> filesystem could not handle the full 4x 4TB. I had to terminate the
>> reshape.
> 
> This sounds like a dead end for now, normal io beyond reshape position
> must wait:
> 
> raid5_make_request
>   make_stripe_request
>    ahead_of_reshape
>     wait_woken

Not sure if I've got the wrong end of the stick, but if I've understood 
correctly, that shouldn't be the case.

Reshape takes place in a window. All io *beyond* the window is allowed 
to proceed normally - that part of the array has not been reshaped so 
the old parameters are used.

All io *in front* of the window is allowed to proceed normally - that 
part of the array has been reshaped so the new parameters are used.

io *IN* the window is paused until the window has passed. This 
interruption should be short and sweet.

Cheers,
Wol
