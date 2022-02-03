Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7360FC433EF
	for <linux-raid@archiver.kernel.org>; Thu,  3 Feb 2022 18:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353595AbiBCSzg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Feb 2022 13:55:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234035AbiBCSzf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Feb 2022 13:55:35 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3812C061714
        for <linux-raid@vger.kernel.org>; Thu,  3 Feb 2022 10:55:35 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id n17so4480725iod.4
        for <linux-raid@vger.kernel.org>; Thu, 03 Feb 2022 10:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6CxBR6kFyyd8xbmPbdEADYFDZ4ypQXnmrZTvqJC1nOo=;
        b=mOTvptVjGQ4nYpt8+KceGqknyiv8lw7xov8VgiyguavJP2DRQ8Q+uCQzNCY9bQs+L/
         S/Vpod2vo/WfH/2n4JkEWq1OYSzECwuj2GJv3gAG3wXOxm2OQ8LL04KD9EcBFC0b2bjf
         snfWG3p0I5pgU8hO/DEaClqDAWfw2AQ5/SCaNdNf9gaXoXleLYSuI/dzS0kBR4lPiaMq
         5hMYh3YheTKm9oQ8QvRAh7Gr/sLZxhVppk//AKPmAsjNxBUxRxNioXs+dhDsEvI4zrjh
         DMtdYcMRRbShcz8q9T+jYt4of7FM1aq9FccfpBDwvM3NZ75PmhbPqeROTwsrYYJ4Pc7i
         0MeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6CxBR6kFyyd8xbmPbdEADYFDZ4ypQXnmrZTvqJC1nOo=;
        b=4JRdV2FEzza6c9sO2h+87TOwd5y2qytn7tYUcE9EIMGuBxzTGSv6ur2Uf5bH8Y2TpV
         6+uD9q2ne9HBEBLYYlZz2xhRPmsTqxjaDmjJgTSHYxsQQUsByKQanKuxiwlZLcpC82kz
         bX8/Fmy0U4r7AhcFKJf2Kslzk+o2g/aLwN5ohoD7ok2OfDeGS66MGi8fx1SOtjE95eZL
         5GQu3JbUIODGLZ2qfWqDZ3e9usMuTx/jCTtPeikL09saC4hkkfzGkQzI4dFIwf7PsdDp
         oUrAeuf7VRQ22T1jAq6YFaBE01xrjMTZSqDJbn7j0K0uBXTbf3zxGl9yjN1i6i5Lj2QZ
         YtRw==
X-Gm-Message-State: AOAM532UaWssh6qwAXamZFTrenyi3MDj8TNfGeyFk/nMRUAKBWd334JB
        U8NQf6nnEuuamNPbwly4ZssmaFq99+ezCQ==
X-Google-Smtp-Source: ABdhPJytx3zZ5K6JAqGL2VL7QybNYnnVsOvLeY3AFAUq5cw5EY0ji/38sBYCpjBa4mdihNO6uayiSw==
X-Received: by 2002:a05:6638:1408:: with SMTP id k8mr6096592jad.267.1643914534754;
        Thu, 03 Feb 2022 10:55:34 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id d12sm5179163ilv.42.2022.02.03.10.55.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 10:55:34 -0800 (PST)
Subject: Re: [GIT PULL] md-fixes 20220203
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
References: <367A4982-7D31-4E62-8867-3912D5B9FB5C@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <10993cdc-56cb-5ccb-c632-aa4c15633e15@kernel.dk>
Date:   Thu, 3 Feb 2022 11:55:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <367A4982-7D31-4E62-8867-3912D5B9FB5C@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2/3/22 11:50 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following fix on top of your block-5.17 branch. 
> It fixes a NULL ptr deref case with nowait. 

Pulled, thanks.

-- 
Jens Axboe

