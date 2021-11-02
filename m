Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C7AFC433EF
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 19:12:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D567360EB8
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 19:12:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhKBTPR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Nov 2021 15:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhKBTPQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Nov 2021 15:15:16 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29465C061714
        for <linux-raid@vger.kernel.org>; Tue,  2 Nov 2021 12:12:41 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id l19so173384ilk.0
        for <linux-raid@vger.kernel.org>; Tue, 02 Nov 2021 12:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K4SYCpCs7cyT6iyrmp5jcYOIGyV8TL0N7RQQPDr/SQI=;
        b=h2vE8uEtmTiIalYUKHzXF0kUPMNGTyd/JUO27H2lZTtSEO8YJSzGiQdLSUrG3XUH1g
         J6e/F4+I36DhT/3qSi027Xz1+BTi2CDFSkwJ7BDF+X6t+Qt2yRt2byknW1aXIVwUfm4q
         c4XM2kv9YrBDwExKk3nwCIsQVTkqmaLlbG87IGwXTOP0C7z5hsWj199Hqetd6IaRiAlL
         MBgykx30HA/kjD+O23SzbLmvEJjr1lm5nKQCIv6IQTk1uPQGISLqCbik1TOsUJUBdlsn
         ThrYfhtq972KU8H73xLdLWMSDWPINtaaSLfIvhvuIDO/byiyrAqS5Pgb9pJP2Jv13k5a
         8NxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K4SYCpCs7cyT6iyrmp5jcYOIGyV8TL0N7RQQPDr/SQI=;
        b=2oOPqzv9DVf1Kukz4Enre/Vbxs80kXYGVlIEw/DJqN7QrLawyI4M7g9tXyDnheuWJr
         OTf0swlgZ9gzq4TaiYRkOTozePOQJm3Nc6VLFra9LDXi/+yKsqiThrua471A90vOdMK1
         tl84BmSzsxpmKmjkxpR5+KeYdd8PQAVjL3J3VZOCAgomROcK3x9x+f5wkroxhzgNnNud
         Izpx7/JDgLzPPKXESkQFBI/pVkFoLBjuz/sBc86vTYLOAP7d6JzOhOIzK9ybB9AoawX1
         6wgNOjXm8JVEopTUByiio+wTJs2m9iDx4WyHuguvK64kzn2eZFnrkAWKraPTQay1AwMq
         R6gA==
X-Gm-Message-State: AOAM531bdVPCkBd/uaU4IpYAj/88iv0huORKzJQ7z3lh7CuTA840u+K5
        7AG5ZBjynBlR3VHqo+7Y5Iv3sw==
X-Google-Smtp-Source: ABdhPJz7G4LlD0Ekhvwu68OV0oMbnuzoTQLFYOkbEIzQ/NL49391EbgXLc4sMc5Ja2Akl2DGQMDj2g==
X-Received: by 2002:a92:d908:: with SMTP id s8mr5524608iln.168.1635880360514;
        Tue, 02 Nov 2021 12:12:40 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x11sm3625995ilu.51.2021.11.02.12.12.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 12:12:40 -0700 (PDT)
Subject: Re: [GIT PULL] md-next 20211102
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Guoqing Jiang <jgq516@gmail.com>,
        Yang Guang <yang.guang5@zte.com.cn>
References: <B99EFF4D-AF56-41FB-AA4C-E42E05263D20@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7e64038b-8996-292a-32e1-ef8329e70b3f@kernel.dk>
Date:   Tue, 2 Nov 2021 13:12:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <B99EFF4D-AF56-41FB-AA4C-E42E05263D20@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/2/21 12:59 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes on top of your for-5.16/drivers
> branch. The only significant change here is a fix in back_log sysfs entry, by
> Guoqing Jiang. 

Pulled, thanks.

-- 
Jens Axboe

