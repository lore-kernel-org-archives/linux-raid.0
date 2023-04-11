Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C766FC7619A
	for <linux-raid@archiver.kernel.org>; Tue, 11 Apr 2023 19:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbjDKTru (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 11 Apr 2023 15:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjDKTrt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 11 Apr 2023 15:47:49 -0400
Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B9C2D55
        for <linux-raid@vger.kernel.org>; Tue, 11 Apr 2023 12:47:47 -0700 (PDT)
Received: from quad.stoffel.org (097-095-183-072.res.spectrum.com [97.95.183.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id DCBD51E6EC;
        Tue, 11 Apr 2023 15:47:46 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id 82086A8575; Tue, 11 Apr 2023 15:47:46 -0400 (EDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <25653.47458.489415.933722@quad.stoffel.home>
Date:   Tue, 11 Apr 2023 15:47:46 -0400
From:   "John Stoffel" <john@stoffel.org>
To:     Moritz Rosin <moritz.rosin@itrosinen.de>
Cc:     linux-raid@vger.kernel.org
Subject: Re: Recover data from accidentally created raid5 over raid1
In-Reply-To: <c0a9e08b91e86c86038be889907f0796@itrosinen.de>
References: <c0a9e08b91e86c86038be889907f0796@itrosinen.de>
X-Mailer: VM 8.2.0b under 27.1 (x86_64-pc-linux-gnu)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>>>> "Moritz" == Moritz Rosin <moritz.rosin@itrosinen.de> writes:

> Hey there,
> unfortunately I have to admit, that I learned my lesson the hard way 
> dealing with software raids.

> I had a raid1 running reliable over month using two 4TB HDDs.
> Since I ran short on free space I tried to convert the raid1 to a raid5 
> in-place (with the plan to add the 3rd HDD after converting).
> That's where my incredibly stupid mistake kicked in.

> I followed an internet tutorial that told me to do:
> mdadm --create /dev/md0 --level=5 --raid-devices=2 /dev/sdX1 /dev/sdY1

Please share the link to the tutorial so we can maybe shame that
person into fixing it.  Or removing it.  

> I learned that I re-created a raid5 array instead of converting the 
> raid1 :-(

Yeah, I think you're out of luck here.  What kind of filesystem did
you have on your setup?  Were you using MD -> LVM -> filesystem stack?
Or just a raw filesystem on top of the /dev/md?  device?

> Is there any chance to un-do the conversion or restore the data?
> Has the process of creation really overwritten data or is there
> anythins left on the disk itself that can be rescued?

If you have any information on your setup before you did this, then
you might be ok, but honestly, I think you're toast.

John
