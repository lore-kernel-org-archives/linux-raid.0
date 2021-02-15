Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20885C433DB
	for <linux-raid@archiver.kernel.org>; Mon, 15 Feb 2021 04:06:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D848C64DA8
	for <linux-raid@archiver.kernel.org>; Mon, 15 Feb 2021 04:06:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhBOEF7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 14 Feb 2021 23:05:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35127 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbhBOEF6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 14 Feb 2021 23:05:58 -0500
Received: from mail-pj1-f70.google.com ([209.85.216.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <matthew.ruffell@canonical.com>)
        id 1lBV8L-0007be-V6
        for linux-raid@vger.kernel.org; Mon, 15 Feb 2021 04:05:14 +0000
Received: by mail-pj1-f70.google.com with SMTP id fv24so6754126pjb.9
        for <linux-raid@vger.kernel.org>; Sun, 14 Feb 2021 20:05:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VWBqI87tduJn9har2RYL9IFmen1Ulxt1xpKdHfRxynY=;
        b=jrLtwkisj5EH8HYtqIJHRL2hEt2+ZpzSu789coViPeQUqEeUPIRRCWDJMdnxqckJnN
         tHxciHo1ahSyc7LCogrMRA0yK5QQTGk5h0EvB2r3XVlg/zz+ecxD6rmczbI9yMMtNSnN
         Uirm2k8jK/ZwywI//Da9NDclQK5DJmkJ/yRFVXbK3D8roCiVw2HKXOf89ah1unFn8R1D
         g5AXjDstOJQHVEyVGTh3fyeqaIqnXLudRo4br2pZfEDz+Cl9FIcuHErt3kdfV7ItK/YC
         2sUfg8cJOoZ+tnFh7S8uhJMq6XHF3oJkFyz4w5G/r6whaAIKvn2h1ecMreAD2fLij24r
         6TOA==
X-Gm-Message-State: AOAM530WESj1Hibfx0NxnMq31SGpdemT/sea8hqihQh0zq8sqP34bvuV
        2wsYq7RbNp/iI4HOR56WvQSKoczNP8AvOZP96bX/RunjerxPXPY1Vk6g67fKIvrQvYxM8PRW8m6
        qfoF5+AMYGaWyEyEzb64n89oa/GVPbcW+/XWeb50=
X-Received: by 2002:a63:cd09:: with SMTP id i9mr112256pgg.407.1613361912520;
        Sun, 14 Feb 2021 20:05:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxIYlCag0+rDSGeEHzMxZ4EP+9A7e7hLqE9gcpLhLsyQCa0DhO4lyrBphZULT2YnCUtVzKFsw==
X-Received: by 2002:a63:cd09:: with SMTP id i9mr112235pgg.407.1613361912228;
        Sun, 14 Feb 2021 20:05:12 -0800 (PST)
Received: from [192.168.1.107] (222-152-178-139-fibre.sparkbb.co.nz. [222.152.178.139])
        by smtp.gmail.com with ESMTPSA id 194sm16168354pfu.165.2021.02.14.20.05.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Feb 2021 20:05:11 -0800 (PST)
Subject: Re: [PATCH V2 0/5] md/raid10: Improve handling raid10 discard request
To:     Xiao Ni <xni@redhat.com>, songliubraving@fb.com
Cc:     linux-raid@vger.kernel.org, colyli@suse.de,
        guoqing.jiang@cloud.ionos.com, ncroxon@redhat.com
References: <1612425047-10953-1-git-send-email-xni@redhat.com>
From:   Matthew Ruffell <matthew.ruffell@canonical.com>
Message-ID: <d86c7211-787f-ee34-d2c1-cf780ecd9322@canonical.com>
Date:   Mon, 15 Feb 2021 17:05:06 +1300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <1612425047-10953-1-git-send-email-xni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Xiao,

Thanks for posting the patchset. I have been testing them over the past week,
and they are looking good.

I backported [0] the patchset to the Ubuntu 4.15, 5.4 and 5.8 kernels, and I have
been testing them on public clouds.

[0] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1896578/comments/13

For performance, formatting a Raid10 array on NVMe disks drops from 8.5 minutes 
to about 6 seconds [1], on AWS i3.8xlarge with 4x 1.7TB disks, due to the 
speedup in block discard.

[1] https://paste.ubuntu.com/p/NNGqP3xdsc/

I have also tested the data corruption reproducer from my original problem 
report [2], and I have found that throughout each of the steps of formatting the 
array, doing a consistency check, writing data, doing a consistency check, 
issuing a fstrim, doing a consistency check, the /sys/block/md0/md/mismatch_cnt 
was always 0, and all deep fsck checks came back clean for individual disks [3].

[2] https://www.spinics.net/lists/kernel/msg3765302.html
[3] https://paste.ubuntu.com/p/5DK57TzdFH/

So I think your patches do solve the data corruption problem. Great job.

To try and get some more eyes on the patches, I have provided my test kernels to
5 other users who are hitting the Raid10 block discard performance problem, and
I have asked them to test on spare test servers, and to provide feedback on
performance and data safety.

I will let you know their feedback as it comes in.

As for getting this merged, I actually agree with Song, the 5.12 merge window
is happening right now, and it is a bit too soon for large changes like this. 
I think we should wait for the 5.13 merge window. That way we can do some more 
testing, get feedback from some users, and make sure we don't cause any more 
data corruption regressions.

I will write back soon with some user feedback and more test results.

Thanks,
Matthew
