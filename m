Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB427C6FD1F
	for <linux-raid@archiver.kernel.org>; Sun, 19 Mar 2023 18:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjCSS6p (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 19 Mar 2023 14:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjCSS6n (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 19 Mar 2023 14:58:43 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957A61ABF8
        for <linux-raid@vger.kernel.org>; Sun, 19 Mar 2023 11:58:41 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id x22-20020a056830409600b0069b30fb38f7so5663731ott.5
        for <linux-raid@vger.kernel.org>; Sun, 19 Mar 2023 11:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679252321;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h8gi0Sx95U9sxH8+ztTyhwo4Vx5QgLBI65NQfgDcp7A=;
        b=dlavt5EnW9FPE5lcvtAYQQzAGsmLNK/jPOxjCZbSP3ApIMU2KcDEtZr4OIS5TeRaPJ
         xM11KwfT3iwZe0ndhdsT1UAkJEFt515tEoRuEzdAkV9Hg68RMQ3PbMhd3Bhh1TvaFth/
         tUUO9b3tXR/s7KK+3wV7Y++WMsjl37ZgBiIm9HohYX8KC09e63+kxaU522CtXCAsf+fP
         fyZ8289zICsXs4awt+l772BDRaNSrS02Glsdnz5AyFbcFgmDSX2o8Xi1vQ8qg5RTiTQT
         9goQ7GZaV5OpsTDfShNMdmyp3M0zq1lkIjVJiSAy9emnPWBbf6crVfIz8/k6r9in++K5
         r8OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679252321;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h8gi0Sx95U9sxH8+ztTyhwo4Vx5QgLBI65NQfgDcp7A=;
        b=62oYPuPlSgkdzU4CZNO7UCwb2KR0jf73AqQXY4rOyzxr4P6BK0INSqvGtrOmEC8Hvd
         NpKtGP02PPW34n5jF7DM/B4sc9A/LNz/ek0Jq899/cU5eLwnTeUhTJ3UTibIuiSiaAtH
         6mf5gvRt+zRXgppWXLd56KxUAr8SmWfJi1ZNzx1Gi2xpaiL7eVxRTe0YVPB1haY8yNUK
         w2YTCUiiz+EGxdqZdORb7AL0arEILB56zY3V5IlTKLAFI5cGceAU7s94MDlG7sjnu3tF
         /Hc7lKaviFVuvcsuY8iDC0SdnwoD8adlR1VvuqI79R1LCUAe51FqZuMLj80kAAIoj3WY
         fDCA==
X-Gm-Message-State: AO0yUKViYkwVy275wo6MqOBWm9N9dZlYNOmTXlJ4jgl3CI4mQ594rvpF
        wBMh0p3XQOMAwibS+oAb0MzrqnyQNpk=
X-Google-Smtp-Source: AK7set/Y1ve9eKcrDkOS6FiEAnyL8wlrTq1W5GN5PexWRbGv00DBGHpijelOTMIehPA5xORjHTywEA==
X-Received: by 2002:a05:6830:22cd:b0:69d:2629:fe5d with SMTP id q13-20020a05683022cd00b0069d2629fe5dmr3005024otc.37.1679252320851;
        Sun, 19 Mar 2023 11:58:40 -0700 (PDT)
Received: from [192.168.3.92] ([47.189.247.51])
        by smtp.gmail.com with ESMTPSA id f15-20020a9d5f0f000000b0068bd6cf405dsm977004oti.1.2023.03.19.11.58.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Mar 2023 11:58:40 -0700 (PDT)
Message-ID: <97945e22-f0d4-96d7-ef66-284ae6f8b016@gmail.com>
Date:   Sun, 19 Mar 2023 13:58:40 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Renaming md raid and moving md raid to a different machine.
Content-Language: en-US
From:   Ram Ramesh <rramesh2400@gmail.com>
To:     Linux Raid <linux-raid@vger.kernel.org>
References: <f237651e-536a-e305-8c1c-475e4c14d906@gmail.com>
In-Reply-To: <f237651e-536a-e305-8c1c-475e4c14d906@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

   My primary DVR is old and I need to move it to more recent hardware. 
I have two md raids (a raid1 and another raid6) called /dev/md0 and 
/dev/md1. I plan to have root on the new machine on raid1 and thus I 
like to rename my /dev/md0 to /dev/md1 in the old machine before I move 
it to the new machine. After that I want to move the disks in the most 
recommended way to minimize the chance of loss.

   Since the data is large and usually contains recordings and videos 
that have backup on Hulu/Ultraviolet, I worry less about backup. Still 
it will be big task to repopulate all my data from the source and 
therefore prefer not to do stupid things and loose the data.

  Online search showed me a way to rename using just mdadm.conf and that 
did not work at all. In fact it messed up my raid6 that I had a panic 
for a short time. Luckily, I got everything back working normally. So, I 
am not sure which one of the online instructions to follow to rename my 
/dev/md0 to /dev/md1 before the move. So, I thought best to ask here.

   Also, once I renamed /dev/md0 to /dev/md1, I want to move all 6 disks 
in raid6 to the new machine. What is the correct procedure so that after 
the movement, I will be able to reboot both the old machine without 
raid6 (ie /dev/md1)and the new machine with the moved disks as /dev/md1? 
Ideally, I like to teach my old machine to forget /dev/md1 that I want 
to move and not touch the disks. If I do not do that, I am afraid my 
reboot (of the old machine) will get stuck at some point trying to look 
for the missing disks/md. All online tutorial talks about how to 
assemble on new machine. Does not talk about gracefully removing an md 
from an old machine. I want to know if there is any trick to this other 
than shutting down and pulling all disks and rebooting.

   Old host runs debian bullseye (linux 5.19, mdadm v4.1) and new will 
run debian testing/bookworm (linux 6.1,  mdadm v4.2).  Let me know if 
you need anymore information.

Thanks and Regards
Ramesh

