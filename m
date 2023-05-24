Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF1FCC77B73
	for <linux-raid@archiver.kernel.org>; Wed, 24 May 2023 15:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236419AbjEXPDX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 May 2023 11:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236397AbjEXPDW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 May 2023 11:03:22 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7366C195
        for <linux-raid@vger.kernel.org>; Wed, 24 May 2023 08:03:20 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id ca18e2360f4ac-760dff4b701so8105439f.0
        for <linux-raid@vger.kernel.org>; Wed, 24 May 2023 08:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1684940599; x=1687532599;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GgDKrHLcU2tmKaG5NStKDv/+h6lvDy9SPWrocWEqRKY=;
        b=KbH4KU5/h08dj7t3PcKDEDm1/UReJFYLAuotdxeU7tXw+L3zRabkYBA3/BiKFZ6qGI
         F+gr7jKiGNgNggWdzLjBSu+ilsXCZXOWONG2Kn86u2gb7qD1QKtBHYmpFu6P7boIIbxF
         Ikcp+oCxS1YOq8hwfuzdVPoX0d+TFE5d9+HLvpfoYubx+csuBQlK4vxHr9KiirNkQuvc
         yjhDXcL/i6vHnVwz0il0gJbyfMbbI6KloHYzHtfn/jh5+C9TFsv3L+Je+WxPCKJeD4Xa
         5FGGnwZv1ZsixHpLsBZSgDQfww5jeEUekWIIolhHQKnmz/X1ZKN3WbCjGwog/cXUR0Vv
         eGIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684940599; x=1687532599;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GgDKrHLcU2tmKaG5NStKDv/+h6lvDy9SPWrocWEqRKY=;
        b=V2zAWKIC1xUtXrps0uMuZxHFEkkR7ilO5h67pxI0HpQRcnTFvzJn+h+ku5hhZNZ6nQ
         BzXqvvplYpD2XPLvUB6rJY27Uf1edaEcqCvJ1BvWmYQxQCnuLzkNGTSzzLqXI/EvVCOs
         +aYcWmV9hIqQIVjUlUZ8UESKV6XeNb4a1vs4Rl+ICM+YiBeq66Q5ysWytceT2wwKKJsS
         OSa1p4SMQ7R9l2iqreSWst6m3zdhxLsA1YNZE1IynCdg2RbhsXu3KuphyXVghx1NEhjq
         6tT+4xeyS0TZPzogha+cRJMSYEUXOXCpoz0Kop6OmDqSbwG5joqnYWOXPTG9RoljzH22
         iIpg==
X-Gm-Message-State: AC+VfDx1NMWiY8XYOnLIJ+4XBPkvD9XAPUCb/xVuAiHRmv04gMK2MXiv
        RYs5qhBfBqjuGLS+UJaga4lL3w==
X-Google-Smtp-Source: ACHHUZ5ssaxrjwm/Xnp0jY+aTTrWQU+36ntdVpV25h3nuBN3qq1X8OGPSHY1YY5Xi3JTKSSDYR1gOQ==
X-Received: by 2002:a92:cd8b:0:b0:332:868a:ea8 with SMTP id r11-20020a92cd8b000000b00332868a0ea8mr10627847ilb.1.1684940599631;
        Wed, 24 May 2023 08:03:19 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t14-20020a92c90e000000b0032b54912651sm1073938ilp.5.2023.05.24.08.03.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 May 2023 08:03:18 -0700 (PDT)
Message-ID: <7075bfd8-7c52-a778-5651-71ade3cd1f03@kernel.dk>
Date:   Wed, 24 May 2023 09:03:17 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] md/raid5: fix miscalculation of 'end_sector' in
 raid5_read_one_chunk()
Content-Language: en-US
To:     Yu Kuai <yukuai1@huaweicloud.com>, hch@lst.de, song@kernel.org,
        chaitanya.kulkarni@wdc.com, johannes.thumshirn@wdc.com,
        damien.lemoal@wdc.com
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
References: <20230524014118.3172781-1-yukuai1@huaweicloud.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230524014118.3172781-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/23/23 7:41 PM, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> 'end_sector' is compared to 'rdev->recovery_offset', which is offset to
> rdev, however, commit e82ed3a4fbb5 ("md/raid6: refactor
> raid5_read_one_chunk") changes the calculation of 'end_sector' to offset
> to the array. Fix this miscalculation.
> 
> Fixes: e82ed3a4fbb5 ("md/raid6: refactor raid5_read_one_chunk")

This needs a stable tag as well, Fixes alone is not enough to guarantee
it ends up in stable.

Song, are you picking this up?

-- 
Jens Axboe


