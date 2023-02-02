Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2035FC05027
	for <linux-raid@archiver.kernel.org>; Thu,  2 Feb 2023 00:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjBBAlv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Feb 2023 19:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjBBAlu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Feb 2023 19:41:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EED519A
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 16:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675298463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zk9rueH/L8tL/Ht7T9SszwJ1UITBrtNBgzoTR/tgPO0=;
        b=KHiOrzjSJ1tbyMun+af19p90e303XHR6i3jw48XVbzyzMe8u3YHMiYJ/f941gvBCdai0U2
        4qnN42lUCntSJKPrw/ky6hgbQBu6D7UHLrePrqp+ocrMaJtpNd5sQsE/8jmbjn6Iy9rHXS
        vkHY9YXOk/XlQLI6X4C+lgJSnBqAGmg=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-48-_T81w6FFPc-8fbMVaNtBkw-1; Wed, 01 Feb 2023 19:41:00 -0500
X-MC-Unique: _T81w6FFPc-8fbMVaNtBkw-1
Received: by mail-pl1-f200.google.com with SMTP id l1-20020a17090270c100b00198be135a14so112179plt.9
        for <linux-raid@vger.kernel.org>; Wed, 01 Feb 2023 16:40:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zk9rueH/L8tL/Ht7T9SszwJ1UITBrtNBgzoTR/tgPO0=;
        b=fnnYeciH/eDi6nRRWBas67d4BYEe6Q+e4ThfvFDBsScTupO3cAIhTdyfWMTq3quzjY
         ap+U6ZFvCScm/QL8ACv7eALJAifV5WAqWF5z3O8BG53poa5VqlzBnzsH2ryRfgQX37t/
         R/a17RSZhqbk02WuolewporGZVlH0rhu8prECxqMybKp8j6qC/5EGtwPLgIxmS8NHVJO
         Yjp3LjPdo0YgUCiH1FwZH/32zh+4ZeNksUuC3aVZqFoCO3H4fvj5fygk5BF8b6M9X+JV
         cIkot3JjrqaK7loR5RVgh8AtKIYTDmrmg7tgjO2GZy9PiLnJfkUMjcqK2MPSPGl3Suf3
         BgNg==
X-Gm-Message-State: AO0yUKUsiw8YNexbbnjZaJOXyp2iludWkVcGzTxnNsxe3/zuAH8k7JzC
        vIn4Io4Z4xDPKC34wkHkRlfQB9hROCDqGQldT1o2GiwAH3lj1MW2ScUAvAwkOFvaDMaMxZt46pT
        0ZAHhwmMpkGvklv2f8TF/oX+OQEBu596QYuLS9A==
X-Received: by 2002:a05:6a00:1502:b0:593:8deb:820a with SMTP id q2-20020a056a00150200b005938deb820amr925782pfu.53.1675298459081;
        Wed, 01 Feb 2023 16:40:59 -0800 (PST)
X-Google-Smtp-Source: AK7set/FAktuMbH6x4O1cRKFedCtNMAttMNfOO3zYtzHbPwaLVmjagVIri1erDgLoHdsv7/8jCySYuePVF3TQqiO0BE=
X-Received: by 2002:a05:6a00:1502:b0:593:8deb:820a with SMTP id
 q2-20020a056a00150200b005938deb820amr925777pfu.53.1675298458780; Wed, 01 Feb
 2023 16:40:58 -0800 (PST)
MIME-Version: 1.0
References: <20230201124640.3749-1-xni@redhat.com> <CAPhsuW7MCSVREMp48CoO-qE-HfMonxhJn-+HfRUxvHfBXL0Nug@mail.gmail.com>
 <CALTww2_cLaULw4+QwwkjhhmBwjcP9GBTxNOR=WsZXAnPJaUakg@mail.gmail.com>
In-Reply-To: <CALTww2_cLaULw4+QwwkjhhmBwjcP9GBTxNOR=WsZXAnPJaUakg@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Thu, 2 Feb 2023 08:40:47 +0800
Message-ID: <CALTww2-Df5LZODnur7Mq9e+Q1bv_aDr_P+q3Y4Ded2tUnsNFTQ@mail.gmail.com>
Subject: Re: [PATCH V3 1/1] md/raid0: Add mddev->io_acct_cnt for raid0_quiesce
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, ming.lei@redhat.com,
        ncroxon@redhat.com, heinzm@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Feb 2, 2023 at 8:23 AM Xiao Ni <xni@redhat.com> wrote:
>
> On Thu, Feb 2, 2023 at 2:00 AM Song Liu <song@kernel.org> wrote:
> >
> > On Wed, Feb 1, 2023 at 4:46 AM Xiao Ni <xni@redhat.com> wrote:
> > >
> > > It has added io_acct_set for raid0/raid5 io accounting and it needs to
> > > alloc md_io_acct in the i/o path. They are free when the bios come back
> > > from member disks. Now we don't have a method to monitor if those bios
> > > are all come back. In the takeover process, it needs to free the raid0
> > > memory resource including the memory pool for md_io_acct. But maybe some
> > > bios are still not returned. When those bios are returned, it can cause
> > > panic bcause of introducing NULL pointer or invalid address. Something
> > > like this:
> >
> > Can we use mddev->active_io for this? If not, please explain the reason
> > in the comments (in the code).
>
> Hi Song
>
> At first, we thought this way. Now ->acitve_io is used to wait all
> submit processes to exit.
> If we use ->active_io to count acct_bio, it means we change the usage
> of ->active_io.
> In mddev_suspend, first it waits for all submit processes to finish,
> then it calls ->quiesce
> to wait all inflight io to come back. For raid0, it's ok to use
> ->acitve_io to count acct_bio.
> But for raid5, not sure if it's ok. What's your opinion?

Hi Song

I've sent V4. If you think ->active_io is a better way to count acct_io,
I'll re-write the patch to use ->active_io

Regards
Xiao
>
> >
> > [...]
> >
> > > +       } else
> >
> > Please add { } for the else clause.
>
> ok
>
> Regards
> Xiao
> >
> > Thanks,
> > Song
> >
> > > +               if (percpu_ref_is_dying(&mddev->io_acct_cnt))
> > > +                       percpu_ref_resurrect(&mddev->io_acct_cnt);
> > >  }
> > >
> > >  static struct md_personality raid0_personality=
> > > --
> > > 2.32.0 (Apple Git-132)
> > >
> >

