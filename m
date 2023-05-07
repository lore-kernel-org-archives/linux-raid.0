Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48C0DC77B75
	for <linux-raid@archiver.kernel.org>; Sun,  7 May 2023 01:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjEGB3k (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 6 May 2023 21:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjEGB3k (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 6 May 2023 21:29:40 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163433A8F
        for <linux-raid@vger.kernel.org>; Sat,  6 May 2023 18:29:36 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id ca18e2360f4ac-76355514e03so252650339f.0
        for <linux-raid@vger.kernel.org>; Sat, 06 May 2023 18:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google; t=1683422975; x=1686014975;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iixviUqA4SH/jXlGp8BZH7nMPIu2wSinabUjYtLmRQE=;
        b=NH7FjMvAhDXdJnXwYXuyaLOFryHbkpkcBDHZHJaBtv6V56bMRqLGJthXoUgTOmCFU0
         ym1nAvz5pwOoZsnx0t68EwbjuA4cW4yak5V6qpQa4j4nihqQds4R5B3Mp4wMXa96j/Vt
         XuWTZKiDxIEaCvw8tP8aOd78yja7/SrNdZkAU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683422975; x=1686014975;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iixviUqA4SH/jXlGp8BZH7nMPIu2wSinabUjYtLmRQE=;
        b=PONemYkIcFPi5LrfiO5/re1jX1C0C5w85wFRbNAg1IgJxnUUGctuWM9DYED5e7aucj
         /7OX66M0hN2QBW6BWkf7yqT72ou6j/TvUEbQAJo8Z0vYvRH44FHariwISdok0IgZQI4k
         RBWh7dtFw8xTPskFYIjQL/kJ7gzaOr54C3aTabgIK7L8Xe7a8tVCNCGUYyvu/cEsJ6g9
         pyvTYO9nsnOL7UqIQ4tCAWWimrQNiPzPCSFs+w6P8dSL3pwtl26BEWcpjAWP6TRfCkaL
         yXd9ieLBR7Rw3rZKBGAJV5kgu1bqEBm0a/HnTJmm0IgIIV34dvT5rel0nHmSIfvyI/9e
         1WBQ==
X-Gm-Message-State: AC+VfDzRfwIX47APxgtK1qwWvSZqtR+IthzFTcOIf1SwGU6A6Bnb0pTP
        2YlCbcThw3aheEseLtqH0mZxoEcCJsjwNBlSbEE=
X-Google-Smtp-Source: ACHHUZ71c9UwYX6HMRnGQCHmGibEFE/Rbn4BcDQU7pHV+O7fUGQz60YK1kWQb3f4xmDBki4pmRiwTQ==
X-Received: by 2002:a5d:8984:0:b0:763:684d:7f11 with SMTP id m4-20020a5d8984000000b00763684d7f11mr4133111iol.5.1683422975435;
        Sat, 06 May 2023 18:29:35 -0700 (PDT)
Received: from [10.211.55.3] ([98.61.227.136])
        by smtp.googlemail.com with ESMTPSA id m3-20020a6b7b43000000b007635e44126bsm1090893iop.53.2023.05.06.18.29.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 May 2023 18:29:34 -0700 (PDT)
Message-ID: <8f046b28-f187-66d8-f67c-3e5821f66e92@ieee.org>
Date:   Sat, 6 May 2023 20:29:23 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Second of 3 drives in RAID5 missing
To:     Wol <antlists@youngman.org.uk>, Hannes Reinecke <hare@suse.de>,
        linux-raid@vger.kernel.org
References: <d11acbac-a31b-b38c-8e10-b664ec52a47b@ieee.org>
 <7605c54f-670a-a804-b238-627cd561ce52@suse.de>
 <0b5a2849-90ec-573c-03ed-0847135a4e9d@youngman.org.uk>
Content-Language: en-US
From:   Alex Elder <elder@ieee.org>
In-Reply-To: <0b5a2849-90ec-573c-03ed-0847135a4e9d@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/6/23 6:28 PM, Wol wrote:
> 
> 
> On 06/05/2023 23:29, Hannes Reinecke wrote:
>>>     Device Role : Active device 2
>>>     Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
>>> root@meat:/#
>>>
>> mdadm manage /dev/md127 --add /dev/sdd ?
> 
> OMG NO!
> 
> That really will trash your array ...
> 
> Cheers,
> Wol

This is why I sent the original message; I really
want to avoid losing my data because of a dumb
misunderstanding.  I did look at the Linux_Raid
page on raid.wiki.kernel.org but was not confident
I knew the right thing to do.  I'm very familiar
(as a developer) with storage software, just not
MD and the tools to manage its volumes.

I suspect that putting a proper MD superblock on the
middle partition (sdc1, out of sd{b,c,d}1) might be
enough to get it to assemble again.  After that I
think I'll be able to rebuild the newly replaced
drive and also rename it to /dev/md/z.

Is it an easy command?  Is any more information required?

Thanks.

					-Alex
