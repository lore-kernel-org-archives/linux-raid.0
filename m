Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76666C433EF
	for <linux-raid@archiver.kernel.org>; Sun, 15 May 2022 00:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbiENXyE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 14 May 2022 19:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232922AbiENXyD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 14 May 2022 19:54:03 -0400
X-Greylist: delayed 434 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 14 May 2022 16:54:01 PDT
Received: from box.sotapeli.fi (sotapeli.fi [37.59.98.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915F413DF7
        for <linux-raid@vger.kernel.org>; Sat, 14 May 2022 16:54:01 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 2F7388045E;
        Sun, 15 May 2022 01:46:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sotapeli.fi; s=dkim;
        t=1652572003; h=from:subject:date:message-id:to:mime-version:content-type:
         content-transfer-encoding:in-reply-to:references;
        bh=1LnVFa5BU4Jnkfn39GLR8l6jMip5l1h/+RsFPh6hblU=;
        b=aJBTYtVT0edkwtcZe8kBuqWkODoG+jgKAPAvwJLnyGXUlsT00joOlcIOMXfcIdGv3XH+gj
        E5TlyBbc9kY37+Kq6BhSjXT7s3aP6hJTMix5wyZrRgQZeOe68j+qQhpzKHF4g+3nZuLrEC
        OnWhH2PJE7JW+EXeQhfHMXZlU2aSvBbwtHYoPnIOfCd3CoKcIXBYsI/nnox1ffjrzCFfJG
        tGzhTLbbO2sf1ivoRD8y3ygF01U+3HINOiasGBcMMIN2VhFxnz/jf5PdvgYCuAFrH0grQU
        IV/fwi77hUykszGytLMyaOGzyA2SevIV9cebt2gLBjpqBq8z2ayeoLlA6vGC0g==
Message-ID: <a5691201-1d9b-f7e4-d76b-52c45ea61576@sotapeli.fi>
Date:   Sun, 15 May 2022 02:46:37 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: failed sector detected but disk still active ?
To:     Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <CAJH6TXh7cVHa+G1DaJwWSvgDaCOrYLP_Ppau8q6pk1V4dS3D_Q@mail.gmail.com>
From:   Jani Partanen <jiipee@sotapeli.fi>
In-Reply-To: <CAJH6TXh7cVHa+G1DaJwWSvgDaCOrYLP_Ppau8q6pk1V4dS3D_Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Interesting. I had just yesterday same error, but in my case it happened 
when I was rebuilding raid-5 and system was very unhappy, eventually 
stopped rebuild because there was like 10 errors.
I was actually afraid that I lost that pool, but when I did reboot, 
rebuild started again and at some point it did show again same errors 
but now only 2 times and rebuild finished.
Now I am running check and after check I will run btrfs scrub because I 
have btrfs on that pool with double meta.

What kernel version you are running? I'm on 5.17.6-300.fc36.x86_64

I do have now 23 bending sectors on that disk what is for me quite big 
indicator that I really need to replace that disk, it will be toasted 
soon by previous experience. So check your smart status from that disk.


//JiiPee


Gandalf Corvotempesta kirjoitti 13/05/2022 klo 10.37:
> How this is possible ?
> seems that sdc has some failed sectors but disk is still active in the array
>
> [Mon May  2 03:36:24 2022] sd 0:0:2:0: [sdc] Unhandled sense code
> [Mon May  2 03:36:24 2022] sd 0:0:2:0: [sdc]
> [Mon May  2 03:36:24 2022] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [Mon May  2 03:36:24 2022] sd 0:0:2:0: [sdc]
> [Mon May  2 03:36:24 2022] Sense Key : Medium Error [current]
> [Mon May  2 03:36:24 2022] Info fld=0x10565570
> [Mon May  2 03:36:24 2022] sd 0:0:2:0: [sdc]
> [Mon May  2 03:36:24 2022] Add. Sense: Unrecovered read error
> [Mon May  2 03:36:24 2022] sd 0:0:2:0: [sdc] CDB:
> [Mon May  2 03:36:24 2022] Read(10): 28 00 10 56 51 80 00 04 00 00
> [Mon May  2 03:36:24 2022] end_request: critical medium error, dev
> sdc, sector 274093424
> [Mon May  2 03:36:25 2022] sd 0:0:2:0: [sdc] Unhandled sense code
> [Mon May  2 03:36:25 2022] sd 0:0:2:0: [sdc]
> [Mon May  2 03:36:25 2022] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [Mon May  2 03:36:25 2022] sd 0:0:2:0: [sdc]
> [Mon May  2 03:36:25 2022] Sense Key : Medium Error [current]
> [Mon May  2 03:36:25 2022] Info fld=0x10565584
> [Mon May  2 03:36:25 2022] sd 0:0:2:0: [sdc]
> [Mon May  2 03:36:25 2022] Add. Sense: Unrecovered read error
> [Mon May  2 03:36:25 2022] sd 0:0:2:0: [sdc] CDB:
> [Mon May  2 03:36:25 2022] Read(10): 28 00 10 56 55 80 00 04 00 00
> [Mon May  2 03:36:25 2022] end_request: critical medium error, dev
> sdc, sector 274093444
> [Mon May  2 04:06:32 2022] md: md0: data-check done.
>
>
>
> # cat /proc/mdstat
> Personalities : [raid1]
> md0 : active raid1 sdc1[2] sda1[0] sdb1[1]
>        292836352 blocks super 1.2 [3/3] [UUU]
>        bitmap: 3/3 pages [12KB], 65536KB chunk
>
> unused devices: <none>

