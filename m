Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADA7DC04A94
	for <linux-raid@archiver.kernel.org>; Mon, 14 Aug 2023 21:43:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbjHNVm7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Aug 2023 17:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbjHNVmd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Aug 2023 17:42:33 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60AED12E
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 14:42:32 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-68844c0af5dso110904b3a.1
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 14:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1692049352; x=1692654152;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HSIldyM9ZO9e6Fpyrl2GkFN+Bykp72uar7R7def8VvI=;
        b=GYb2K+g5uNx++Jc96DOAxkWsH1ztEIM+rOCFuk7jLjnB0rUS7LlWXuAUWxnpxBU39C
         EsFYrcG8jCw2H1sSrskHvZhu5N5XMmzCe4Nzrjuah+vC5bcAjLzuWcTFzGAoXkRCoajQ
         PpI3btgIJig5kxDscTOX854BlbNwX0KA4onIgz+b5Hob334gSRmApte32Ct8RllxJqBn
         TWlK5nnCE5kbxJKWchHqRk2PxOmD85ZRaJzN2zlIEwtuWRplpfas3QDFYMxLZDHNS6mH
         Eu+WrwiAvquV26YXHbOz+fnFv02ovXDlvNpNObJlTbLOzNSBs/2n6H5OM4MGSkpezrmN
         l4TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692049352; x=1692654152;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HSIldyM9ZO9e6Fpyrl2GkFN+Bykp72uar7R7def8VvI=;
        b=MOqpI+R2lCXVkm1K+fcqPbdx3A0RcCWEX+n9hxvFVM+HGYshcljRt8f8ZZRTXZdpiB
         U6ZRU6MV+W9ReLSm7q0u13DlNRdTfGohrmKExh7UsZMKm96wdeFmQJpIlz531oUnvNk/
         R/sqMuo7QSJPn4X09gTYi1IUpN99w3Dliszljqr/amV1iGiVRY/Wa9YCOzIm/i/qkA1L
         rdNhzeK/TeC516hbAMjbAOdXWyaEEDSpOC1rN+wPZ4g2OQpGRhFFthR0ggplmOYQJTUs
         8N2oLg5ZefOy8XvP5IPnMu3Z1BUxhOq5lh14FHt8ZpHAt9H2NWWIWvUBaVN4ZBNMcTSO
         EjkA==
X-Gm-Message-State: AOJu0YzwO41bYod3YBt41tDTFcXvbTaVtUJ8zXh1J9FVcjod5+u9SeRe
        5fQE3fCH1zqIDsDx9jIg78QK4K1kexjTNoN9fqM=
X-Google-Smtp-Source: AGHT+IGIBwADEmJs1M98Fu3KGZNqoow4pAuiaqZwxnUoTZZb8Dl9VNdbfr/iCv1dSHMW3PqX3tb+sQ==
X-Received: by 2002:a17:902:d503:b0:1b8:95fc:cfe with SMTP id b3-20020a170902d50300b001b895fc0cfemr12714976plg.3.1692049351794;
        Mon, 14 Aug 2023 14:42:31 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8-20020a17090a19c800b00267c49d74e8sm11099372pjj.42.2023.08.14.14.42.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 14:42:31 -0700 (PDT)
Message-ID: <71fbaeb7-1f70-4e61-a539-f66163082df8@kernel.dk>
Date:   Mon, 14 Aug 2023 15:42:29 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-next 2023-08-14
Content-Language: en-US
To:     Song Liu <songliubraving@meta.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Yu Kuai <yukuai3@huawei.com>, WANG Xuerui <git@xen0n.name>,
        Li Lingfeng <lilingfeng3@huawei.com>,
        Zhang Shurong <zhang_shurong@foxmail.com>
References: <C2AF38F3-4BFF-4AD7-B575-C94A8C86A3EE@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <C2AF38F3-4BFF-4AD7-B575-C94A8C86A3EE@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/14/23 4:45 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-next on top of your
> for-6.6/block branch. The major changes are:
> 
> 1. raid6test build fixes, by WANG Xuerui;
> 2. Various non-urgent fixes. 

Pulled, thanks.

-- 
Jens Axboe

