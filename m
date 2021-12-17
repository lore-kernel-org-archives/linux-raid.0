Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 378EBC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 17 Dec 2021 10:08:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbhLQKIF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 17 Dec 2021 05:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbhLQKIC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 17 Dec 2021 05:08:02 -0500
Received: from box.sotapeli.fi (sotapeli.fi [IPv6:2001:41d0:302:2200::1c0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9091BC06173E
        for <linux-raid@vger.kernel.org>; Fri, 17 Dec 2021 02:08:02 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5AF6080D84;
        Fri, 17 Dec 2021 11:07:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sotapeli.fi; s=dkim;
        t=1639735676; h=from:subject:date:message-id:to:cc:mime-version:content-type:
         content-transfer-encoding:in-reply-to:references;
        bh=9lh/KbOSKigix137wz062Mx2VI8iMx/8uUirl3HkmA8=;
        b=UYLwRfLyQ6PwGZMUyEfa1b2SqAdKOLqhLB4oWJT8QImX4yKl664opUQhFcduVycwnvKG23
        lh3p8rH6pvgrGkaXoesyio5UIG6lzYq1qoeQSzq5decvKhZxtoZ7dlWJgx9RB/wSJx2juH
        iszBrnG9J3iw8DB82zMvT7jVjtj7cQWqiefrmSyZSlo8chTlh/BUhsGXWrvgX7U6KFn5kg
        eQiE9J9qoBsHrIsFjpblln+k9bnAWLNJR2eGDOj/ojF2xXxInGhfQ9m4tEwBRF74bezZwV
        nE37KaNfnox6tjRm5pyaOI28dNbZrisRRfBgTkucERKc2Eg0/F2Yttxnad2qow==
Message-ID: <6cf644c8-7433-b20c-8db4-191f7e2bc76e@sotapeli.fi>
Date:   Fri, 17 Dec 2021 12:07:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: Debugging system hangs
To:     Wols Lists <antlists@youngman.org.uk>,
        John Stoffel <john@stoffel.org>,
        Roger Heflin <rogerheflin@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <d8a0d8c9-f8cc-a70a-03a0-aae2fd6c68c2@youngman.org.uk>
 <CAAMCDeekr+a6e7BwyF9b=n49X6YgqUWBc8UtAyZkjFcHBnbyRQ@mail.gmail.com>
 <cbfc2f45-96d8-4ee7-a12b-5a24bd2f2159@youngman.org.uk>
 <CAAMCDeemZO2u_4WW8pHVP2qOxz0HdHQTy2Gsa=zgY-7g4ptw7w@mail.gmail.com>
 <25019.45839.872620.235430@quad.stoffel.home>
 <63778a8a-aba9-c70c-d325-b5c786e50f18@youngman.org.uk>
From:   Jani Partanen <jiipee@sotapeli.fi>
In-Reply-To: <63778a8a-aba9-c70c-d325-b5c786e50f18@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Wols Lists kirjoitti 17/12/2021 klo 0.30:
> On 16/12/2021 21:43, John Stoffel wrote:
>> Another thing that struck me is maybe it's time to boot into a small
>> stress testing image and see if it's more of a hardware issue. It
>> might also be a power supply issue, where as the load goes up, your
>> power supply can't keep the voltage up and the system fails that way?
>
> Unlikely, but never say never ...
>
> It doesn't seem to be crashing under load, it's more like getting 
> stuck in idle, but I've debugged enough problems to know that it's 
> rarely what you initially think it is.
>
> The PSU is a 550W Corsair unit, so unless it's faulty power load 
> certainly won't be an issue...
>
> I'll need to do a lot of playing over Christmas, if I get the chance ...
>
> Cheers,
> Wol

I have couple old CPU's I5 4670K and I7 4790K, both have idle locking 
issues. I solved my issue boosting voltages little from bios. I7 from 
friend and I know it's been heavily overclocked and it's so bad that if 
I use stock settings what bios set, I cannot even install OS because it 
just lock up or crash on install.
But when I boost voltages, it does run stable. Another lockup source 
what I have got is memory. I was trying to add 16GB momory, but sticks 
are not same brand and speed and they just don't play nice together even 
if I run them with stock settings.


// JiiPee
