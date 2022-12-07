Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 414E6C63705
	for <linux-raid@archiver.kernel.org>; Wed,  7 Dec 2022 23:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiLGXIm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 7 Dec 2022 18:08:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiLGXIj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 7 Dec 2022 18:08:39 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77487F883
        for <linux-raid@vger.kernel.org>; Wed,  7 Dec 2022 15:08:36 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id e7-20020a17090a77c700b00216928a3917so2860590pjs.4
        for <linux-raid@vger.kernel.org>; Wed, 07 Dec 2022 15:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8cz7FtbLCIk84E/qnSv5m0mZi4Cb+DIbSaYsI85FKRg=;
        b=z0pu25Bh6lANc0vEMiG/HKWj9wjGOe0DGZ9yVvU+wlDuUwFfWTPOgmTMc04vdyWrDK
         xxyeRrGHYPWLBTA64PeNhooNwo5IemAT07uSptNGLPWmGOcpvPG+CCRIo58YgA0xxT8/
         zrvKfmswk1mUxWDgjzwvgojydqQVXozavA4U18EgKwoZOQ5gSqfykxY7aPYx5eDXS87F
         JA2DyJq8WGcotbiLTGXd0UOrjYZcUFZWzF4mhOiVSCjUaPWPFwOUNmHpIdMs9slp3YTz
         lhVdxatG4h6NP3Uhf/eRKQ6Gr8h5dn4VhYsEO0jfyl9vgBGAqzBmbwAPHc0WSmiwp+Dv
         2znQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8cz7FtbLCIk84E/qnSv5m0mZi4Cb+DIbSaYsI85FKRg=;
        b=WZC18CVAk2xALQ3/10UPC4jeFbPiAsvlRRHfuI8QT1DCO/mA92wdeJ6NvX6Dr4eJOv
         tLA7mE636s41i9fJ4/waV6Z/WoexrLQp9t2JgPTd7Hm4qXYbKZOP+UdN0P2vFJR1aGNu
         2mFxaSLLvdtkvFgfMi7GQb0dhRosBUOWK0iOmfAHJA+iIV237glqH9+0g77ERyZ3RvjM
         xJP8L0roC2aOJH0xU8Z5jgTaQM3GGtjLKFwUTDtu99x3C3svbTPW5bg1R0pIssJsnuzk
         pEPNcqm8V0SbGYqZ4mxFhafxqVc7pMHH8dq3DjP3HE5wsnP2x2T8cKwgi7IMwYzvq6Nk
         VFlw==
X-Gm-Message-State: ANoB5pnH03WKn8Dl2Rqftv0qjmW1yZylMhU/kj2l265uh8DIzZrOQoIU
        lg0v3ymhd5DahOt0Pa+89ju00A==
X-Google-Smtp-Source: AA0mqf6NChvQ+6VGxcj9TuOceBjh4tzkE39hbYJ44cM567wbm+gRoT462mEspyLU7F6tqEVSBYhuIQ==
X-Received: by 2002:a17:90b:3687:b0:219:468e:88ac with SMTP id mj7-20020a17090b368700b00219468e88acmr47734105pjb.105.1670454516121;
        Wed, 07 Dec 2022 15:08:36 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u126-20020a627984000000b00575caf80d08sm14105794pfc.31.2022.12.07.15.08.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 15:08:35 -0800 (PST)
Message-ID: <abaa2003-4ddf-5ef9-d62c-1708a214609d@kernel.dk>
Date:   Wed, 7 Dec 2022 16:08:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC for-6.2/block V2] block: Change the granularity of io ticks
 from ms to ns
Content-Language: en-US
To:     Gulam Mohamed <gulam.mohamed@oracle.com>,
        linux-block@vger.kernel.org
Cc:     philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
        christoph.boehmwalder@linbit.com, minchan@kernel.org,
        ngupta@vflare.org, senozhatsky@chromium.org, colyli@suse.de,
        kent.overstreet@gmail.com, agk@redhat.com, snitzer@kernel.org,
        dm-devel@redhat.com, song@kernel.org, dan.j.williams@intel.com,
        vishal.l.verma@intel.com, dave.jiang@intel.com,
        ira.weiny@intel.com, junxiao.bi@oracle.com,
        martin.petersen@oracle.com, kch@nvidia.com,
        drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        nvdimm@lists.linux.dev, konrad.wilk@oracle.com, joe.jin@oracle.com
References: <20221207223204.22459-1-gulam.mohamed@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221207223204.22459-1-gulam.mohamed@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/7/22 3:32?PM, Gulam Mohamed wrote:
> As per the review comment from Jens Axboe, I am re-sending this patch
> against "for-6.2/block".
> 
> 
> Use ktime to change the granularity of IO accounting in block layer from
> milli-seconds to nano-seconds to get the proper latency values for the
> devices whose latency is in micro-seconds. After changing the granularity
> to nano-seconds the iostat command, which was showing incorrect values for
> %util, is now showing correct values.
> 
> We did not work on the patch to drop the logic for
> STAT_PRECISE_TIMESTAMPS yet. Will do it if this patch is ok.
> 
> The iostat command was run after starting the fio with following command
> on an NVME disk. For the same fio command, the iostat %util was showing
> ~100% for the disks whose latencies are in the range of microseconds.
> With the kernel changes (granularity to nano-seconds), the %util was
> showing correct values. Following are the details of the test and their
> output:

My default peak testing runs at 122M IOPS. That's also the peak IOPS of
the devices combined, and with iostats disabled. If I enabled iostats,
then the performance drops to 112M IOPS. It's no longer device limited,
that's a drop of about 8.2%.

Adding this patch, and with iostats enabled, performance is at 91M IOPS.
That's a ~25% drop from no iostats, and a ~19% drop from the iostats we
have now...

Here's what I'd like to see changed:

- Split the patch up. First change all the types from unsigned long to
  u64, that can be done while retaining jiffies.

- Add an iostats == 2 setting, which enables this higher resolution
  mode. We'd still default to 1, lower granularity iostats enabled.

I think that's cleaner than one big patch, and means that patch 1 should
not really have any noticeable changes. That's generally how I like to
get things split. With that, then I think there could be a way to get
this included.

-- 
Jens Axboe

