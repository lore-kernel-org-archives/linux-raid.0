Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD3D4C433FE
	for <linux-raid@archiver.kernel.org>; Thu, 29 Sep 2022 15:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234951AbiI2PaZ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 29 Sep 2022 11:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234955AbiI2PaX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 29 Sep 2022 11:30:23 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7BF15FC0
        for <linux-raid@vger.kernel.org>; Thu, 29 Sep 2022 08:30:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1664465402; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=biJ83GScxFJr8icW5iXaTFbtMp20VL97zLzSiveZJeQMmG5aiMcihoHQh2auQ+unpM+TxOO4qn1qqnv6v8LcBZpjUiFeSu3NHWSIzabkr+LYiPHgzsjjYdGKfH7MzulInvSNdyt5p2eRiQQJg/Lpkv4YzUO8y7Ld7qPhnNgfm/g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1664465402; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=YB/tLXKKoQqlUFgmLLxbo8HSDRJ0k/Qr8bEBWPWC4y4=; 
        b=IdHH8blyyL+4lj06iQmsrtwFkU3DyetlugAIE/bOyuKdpxgrGof2+eGvBzAMbqYOHmreZTdn84jBudRtqjSUEu5lnJMwm6NHczNek5Q3VCSb3x0DoCRdY1z+DqXFaGHeBFGyH5VMNhMqD5VMz+AWNkSVM8rGz3oFAEjf0KAyedM=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-72-69-213-125.nycmny.fios.verizon.net [72.69.213.125]) by mx.zoho.eu
        with SMTPS id 1664465399004758.9350433426798; Thu, 29 Sep 2022 17:29:59 +0200 (CEST)
Date:   Thu, 29 Sep 2022 11:29:57 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v4 0/2] Mdmonitor improvements
Content-Language: en-US
To:     Coly Li <colyli@suse.de>
Cc:     Kinga Tanska <kinga.tanska@intel.com>, linux-raid@vger.kernel.org,
        pmenzel@molgen.mpg.de
References: <20220606103213.12753-1-kinga.tanska@intel.com>
 <08caf2f3-2223-fd3b-82f6-44fee597ddc8@trained-monkey.org>
 <523B910D-50B8-4F2A-9883-60F77B45A3F7@suse.de>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <ebcd9f22-8504-ec0e-2557-38d0bc7def2a@trained-monkey.org>
In-Reply-To: <523B910D-50B8-4F2A-9883-60F77B45A3F7@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/29/22 11:19, Coly Li wrote:
> 
> 
>> 2022年9月29日 23:08，Jes Sorensen <jes@trained-monkey.org> 写道：
>> Coly,
>>
>> I am curious why these are marked Changes-requested in patchwork as
>> there are no replies in the thread.
>>
>> https://patchwork.kernel.org/project/linux-raid/patch/20220907125657.12192-2-mateusz.grzonka@intel.com/
> 
> Hi Jes,
> 
> I noticed this too, and asked Mariusz offline why these patches disappeared from my delegation, and he didn’t know why neither. So I just continue to review this series regardless its patchwork state. This is something I am not familiar with, so the progress is a bit slow.

No worries, I changed the marking to under review.

Thanks,
Jes



