Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC92C433F5
	for <linux-raid@archiver.kernel.org>; Thu, 28 Apr 2022 01:37:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240712AbiD1Bki (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 27 Apr 2022 21:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240709AbiD1Bkg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 27 Apr 2022 21:40:36 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4436B088
        for <linux-raid@vger.kernel.org>; Wed, 27 Apr 2022 18:37:22 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id j17so2985095pfi.9
        for <linux-raid@vger.kernel.org>; Wed, 27 Apr 2022 18:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=iLWHycFBU47e292njYAAnMdRB8fTLslwprEmAlONSu4=;
        b=bhGZjBgAOzBOKz/UaEXqR17QVn6wZz1LcvpDdKr7QNIizVLEOo7KT1recEgyX6JfL1
         I86hS8C38vAcwsitzwDc2oyBF+1ytFf1U6TRMFjVbc0hi2LNOditSv5Z78of3iLiufOn
         XR9mYalw+cbzf5UZyT1jAs0a7fe84wQbqME9CuzEXVAOKJWI6Y40Kjh6uzLhcggD+rDk
         yMJKIlRD3nHOJNnibVdiCV5J7wgSEpzmI48HpisjcVjo4fZRkVKgZTR99NmRRPtmpsrw
         cmIfadgZcMyQ9hVYH2Z425fWN6qkLJRbcIzNn/4ghOQmISfndA9mcNZobuezPnjunY08
         Cx6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iLWHycFBU47e292njYAAnMdRB8fTLslwprEmAlONSu4=;
        b=cE6tkrvG+B4g4L/dpy1Mo56nlTT4I1lHSs5sPn3jUIyVT4b2q00M8wbllMR+RP2v3a
         sd7ZDIcI7WGBtIP4L71/au3QaWpUIPwJoFVed3HzdevzKfcq0joj60Qzy9QpRArT3X4M
         LMVPzgUcrhFjAD7MggdcSc8yYT7P5RU98fs1Oo+BBXHWCCCWBYeluSmW/CINySZ7BoT8
         WIWoznCxQMes39KcwbkdEYWNmctryqndsguBn0Uji7BFUqU1QfFvTV71Cg3oCByYCuP9
         kitcosvN0ter681oKDmB/LJzjpPmH0yo++sAo4Vl0cy9/4+tnQe0DcqkER4QS2qtaqcV
         dvkw==
X-Gm-Message-State: AOAM5314GznPhAK8+60n+6Hhpz51qwg+jSRKhKzLlYCkRHfotvgpTyRN
        yJVa/eFyErdw8fFmZ9Bo9xVCUzL7blnfOvHu
X-Google-Smtp-Source: ABdhPJxnm0JuhS8ZpY5cUrMwuQ+twuXRTr8HIzqp/6rx+fHXh729ZdDZaFb4Jj+uwY+OToFnTAD2hA==
X-Received: by 2002:a05:6a02:197:b0:382:a4b0:b9a8 with SMTP id bj23-20020a056a02019700b00382a4b0b9a8mr25970668pgb.325.1651109841727;
        Wed, 27 Apr 2022 18:37:21 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s19-20020aa78d53000000b004fdaae08497sm19633991pfe.28.2022.04.27.18.37.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 18:37:21 -0700 (PDT)
Message-ID: <2ff4c01a-1282-0463-179a-fa7fcba2d2cb@kernel.dk>
Date:   Wed, 27 Apr 2022 19:37:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [GIT PULL] md-next 20220427
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        David Sloan <david.sloan@eideticom.com>,
        Pascal Hambourg <pascal@plouf.fr.eu.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Heming Zhao <heming.zhao@suse.com>,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>
References: <EEF117E6-B4F7-4702-AF1C-37FAEA131697@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <EEF117E6-B4F7-4702-AF1C-37FAEA131697@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/27/22 6:29 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-next on top of your 
> for-5.19/drivers branch. The major changes are
> 
> 1. Improve annotation in raid5 code, by Logan Gunthorpe.
> 2. Support MD_BROKEN flag in raid-1/5/10, by Mariusz Tkaczyk.
> 3. Other small fixes/cleanups. 

Pulled, thanks.

-- 
Jens Axboe

