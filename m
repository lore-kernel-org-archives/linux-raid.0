Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F975C001DC
	for <linux-raid@archiver.kernel.org>; Sun, 30 Jul 2023 09:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjG3JrR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 30 Jul 2023 05:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjG3JrQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 30 Jul 2023 05:47:16 -0400
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19FDF19A;
        Sun, 30 Jul 2023 02:47:15 -0700 (PDT)
Received: from [192.168.0.2] (ip5f5ae955.dynamic.kabel-deutschland.de [95.90.233.85])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id F3C7D61E5FE01;
        Sun, 30 Jul 2023 11:46:24 +0200 (CEST)
Message-ID: <f21e34ca-72ad-26b5-fac4-fd71180719a2@molgen.mpg.de>
Date:   Sun, 30 Jul 2023 11:46:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH] md: fix potential OOB in multipath_remove_disk()
Content-Language: en-US
To:     Song Liu <song@kernel.org>,
        Zhang Shurong <zhang_shurong@foxmail.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <tencent_E2C71605D88087940237AA9A44CC8D436D06@qq.com>
 <ZK7Zy2U86znezl+a@infradead.org>
 <tencent_0EDE0D522DF8161358B80786820BAAA5C406@qq.com>
 <CAPhsuW54pW7As-A1G4H+OWALUh7_a5+-zkLXghTh6_JjcWZoMQ@mail.gmail.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <CAPhsuW54pW7As-A1G4H+OWALUh7_a5+-zkLXghTh6_JjcWZoMQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Song, Zhang and Christoph,


Am 29.07.23 um 12:46 schrieb Song Liu:
> On Sat, Jul 15, 2023 at 5:45 PM Zhang Shurong wrote:
>>
>> 在 2023年7月13日星期四 CST 上午12:50:19，Christoph Hellwig 写道：
>>> On Thu, Jul 13, 2023 at 12:46:05AM +0800, Zhang Shurong wrote:
>>>> If rddev->raid_disk is greater than mddev->raid_disks, there will be
>>>> an out-of-bounds in multipath_remove_disk. We have already found
>>>> similar reports as follows:
>>>>
>>>> 1) commit d17f744e883b ("md-raid10: fix KASAN warning")
>>>> 2) commit 1ebc2cec0b7d ("dm raid: fix KASAN warning in raid5_remove_disk")
>>>>
>>>> Fix this bug by checking whether the "number" variable is
>>>> valid.
>>>
>>> I think it might just be time to finally dropped the deprecated md
>>> multipath code instead..
>> Should I write another patch to delete them?
> 
> Yes, please write a patch to delete the multipath code.

How would fixing this bug work with the stable series? Probably a 
removal patch wouldn’t be picked, right? Shouldn’t the fix be accepted 
in master, and then the code be removed?


Kind regards,

Paul
