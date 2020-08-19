Return-Path: <SRS0=jE/M=B5=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01356C433DF
	for <linux-raid@archiver.kernel.org>; Wed, 19 Aug 2020 18:39:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B251C207FF
	for <linux-raid@archiver.kernel.org>; Wed, 19 Aug 2020 18:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597862348;
	bh=VmtnYIlrJv63X2hpoTNAYQ6tX+DHuv/SPtaRQNt5Jr8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=PwtoHJoE9+BQ4UFOcpKdYsoOEIMbLGsAPd/IQV7HucDK+cxMPHM52FH6AZTD9Z1Zt
	 ERnWIrTC0YGQmM054MRVtrCLKln0CRuMqXYsznPQRCrJxPVgS2DJ3NL1AQHxIpl3HC
	 3N0GPOMROj6kdaue1uecb7S9D+ilXEcXTIAapsxM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgHSSjI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Aug 2020 14:39:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbgHSSjH (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 19 Aug 2020 14:39:07 -0400
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 491F1207FF
        for <linux-raid@vger.kernel.org>; Wed, 19 Aug 2020 18:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597862347;
        bh=VmtnYIlrJv63X2hpoTNAYQ6tX+DHuv/SPtaRQNt5Jr8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=xdXb0rDib0XLEeiyYAgMr/vmdHj3xLUitf1NedOGJEuHq3tCK2xh7vF1qdT7htbJm
         GYpDvbcMfOt1pcwTWfl3+xNDs+eApztq91NuiLkA8fAAjHRImON6J4RhuiUsI5y9eJ
         ZmkSZe5JBTKqi6EL2pUC1lrQL48hfXGMPWOuB8h4=
Received: by mail-lf1-f49.google.com with SMTP id c8so1020660lfh.9
        for <linux-raid@vger.kernel.org>; Wed, 19 Aug 2020 11:39:07 -0700 (PDT)
X-Gm-Message-State: AOAM5302lxzW5dG2UgR4ZUorPjoUG8x9F3ci901DsauQqNJ5pepvPhSk
        pF1XxG3ywfMBFCOqoBsjz2lTcZu8yqPz9CE9hlw=
X-Google-Smtp-Source: ABdhPJw1hYOkGqzy2XCK+wYPMJh4c25VcqjVksO12VxOHAmS39DFC2sa/4GZya0vb0dRNnoxLcEPphVmRqWtFgBqTYM=
X-Received: by 2002:ac2:4881:: with SMTP id x1mr1915841lfc.162.1597862345201;
 Wed, 19 Aug 2020 11:39:05 -0700 (PDT)
MIME-Version: 1.0
References: <1597306476-8396-1-git-send-email-xni@redhat.com> <1597306476-8396-5-git-send-email-xni@redhat.com>
In-Reply-To: <1597306476-8396-5-git-send-email-xni@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 19 Aug 2020 11:38:54 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6OSp71fEXiW4D0uf4n=T65xLMiQDbSRd6FDhua3adg-A@mail.gmail.com>
Message-ID: <CAPhsuW6OSp71fEXiW4D0uf4n=T65xLMiQDbSRd6FDhua3adg-A@mail.gmail.com>
Subject: Re: [PATCH V3 4/4] md/raid10: Improve discard request for far layout
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>, Coly Li <colyli@suse.de>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Aug 13, 2020 at 1:15 AM Xiao Ni <xni@redhat.com> wrote:
>
> For far layout, the discard region is not continuous on disks. So it needs
> far copies r10bio to cover all regions. It needs a way to know all r10bios
> have finish or not. Similar with raid10_sync_request, only the first r10bio
> master_bio records the discard bio. Other r10bios master_bio record the first
> r10bio. The first r10bio can finish after other r10bios finish and then return
> the discard bio.
>
> Signed-off-by: Xiao Ni <xni@redhat.com>

1/4 and 2/4 of the set looks good to me. But we will need more work on 3
and 4. Please refer to comments in 3/4.

Please also rebase on top of the latest md-next branch, and try fix warnings
from checkpatch.pl.

Thanks,
Song
