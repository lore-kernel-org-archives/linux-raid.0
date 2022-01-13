Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D6A8C433F5
	for <linux-raid@archiver.kernel.org>; Thu, 13 Jan 2022 00:24:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiAMAYF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 Jan 2022 19:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiAMAYE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 12 Jan 2022 19:24:04 -0500
Received: from box.sotapeli.fi (sotapeli.fi [IPv6:2001:41d0:302:2200::1c0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4006DC06173F
        for <linux-raid@vger.kernel.org>; Wed, 12 Jan 2022 16:24:04 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id CD21882C45;
        Thu, 13 Jan 2022 01:23:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sotapeli.fi; s=dkim;
        t=1642033440; h=from:subject:date:message-id:to:cc:mime-version:content-type:
         content-transfer-encoding:in-reply-to:references;
        bh=YvizPVHjetBMqt24TtZs067zpAlwMAgjwEcceQK/qEA=;
        b=Jm3fh0YhpvLs4BRgGRc3UDuNnawVse7Gnfmlc839Oa45KzicsGTx4jrpkkkim1xjYv4vuX
        IIkxyXnQAmN5jsF3V/JHu/WILjIQOXm0UMFFTFm1263FanempoS6wZj52nM3/bB5zAHXDm
        i2LpIxemGmHdmNI4V51Tthkn+loIwxoLq8Q7gtoleRPnh829juZARn+u8ep5OxycmuMxt6
        ie0knlWmd8CitHiT1kmTv0Ug2uSvemeDU2t7IbbubYgpoGSK86j2PiqlcL/BuqEuBWmrJ3
        dp4sVvxzJj58768alKC5OIVO3did4+Cwd/U9C00dYNJRoLmfnJjAlsuoW+6XRQ==
Message-ID: <c94d975f-78d0-259f-bca2-a7b74c55f2a6@sotapeli.fi>
Date:   Thu, 13 Jan 2022 02:23:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: md device remains active even when all supporting disks have
 failed and been disabled by the kernel.
To:     Aidan Walton <aidan.walton@gmail.com>,
        Roger Heflin <rogerheflin@gmail.com>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <CAPx-8MP0+C9M9ysigF-gfaUBE8nv7nzbm4HO06yC_z5i3U3D=Q@mail.gmail.com>
 <20220110104733.00001048@linux.intel.com>
 <CAPx-8MNa97Aokgz8RzfiGEPXFLpzbGduNV9hUOYdGXRmfxSg3g@mail.gmail.com>
 <CAAMCDecViLw=V_nFgJicLa=nDoADScpwg_pfWF2ubF5D=aCsaA@mail.gmail.com>
 <CAPx-8MNgtVuUgdOBsZiQyXmS=nCoj255D+oNrkGOcsNVhixC3g@mail.gmail.com>
From:   Jani Partanen <jiipee@sotapeli.fi>
In-Reply-To: <CAPx-8MNgtVuUgdOBsZiQyXmS=nCoj255D+oNrkGOcsNVhixC3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Aidan Walton kirjoitti 13/01/2022 klo 2.03:
> Hi Roger,
> As I mentioned, it is a:
> JMicron Technology Corp. JMB363

If my memory is correct. This chip is trash. If I am right, I have same 
chip on cheap controller what I bought to get IDE controller mainly, it 
also has 2xSATA ports and I had only troubles with that controller in linux.
If I had no drives on SATA ports, dmesg got spammed port errors. If I 
had drives installed, they was randomly dropping in and out. Chip itself 
was running hot as hell, I mean so hot that you could not keep finger on 
chip. I did put some small finns to it and I think it did help little 
for drives dropping in and out, but didn't solve it.
If you want a cheap controller, get this chip:
02:00.0 SATA controller: ASMedia Technology Inc. Device 1166 (rev 02)

It's been quite stable for me and didn't cost much. Only issue I have 
that I cannot force it's ports transfer speed to example 3.0G. Spinnin 
rust do not need 6.0G speed what in my experience increase chance for 
dropouts if you cables aren't 6.0G ready and how do you tell if they are 
when cable doesn't have any mention about it?
I think it's something to do that it's PMP card and I don't understand 
how you have to format kernel parameter when you have PMP situation. I 
can tune internal controller all ports just fine, but not this expansion 
card. Kernel tell you it's forcing them to 3.0G, but when you check 
later what transfer speed is, it's still 6.0G


