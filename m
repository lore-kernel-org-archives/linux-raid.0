Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C43BFC47088
	for <linux-raid@archiver.kernel.org>; Wed, 26 May 2021 01:06:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 826CB61417
	for <linux-raid@archiver.kernel.org>; Wed, 26 May 2021 01:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbhEZBHm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 25 May 2021 21:07:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232667AbhEZBHm (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 25 May 2021 21:07:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A4B861417;
        Wed, 26 May 2021 01:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621991171;
        bh=suWTak2nIbJaH1PfuIsaIK72vhJNtSmBM6r/7RbK0k8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=L5WIbr5cxGGrmxVmCMdO1bpKdssiR0RVeFLSNOEhwnK1pOD/bQ/vesHInb6iHD3nt
         xa0jbASNq2n+KGeE50n6dTZY+iIqnKM2WT9l52vuVJhqGGsJLAXVWNSFG5qo60POkN
         Pn9ZKRoterDaiJ1CcjV6ZhuK2HPJaAMjMvZ2fAtQ5hDTfR36LGvQkJilaBGDlReRPW
         xZ4bD41PKJ1LccOn4B2hz7HU21qs2YKouHhJJhaDB2FRMMvQxqwr1b0dNA/37HqVva
         7BrcrX4HowakojJEfZTEN8mOJ6NL68emHQ/JWYGXv6arhL0xw5Z60FTMWAIqEs7BlF
         6P9UTuChvlSXw==
Received: by mail-lf1-f41.google.com with SMTP id q7so47586123lfr.6;
        Tue, 25 May 2021 18:06:11 -0700 (PDT)
X-Gm-Message-State: AOAM533uDB9e9Ic8U85NFriS0L2liveAH3jPYs/TncWjayQZdfrK6jqV
        Dd8zsxlsivf6iSkxU5kpbSApkq11Xj/dpOeFMME=
X-Google-Smtp-Source: ABdhPJznpc79jCmsT4vtUKJ8lkaFEHW03odhnF4mfNqfP0PkcJ8aaxoNlCxV2GF7YW2hHjNkQb4cuvUY567k+x21krc=
X-Received: by 2002:ac2:5b12:: with SMTP id v18mr274027lfn.261.1621991169859;
 Tue, 25 May 2021 18:06:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210519062215.4111256-1-hch@lst.de> <1102825331.165797.1621422078235@ox.hosteurope.de>
 <CAPhsuW7W7NfBTHY3A87py1No=FOPZgxMP4Ms43Re3uRnT0JzkQ@mail.gmail.com> <5C3BA4F9-DBA4-49AF-9F2C-D469BCA9E1A0@dazinger.net>
In-Reply-To: <5C3BA4F9-DBA4-49AF-9F2C-D469BCA9E1A0@dazinger.net>
From:   Song Liu <song@kernel.org>
Date:   Tue, 25 May 2021 18:05:58 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5o0TO-==OmuBS7Zgmeqk390Qbrmd1FSXYGRO=WCf=6Ew@mail.gmail.com>
Message-ID: <CAPhsuW5o0TO-==OmuBS7Zgmeqk390Qbrmd1FSXYGRO=WCf=6Ew@mail.gmail.com>
Subject: Re: [PATCH] md/raid5: remove an incorect assert in in_chunk_boundary
To:     "Florian D." <spam02@dazinger.net>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, May 24, 2021 at 4:00 AM Florian D. <spam02@dazinger.net> wrote:
>
> As you like... if it's better in the 'tested by:' line, you can also take my full name: Florian Dazinger.
>  I use the e- mail address regularly, so that's ok.
>

Added both Reported-by and Tested-by with your full name.

Thanks,
Song
