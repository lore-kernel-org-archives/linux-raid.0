Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD79ECAAD8
	for <linux-raid@archiver.kernel.org>; Tue, 13 Sep 2022 17:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbiIMR1m (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 13 Sep 2022 13:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbiIMR1B (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 13 Sep 2022 13:27:01 -0400
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D21B69F54
        for <linux-raid@vger.kernel.org>; Tue, 13 Sep 2022 09:15:33 -0700 (PDT)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4MRndf1zPtzXLb;
        Tue, 13 Sep 2022 17:37:10 +0200 (CEST)
Message-ID: <3c299ccc-01e6-a94f-df50-f51243f834f0@thelounge.net>
Date:   Tue, 13 Sep 2022 17:37:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: change UUID of RAID devcies
Content-Language: en-US
From:   Reindl Harald <h.reindl@thelounge.net>
To:     Wol <antlists@youngman.org.uk>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <2341a2a9-b86e-f0e5-784a-05dbd474dec5@thelounge.net>
 <729bdc01-b0ae-887a-6d2a-5135d287636c@youngman.org.uk>
 <05a1161b-d798-c68f-d37c-a9fc373c6e73@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <05a1161b-d798-c68f-d37c-a9fc373c6e73@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 13.09.22 um 12:28 schrieb Reindl Harald:
> Am 12.09.22 um 23:37 schrieb Wol:
>> On 12/09/2022 16:04, Reindl Harald wrote:
>>> the reason for that game is that the machines are running for 10 
>>> years now and all the new desktop hardware can't hold 4x3.5" disks 
>>> and so just put them in a new one isn't possible
>>
>> How many SATA ports does the mobo have? Can you --replace onto the new 
>> drives (especially if it's raid-10!), then just fail the remaining two 
>> drives?
>>
>> Iirc raid-10 doesn't require the drives to be the same size, so 
>> provided the two new drives are big enough, that should just work.
>>
>> Then with just two drives you change the raid to raid-1

[root@testserver:~]$ mdadm /dev/md0 --grow --level=1
mdadm: RAID10 can only be changed to RAID0

virtual machine with two drives replaced against double sized

so we are back at the dd/ssh-game and how do i set the UUIDs identical?
