Return-Path: <SRS0=xKAG=B6=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7092EC433E1
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 22:45:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4282B207DA
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 22:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597963522;
	bh=yiY8iyb7Rnib+8p1lQnuWBgvhddMANznKVgWuR9f+xE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=rGGXRfwZkinLleB7b1gnpH+903jAaaSRwPcjCdmfT8OtyDc83yRme2EocenWqpB8e
	 1Ir3FRhe4W7GSgD09MGCrges4CtnbVW4RMAA/PM2j0a/eT/qr4pn4n5cwoDjDiZkha
	 WWlcOoJC0wRyTSJQZszKnQAPqiUrcvxTe/Xqw/+Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728498AbgHTWpV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Aug 2020 18:45:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728423AbgHTWpR (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 20 Aug 2020 18:45:17 -0400
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06CE52087D
        for <linux-raid@vger.kernel.org>; Thu, 20 Aug 2020 22:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597963517;
        bh=yiY8iyb7Rnib+8p1lQnuWBgvhddMANznKVgWuR9f+xE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gNhXUiiywpEjJJrIeE0QQ7Uk7tEY6JTDAYg2KU9uZtl+rcVeD/bPcDjhj68yTlGqP
         AYJ6djFD+9aBt/E5nQzCVcH6gRWs6QdFGj6GOC1puMxvJDqIvhjuZIyVJj0up6v0ty
         iGp0pAQlSC6leVoom5PO/sohOitq34uY4gJPH0o8=
Received: by mail-lj1-f179.google.com with SMTP id v9so3878974ljk.6
        for <linux-raid@vger.kernel.org>; Thu, 20 Aug 2020 15:45:16 -0700 (PDT)
X-Gm-Message-State: AOAM532E1J+VkeOG7VIZh3VBYutmV1wyIvBxqw9RjzMuDjuFxgIvx7/h
        VThpJkkxn+b4De07sszRqKBPd+cNdRowq4nSD8E=
X-Google-Smtp-Source: ABdhPJxsEbCAr7YzsYcaGR90400Z0hisXEBFFsRSZZMJ+IkvcI8WYzsY6FpvnUVPp56Kfs+TBPLS5ryYvlqQPRcgDEY=
X-Received: by 2002:a2e:7a03:: with SMTP id v3mr91077ljc.350.1597963515323;
 Thu, 20 Aug 2020 15:45:15 -0700 (PDT)
MIME-Version: 1.0
References: <1597306476-8396-1-git-send-email-xni@redhat.com>
 <1597306476-8396-4-git-send-email-xni@redhat.com> <CAPhsuW4sa8PBC8sn4u+9SBMEHkinoAr2jRss1bSsvV+WQ+yPuA@mail.gmail.com>
 <f1a59821-cd64-d694-5d4e-f0dba81e635f@redhat.com> <b01d98d4-51b2-14e6-9eac-bf2139189e2e@redhat.com>
In-Reply-To: <b01d98d4-51b2-14e6-9eac-bf2139189e2e@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 20 Aug 2020 15:45:03 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4Ej1h8B9=xAVdaty_NY=rQWBmj_2CfSRicROu+vu72rQ@mail.gmail.com>
Message-ID: <CAPhsuW4Ej1h8B9=xAVdaty_NY=rQWBmj_2CfSRicROu+vu72rQ@mail.gmail.com>
Subject: Re: [PATCH V3 3/4] md/raid10: improve raid10 discard request
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

On Thu, Aug 20, 2020 at 2:06 AM Xiao Ni <xni@redhat.com> wrote:
[...]

> >> We need to clear blocked_rdev before this goto, or put retry_wait label
> >> before "blocked_rdev = NULL;". I guess this path is not tested...
> > I did test for this patch with mkfs with/without resync and wrote some
> > files to device.
> > And ran fstrim after writing some files. The patch worked well during
> > the test.
> > For blocked device situation, I didn't test. I'll add this test.
> >>
> >> We are duplicating a lot of logic from raid10_write_request() here.
> >> Can we
> >> try to pull the common logic into a helper function?
> > I'll do this.
>
> Hi Song
>
> At first I had thought about this. In raid10_write_request, it checks
> blocked rdev, badblock and sets
> r10_bio->devs[].bio in one loop. Can we move the codes that check
> blocked rdev into a separate loop,
> similar like this:
>
> wait_block:
> for (i = 0;  i < conf->copies; i++) {
>      /* check rdev/rrdev is block or not
>       * If it's block, goto wait_block
>       */
> }
>
> for (i = 0;  i < conf->copies; i++) {
>      /* check bad block
>       * sets r10_bio->devs[i].bio
>       */
> }
>
> This way it waits until all rdev devices are not blocked. There is a
> possibility that some rdev devices change
> to blocked again after checking. But the way raid10_write_request uses
> now has this risk too. If you think
> the method mentioned above is OK, I'll try to use this way.

I think it is possible to make the code work this way. Let's try refactor
raid10_write_request() like this. If it doesn't work for some reason, we
can revisit this part.

Thanks,
Song
