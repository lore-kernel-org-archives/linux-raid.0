Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE118C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 17 Nov 2021 17:56:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7C0560FED
	for <linux-raid@archiver.kernel.org>; Wed, 17 Nov 2021 17:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbhKQR7J (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 Nov 2021 12:59:09 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:16487 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231311AbhKQR7I (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 17 Nov 2021 12:59:08 -0500
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1mnPAG-0006b6-A0; Wed, 17 Nov 2021 17:56:08 +0000
Subject: Re: Failed Raid 5 - one Disk possibly Out of date - 2nd disk damaged
To:     Martin Thoma <thomamartin1985@googlemail.com>,
        linux-raid@vger.kernel.org
References: <CAFPgooeJrvrNQcOQXUD82oc52rgB3DvH=JFzDVDMnfc+gs7nDg@mail.gmail.com>
From:   Wols Lists <antlists@youngman.org.uk>
Message-ID: <06b0f87c-2d06-3f94-f0b3-19d631968fa0@youngman.org.uk>
Date:   Wed, 17 Nov 2021 17:56:07 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAFPgooeJrvrNQcOQXUD82oc52rgB3DvH=JFzDVDMnfc+gs7nDg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 17/11/2021 12:22, Martin Thoma wrote:
> Hi All,
> 


> 
> So /dev/sdd1 was considered , when i ran the command again the raid
> assembled without sdd1
> 
> When i tried Reading Data after a while it stopped (propably when the
> data was on /dev/sdc
> 
> dmesg showed this:
> [  368.433658] sd 8:0:0:1: [sdc] tag#0 FAILED Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE
> [  368.433664] sd 8:0:0:1: [sdc] tag#0 Sense Key : Medium Error [current]
> [  368.433669] sd 8:0:0:1: [sdc] tag#0 Add. Sense: Unrecovered read error
> [  368.433675] sd 8:0:0:1: [sdc] tag#0 CDB: Read(16) 88 00 00 00 00 00
> 00 08 81 d8 00 00 00 08 00 00
> [  368.433679] blk_update_request: critical medium error, dev sdc, sector 557528
> [  368.433689] raid5_end_read_request: 77 callbacks suppressed
> [  368.433692] md/raid:md0: read error not correctable (sector 555480 on sdc1).
> [  375.944254] sd 8:0:0:1: [sdc] tag#0 FAILED Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE
> 
> and the Raided stopped again.
> 
> How can i force to assemble the raid including /dev/sdd1 and not
> include /dev/sdc (because that drive is possibly damaged now)?
> With a mdadm --create --assume-clean .. command?

NO NO NO NO NO !!!
> 
> I'm using  mdadm/zesty-updates,now 3.4-4ubuntu0.1 amd64 [installed] on
> Linux version 4.10.0-21-generic (buildd@lgw01-12) (gcc version 6.3.0
> 20170406 (Ubuntu 6.3.0-12ubuntu2) )
> 
That's an old ubuntu? and an ancient mdadm 3.4?

As a very first action, you need to source a much newer rescue disk!

As a second action, if you think sdc and sdd are dodgy, then you need to 
replace them - use dd or ddrescue to do a brute-force copy.

You don't mention what drives they are. Are they CMR? Are they suitable 
for raid? For replacement drives, I'd look at upsizing to 4TB for a bit 
of headroom maybe (or look at moving to raid 6). And look at Seagate 
IronWolf, WD Red *PRO*, or Toshiba N300. (Personally I'd pass on the WD ...)

Once you've copied sdc and sdd, you can look at doing another force 
assemble, and you'll hopefully get your array back. At least the event 
count info implies damage to the array should be minimal.

https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn

Read, learn, and inwardly digest ...

And DON'T do anything that will make changes to the disks - like a 
re-create!!!

Cheers,
Wol
