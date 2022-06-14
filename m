Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EFF9C43334
	for <linux-raid@archiver.kernel.org>; Tue, 14 Jun 2022 14:11:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234534AbiFNOL3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Jun 2022 10:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbiFNOL2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Jun 2022 10:11:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 12C0631517
        for <linux-raid@vger.kernel.org>; Tue, 14 Jun 2022 07:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655215886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rs/pZGw1ra4UPG+NfPQpDKYmSeeXVO7a6c5owMg0Bl0=;
        b=SqmtdN2BIj1dlXiTnO8MKUAcVENpAPL0ZYjcXBwC8TWlHiQasofL2vMwNr5RmS3nXPK8Ms
        Jg6J0Q42CDdCVqZIMWCkb4xRK9wSnR9ue05Q4v1dXBZtt+ntXsIPObcML0GhjqV+6FK1BS
        zf/lxEon2x3IWCs7CXucxTF4F+x4t/g=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-487-xdriBj22MZ6aTX-p46_fAw-1; Tue, 14 Jun 2022 10:11:25 -0400
X-MC-Unique: xdriBj22MZ6aTX-p46_fAw-1
Received: by mail-qt1-f198.google.com with SMTP id 15-20020ac8570f000000b00304e9e3b19aso6662294qtw.8
        for <linux-raid@vger.kernel.org>; Tue, 14 Jun 2022 07:11:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=rs/pZGw1ra4UPG+NfPQpDKYmSeeXVO7a6c5owMg0Bl0=;
        b=quiqEBeB0E901MrVH7nNYQfxRJe5DbOHv40F5/ME5Cn7grVcFSHPhDvpTBufVv/bXb
         kpj87rSftVdxsoqnl+0DBiU++o0EjHKI4YzZodeMJF6yz8BxGmTaNSecS3uGIseNgPbD
         EaEoIG9xDmU2MwLN5ETMbcEYK3SllMG47uC6O0mInSGXaj6wIj6x+4FR1Z3Hs3FGMZYt
         h+Uc/sPiRQjOvSsGR3DTDEUybYnJq/5bYRLaEwIPCRrvtTVDVESHj8S1xyH3gQYS5ALP
         kRy9n+lSmh4QNJHzrLtR/54XXsywf+ZOfRUq86CxgUtU/gplmTxiewJw338H9qx/G0WK
         BXRA==
X-Gm-Message-State: AOAM5322yoDmqgHbESowmnvRAYLMOAc3Ed/oHl5zQOjuOS9uVZNvyLfM
        WDzQa8pxUhrpXDvLEWX1r37aAlFHJkZs/J7DiCy0sKWgd1XNskLZC+aPW4UW47I2GnEHHH5iIu9
        RuD4b5tDu8rb8ZCfljQcr9g==
X-Received: by 2002:ae9:d60b:0:b0:6a6:ab28:3c05 with SMTP id r11-20020ae9d60b000000b006a6ab283c05mr4024166qkk.180.1655215884018;
        Tue, 14 Jun 2022 07:11:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyoNd97H2tWRx+ey8qOvoT6LkO3OG675dYwMXHGzNfQSBSU3s2NWtosQ7ocQg6ZAXrXRsssTg==
X-Received: by 2002:ae9:d60b:0:b0:6a6:ab28:3c05 with SMTP id r11-20020ae9d60b000000b006a6ab283c05mr4024091qkk.180.1655215883162;
        Tue, 14 Jun 2022 07:11:23 -0700 (PDT)
Received: from [192.168.1.211] (d-137-103-110-215.nh.cpe.atlanticbb.net. [137.103.110.215])
        by smtp.gmail.com with ESMTPSA id l2-20020a05620a28c200b006a701d8a43bsm9532013qkp.79.2022.06.14.07.11.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 07:11:22 -0700 (PDT)
Message-ID: <54144438-5b6a-60dd-6f62-e90e052772ee@redhat.com>
Date:   Tue, 14 Jun 2022 10:11:21 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH] Revert "mdadm: fix coredump of mdadm --monitor -r"
Content-Language: en-US
From:   Nigel Croxon <ncroxon@redhat.com>
To:     jes@trained-monkey.org, linux-raid@vger.kernel.org,
        mariusz.tkaczyk@linux.intel.com, wuguanghao3@huawei.com,
        colyli@suse.de
References: <20220418174423.846026-1-ncroxon@redhat.com>
In-Reply-To: <20220418174423.846026-1-ncroxon@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/18/22 1:44 PM, Nigel Croxon wrote:
> This reverts commit 546047688e1c64638f462147c755b58119cabdc8.
> 
> The change from commit mdadm: fix coredump of mdadm
> --monitor -r broke the printing of the return message when
> passing -r to mdadm --manage, the removal of a device from
> an array.
> 
> If the current code reverts this commit, both issues are
> still fixed.
> 
> The original problem reported that the fix tried to address
> was:  The --monitor -r option requires a parameter,
> otherwise a null pointer will be manipulated when
> converting to integer data, and a core dump will appear.
> 
> The original problem was really fixed with:
> 60815698c0a Refactor parse_num and use it to parse optarg.
> Which added a check for NULL in 'optarg' before moving it
> to the 'increments' variable.
> 
> New issue: When trying to remove a device using the short
> argument -r, instead of the long argument --remove, the
> output is empty. The problem started when commit
> 546047688e1c was added.
> 
> Steps to Reproduce:
> 1. create/assemble /dev/md0 device
> 2. mdadm --manage /dev/md0 -r /dev/vdxx
> 
> Actual results:
> Nothing, empty output, nothing happens, the device is still
> connected to the array.
> 
> The output should have stated "mdadm: hot remove failed
> for /dev/vdxx: Device or resource busy", if the device was
> still active. Or it should remove the device and print
> a message:
> 
> mdadm: set /dev/vdd faulty in /dev/md0
> mdadm: hot removed /dev/vdd from /dev/md0
> 
> The following commit should be reverted as it breaks
> mdadm --manage -r.
> 
> commit 546047688e1c64638f462147c755b58119cabdc8
> Author: Wu Guanghao <wuguanghao3@huawei.com>
> Date:   Mon Aug 16 15:24:51 2021 +0800
> mdadm: fix coredump of mdadm --monitor -r
> 
> -Nigel
> 
> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
> ---
>   ReadMe.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/ReadMe.c b/ReadMe.c
> index 8f873c48..bec1be9a 100644
> --- a/ReadMe.c
> +++ b/ReadMe.c
> @@ -81,11 +81,11 @@ char Version[] = "mdadm - v" VERSION " - " VERS_DATE EXTRAVERSION "\n";
>    *     found, it is started.
>    */
>   
> -char short_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:r:n:x:u:c:d:z:U:N:safRSow1tye:k";
> +char short_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
>   char short_bitmap_options[]=
> -		"-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:r:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
> +		"-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
>   char short_bitmap_auto_options[]=
> -		"-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:r:n:x:u:c:d:z:U:N:sa:rfRSow1tye:k:";
> +		"-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sa:rfRSow1tye:k:";
>   
>   struct option long_options[] = {
>       {"manage",    0, 0, ManageOpt},

Jes, That is the status of this patch?

Thanks, Nigel

