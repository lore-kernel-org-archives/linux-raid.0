Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA596C43334
	for <linux-raid@archiver.kernel.org>; Mon, 27 Jun 2022 18:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbiF0SmA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 27 Jun 2022 14:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235212AbiF0Sl7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 27 Jun 2022 14:41:59 -0400
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008AEB25
        for <linux-raid@vger.kernel.org>; Mon, 27 Jun 2022 11:41:58 -0700 (PDT)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4LWxQr5wK5zXMm;
        Mon, 27 Jun 2022 20:41:56 +0200 (CEST)
Message-ID: <4b90d4e6-186c-23ea-78be-c507bcc04427@thelounge.net>
Date:   Mon, 27 Jun 2022 20:41:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: what's wrong with RAID-10? (was "Re: moving a working array")
Content-Language: en-US
To:     Wols Lists <antlists@youngman.org.uk>,
        David T-G <davidtg-robot@justpickone.org>,
        Linux-RAID <linux-raid@vger.kernel.org>
References: <CAPpdf595_7eW8amX8eueMxgjaWvLW-hWHh1SHHaGAt8YyP7yDw@mail.gmail.com>
 <7683b644cf076f8db06d60fdd3e4f88424f35bd2.camel@gmail.com>
 <92378403-adf6-dedb-828c-81b331c1d8c1@youngman.org.uk>
 <20220627104109.GJ18273@justpickone.org>
 <d058da47-528e-f9af-dbb1-5941eef72b56@youngman.org.uk>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <d058da47-528e-f9af-dbb1-5941eef72b56@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 27.06.22 um 17:10 schrieb Wols Lists:
> On 27/06/2022 11:41, David T-G wrote:
>> Wol, et al --
>>
>> ...and then Wols Lists said...
>> %
>> % On 24/06/2022 15:09, Wilson Jonathan wrote:
>> % > On Fri, 2022-06-24 at 08:38 -0500, o1bigtenor wrote:
>> % > >
>> % > > I have a working (no issues) raid-10 array in one box.
>> %
>> % Bummer. It's a raid-10. A raid-1 would have been easier.
>> [snip]
>>
>> This tripped me.  I presumed that the reason for -10, not least because
>> he also said "these 4 drives", was because the array space is bigger than
>> just one hard drive size, ie 6T on 4ea 3T drives.  How would RAID-1 work
>> for that storage?  And why would it be easier than RAID-10?
>>
> Just that raid-1 would have been a simple case of two drives, each a 
> backup of the other. Keep one safe, put the other in the new system.
> 
> With raid-10, it's much more complicated - you can't just do that :-(

you can easily do that with RAID10

* just buy replacement disks
* pull out two disks
* look if it boots
* if not pull a different out
* rebuild the array with the new disks
* put the other two disks with two blank
   ones in the other box
* rebuild the array in the other box
* voila you have two indetical redundant machines

frankly i cloned machines by intention that way
