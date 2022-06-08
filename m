Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52A6FC43334
	for <linux-raid@archiver.kernel.org>; Wed,  8 Jun 2022 18:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234323AbiFHSTE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Jun 2022 14:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235581AbiFHSQO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Jun 2022 14:16:14 -0400
Received: from mail.areainter.net (wetnet.areainter.net [31.211.71.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36D556752
        for <linux-raid@vger.kernel.org>; Wed,  8 Jun 2022 11:16:10 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.areainter.net (Postfix) with ESMTP id 17AEC5A184;
        Thu,  9 Jun 2022 01:16:08 +0700 (+07)
X-Virus-Scanned: Debian amavisd-new at areainter.net
Received: from mail.areainter.net ([127.0.0.1])
        by localhost (mail.areainter.net [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fdqMR9j3mS9K; Thu,  9 Jun 2022 01:16:07 +0700 (+07)
Received: from [10.60.10.197] (unknown [10.60.10.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pavel2000@areainter.net)
        by mail.areainter.net (Postfix) with ESMTPSA id 5E73B5A0DB;
        Thu,  9 Jun 2022 01:16:07 +0700 (+07)
Message-ID: <deacdcb9-d100-877a-40b4-42952731806c@areainter.net>
Date:   Thu, 9 Jun 2022 01:16:06 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Misbehavior of md-raid RAID on failed NVMe.
Content-Language: ru
To:     Wol <antlists@youngman.org.uk>
References: <984f2ca5-2565-025d-62a2-2425b518a01f@ngs.ru>
 <b14b62c9-1494-935f-f9f0-43f8083e8547@youngman.org.uk>
From:   Pavel <pavel2000@areainter.net>
Cc:     linux-raid@vger.kernel.org
In-Reply-To: <b14b62c9-1494-935f-f9f0-43f8083e8547@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

08.06.2022 23:52, Wol пишет:
> On 08/06/2022 04:48, Pavel wrote:
>
> Did you dd the raid device (/dev/md0 for example), or the individual 
> nvme devices?

There was LVM over /dev/md0, and dd transferred LVM volumes data.

>> While data in transfer, kernel started IO errors reporting on one of 
>> NVMe devices. (dmesg output below)
>> But md-raid not reacted on them in any way. RAID array not went into 
>> any failed state, and "clean" state reported all the time.
>
> This is actually normal, correct and expected behaviour. If the raid 
> layer does not report a problem to dd, the data should have copied 
> correctly. And raid really only reports problems if it gets write 
> failures.

Yes, but data was not copied correctly.

> Unfortunately, you're missing a lot of detail to help us diagnose the 
> problem. What raid level are you using, for starters. It sounds like 
> there is a problem, but as Mariusz implies, it looks like a faulty 
> nVME device. And if that device is lying to linux, as appears likely 
> (my guess is that raid is trying to fix the data, and the drive is 
> just losing the writes),

Feel free to ask. Raid level: RAID 1, built over partitions on two NVMe 
devices.

Yes, drive is "just" losing the writes. But there is nothing "to fix" on 
RAID level.
 From my user POV, RAID should detect the loss and take appropriate 
actions (mark device as failed).

I don't know, if NVMe layer lies to kernel or not, but I clearly see
"I/O error, dev nvme0n1, sector 1297536456 op 0x1:(WRITE) flags 0x0 
phys_seg 1 prio class 0"
messages, and I expect they clearly mean write failure.

> then there is precious little we can do about it.

As a kernel user, I did all I might to do - posted an report here.
As a kernel developers, you can do a bit more, than users.

Thanks for your answers.

Regards,
Pavel.

