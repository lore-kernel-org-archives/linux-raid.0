Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D86C433F5
	for <linux-raid@archiver.kernel.org>; Thu, 16 Dec 2021 22:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbhLPWaz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 16 Dec 2021 17:30:55 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:9249 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230462AbhLPWaz (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 16 Dec 2021 17:30:55 -0500
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1mxzH3-0001T7-5O; Thu, 16 Dec 2021 22:30:53 +0000
Message-ID: <63778a8a-aba9-c70c-d325-b5c786e50f18@youngman.org.uk>
Date:   Thu, 16 Dec 2021 22:30:52 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: Debugging system hangs
Content-Language: en-US
To:     John Stoffel <john@stoffel.org>,
        Roger Heflin <rogerheflin@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <d8a0d8c9-f8cc-a70a-03a0-aae2fd6c68c2@youngman.org.uk>
 <CAAMCDeekr+a6e7BwyF9b=n49X6YgqUWBc8UtAyZkjFcHBnbyRQ@mail.gmail.com>
 <cbfc2f45-96d8-4ee7-a12b-5a24bd2f2159@youngman.org.uk>
 <CAAMCDeemZO2u_4WW8pHVP2qOxz0HdHQTy2Gsa=zgY-7g4ptw7w@mail.gmail.com>
 <25019.45839.872620.235430@quad.stoffel.home>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <25019.45839.872620.235430@quad.stoffel.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 16/12/2021 21:43, John Stoffel wrote:
> Another thing that struck me is maybe it's time to boot into a small
> stress testing image and see if it's more of a hardware issue.  It
> might also be a power supply issue, where as the load goes up, your
> power supply can't keep the voltage up and the system fails that way?

Unlikely, but never say never ...

It doesn't seem to be crashing under load, it's more like getting stuck 
in idle, but I've debugged enough problems to know that it's rarely what 
you initially think it is.

The PSU is a 550W Corsair unit, so unless it's faulty power load 
certainly won't be an issue...

I'll need to do a lot of playing over Christmas, if I get the chance ...

Cheers,
Wol
