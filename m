Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC290C04AA5
	for <linux-raid@archiver.kernel.org>; Wed, 24 Aug 2022 19:59:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238460AbiHXT75 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Aug 2022 15:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234790AbiHXT7z (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 Aug 2022 15:59:55 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339622C657
        for <linux-raid@vger.kernel.org>; Wed, 24 Aug 2022 12:59:54 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id i77so14266107ioa.7
        for <linux-raid@vger.kernel.org>; Wed, 24 Aug 2022 12:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=yWSNEqFgT676yBRSaCc3fhUXIE2tJ9Usl3qxHOimjV8=;
        b=p8PbqZmbyUAx9ZgLovTAqucFjv/Cia5uCtFs3hJi1vRCdRscLnlfiDJ5LqOVuWLOYq
         IUUqXhutW2vVMKGR8L0vHH1pxfWXoWfTQbCLk2GPJzH++taRWSRnXDo82y5sTy9dagpf
         oqxI4tDqHghdf42udSqZ7usRJwBGrPymllvI20NOBcI0E92Bt1Vc1LbT1eOzuIQzmkdK
         tRUK4SsjSqBxrqOQBRU4/HXCkvAqFeRPyre9QqT0lGQiA7zahHMBnao6rkiPY1N7L6BV
         w65LocVh3FQk6DA+xAyri4zmqeuSrFMAPa+JTjRFh4Nusc3QYdZbMAtke2IzHzgDdITz
         07mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=yWSNEqFgT676yBRSaCc3fhUXIE2tJ9Usl3qxHOimjV8=;
        b=05GkwPR+IUWC3EYkSyhh4WKhfxccluyRzL+mzR15bc1F/z6NUDqnkCDZ4AIIZoCg+O
         2XQKX8CKA81nCnJuHyy6uW7z9Q0owWoimkKikpPm/Nhri2GC4+B8jEubaBV2ZVQJnegU
         IXqzSrmMH/uwiG6BloKPLEXMWSgX4f3aYlSvjXfRN+QHxvZRvJYeqim0HfYZs/nwmj/L
         U4/UyX6GyCRodua4eg317ZVJ3W9GRUfuwi4JVRSgNStwm35CJjdVMBnsQIYqFdS1xsT4
         UaIrubwDyaTpVl0i1I//uvsJhR3ftwj1L5B7sjyhIPcVq7PbvuOZccoQbiqKTNjx5b4t
         PqDw==
X-Gm-Message-State: ACgBeo2699dj2sX+xGXnvY7o3EVgVzuix6KpdLgceyh4Iyco56Ce9IGc
        JSHQSwAp99Vjsf5bOoxUCFIdIWqPg8bIMA==
X-Google-Smtp-Source: AA6agR4sa8wP25sfFwM6g/2IlGBJLFPT/p91YWTbwaNICeqiccgyN1qaCDUXFHQfrKbhk2R8Q6/QgQ==
X-Received: by 2002:a05:6638:1450:b0:346:8a18:737c with SMTP id l16-20020a056638145000b003468a18737cmr249598jad.149.1661371193563;
        Wed, 24 Aug 2022 12:59:53 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q2-20020a05663810c200b00347d092f31dsm176937jad.60.2022.08.24.12.59.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 12:59:53 -0700 (PDT)
Message-ID: <cee88f5d-d058-c14a-4ac5-00e8daa45c71@kernel.dk>
Date:   Wed, 24 Aug 2022 13:59:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [GIT PULL] md-fixes
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Bart Van Assche <bvanassche@acm.org>,
        David Sloan <david.sloan@eideticom.com>,
        NeilBrown <neilb@suse.de>
References: <FEC5B8F6-0165-4CE7-A1F4-F7123D37B858@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <FEC5B8F6-0165-4CE7-A1F4-F7123D37B858@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/24/22 12:31 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-fixes on top of your 
> block-6.0 branch. The changes are:
> 
> 1. Fix for clustered raid, by Guoqing Jiang. 
> 2. req_op fix, by Bart Van Assche. 
> 3. Fix race condition in raid recreate, by David Sloan. 

Pulled, thanks.

-- 
Jens Axboe


