Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0889EEAA5D
	for <linux-raid@archiver.kernel.org>; Thu, 14 Sep 2023 18:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239446AbjINScT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 14 Sep 2023 14:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239341AbjINScS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 14 Sep 2023 14:32:18 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736CA1FD7
        for <linux-raid@vger.kernel.org>; Thu, 14 Sep 2023 11:32:14 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id e9e14a558f8ab-34fb886989dso225535ab.0
        for <linux-raid@vger.kernel.org>; Thu, 14 Sep 2023 11:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694716333; x=1695321133; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QlLAR67mkjHm5vE/PI1iwohGmNq9EffZ3nbnA8kHjVs=;
        b=yb7bWBKgk+FvAqTZ4U1ignGl78gNLrjq8xz4EtWpW5nGcjchWOqBMKnb6aw3eTzbdy
         BZOMBwEOsx25FsV0+NYZ1jfVpskCpvGPoQdCcgFGbWaAmXlZLvJXZqbqlzO5RZ/acCTa
         jCTt66k/nEPh9qPmoEjKySEy6kJHOz+aMKEgFl8V+fEtiAVqIZ4Y7ZgyCC9bpMgEo6Is
         S5zKiqK+eeNCGKy0SgvYtL8icejIoF8NzZypsSFLdedLdJG1HYNQxe/FQxxAOn8QrwJ+
         cj899G8nZ2juZ7Ffs6anYFTgFKFV0r9uwEWdfjm4qbl34HZFzpkR4t2Y02VHIS+vMK5I
         KjiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694716333; x=1695321133;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QlLAR67mkjHm5vE/PI1iwohGmNq9EffZ3nbnA8kHjVs=;
        b=lHMRSy7sW/7WNbfDgSS62vymVQbKHDs6DZoLpAZvCNJOkWMSdzU62baV4wN/7OUzot
         soXMWTXrhA0/OgnsxrJX4rzAI5xxE3IutbgyMs8WsZZEfuOPKoxWdPCb69BdxfovTjYJ
         Unz8AF4U6ywcgHOZxRUE36mUyo04VrAtC0XwFdFKw4oP1zbmeHrimm50GdnwRI+4sQIY
         Hji+AazTaRZCXdIrzvzgEwk4/GSkJxvfKpdTbUoXUC1T52sDXtoJN0sWoYQDhtfxrIQu
         qTmKlszL+P9UgwjrpsnR/29GbJokw7jaTFdBz6R6rp+GrbmS4W0eE7voHT7jnV+TVpwx
         Ph3g==
X-Gm-Message-State: AOJu0YwjT3KSUtqxjbqMkrWrMHMXwxrZCrMHcpc2nlPxGbe8Qxw8pCRz
        Z9eiPwldxKoPe7kphlmbirG42FfEnjZZX4rjOEQY6A==
X-Google-Smtp-Source: AGHT+IH99dyLcFOh1tyaLVirNP2pay1ZHGEVceSdaGViFHxLCXxU5Gq2vIAswoMq3lkSDDcCYjFLhQ==
X-Received: by 2002:a6b:3b50:0:b0:792:6068:dcc8 with SMTP id i77-20020a6b3b50000000b007926068dcc8mr6585478ioa.2.1694716333663;
        Thu, 14 Sep 2023 11:32:13 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j14-20020a02cc6e000000b0042b16c005e9sm601675jaq.124.2023.09.14.11.32.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Sep 2023 11:32:12 -0700 (PDT)
Message-ID: <bc752aac-326c-4993-9e01-375f345c2f20@kernel.dk>
Date:   Thu, 14 Sep 2023 12:32:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-fixes 20230914
Content-Language: en-US
To:     Song Liu <songliubraving@meta.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Nigel Croxon <ncroxon@redhat.com>, Yu Kuai <yukuai3@huawei.com>
References: <2294B0D1-4352-4BA4-A070-2625847A1547@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2294B0D1-4352-4BA4-A070-2625847A1547@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/14/23 12:13 PM, Song Liu wrote:
> 
> Hi Jens, 
> 
> Please consider pulling the following changes for md-fixes on top of your
> block-6.6 branch. These commits fix a bugzilla report [1] and some recent
> issues in 6.5 and 6.6. 

Pulled, thanks.

-- 
Jens Axboe


