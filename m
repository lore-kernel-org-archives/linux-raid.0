Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C39F3C6FD1C
	for <linux-raid@archiver.kernel.org>; Mon, 20 Mar 2023 22:25:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjCTWZU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Mar 2023 18:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbjCTWYz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Mar 2023 18:24:55 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A1C19C42
        for <linux-raid@vger.kernel.org>; Mon, 20 Mar 2023 15:24:28 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id a9so2398598oiw.2
        for <linux-raid@vger.kernel.org>; Mon, 20 Mar 2023 15:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679350983;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9QPEp9smik+lXTwno/wVQcIFLUgCOIyFNRNwk+MPiIM=;
        b=G/Mx7JRgKTBhJts9Xt9VNXzj1J5RlHj7BzCWRa2Ltu0GHg6vDSwghHuPdX1x1nPzm3
         YDnH9NRkSh4cLPnp/A5AbZ6FmwUNai+a1ZTCCUcpH4DetdfN01Iy7KXL9FMbpfM4K5fZ
         qWtUv5OPZiqK5bwgCzwQJ1r+RepoT/72Hf3eop6KU24Lk6hHrmA5eAwEB/8vtl62+GHq
         e4/ySReBig7sVJnYvFxleyGmzXZUATEnc5+GpDmtWI4cxLJH3KJT/fj3eZ4Kh2i/t7qr
         E/l8TlSHfm76ypGINAn8ORTCKiooGyHzfUbKe67FbH9X8x+arB9uuX7FjP2c5M4SzL29
         fBcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679350983;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9QPEp9smik+lXTwno/wVQcIFLUgCOIyFNRNwk+MPiIM=;
        b=CNl3p8QW3eA0p8iwZrWWew9nE3lAAaoGHn/L03E3uV88UKeKqTn4HJLIxzIsacWHXb
         hefqm6E+gnoSaWr8KE+DzeRJCx9kSa1aQJNAcvX0IJdt8poE3vVu6PNrkSZugQjemEXW
         P3WLoeaFyCaUqMxWaBJz8fKU5OeI9nzEdeDeHjQDqMcs30Vn2iMcd5Hx5ZkFvX2PJPF0
         4KbOnGU8L0nZTKq5lc86WekW0shzrANgjKfPzv+Gt+UWoWb8EU4NbLO4wpLTYONAAy01
         eQ2pbiUZVis+4+J9oC78EpZNeVy83DGGdbcG+Iy091wmnAciKiGcTHYj2J4tCrHTSloM
         RUwg==
X-Gm-Message-State: AO0yUKWm/86D2GQ+Y2AsxIZmt+Pj897TtRnVH0tZXnfjPBKb7oIdTqfR
        xyloXNijhlU50GOyZWjhNwk=
X-Google-Smtp-Source: AK7set//hlA/taBf1McXZt52ckByhS66NmxAlSqbT8hGuaGK0UinYT8ujjVtBlA8JMoFaAI6gzUjkg==
X-Received: by 2002:aca:6709:0:b0:386:a77d:862 with SMTP id z9-20020aca6709000000b00386a77d0862mr10906oix.38.1679350983140;
        Mon, 20 Mar 2023 15:23:03 -0700 (PDT)
Received: from [192.168.3.92] ([47.189.247.51])
        by smtp.gmail.com with ESMTPSA id f204-20020a4a58d5000000b0053b547ebee7sm218575oob.1.2023.03.20.15.23.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 15:23:02 -0700 (PDT)
Message-ID: <e85fed01-f50f-21da-d09f-fa40da35ef7a@gmail.com>
Date:   Mon, 20 Mar 2023 17:23:02 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Renaming md raid and moving md raid to a different machine.
Content-Language: en-US
To:     Reindl Harald <h.reindl@thelounge.net>,
        Wol <antlists@youngman.org.uk>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <f237651e-536a-e305-8c1c-475e4c14d906@gmail.com>
 <97945e22-f0d4-96d7-ef66-284ae6f8b016@gmail.com>
 <7037738d-05e3-b277-61ed-37f66cfdef7e@youngman.org.uk>
 <671da160-d5b3-8ed1-f7c1-672fa587ecad@gmail.com>
 <029ada0e-2b85-8999-007b-65f3bfdbc034@youngman.org.uk>
 <c4f58d3f-57a8-81ce-5a04-47744504a648@gmail.com>
 <86bd2ef7-64f8-70c9-96a2-47bd3915bea6@thelounge.net>
From:   Ram Ramesh <rramesh2400@gmail.com>
In-Reply-To: <86bd2ef7-64f8-70c9-96a2-47bd3915bea6@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/20/23 03:35, Reindl Harald wrote:
> 
> 
> Am 20.03.23 um 01:34 schrieb Ram Ramesh:
>> Yes the names must be in the metadata of the md because I populate 
>> mdadm.conf after every change by actually using the output from mdadm 
>> --detail -scan. Since that comes up with md0/md1/md2, I assume somehow 
>> mdadm simply finds them again and again with exact same name.
>>
>> I do not ever get md127
> 
> no - your mdadm.conf is in the initrd because how else should the rootfs 
> could live on the array containing mdadm.conf

Agreed.  After I moved the rootfs of the old system to new hardware (a 
new machine with is two nvme raid1), I booted into it and it did show 
that the rootfs is on md127. However, after making mdadm.conf entries 
and update-initramfs, md name changed to /dev/md0. So, it must be what 
you said.

Regards
Ramesh

