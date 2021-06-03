Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E09C47083
	for <linux-raid@archiver.kernel.org>; Thu,  3 Jun 2021 01:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3D35613E9
	for <linux-raid@archiver.kernel.org>; Thu,  3 Jun 2021 01:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbhFCBUZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 2 Jun 2021 21:20:25 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:43634 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhFCBUZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 2 Jun 2021 21:20:25 -0400
Received: by mail-pj1-f47.google.com with SMTP id l10-20020a17090a150ab0290162974722f2so2873538pja.2
        for <linux-raid@vger.kernel.org>; Wed, 02 Jun 2021 18:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=e/BkFIYaNxoZs0Dj3PItlfWrJqe2GuS3QINhWBQ4IkM=;
        b=g33Fp/B/uqabjMn/4zK8t60fy5CcxQhZTjX/8V3evMiPl5a+y+ugtGXaNWMHKRTJY/
         M5ZtFHcgxqywPxNiv8VEnZNYFN9+qm1+a8QEOTlF1bzKIK6Wn/PtJBkbLOs+gbX6bfjP
         +9/iRSVw7Qj4cYSGZGkpTshsh22/ySTAqkSctIy140q/3eWvKUSXhdKDNBjNHKScWomA
         h9JAB6GE1qc6Yp0EjO6Jm1JHnu+AjQGloNUS9wPxgKKN8HEFTyXavgeWCYQ6u/NihaTw
         oTcH7O7uH8Tvdgn1gNsBJETCL34L3i+Q/HTpqVUyAIOG4YuiB5GJXx1qgpC5Dk6VLOex
         bR1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=e/BkFIYaNxoZs0Dj3PItlfWrJqe2GuS3QINhWBQ4IkM=;
        b=DipewzhSGJzY9h8o5YaL3OGwoXVs/YHyklRDbsafxeHF8ylOhft5mWasv1PPAyXS1G
         bJTLYuA+mTEPGkpE1RWEd7zCEq+NL79m328FX85QXaM0X0Cu2BWbZcpP+U7BhKb8ioq8
         1H9N3au52/435mBBOTFmSRLR8ubAGoUM5f/Y0cB0YievNYE2+VSCemxTZYWb2vf5WxnR
         LyKL5ALy4fdlZgoErQta2gDMKMtFipeVfZ1h7P2q1w7XxJIL5VjZ1+RHxoo8i3gHe9Dx
         h3R5jP0PJk5coLYeFr0BzQ9Wju3rBbkJerxv2KhWwVswVkucGG9aFBikferuB5qYN1we
         4Hzg==
X-Gm-Message-State: AOAM531PRirn/1N03FvolIOrJxDL10msFmYkOqelw/+2mSZIp1xNqpvY
        +sXr0E+4tSKXB53O6EV2yDdovktJrKk=
X-Google-Smtp-Source: ABdhPJyQFPpYli3tac20NRkToUn3fVGQ3RUUyB0LuZHCt92i0ykMPM6lbu0k5q1RJ6i4WDs/j9f3HQ==
X-Received: by 2002:a17:902:b594:b029:f8:fb4f:f8d3 with SMTP id a20-20020a170902b594b02900f8fb4ff8d3mr33351552pls.25.1622683047794;
        Wed, 02 Jun 2021 18:17:27 -0700 (PDT)
Received: from [10.6.2.150] ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id v6sm643083pfi.46.2021.06.02.18.17.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jun 2021 18:17:27 -0700 (PDT)
Subject: Re: [Update PATCH V3 2/8] md: add io accounting for raid0 and raid5
From:   Guoqing Jiang <jgq516@gmail.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
References: <20210525094623.763195-1-jiangguoqing@kylinos.cn>
 <20210601011946.1299847-1-jiangguoqing@kylinos.cn>
Message-ID: <be04b7a2-d963-f83d-61d1-a1216097fe26@gmail.com>
Date:   Thu, 3 Jun 2021 09:17:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210601011946.1299847-1-jiangguoqing@kylinos.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 6/1/21 9:19 AM, Guoqing Jiang wrote:
> From: Guoqing Jiang <jgq516@gmail.com>
>
> We introduce a new bioset (io_acct_set) for raid0 and raid5 since they
> don't own clone infrastructure to accounting io. And the bioset is added
> to mddev instead of to raid0 and raid5 layer, because with this way, we
> can put common functions to md.h and reuse them in raid0 and raid5.
>
> Also struct md_io_acct is added accordingly which includes io start_time,
> the origin bio and cloned bio. Then we can call bio_{start,end}_io_acct
> to get related io status.
>
> Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
> Signed-off-by: Song Liu <song@kernel.org>
> ---
> Hi Song,
>
> Please consider apply the updated patch which has minor changes based on
> Christoph's comment.
>
> 1. don't create io_acct_set for raid1 and raid10.
> 2. update comment for md_account_bio.

Pls ignore this given it didn't check all the places before io_acct_set.
Do you want an incremental patch against for-next branch or a fresh
one to replace current patch in the tree?

Thanks,
Guoqing
