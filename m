Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA265C433EF
	for <linux-raid@archiver.kernel.org>; Wed,  2 Feb 2022 17:55:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237007AbiBBRzb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 2 Feb 2022 12:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232505AbiBBRzb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 2 Feb 2022 12:55:31 -0500
X-Greylist: delayed 70802 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 02 Feb 2022 09:55:29 PST
Received: from srv.fail (srv.fail [IPv6:2a01:4f9:4b:2117:4441:dbff:fedd:beef])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821C3C061714
        for <linux-raid@vger.kernel.org>; Wed,  2 Feb 2022 09:55:29 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by srv.fail (Postfix) with ESMTP id C4BF6152FB36;
        Wed,  2 Feb 2022 18:55:26 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at srv.fail
Received: from srv.fail ([127.0.0.1])
        by localhost (srv.fail [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 70esoxBS5Sd5; Wed,  2 Feb 2022 18:55:24 +0100 (CET)
Received: from [IPV6:2a02:908:1086:27c0::84a] (unknown [IPv6:2a02:908:1086:27c0::84a])
        by srv.fail (Postfix) with ESMTPSA id 6DEFE152FA00;
        Wed,  2 Feb 2022 18:55:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=totally.rip;
        s=default; t=1643824524;
        bh=tKY+L9rXz/w/4qn0LxB3E1onA42Uup5e6XrmDn59YXk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=iQhOuZbD2IfdD7xLITpL73Qtz9xHCLNwa+bG/DDfpJd5bkcIf52YfiFDyasNJMWGk
         aWMAYNT2tjlXC+DsRJEJDdwOcyEcrVP4hk74Hbq8i+cM5uXmPUPDrN8s3PMrz/Vh1k
         c44YGnZRFETB6mmA2loKI5ni9Rq9P7aWN1xzaCh9OXPMPlqF39FsRjwM2QZEUZM+IY
         BgdpUlfejDscBDovufAWGX1FANnKwqZFiPiBuP7ktbNr1QKkD6os0x7Z21x16MBmoU
         1ewgBa2iyOWPwLyDyGGSbZVZp0QcJ5uH7mP2lZanG3rnRnuN8ctcDTw/t8aLCjYHx2
         VrnXtYjWvI4rg==
Message-ID: <9077941e-d1c6-0bfd-b0ec-5698d40fc677@totally.rip>
Date:   Wed, 2 Feb 2022 18:55:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: NULL pointer dereference in blk_queue_flag_set
Content-Language: en-US
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <a673c90f-d9eb-c6d5-b675-e6c2e1c04e5f@totally.rip>
 <CAPhsuW5H1uROu868FhS5MNXuP=nS_=6b8zUrFv4jBjPEA=joPQ@mail.gmail.com>
 <858fc88b-40fe-5bb4-e9be-e8b5f66ff562@totally.rip>
 <CAPhsuW5yfv_ahTwuGCNwgGwyFMpzBOSLwpQH=_PB+MH1zVx_fw@mail.gmail.com>
From:   jkhsjdhjs <jkhsjdhjs@totally.rip>
In-Reply-To: <CAPhsuW5yfv_ahTwuGCNwgGwyFMpzBOSLwpQH=_PB+MH1zVx_fw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Yes, I'd like that. Since I have never done that before I looked it up 
and it seems to me that you'll just add Reported-by and Tested-by to the 
commit message. In this case please use Reported-by: Leon Möller 
<jkhsjdhjs@totally.rip> and similar for the Tested-by line. Thanks!

Leon

On 02.02.22 17:57, Song Liu wrote:
> On Wed, Feb 2, 2022 at 4:50 AM jkhsjdhjs <jkhsjdhjs@totally.rip> wrote:
>> Hey Song,
>>
>> thanks for the quick reply! I applied your patch on top of 5.17-rc2 and
>> it fixes the issue:
>>
>> [   15.394670] device-mapper: raid: Loading target version 1.15.1
>> [   15.395216] device-mapper: raid: Ignoring chunk size parameter for RAID 1
>> [   15.395224] device-mapper: raid: Choosing default region size of 4MiB
>> [   15.399865] md/raid1:mdX: active with 2 out of 2 mirrors
>>
> That's great. Thanks!
>
> Would you like to attach Reported-by and Tested-by tag to the fix?
>
> Song
