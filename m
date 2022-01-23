Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D617EC433F5
	for <linux-raid@archiver.kernel.org>; Sun, 23 Jan 2022 17:26:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239220AbiAWR0m (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 23 Jan 2022 12:26:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239172AbiAWR0l (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 23 Jan 2022 12:26:41 -0500
Received: from box.sotapeli.fi (sotapeli.fi [IPv6:2001:41d0:302:2200::1c0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50E8C06173B
        for <linux-raid@vger.kernel.org>; Sun, 23 Jan 2022 09:26:41 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 913268141A;
        Sun, 23 Jan 2022 18:26:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sotapeli.fi; s=dkim;
        t=1642958796; h=from:subject:date:message-id:to:mime-version:content-type:
         content-transfer-encoding:in-reply-to:references;
        bh=VvbQtVKRYVdGJ0iZ4n5Dob1FoJdY44E7SJdRHbQnbZY=;
        b=JLMDj/2Bd8P81nKcehiRkg8rdot8Q+Q1ND69gUTunY4sRKxO+DRqkleKN/W2dUidU0QLmG
        9UU3TORDTBwrQ8JpYtKsmbfQtjVgvI5e3jKNEojyIXIHwLqCej8RmbyOVaqwf8bA0zRRP1
        KnnmuXTmox7/q+WuAkBUqqW72QDltI0m4HtmNa8D+rUcQM56c0BSMG6iTndQJInr+2KKhD
        aQ3giTAoSx9sBoMkQzWJhyPmc2oBCIucS+nZJj886PPX9PqIMe0VYJqrNcO3G+JJEG/Xyn
        Q0WuhHf/2oJh6lQN/IUp9asLTHa1M41ot+/83Q6e+28vDjZz+j3ylA1HEr6+TA==
Message-ID: <d148862a-dd1c-5ef9-de40-7e8125b6648c@sotapeli.fi>
Date:   Sun, 23 Jan 2022 19:26:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Backup drive DOA?
To:     Wols Lists <antlists@youngman.org.uk>,
        linux-raid <linux-raid@vger.kernel.org>
References: <b8c7f666-3bad-2bde-4513-acbfd45618bf@youngman.org.uk>
From:   Jani Partanen <jiipee@sotapeli.fi>
In-Reply-To: <b8c7f666-3bad-2bde-4513-acbfd45618bf@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I had 6TB X300 what worked fine about half year. Then it started to do 
clicking sound sometimes, until one evening I came home and and was 
clicking constantly. Stopped after reboot. But smart data was showing 
over 1000 g-shock errors, I think drive does detect every click as shock 
with that g-sensor, so I returned it to shop where I bough it.
So kinda bad experience of Toshiba drive to me. Reminded me of all 
issues I had with Hitachi 75GXP drives. I did RMA like 3 of them in row 
until I got enough and switched to WD.
I do not know if Toshiba 300 series drives are generally bad but by 
googling around, seems like quite many had same issues with that drive.


Wols Lists kirjoitti 23/01/2022 klo 14.19:
> Seeing as I guess most people here have plenty of experience with dead 
> drives ...
>
> My 8TB N300 arrived a couple of days ago. I've just tried to add it 
> into my system, and ...
>
> When I powered up the system I heard a "clackety clackety clack" noise.
> The system hung on boot, didn't get as far as grub.
> I could hear a steady repeated "boom chacka boom chacka ..." coming 
> from the new drive.
>
> I'm guessing the drive is dead and it's an RMA? I've never heard 
> sounds like that from a drive before ...
>
> Cheers,
> Wol

