Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA299C433F5
	for <linux-raid@archiver.kernel.org>; Mon, 17 Jan 2022 19:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235659AbiAQT7f (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 17 Jan 2022 14:59:35 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:13574 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231292AbiAQT7e (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 17 Jan 2022 14:59:34 -0500
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1n9YA8-0001mv-Ck;
        Mon, 17 Jan 2022 19:59:33 +0000
Message-ID: <ca5651d0-ef02-4a7d-1486-2cdfb1cd4fe1@youngman.org.uk>
Date:   Mon, 17 Jan 2022 19:59:32 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Feature request: Add flag for assuming a new clean drive
 completely dirty when adding to a degraded raid5 array in order to increase
 the speed of the array rebuild
Content-Language: en-GB
To:     =?UTF-8?B?SmFyb23DrXIgQ8OhcMOtaw==?= <jaromir.capik@email.cz>,
        Roger Heflin <rogerheflin@gmail.com>
Cc:     Linux RAID <linux-raid@vger.kernel.org>
References: <Ja6.44rcR.6N3YLK}k{ZL.1XskzP@seznam.cz>
 <0394837e-0109-e7b7-59f9-5e90a03bc629@youngman.org.uk>
 <CAAMCDec5kcK62enZCOh=SJZu0fecSV60jW8QjMierC147HE5bA@mail.gmail.com>
 <KN4.44rdw.1WKWgyVtkH0.1XtLJu@seznam.cz>
 <CAAMCDef-bxeM0a_qS0FuviZ89a_Qn496KDsj1WQ3r7NT+t5+_Q@mail.gmail.com>
 <Ly2.44rd2.7sLtKmD9o5e.1Xto6p@seznam.cz>
 <NWX.44oOw.7USLwiS0IVD.1XuOH9@seznam.cz>
 <CAAMCDedMLUPawEwKZWw4gRSP-04SyihqiLcHeXTN2XhfDTcsKg@mail.gmail.com>
 <Pio.44oOQ.1niDXrCPXrs.1XvQvl@seznam.cz>
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <Pio.44oOQ.1niDXrCPXrs.1XvQvl@seznam.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 17/01/2022 17:59, Jaromír Cápík wrote:
> Few times a year, different reasons. Usually requests for higher capacity
> where I need to replace all drives one by one and then grow the array.
> Sometimes reallocated sectors appear in the SMART output and I never
> let such drives in the array considering them unreliable. The --replace
> feature is nice, but often there's no room for one more drive in the
> chasis and going that way requires an external USB3 rack and a bit of
> magic if the operation cannot be done offline.
> 
You seen the stuff about running raid over USB? Very unwise?

Do you have room for an eSATA card? If so, get an external SATA cage, 
and you can swap a drive out into the cage, rebuild the array with 
--replace, and repeat. Much safer, probably much quicker, and no extra 
work shutting down the system to replace each drive in turn. And if your 
chassis is hot-swap, then all the better, no downtime at all. Just a few 
moments danger each time you physically swap a drive.

> So, I still hope someone will find enough courage one day to implement
> the new optional sync strategy:)

There is the argument that increasing the load on the drive increases 
the risk to the drive ...

Cheers,
Wol
