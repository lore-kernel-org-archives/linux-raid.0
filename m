Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE800C7619A
	for <linux-raid@archiver.kernel.org>; Fri, 31 Mar 2023 02:31:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjCaCbU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 30 Mar 2023 22:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCaCbT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 30 Mar 2023 22:31:19 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967F1D50B
        for <linux-raid@vger.kernel.org>; Thu, 30 Mar 2023 19:31:16 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id p13-20020a17090a284d00b0023d2e945aebso7662345pjf.0
        for <linux-raid@vger.kernel.org>; Thu, 30 Mar 2023 19:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1680229876; x=1682821876;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rL3uaqw5VlxrRcrq4+BV97ALZaZAZsm58SsHYEesJvc=;
        b=gNp3MXVAhcOmJiBbEcDsAIzHOWCvMaDSEfia8qqKk0HmTEAYOO3C/9XXQWFekEruQw
         5z+o59doAGSiCmC/fd6ZJaRYg2U3Z6yTmaMeNnD8V2kfimyO6UtcabLC3ielE3RZr9d4
         m2i37E3JvVT1JxnIMxKGigPTOYcpOeccqNokptnzZjR8jF3SYK0QiRcrFae0biTI4Jmk
         TULusXDSPchbojS57AQWovKblLwJLDwqfEDpqkHjqxNUwlFQpozI5mwiVXpx86boKswd
         XF7OvyqqwYiG8EwIIYFBxbVNhXAW29iUzrjcRx7fP4d6q01U48Hia6Na2xtMyqJXefYl
         VgsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680229876; x=1682821876;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rL3uaqw5VlxrRcrq4+BV97ALZaZAZsm58SsHYEesJvc=;
        b=F+ZWOyz96Xk3LFc/VJP2VgA4tigX8Qol0rBTTHv4bOpw0svuc1IKsIdHc3ciLIMCJe
         bQhRJwVcO8x+v6GVQ1PGbYQ3UU5PLTJwzrOl7AhUla7+8kEOm7jIspnmfRfDgIXd8t/s
         76urztIop19VFFiJMCuCeZmTW1YE858qeNO7sEX+nfdpgSOdgCWH1VNIOeaouEIeTeon
         M1fb4PgEX5x9bJXRiRqTKOcmUXN3I1f3a3DSWMwW2CVm6zlUVHx38iiKcbZ8P/LYh6Q6
         50UYUgE4b8nrae1ZTPy0i6S2hcQe1NeNnB8rw4SPDkhRyDcWW5SeJVPBCb/KBFF5PZcJ
         WcBA==
X-Gm-Message-State: AAQBX9eHnQjuKoEJKSzHcpkDc7Acc2lrn0omcKtuNFA3Y66bVxzePWiY
        17mmBqa5YtEb+5BGmhvDBESH+g==
X-Google-Smtp-Source: AKy350bm0vHPF6qGrA84MbD8MufWAWHT6Rtw3YlznHipbEWtIepeqdaiIZDh/vqOGXfXOStv5BXnGQ==
X-Received: by 2002:a17:902:7c0d:b0:1a0:7663:731b with SMTP id x13-20020a1709027c0d00b001a07663731bmr21993271pll.5.1680229875830;
        Thu, 30 Mar 2023 19:31:15 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id je22-20020a170903265600b001a0742b0806sm385250plb.108.2023.03.30.19.31.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 19:31:15 -0700 (PDT)
Message-ID: <a5a6d3df-4148-7e42-5db3-18dafb3c5832@kernel.dk>
Date:   Thu, 30 Mar 2023 20:31:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [GIT PULL] md-fixes 20230329
Content-Language: en-US
To:     Song Liu <songliubraving@meta.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Yu Kuai <yukuai3@huawei.com>
References: <B94EC4B1-8772-4A2C-A454-625B661C03B8@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <B94EC4B1-8772-4A2C-A454-625B661C03B8@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/29/23 12:53 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following fix for md-fixes on top of your 
> block-6.3 branch. 
> 
> This commit, by Yu Kuai, fixes a null pointer deference in 6.3 RCs.

Pulled.

-- 
Jens Axboe


