Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A6EC43334
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jul 2022 13:07:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235179AbiGTNH1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Jul 2022 09:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbiGTNH0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 20 Jul 2022 09:07:26 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4BC3FA13
        for <linux-raid@vger.kernel.org>; Wed, 20 Jul 2022 06:07:23 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id j1-20020a17090aeb0100b001ef777a7befso3661090pjz.0
        for <linux-raid@vger.kernel.org>; Wed, 20 Jul 2022 06:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=T73B6VNvaauhr+wYqkYhiZqdBGBz5dqjrqZGOrwfgwE=;
        b=xPMXU/O01CHX4j15GpTWBYIgwp8SlzY9FjczeeZng8OGWkRy/b9u5SyXBiJgrPIbsb
         duvjN543qw9WdS4GP1x2f5oC+gptK1dzOzdaxAN9qYSvDmSfo+cuaz7Wv8RWm1u2zQyT
         qEchOyVzlvmuUSgyRjMu3M/E6KX530EtS6ENRwXXsayZVW02EV2MKzqJjwYlaM8LJv1S
         e2qLZCByNra7VKE1aPSqZpoJzAGiMLBW2W7zQmMWrZc7HrhFb4YGDJt8ILulPPTqpHlR
         LnCTo7qzT1Amr+Xj2ikAaPLDrvP6TJDZQXcn7T79LSSnQMJ3o9UPDjK5zF7a70dEtPpC
         jB0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=T73B6VNvaauhr+wYqkYhiZqdBGBz5dqjrqZGOrwfgwE=;
        b=znU5epeO9nL0KDG880TPU3kZhCM2MZnU6V+f9BxfnL/hqlcC/w8JOC0mzvCDWutsN4
         jHK9dYzGrhinEI+izISSI0WjslBDdUF2DBJhGY8Q2Ue/OKWBApGzvqsMc7FzS3AApeSK
         ROfw7fmG9W2h49eX1j3hIgWCgEH5wE2JkRsO6W1Fhqyun7O2K2poze+vCoBasjbnUp2f
         M32PJDB1Rzz8dgoU9wJKSIArbK+jq36uOYWRm58TRVXL4/GYqsHG/C//wWrI35gNCJAP
         xNozuFlSlaEppr9uUl7sjPoR1e3EDFdRpyWgtiB/3c59IubUrVs2ArYiu8OUoyMBjYhB
         Yrxg==
X-Gm-Message-State: AJIora/IrM/OfB4kSCjgsjcZRxz4VgrOnCnwGPEYkDwTGcTtrktS6n8Z
        5RkPgJthaaev5P1Bjwk1YzG4I/qk950Ieg==
X-Google-Smtp-Source: AGRyM1tTsZiSMq7KEkNJqED+j4Og79KvzasmKNpff79Lfb5aE5n9x34ZmRFsEx2zZ5voKonVGFEApg==
X-Received: by 2002:a17:902:e5cc:b0:16c:4043:f68b with SMTP id u12-20020a170902e5cc00b0016c4043f68bmr40681343plf.110.1658322443093;
        Wed, 20 Jul 2022 06:07:23 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v7-20020a622f07000000b0052ac2e23295sm13576632pfv.44.2022.07.20.06.07.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jul 2022 06:07:22 -0700 (PDT)
Message-ID: <3305494e-e89a-9772-c7ca-1190aee3c296@kernel.dk>
Date:   Wed, 20 Jul 2022 07:07:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL] md-next 20220719
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Jackie Liu <liuyun01@kylinos.cn>
References: <5553FDCD-7628-4A40-A228-8E1BEF6FFFA1@fb.com>
 <57876115-7e41-f11e-3cca-738235cd68db@kernel.dk>
 <7C4DD0FE-6C05-4BF4-9A20-8C6A012B6658@fb.com>
 <c8cad78b-08cf-43e4-6610-6978fe0ce201@kernel.dk>
 <D5C50E0C-3301-428D-9FF8-642EA1568445@fb.com>
 <83ABEE55-79BB-4FD5-A2D2-CA40F579E7EA@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <83ABEE55-79BB-4FD5-A2D2-CA40F579E7EA@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/20/22 12:08 AM, Song Liu wrote:
> 
>> On Jul 19, 2022, at 10:56 PM, Song Liu <songliubraving@fb.com> wrote:
> 
> [...]
> 
>> Thanks Jens! (assuming the branch is named for-5.20/drivers-post). 
>>
>> Please consider the following pull request. The major changes are: 
>>
>> 1. Fix md disk_name lifetime problems, by Christoph Hellwig;
>> 2. Convert prepare_to_wait() to wait_woken() api, by Logan Gunthorpe;
>> 3. Fix sectors_to_do bitmap issue, by Logan Gunthorpe. 
> 
> One more last minute change (added Logan's Reviewed-by to two commits).

Pulled, thanks.

-- 
Jens Axboe

