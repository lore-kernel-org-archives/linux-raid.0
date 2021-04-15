Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A24C433B4
	for <linux-raid@archiver.kernel.org>; Thu, 15 Apr 2021 19:50:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0284C60C3E
	for <linux-raid@archiver.kernel.org>; Thu, 15 Apr 2021 19:50:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbhDOTvL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 15 Apr 2021 15:51:11 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:43728 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235059AbhDOTvJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 15 Apr 2021 15:51:09 -0400
Received: by mail-pl1-f181.google.com with SMTP id u15so4133767plf.10;
        Thu, 15 Apr 2021 12:50:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jzSTR4S/XfBfmHFocbuUnh6F7IZZt8GfGeTP4lw6/K4=;
        b=apWIUZHIHt4+i6wPIkUq+M+gy2DRbKQZ4yCC205zpY1de+xe3Q6pP2SZ2c+x+Kp4Pj
         0YFxb6RFjlujEGFT8ZpSqPu1oMnTXknm3bc7iGRQoMy6CxWzR3pFY+N7X7CCkf4i+eqr
         4vxgBvEB6w4xn7/tZQDR2S77kSm5O12H9zslXpO5P7XO5ZXMk4AyIWgVJDfQjoZ3/vQN
         1EEIEY1E606I2lYDzpTlT6V2h726IczLnbYwZ1uknbZ/CVbyKxaQItvW1k0k86gWuMHY
         Yon1rL4561ojF+QI15FoY/U+LLSlJwByfVgFy5/iy+QCigsNDp05u7V6PPuBahwEu2S7
         +h5Q==
X-Gm-Message-State: AOAM533A78SK7Xs4KCwhZj4prpXtRSoGd0H9pG8xvOUl9EWWidCFqADX
        dRa1Ws8XUPHbnPMVyIC8AKU=
X-Google-Smtp-Source: ABdhPJxePiKeGIZglO2VnENKO4CmWRNHyXXkuqGu0pEa2yWYv+nCrnpvMLLjycBthAhK0BSdfce1dg==
X-Received: by 2002:a17:902:7689:b029:eb:3d5f:ae58 with SMTP id m9-20020a1709027689b02900eb3d5fae58mr5532107pll.39.1618516245716;
        Thu, 15 Apr 2021 12:50:45 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:f031:1d3a:7e95:2876? ([2601:647:4000:d7:f031:1d3a:7e95:2876])
        by smtp.gmail.com with ESMTPSA id e9sm2997293pgk.69.2021.04.15.12.50.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 12:50:44 -0700 (PDT)
Subject: Re: [RFC PATCH 1/2] percpu_ref: add percpu_ref_tryget_many_live
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
        linux-nvme@lists.infradead.org, Tejun Heo <tj@kernel.org>,
        Christoph Hellwig <hch@lst.de>
References: <20210415103310.1513841-1-ming.lei@redhat.com>
 <20210415103310.1513841-2-ming.lei@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <dcdc3233-b4a6-24b2-85dd-78ed9e70fef1@acm.org>
Date:   Thu, 15 Apr 2021 12:50:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210415103310.1513841-2-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/15/21 3:33 AM, Ming Lei wrote:
>  /**
> - * percpu_ref_tryget_live - try to increment a live percpu refcount
> + * percpu_ref_tryget_many_live - try to increment a live percpu refcount
>   * @ref: percpu_ref to try-get
> + * @nr: number of references to get

You may want to change "increment" into "increase" to make it more clear
that this function may increase the percpu refcount by more than one.

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
