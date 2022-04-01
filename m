Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3128AC433EF
	for <linux-raid@archiver.kernel.org>; Fri,  1 Apr 2022 21:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351304AbiDAVfF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Apr 2022 17:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235288AbiDAVfE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Apr 2022 17:35:04 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196AA264F7E
        for <linux-raid@vger.kernel.org>; Fri,  1 Apr 2022 14:33:14 -0700 (PDT)
Received: from host86-155-180-61.range86-155.btcentralplus.com ([86.155.180.61] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1naOtM-0005zN-AZ;
        Fri, 01 Apr 2022 22:33:12 +0100
Message-ID: <3347cdba-9233-4af5-d00f-c34539783894@youngman.org.uk>
Date:   Fri, 1 Apr 2022 22:33:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Trying to rescue a RAID-1 array
Content-Language: en-GB
To:     bruce.korb+reply@gmail.com
Cc:     linux-raid@vger.kernel.org
References: <CAKRnqN+_=U58dT5bvgWJ1DgyEuhjsbmCuDL+xOLxmcuG1ML4qg@mail.gmail.com>
 <e3573002-05f3-3110-62a6-e704385f877f@youngman.org.uk>
 <CAKRnqNLjsX9nVLrLedo4tfxtg0ZBz=6XJu=-z_Ebw6Auh+oz-Q@mail.gmail.com>
 <8c2148d0-fa97-d0ef-10cc-11f79d7da5e5@youngman.org.uk>
 <CAKRnqN+21BZT1eufn962xiEDvnrBtk68dTBSLT1mx7+Ac2kJ+w@mail.gmail.com>
 <CAKRnqN+6wAFPf5AGNEf948NunA97MJ9Gy5eFzLCfX+WfHY72Pg@mail.gmail.com>
 <776f85f6-33a2-f226-f6ff-09e736ccefd1@youngman.org.uk>
 <CAKRnqNL0aNWGHFgcz-KVKn3dpVpUa1oN5miu+oiv16vdJx3OHw@mail.gmail.com>
 <0955d209-ab2b-dc20-a9fb-ad15c09eb884@youngman.org.uk>
 <CAKRnqNLQDC8HCO873+_KiFC2zg_CyibsteGC_URLQoyYaCEO6A@mail.gmail.com>
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <CAKRnqNLQDC8HCO873+_KiFC2zg_CyibsteGC_URLQoyYaCEO6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 01/04/2022 22:24, Bruce Korb wrote:
> with the RAID superblock at the end and the file system layout at the start,
> it should be good. Fingers crossed. Please point me to where I can learn
> how to loopback mount an XFS file system within a RAID partition.:)

https://raid.wiki.kernel.org/index.php/Recovering_a_damaged_RAID

Note I've never done this myself (fortunately never needed it!), but a 
fair few people have needed it, and have done it ...

Cheers,
Wol
