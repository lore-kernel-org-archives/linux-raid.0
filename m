Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B6AC2D0E4
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 03:18:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 704AF20782
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 03:18:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NzLu3icn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgKYDSe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 24 Nov 2020 22:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbgKYDSd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 24 Nov 2020 22:18:33 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4B9C0613D4
        for <linux-raid@vger.kernel.org>; Tue, 24 Nov 2020 19:18:33 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id 79so958198otc.7
        for <linux-raid@vger.kernel.org>; Tue, 24 Nov 2020 19:18:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=YE8ZcsJgo6Am6N4+KvwGTW04+nmWc4gaZbTKX8mJpls=;
        b=NzLu3icn8GlfYX1BKOoW2Xhc6OAENfwc5EuyXQxcHrL5qtiEndLJFvniKpAZRWFilK
         wv8bCo3VfXZG3jGIcv+ZhCgrSlFhopOn0cjTQu62nbkHbzRN7jXrxOQ9hHopV2Yo9clC
         G+ZX+FOc2qM/yYsO6t6Ic6qi6Y8umyuBFxfUyEx077Aze2oIrbsVX36SQvfhQv9vhdaz
         bM6AF5KZ/7zuH/adLtlMmob/UvMiwstqx/Mui3o7eCKpVx5SwitFNWBrYH3mx1J0+P9t
         p+ZloLuj9fM9S9ILrzXzbAwCn1wxl/DuBclkB4W1wBqwY807pBzvFxyRg2vIQIc7KY9X
         60Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=YE8ZcsJgo6Am6N4+KvwGTW04+nmWc4gaZbTKX8mJpls=;
        b=bR18KtSCto07LpAYvLvRmE1f33YY62EfX7E7u6VgjyWe6PcYGsWNhsDdFeCKWft6VP
         WWMpW4rJGUcH5KwIfygY2kOqRdiIbfAB6W7G2r0bapS6gIiofFJv4bTjzd6/Nbtdgqau
         Z+TF6qyzHYWhWNEZmaGOXUVWuqgLlmGkFtYl/xRyPeuAa9rcUaR9fEsV2BoIzFOTcVfB
         k7MMkfZkTDMR9uKdbhF6IbbVnjojYojsM4GfqOoLuFzlhy32FIPZkxnIqX4BlOEZcukq
         eL85W3QxJrPP+bilGVm2/rq9PjeeJhJ4JbOoSKXM9SYWitqbvrR1DcU/1IYkdC2GF2co
         m83A==
X-Gm-Message-State: AOAM532cEKmO4aVjviHu4yTW9PS6Jxlw9B/jI0ftF2+KVZvIXtr6jiRN
        htY8pnqMZuQOfP3BOs02951tgTLVChk=
X-Google-Smtp-Source: ABdhPJxG44W5LFgCPHSIxX2ZK/g3FzX2HkhMxv9dC9o0LkCUjaqzuNwNqttnDHImFo3Lt8vGRslxWg==
X-Received: by 2002:a05:6830:3109:: with SMTP id b9mr1401709ots.364.1606274312196;
        Tue, 24 Nov 2020 19:18:32 -0800 (PST)
Received: from [192.168.3.75] ([47.187.193.82])
        by smtp.googlemail.com with ESMTPSA id a25sm652025oos.23.2020.11.24.19.18.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 19:18:31 -0800 (PST)
Subject: Re: Considering new SATA PCIe card
To:     Alex <mysqlstudent@gmail.com>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <CAB1R3sgQm2_-Bhbzned4y056XP5hM9oz1OnTZSfHH9+L5sdpFQ@mail.gmail.com>
 <c629eb5c-ee37-a7fc-6ffb-8035945e5f16@gmail.com>
 <CAB1R3sgK3cmqhNM-PcMP88yhFV6mgQwdVYOkUbf4N1aM-BB9sw@mail.gmail.com>
From:   Ram Ramesh <rramesh2400@gmail.com>
Message-ID: <25741f58-676a-c4ef-7463-31b5b3a08bc5@gmail.com>
Date:   Tue, 24 Nov 2020 21:18:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAB1R3sgK3cmqhNM-PcMP88yhFV6mgQwdVYOkUbf4N1aM-BB9sw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/24/20 9:14 PM, Alex wrote:
> Hi,
>
> On Tue, Nov 24, 2020 at 9:47 PM Ram Ramesh <rramesh2400@gmail.com> wrote:
>> On 11/24/20 8:20 PM, Alex wrote:
>>> Hi, I have a fedora33 server with an E31240 @ 3.30GHz processor with
>>> 32GB that I'm using as a backup server with 4x4TB 7200 SATA disks in
>>> RAID5 and 2x480GB SSDs in RAID1 for root. The motherboard has two
>>> SATA-6 ports on it and the others are SATA3.
>>>
>>> Would there really be any benefit to purchasing a new controller such
>>> as this for it instead of the onboard for the 4x4TB disks?
>>> https://www.amazon.com/gp/product/B07ST9CPND/
>>>
>>> The server is relatively responsive, but I was just wondering if I
>>> could keep it running for a few more years with a faster SATA
>>> controller.
>>>
>>> I'm also curious if the SATA cables have improved over time, or are
>>> the same cables I purchased five years ago just as good today?
>> If plan to use addon cards, please consider LSI SAS9211-8i cards. Well
>> supported and reliable.
> Oh yes, how quickly I forgot. I actually have one of these in another
> server, but I think it's too long to physically fit in the case. Just
> to be sure, this is the card you're referencing, right?
>
> https://www.ebay.com/itm/LSI-SAS-9211-8i-8-port-6G-IT-Raid-Card-ZFS-JBOD-HBA-SAS-SATA6-0-2008-8I/143735992677
Yes. Any one of those that mentions this controller and preferably IT 
(just HBA) firmware instead of IR (Raid) firmware as your raid will be 
implemented as SW mdraid over JBOD.

Regards
Ramesh

