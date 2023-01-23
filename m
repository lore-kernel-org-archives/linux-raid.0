Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 792B3C05027
	for <linux-raid@archiver.kernel.org>; Mon, 23 Jan 2023 23:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbjAWXtl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 23 Jan 2023 18:49:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbjAWXtk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 23 Jan 2023 18:49:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E00972A1
        for <linux-raid@vger.kernel.org>; Mon, 23 Jan 2023 15:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674517732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SEFpIe1Y4Xr9E2zmKTUdsC8GiRKK+vbQkDfDWTVY0Ps=;
        b=Jb63iecPnxLh4SyaWyPLlwgASTG8PdfN4dJcWipoqP3kZYcXj1zzcqsPJnWuN2iTk1soWN
        ildbaIAxyyV2lA+PrN1y0Il2gvvcCto7JldV+V3p+znHKPnzBqwLjsMUfsbgzPmffauRSc
        hHvQ+1k7yI1vW/wy2frFWdlxPDlv7qA=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-68-Okir8rTbMbiAho_6nhr0bA-1; Mon, 23 Jan 2023 18:48:51 -0500
X-MC-Unique: Okir8rTbMbiAho_6nhr0bA-1
Received: by mail-pj1-f72.google.com with SMTP id a2-20020a17090acb8200b00225c0839b80so5491115pju.5
        for <linux-raid@vger.kernel.org>; Mon, 23 Jan 2023 15:48:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SEFpIe1Y4Xr9E2zmKTUdsC8GiRKK+vbQkDfDWTVY0Ps=;
        b=gwrbvO76OJNNQTwe3gT2XqCkso6etqeevtVTTNL403cQuH0HxMhHUDlic0WafHHKge
         KyUJZLhmlZpwWpb5OESDtlvb/BBIF7uBmuE0Ot0/JUHPuM9JLtuCJ5J2CJv89F5dzPO+
         OQsU3W3a9aesFCf2sxAmW4M4T24aUbG8DY/ciG09FrEn5RpER3ds29IfP6Y0n37V9fR+
         dRizexhb5jWKkW/4Qz08q05BhlFwdGa6NSmNuUmrJxHhib3VHoFgNTszlF2hAcf70BTI
         byymzuiOHhq/YhMW7D3kfbGB11uOf1hS9DUMYp8PLXo593Ntd1xDkfkEIRUh5BGrLMDh
         VsiQ==
X-Gm-Message-State: AFqh2kqmXJnUUSLTS75R8PXnNuKFxww2mWzpb1xLeGtvxFHtFzp0PJ8m
        leycPYcsgEGZk1aMPq3iHSQrF4dR+inQR6YSrY74avyI7my1ULjSmxc3MtRpB08tWSmc6+bFveS
        D4qHYAHnbXzNDLIDrzANOaHjvXCDw9oUP8I9d7g==
X-Received: by 2002:a05:6a00:26ec:b0:58b:9760:224c with SMTP id p44-20020a056a0026ec00b0058b9760224cmr2863493pfw.0.1674517730342;
        Mon, 23 Jan 2023 15:48:50 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsNEfssCTSARhZHNjYyiiHGMjboXxuKrlU/IvBZpDViBWIDeXHk0QU2bxUybibVXkmU3tYRX0dxI1kG4LityKw=
X-Received: by 2002:a05:6a00:26ec:b0:58b:9760:224c with SMTP id
 p44-20020a056a0026ec00b0058b9760224cmr2863487pfw.0.1674517729975; Mon, 23 Jan
 2023 15:48:49 -0800 (PST)
MIME-Version: 1.0
References: <20230121013937.97576-1-xni@redhat.com> <20230121013937.97576-2-xni@redhat.com>
 <2480c4f0-dd0a-764e-6f04-d70dfb018501@molgen.mpg.de>
In-Reply-To: <2480c4f0-dd0a-764e-6f04-d70dfb018501@molgen.mpg.de>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 24 Jan 2023 07:48:38 +0800
Message-ID: <CALTww28qWO00-4VegLZZgkjNY=aLD865Lk7YBWob5r8=EVeTSg@mail.gmail.com>
Subject: Re: [PATCH 1/2] md: Factor out is_md_suspended helper
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     song@kernel.org, linux-raid@vger.kernel.org, ming.lei@redhat.com,
        ncroxon@redhat.com, heinzm@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jan 23, 2023 at 9:18 PM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> Dear Xiao,
>
>
> Thank you for the patch.
>
> Am 21.01.23 um 02:39 schrieb Xiao Ni:
> > This helper function will be used in next patch. It's easy for
> > understanding.
> >
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >   drivers/md/md.c | 17 ++++++++++++-----
> >   1 file changed, 12 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 775f1dde190a..d3627aad981a 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -380,6 +380,13 @@ EXPORT_SYMBOL_GPL(md_new_event);
> >   static LIST_HEAD(all_mddevs);
> >   static DEFINE_SPINLOCK(all_mddevs_lock);
> >
> > +static bool is_md_suspended(struct mddev *mddev)
> > +{
> > +     if (mddev->suspended)
> > +             return true;
> > +     else
> > +             return false;
>
> suspended seems to be an integer, so this could be written as:
>
>      return !!mddev->suspended;
>
> or
>
>      return (mddev->suspended) ? true : false;
>
>
> Kind regards,
>
> Paul

Hi Paul

Thanks for this.

Regards
Xiao
>
>
> > +}
> >   /* Rather than calling directly into the personality make_request function,
> >    * IO requests come here first so that we can check if the device is
> >    * being suspended pending a reconfiguration.
> > @@ -389,7 +396,7 @@ static DEFINE_SPINLOCK(all_mddevs_lock);
> >    */
> >   static bool is_suspended(struct mddev *mddev, struct bio *bio)
> >   {
> > -     if (mddev->suspended)
> > +     if (is_md_suspended(mddev))
> >               return true;
> >       if (bio_data_dir(bio) != WRITE)
> >               return false;
> > @@ -434,7 +441,7 @@ void md_handle_request(struct mddev *mddev, struct bio *bio)
> >               goto check_suspended;
> >       }
> >
> > -     if (atomic_dec_and_test(&mddev->active_io) && mddev->suspended)
> > +     if (atomic_dec_and_test(&mddev->active_io) && is_md_suspended(mddev))
> >               wake_up(&mddev->sb_wait);
> >   }
> >   EXPORT_SYMBOL(md_handle_request);
> > @@ -6217,7 +6224,7 @@ EXPORT_SYMBOL_GPL(md_stop_writes);
> >   static void mddev_detach(struct mddev *mddev)
> >   {
> >       md_bitmap_wait_behind_writes(mddev);
> > -     if (mddev->pers && mddev->pers->quiesce && !mddev->suspended) {
> > +     if (mddev->pers && mddev->pers->quiesce && !is_md_suspended(mddev)) {
> >               mddev->pers->quiesce(mddev, 1);
> >               mddev->pers->quiesce(mddev, 0);
> >       }
> > @@ -8529,7 +8536,7 @@ bool md_write_start(struct mddev *mddev, struct bio *bi)
> >               return true;
> >       wait_event(mddev->sb_wait,
> >                  !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) ||
> > -                mddev->suspended);
> > +                is_md_suspended(mddev));
> >       if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
> >               percpu_ref_put(&mddev->writes_pending);
> >               return false;
> > @@ -9257,7 +9264,7 @@ void md_check_recovery(struct mddev *mddev)
> >               wake_up(&mddev->sb_wait);
> >       }
> >
> > -     if (mddev->suspended)
> > +     if (is_md_suspended(mddev))
> >               return;
> >
> >       if (mddev->bitmap)
>

