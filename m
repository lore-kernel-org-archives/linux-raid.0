Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D82C636D3
	for <linux-raid@archiver.kernel.org>; Thu,  2 Feb 2023 00:24:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjBBAYk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Feb 2023 19:24:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjBBAYj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Feb 2023 19:24:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D506E42B
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 16:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675297428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HB+O6mDHJeFy3uTgr5jTSbv6KRSaGpOO3CAJ2X7TWXM=;
        b=BAfq603WvH2ecmzlyTaSx2bRUXG216/vXECr9B6YMU8taUJMqY2RBStsFAbOdHKJ/WVU/+
        Utpd3nD6egk9fHhNOzltjp14niMJotUHC8jF/pY+khgt09sXMmlPxp8trBN89Zpoa1iPi+
        5II14n2PRHQE0EGeC0iCzXNbg89aVjw=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-580-Omm9GF5fMDmiWiLLIT2WQg-1; Wed, 01 Feb 2023 19:23:47 -0500
X-MC-Unique: Omm9GF5fMDmiWiLLIT2WQg-1
Received: by mail-pj1-f70.google.com with SMTP id s16-20020a17090aba1000b002303782fcd8so1640313pjr.9
        for <linux-raid@vger.kernel.org>; Wed, 01 Feb 2023 16:23:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HB+O6mDHJeFy3uTgr5jTSbv6KRSaGpOO3CAJ2X7TWXM=;
        b=dy5SFW0JQLjnt5/2SDYIYYBApS1ThIYxpbs8xReGb4+QqjyVjkKCuntpPXwQKmecFX
         1yagOoXeNkOJbBcc5GISM69+U5FmuT+bfhXeUPEDzHUOhzZZU7qqpssPhcP2A4URHK3+
         i5JKoZQT5FoI/kdY76HoBTgmPSPOvGg02zMfX8tnva/n25ou5OzqZ1hOf2wxnsjMO3Y0
         qPUVNW60gfrcYn14NtG0s1BtZP3vFCYOLp5+NZxir52GEUlDiNPNwZUa9/gY2YwOevB/
         9t/MVfEN87eUsA4QPWPKMfFaKQNaW0z318Tv3d9CuFwCHfu/z1j7wG1SXhlcgOZzhf7B
         4h7A==
X-Gm-Message-State: AO0yUKVhDMi0sWtXP6XjxXajWWIHZZHBmQIvYzVDC4L9mOTcp+xu2bM+
        0Q6y/ZDNjvcMcpoNJDPdIKoVo8YblKoiXWU4G6vLID9jYT16wWoLYRHCOhjH8EmohOyWF3zXXCs
        WCFcQfA8ndu8fquCAQ1Ft/HtAc1+T7tGxWGwsvA==
X-Received: by 2002:a62:ee05:0:b0:593:adf1:3c4 with SMTP id e5-20020a62ee05000000b00593adf103c4mr917970pfi.37.1675297426083;
        Wed, 01 Feb 2023 16:23:46 -0800 (PST)
X-Google-Smtp-Source: AK7set8Ke5pfdGJwDaVLZpHf7+8Ahnjw3xwnIdUlAhjAQt7pnHdFa8fW5t5se5QZgn0/YiqYFn8xqJE69y+R7pn2TIs=
X-Received: by 2002:a62:ee05:0:b0:593:adf1:3c4 with SMTP id
 e5-20020a62ee05000000b00593adf103c4mr917969pfi.37.1675297425815; Wed, 01 Feb
 2023 16:23:45 -0800 (PST)
MIME-Version: 1.0
References: <20230201124640.3749-1-xni@redhat.com> <CAPhsuW7MCSVREMp48CoO-qE-HfMonxhJn-+HfRUxvHfBXL0Nug@mail.gmail.com>
In-Reply-To: <CAPhsuW7MCSVREMp48CoO-qE-HfMonxhJn-+HfRUxvHfBXL0Nug@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Thu, 2 Feb 2023 08:23:34 +0800
Message-ID: <CALTww2_cLaULw4+QwwkjhhmBwjcP9GBTxNOR=WsZXAnPJaUakg@mail.gmail.com>
Subject: Re: [PATCH V3 1/1] md/raid0: Add mddev->io_acct_cnt for raid0_quiesce
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, ming.lei@redhat.com,
        ncroxon@redhat.com, heinzm@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Feb 2, 2023 at 2:00 AM Song Liu <song@kernel.org> wrote:
>
> On Wed, Feb 1, 2023 at 4:46 AM Xiao Ni <xni@redhat.com> wrote:
> >
> > It has added io_acct_set for raid0/raid5 io accounting and it needs to
> > alloc md_io_acct in the i/o path. They are free when the bios come back
> > from member disks. Now we don't have a method to monitor if those bios
> > are all come back. In the takeover process, it needs to free the raid0
> > memory resource including the memory pool for md_io_acct. But maybe some
> > bios are still not returned. When those bios are returned, it can cause
> > panic bcause of introducing NULL pointer or invalid address. Something
> > like this:
>
> Can we use mddev->active_io for this? If not, please explain the reason
> in the comments (in the code).

Hi Song

At first, we thought this way. Now ->acitve_io is used to wait all
submit processes to exit.
If we use ->active_io to count acct_bio, it means we change the usage
of ->active_io.
In mddev_suspend, first it waits for all submit processes to finish,
then it calls ->quiesce
to wait all inflight io to come back. For raid0, it's ok to use
->acitve_io to count acct_bio.
But for raid5, not sure if it's ok. What's your opinion?

>
> [...]
>
> > +       } else
>
> Please add { } for the else clause.

ok

Regards
Xiao
>
> Thanks,
> Song
>
> > +               if (percpu_ref_is_dying(&mddev->io_acct_cnt))
> > +                       percpu_ref_resurrect(&mddev->io_acct_cnt);
> >  }
> >
> >  static struct md_personality raid0_personality=
> > --
> > 2.32.0 (Apple Git-132)
> >
>

