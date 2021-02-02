Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13051C433DB
	for <linux-raid@archiver.kernel.org>; Tue,  2 Feb 2021 03:43:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0C7964ECB
	for <linux-raid@archiver.kernel.org>; Tue,  2 Feb 2021 03:43:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbhBBDnO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 1 Feb 2021 22:43:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59291 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhBBDnM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 1 Feb 2021 22:43:12 -0500
Received: from mail-pj1-f72.google.com ([209.85.216.72])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <matthew.ruffell@canonical.com>)
        id 1l6maE-0003HJ-7O
        for linux-raid@vger.kernel.org; Tue, 02 Feb 2021 03:42:30 +0000
Received: by mail-pj1-f72.google.com with SMTP id b4so915260pji.4
        for <linux-raid@vger.kernel.org>; Mon, 01 Feb 2021 19:42:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2QyTMXw4YiHlxPz2TDd2N4/mAS03FpHnAiVRaHpKfIA=;
        b=qPSoGKqE1Kmry7q4glsi3J7zk2FHyibDWDoKYWhLfE8618X5iS4at1fuiKDsPafFPW
         h2t0yEjMZ+430UPz1TBSCzV30x++jy2MRDBVaW4qSx3N86S8fAFXvPG/qbErBcL6lCoH
         aGrKhixmPoxMGFHkLTnRnniV1MUWxSdI7MKVdeUc9nuTE2b2znEo3heHaUPMz7tciDko
         bpDP7DJCg4wnLA4L5JFb5Q5vJdYQsQJt94xZKSZh0K1A1Pp3gYN6Bgna3nNiXr2rj15L
         9kSuGwNRYY0Y6D5dynlk+GdcP86AT3yRiKWDFlzStVR+/BalsZdGuiXBtgWU276wHKx5
         RV9g==
X-Gm-Message-State: AOAM530fTfBULiuxFPWyLpY+EBgtB8ttkYvA8CLLvWDQbnZS8lZNGNTl
        awzIfgxTHrRjYd4xDhNrGe5ZhPxkS4rwDtY2NgmRTfx5crh6f9z6jrJyrkrx82Rh9PTuxtn7UMX
        LSKq7C39VlR/BDxWrOM4SvkqsoFqFmldpZ3xLM9Y=
X-Received: by 2002:a17:90a:404c:: with SMTP id k12mr2138849pjg.4.1612237348963;
        Mon, 01 Feb 2021 19:42:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx834fiNaEy+R1eVZYa/eRSW+Yvfpm6YMyU3WX/PvjMIX6VuCJWuo0XxR24SAFwXqKnIM75ig==
X-Received: by 2002:a17:90a:404c:: with SMTP id k12mr2138827pjg.4.1612237348614;
        Mon, 01 Feb 2021 19:42:28 -0800 (PST)
Received: from [192.168.1.107] (222-152-178-139-fibre.sparkbb.co.nz. [222.152.178.139])
        by smtp.gmail.com with ESMTPSA id ck10sm965775pjb.3.2021.02.01.19.42.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 19:42:27 -0800 (PST)
Subject: Re: PROBLEM: Recent raid10 block discard patchset causes filesystem
 corruption on fstrim
To:     Xiao Ni <xni@redhat.com>, Song Liu <songliubraving@fb.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Song Liu <song@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Coly Li <colyli@suse.de>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        "khalid.elmously@canonical.com" <khalid.elmously@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
References: <dbd2761e-cd7d-d60a-f769-ecc8c6335814@canonical.com>
 <EA47EF7A-06D8-4B37-BED7-F04753D70DF5@fb.com>
 <a85943ed-60d4-05ad-9f6d-d76324fa5538@redhat.com>
From:   Matthew Ruffell <matthew.ruffell@canonical.com>
Message-ID: <71b9c9df-93a8-165a-d254-746a874f2238@canonical.com>
Date:   Tue, 2 Feb 2021 16:42:20 +1300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <a85943ed-60d4-05ad-9f6d-d76324fa5538@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Xiao,

On 24/12/20 11:18 pm, Xiao Ni wrote:> The root cause is found. Now we use a similar way with raid0 to handle discard request
> for raid10. Because the discard region is very big, we can calculate the start/end address
> for each disk. Then we can submit the discard request to each disk. But for raid10, it has
> copies. For near layout, if the discard request doesn't align with chunk size, we calculate
> a start_disk_offset. Now we only use start_disk_offset for the first disk, but it should be
> used for the near copies disks too.

Thanks for finding the root cause and making a patch that corrects the offset
addresses for multiple disks!

> 
> [  789.709501] discard bio start : 70968, size : 191176
> [  789.709507] first stripe index 69, start disk index 0, start disk offset 70968
> [  789.709509] last stripe index 256, end disk index 0, end disk offset 262144
> [  789.709511] disk 0, dev start : 70968, dev end : 262144
> [  789.709515] disk 1, dev start : 70656, dev end : 262144
> 
> For example, in this test case, it has 2 near copies. The start_disk_offset for the first disk is 70968.
> It should use the same offset address for second disk. But it uses the start address of this chunk.
> It discard more region. The patch in the attachment can fix this problem. It split the region that
> doesn't align with chunk size.

Just wondering, what is the current status of the patchset? Is there anything
that I can do to help? 

> 
> There is another problem. The stripe size should be calculated differently for near layout and far layout.
> 

I can help review the patch and help test the patches anytime. Do you need help
with making a patch to calculate the stripe size for near and far layouts?

Let me know how you are going with this patchset, and if there is anything I
can do for you.

Thanks,
Matthew

> @Song, do you want me to use a separate patch for this fix, or fix this in the original patch?
> 
> Merry Christmas
> Xiao
> 
