Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CF58C4167B
	for <linux-raid@archiver.kernel.org>; Thu, 17 Mar 2022 15:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiCQPvX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 17 Mar 2022 11:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236215AbiCQPvU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 17 Mar 2022 11:51:20 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA7E1B5382
        for <linux-raid@vger.kernel.org>; Thu, 17 Mar 2022 08:50:02 -0700 (PDT)
Received: from host86-155-180-61.range86-155.btcentralplus.com ([86.155.180.61] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1nUsO0-0008Ws-4U;
        Thu, 17 Mar 2022 15:50:00 +0000
Message-ID: <8cb0792c-0e8f-e03c-bb74-91d9b0d21df5@youngman.org.uk>
Date:   Thu, 17 Mar 2022 15:49:59 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: WD MyBookLiveDuo Raid repair/read
Content-Language: en-GB
To:     Rudolf Feile <rudolf@familie-feile.de>, linux-raid@vger.kernel.org
References: <c4216c55-3756-8faa-29c1-318f90c4967c@familie-feile.de>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <c4216c55-3756-8faa-29c1-318f90c4967c@familie-feile.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 17/03/2022 14:42, Rudolf Feile wrote:
> Hi,
> 
> some time ago, my MyBookLiveDuo didn't response anymore. I tried 
> serveral actions mentioned at WD but they where not successful. Thus I 
> took the drive apart, and shared with other things.
> 
> Meanwhile I set up a laptop with ubuntu and started to become familier 
> with linux. As I knew, that the basic system on WD MyBookLiveDuo is also 
> linux, I thought perhaps I could read the drives of the MBLD.
> 
> I own an usb- based double tray drive (SALCAR), took off the drive from 
> MBLD, placed them into this double tray, and connected the usb to the 
> ubuntu system.
> 
> Following  raid.wiki.kernel.org/.../Asking_for_help page I received the 
> answers in request.txt attached.
> 
> It seems quite okay for my low level raid knowledge. The only thing I 
> noticed is that one drive has a corrupt setup date fro 1970 compared to 
> the other files date from 2011.
> 
> My question(s) are:
> 
> - can I get the data from the files directly via this usb double tray 
> drive, and how this will be done
> 
> - or have I to repair the raid-system, and put the two files back to the 
> MBLD.
> 
> Would be fine if someone could have a look into the file attached.
> 
> Thanks in advance,
> 
> Rudolf
> 
given that it comes up with both md2 and md3 reporting 2 active, and 
working, devices, and /proc/mdstat looking good, I'd just try mounting 
the two arrays and seeing if they work!

THEN JUST GET THE DATA OFF.

All being well, it's just a faulty cage. But sticking WD Greens in a 
raid? That's not recommended!

The worst case is WD's trying to fix things might have re-initialised 
the array.

See if you can mount the array, and take it from there.

(Note your tray is USB, try to minimise i/o - I know I know copying off 
the drives will hammer it - because usb and raid don't like each other)

Cheers,
Wol
