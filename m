Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93BC1C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 11 Feb 2022 07:53:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347848AbiBKHxU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:53:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiBKHxK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 11 Feb 2022 02:53:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2CD25BC1
        for <linux-raid@vger.kernel.org>; Thu, 10 Feb 2022 23:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644565988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k89DFN5cIVT30XL1aGXLG3Fj6h8cobtnaut3Iqu5mnQ=;
        b=NNn+iQAsleHXfWxLvt83DM79wvwBFmsuL0LTgsZaCzhgXWTiRTZB48sw3y5jS81bVUIBia
        jUQKc+gQgQekO/ZKcXyIppJhWVyXGJ60yQUozfLGlnfuzMNucm1E15ZaOvPhF4YN7XKZa7
        lYwAjeZ5mVYOXCqrxmb+oC7SkMzonIM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-L78PBP1WPMmublH-FTPKAA-1; Fri, 11 Feb 2022 02:53:06 -0500
X-MC-Unique: L78PBP1WPMmublH-FTPKAA-1
Received: by mail-ed1-f70.google.com with SMTP id l14-20020aa7cace000000b003f7f8e1cbbdso4856654edt.20
        for <linux-raid@vger.kernel.org>; Thu, 10 Feb 2022 23:53:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k89DFN5cIVT30XL1aGXLG3Fj6h8cobtnaut3Iqu5mnQ=;
        b=UQ7eNP71XPzTw/hqpm6B6fV0e0wEAnt5CSRZm3MO4H+R73b/0MCox1EdC3Afot8ROq
         8cLEuJHepRVD9mgCyuiBFZ0xo7Jur5miITxe/CUy8fFwjkKWwKis4DRkVndOmSDECry3
         mlGZh2nN5Gb96nxJPBL3d3A2MbAXmgG/LzoFnjBaYtdNDB6EtKo9IYlXTxcDDzl53aCL
         tnqugUKVYb9iKP5xQpFuylLYfkATNkn1Ufr8MjhiycLBCpoMEPs/54wYE5wwWgkg5eTN
         GxQPM7V1o3ceLpN/JA/7oD9xxjHC1c5e+3Bwwwl3EV9XdyY8pNhuQfQRglcq0iBXONq1
         Hh7g==
X-Gm-Message-State: AOAM533+TPfn3ZdgLSULjDgW4gFqddYV1JR+Sv5xCpt2P1Hu0b+V9OLi
        3SCcaqxuI7DRGV/swojjyNWM3M1p16m4+4Mt4P9kyC3oggeioJo2KoPwDv/QlXjWLdCUX21TLXn
        XE8AV4Nt0m1/9OuD6PjwY2Q/ku77fdzqH5c7AaQ==
X-Received: by 2002:a05:6402:4254:: with SMTP id g20mr576485edb.281.1644565985497;
        Thu, 10 Feb 2022 23:53:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzveimorVn9kxN5bHOIS5ZGwICxo46XO4AT0xHfMQqMVN87PT3XRKpeIroDuojtqLgHssxAfQ7kLWCKtTuyA1M=
X-Received: by 2002:a05:6402:4254:: with SMTP id g20mr576472edb.281.1644565985254;
 Thu, 10 Feb 2022 23:53:05 -0800 (PST)
MIME-Version: 1.0
References: <20220209104046.00004427@linux.intel.com> <CALTww2-OLe4y1kjBnz7CTBQiNerd-y9XrEc34rjO1sm5tEV5VA@mail.gmail.com>
 <CALTww2-+JcA24BAt5PkFyOG1Un_fU-Jxy2LpkCuRPk3ici1pbw@mail.gmail.com>
In-Reply-To: <CALTww2-+JcA24BAt5PkFyOG1Un_fU-Jxy2LpkCuRPk3ici1pbw@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 11 Feb 2022 15:53:42 +0800
Message-ID: <CALTww2-UxsgNBdUJ0EHrmPUyvnO+Q04DsxnOdfExN5dFmjMsfw@mail.gmail.com>
Subject: Re: fail_last_dev and FailFast/LastDev flag incompatibility
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Song Liu <song@kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

After thinking for a while, my words from my last email don't describe properly.
For raid1/raid10, if fail_last_dev is true. The bios which are sent to
member disks all have MD_FAILFAST. If there are no errors, failfast
works well until the last device failure. It will not re-send the bio
without MD_FAILFAST when fail_last_dev is true, because the last
device has been set faulty. There is no meaning to send the bio again
in this situation. So it should be right to only check faulty flag
here.

On Fri, Feb 11, 2022 at 3:24 PM Xiao Ni <xni@redhat.com> wrote:
>
> And for raid1/raid10, it looks like fail_last_dev and FailFast want to
> do opposite things.
> It can fail the last and it doesn't send a rewrite bio when
> fail_last_dev is true. Because the
> last dev has been set faulty. There is no meaning to send the rewrite
> bio. So FailFast only
> works when fail_last_dev is false.
>
> On Fri, Feb 11, 2022 at 2:48 PM Xiao Ni <xni@redhat.com> wrote:
> >
> > Hi Marisuz
> >
> > We don't need to consider MD_FAILFAST for raid456. Because only raid1
> > and raid10 support it.
> > MD_FAILFAST_SUPPORTED is only set in raid1_run/raid10_run. So LastDev
> > only be useful for
> > raid1/raid10. It should be good to only check Faulty here.
> >
> > Best Regards
> > Xiao
> >
> > On Wed, Feb 9, 2022 at 5:40 PM Mariusz Tkaczyk
> > <mariusz.tkaczyk@linux.intel.com> wrote:
> > >
> > > Hi All,
> > > During my work under failed arrays handling[1] improvements, I
> > > discovered potential issue with "failfast" and metadata writes. In
> > > commit message[2] Neil mentioned that:
> > > "If we get a failure writing metadata but the device doesn't
> > > fail, it must be the last device so we re-write without
> > > FAILFAST".
> > >
> > > Obviously, this is not true for RAID456 (again)[1] but it is also not
> > > true for RAID1 and RAID10 with "fail_las_dev"[3] functionality enabled.
> > >
> > > I did a quick check and can see that setter for "LastDev" flag is
> > > called if "Faulty" on device is not set. I proposed some changes in the
> > > area in my patchset[4] but after discussion we decided to drop changes
> > > here. Current approach is not correct for all branches, so my proposal
> > > is to change:
> > >
> > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > index 7b024912f1eb..3daec14ef6b2 100644
> > > --- a/drivers/md/md.c
> > > +++ b/drivers/md/md.c
> > > @@ -931,7 +931,7 @@ static void super_written(struct bio *bio)
> > >                 pr_err("md: %s gets error=%d\n", __func__,
> > >                        blk_status_to_errno(bio->bi_status));
> > >                 md_error(mddev, rdev);
> > > -               if (!test_bit(Faulty, &rdev->flags)
> > > +               if (test_bit(MD_BROKEN, mddev->flag)
> > >                     && (bio->bi_opf & MD_FAILFAST)) {
> > >                         set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
> > >                         set_bit(LastDev, &rdev->flags);
> > >
> > >
> > > It will force "LastDev" to be set on every metadata rewrite if mddevice
> > > is known to be failed.
> > > Do you have any other suggestions?
> > >
> > > + Guoqing - author of fail_last_dev.
> > > + Xiao - you are familiarized with FailFast so please take a look.
> > >
> > > [1]https://lore.kernel.org/linux-raid/CAPhsuW54_9CTR6sh7mnQ6O77F2HNArLHGWHYsUdbNGy7pXgipQ@mail.gmail.com/T/#m8cf7c57429b6fd332220157186151900ce23865d
> > > [2]https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?id=46533ff7fefb7e9e3539494f5873b00091caa8eb
> > > [3]https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?id=9a567843f7ce
> > > [4]https://lore.kernel.org/linux-raid/CAPhsuW5bV+Bz=Od9jomNHoedaEMFAXymN11J80G62GVPwSp41g@mail.gmail.com/
> > >
> > > Thanks,
> > > Mariusz
> > >

