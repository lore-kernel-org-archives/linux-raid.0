Return-Path: <SRS0=8aTj=CH=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5EF3C433E6
	for <linux-raid@archiver.kernel.org>; Sat, 29 Aug 2020 20:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C25720776
	for <linux-raid@archiver.kernel.org>; Sat, 29 Aug 2020 20:45:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XnmGqSmF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbgH2UpP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 29 Aug 2020 16:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728416AbgH2UpK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 29 Aug 2020 16:45:10 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD26C061573
        for <linux-raid@vger.kernel.org>; Sat, 29 Aug 2020 13:45:09 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id a65so2198794otc.8
        for <linux-raid@vger.kernel.org>; Sat, 29 Aug 2020 13:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=IdwBKz6YsLLS2FFP1+vzQ0JGJsaXgOVr8gG0WX5qJag=;
        b=XnmGqSmF1AduA6ycKALc8SfB1hVrPVh/63n5HrHWBHkODJtoJ1nEl3j7REPpsHfLO7
         mV82hrs+40m8PFWBV/QVPeYVqgPzI/d4/fXRbbWL8GB69KTXtpU6MFWX+NY1rUlWzBWM
         lktamNr5r6vbScKpVmbfGbRCXtFZde323zMK2rafDb0V38ShniTGrH9S1de1t6T1AC4z
         9Q0Y+gswSOUSfVpDPMOWNo6iMbtM/hvNwCKvYAP1gdkCsB5iAKZEEfuXsFARHOFTxG8M
         p2z0C6l/OUnZHN0eZuJxTzb87yGDhcWvELIg5cQPCPj2x2o57/OVe6AY3b0CZJJTDqPd
         FDpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=IdwBKz6YsLLS2FFP1+vzQ0JGJsaXgOVr8gG0WX5qJag=;
        b=WGccT1zQmUZhaehSzN7EF44B79IVEnsTbdR30ZBPGeVKF64XMrMGmsCNIokTAwBNMo
         8Can1r2VOR03xWOs+hBhsLeMsrzJhjBMkhly6GQfsqCx9CL+40llLcRrzxBNETQDdU3s
         o43tbH6dDQuF2+2SfTEuAtYE5NJn3ohZwpgCul6jE1H8k4sHxMVNLfYLkriOpmrOzqQL
         0Xc49rMZ0E7pAcJSploVBut0JoFzDP/pNOdMgOehtwmyiGBwZSxRNxFhtA6Ho8gQRR/f
         O/3szrSQxiUouhqMG7dOQLAPJaA84kfYgL6UhGhR8iRu2g4m2+sOVq1JxUH+P3vDN9MB
         K32Q==
X-Gm-Message-State: AOAM533h8vXr9heGDoiXnTk51FEk96P4x4EifWWNOuCp6iN7FNu+0Y4d
        D8Y/U+0slbJIRG5coX4A9nBYZokLR+qoXg==
X-Google-Smtp-Source: ABdhPJyNG5/XalGtgP9h6ScseGY6uxEygAbCCXFXC43YWhU4jOgpQlMui3+yyDZd5eNhSTAtUW7gSQ==
X-Received: by 2002:a9d:850:: with SMTP id 74mr1968219oty.29.1598733905793;
        Sat, 29 Aug 2020 13:45:05 -0700 (PDT)
Received: from [192.168.3.65] ([47.187.193.82])
        by smtp.googlemail.com with ESMTPSA id k23sm691801oig.28.2020.08.29.13.45.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Aug 2020 13:45:05 -0700 (PDT)
Subject: Re: Best way to add caching to a new raid setup.
To:     Roger Heflin <rogerheflin@gmail.com>,
        Roman Mamedov <rm@romanrm.net>
Cc:     antlists <antlists@youngman.org.uk>,
        "R. Ramesh" <rramesh@verizon.net>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
 <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
 <20200828224616.58a1ad6c@natsu>
 <448afb39-d277-445f-cc42-2dfc5210da7b@gmail.com>
 <6a9fc5ae-1cae-a3d6-6dc3-d1a93dc1e38e@youngman.org.uk>
 <20200829205735.58dfcda1@natsu>
 <CAAMCDedK0WFpA9-p9tBMk7vzymUJMMm9nekJTPK9N0hLDUc=ng@mail.gmail.com>
From:   Ram Ramesh <rramesh2400@gmail.com>
Message-ID: <149cd0bc-7679-d9d3-e49a-1484aa9433bc@gmail.com>
Date:   Sat, 29 Aug 2020 15:45:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAAMCDedK0WFpA9-p9tBMk7vzymUJMMm9nekJTPK9N0hLDUc=ng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/29/20 11:26 AM, Roger Heflin wrote:
> I use mdadm raid.  From what I can tell mdadm has been around a lot
> longer and is better understood by a larger group of users.   Hence if
> something does go wrong there are a significant number of people that
> can help.
>
> I have been running mythtv on mdadm since early-2006, using LVM over
> top of it.  I have migrated from 4x500 to 4x1.5tb and am currently on
> 7x3tb.
>
> One trick I did do on the 3tb's is I did partition the disk into 4
> 750gb partitions and then each set of 7 makes up a PV.  Often if a
> disk gets a bad block or a random io failure it only takes a single
> raid from +2 down to +1, and when rebuilding them it rebuilds faster.
> I created mine like below:, making sure md13 has all sdX3 disks on it
> as when you have to add devices the numbers are the same.  This also
> means that when enlarging it that there are 4 separate enlarges, but
> no one enlarge takes more than a day.  So there might be a good reason
> to say separate a 12tb drive into 6x2 or 4x3 just so if you enlarge it
> it does not take a week to finish.   Also make sure to use a bitmap,
> when you re-add a previous disk to it the rebuilds are much faster
> especially if the drive has only been out for a few hours.
>
> Personalities : [raid6] [raid5] [raid4]
> md13 : active raid6 sdi3[9] sdg3[6] sdf3[12] sde3[10] sdd3[1] sdc3[5] sdb3[7]
>        3612623360 blocks super 1.2 level 6, 512k chunk, algorithm 2
> [7/7] [UUUUUUU]
>        bitmap: 0/6 pages [0KB], 65536KB chunk
>
> md14 : active raid6 sdi4[11] sdg4[6] sdf4[9] sde4[10] sdb4[7] sdd4[1] sdc4[5]
>        3612623360 blocks super 1.2 level 6, 512k chunk, algorithm 2
> [7/7] [UUUUUUU]
>        bitmap: 1/6 pages [4KB], 65536KB chunk
>
> md15 : active raid6 sdi5[11] sdg5[8] sdf5[9] sde5[10] sdb5[7] sdd5[1] sdc5[5]
>        3612623360 blocks super 1.2 level 6, 512k chunk, algorithm 2
> [7/7] [UUUUUUU]
>        bitmap: 1/6 pages [4KB], 65536KB chunk
>
> md16 : active raid6 sdi6[9] sdg6[7] sdf6[11] sde6[10] sdb6[8] sdd6[1] sdc6[5]
>        3615495680 blocks super 1.2 level 6, 512k chunk, algorithm 2
> [7/7] [UUUUUUU]
>        bitmap: 0/6 pages [0KB], 65536KB chunk
>
>
>
> On Sat, Aug 29, 2020 at 11:00 AM Roman Mamedov <rm@romanrm.net> wrote:
>> On Sat, 29 Aug 2020 16:34:56 +0100
>> antlists <antlists@youngman.org.uk> wrote:
>>
>>> On 28/08/2020 21:39, Ram Ramesh wrote:
>>>> One thing about LVM that I am not clear. Given the choice between
>>>> creating /mirror LV /on a VG over simple PVs and /simple LV/ over raid1
>>>> PVs, which is preferred method? Why?
>>> Simplicity says have ONE raid, with ONE PV on top of it.
>>>
>>> The other way round is you need TWO SEPARATE (at least) PV/VG/LVs, which
>>> you then stick a raid on top.
>> I believe the question was not about the order of layers, but whether to
>> create a RAID with mdadm and then LVM on top, vs. abandoning mdadm and using
>> LVM's built-in RAID support instead:
>> https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/logical_volume_manager_administration/mirror_create
>>
>> Personally I hugely prefer mdadm, due to the familiar and convenient interface
>> of the program itself, as well as of /proc/mdstat.
>>
>> --
>> With respect,
>> Roman
Roger,

    Good point about breaking up the disk into partitions and building 
same numbered partition in to a raid volume. Do you recommend this 
procedure even if I do only raid1? I am afraid to make raid6 over 4x14TB 
disks. I want to keep rebuild simple and not thrash the disks each time 
I (have to) replace one. Even if I split into 3tb partitions, I replace 
one disk all of them will rebuild and it will be a seek festival. I am 
hoping simplicity of raid1 will be more suited when expected URE size is 
smaller than a single disk capacity. I like the +2 redundancy of raid6 
over +1 raid1 (not doing raid1 over 3 disks as I fee that is a huge waste)

Regards
Ramesh
