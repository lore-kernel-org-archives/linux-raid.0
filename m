Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79AF8C38A2D
	for <linux-raid@archiver.kernel.org>; Thu, 27 Oct 2022 08:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiJ0IJx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 27 Oct 2022 04:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiJ0IJv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 27 Oct 2022 04:09:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8B713CDC
        for <linux-raid@vger.kernel.org>; Thu, 27 Oct 2022 01:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666858188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N3A1HBXAz48GJsAthFqHPPYFuaZyjy7xJ0Xjay//wmg=;
        b=L9NGO305Ed4fqAvj1uL0UxIqkjP21sVzyQKjCwPOXin4tGmLgZwS1i6xrsWvB8xDi7Vtag
        xHjbynxR/94rq8YqXffHQdmOoEyglNJtB5mRpCgaKFKRhWPH1cYtQq/qdOfR4x0mh8gvw8
        LE8We+mlmV45axHDy+JPeYKbrD6v4L4=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-57-c8OgrvirN9mIBLId8y79Xw-1; Thu, 27 Oct 2022 04:09:46 -0400
X-MC-Unique: c8OgrvirN9mIBLId8y79Xw-1
Received: by mail-pl1-f199.google.com with SMTP id l16-20020a170902f69000b001865f863784so579498plg.2
        for <linux-raid@vger.kernel.org>; Thu, 27 Oct 2022 01:09:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N3A1HBXAz48GJsAthFqHPPYFuaZyjy7xJ0Xjay//wmg=;
        b=X0x+2NVLDAB8G4zsozomI2S/Hlrj+qrKCytapgBkD/WnTXZd0u0fKuFMwiPRDfzeS/
         T8p730obFINGcyLwBfWnDi8//nFti87ieV4CSK+Zr2W8i6+yYT49V/BY8V/0xEOAishS
         6NPwaLlV+2rZDsYI7/hidh/G1zfpPvpg5LFr27x8uPfwrfN7M3MS4VcW0fU5Qvhe2a0q
         q9wwAOuLJziQGnZEp3W5eSaubGS3rA0qy0iRt+ZfGsJuz4jf3QKOSxtbvNVqFx9wRmVh
         94NdOBUdeHSsmYMGab7mnEC4+6Be31axe16UND1tDmzYrYDsV4i/hAw34bG3A9Nn3oOR
         VL/A==
X-Gm-Message-State: ACrzQf3EPlf4cQCnpuG3TogYD53d3bPjSlRDrg7Y/Uk8KpCbYO0Jt3Bq
        BU5n1ekQFeytISF1+2Pk3Vx4izX39WjmeBiySDytM/R2t3RvIfkJKB+6nqGoNWPStAGjuZeFlG0
        SVdnWysqbYtI//KgMJ09qew6AD2wNVJvTMZDZgg==
X-Received: by 2002:a17:903:240d:b0:183:9bab:9c3 with SMTP id e13-20020a170903240d00b001839bab09c3mr48456924plo.48.1666858185476;
        Thu, 27 Oct 2022 01:09:45 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4g7aZhMX3lnt9Pwo/ImmeUJV+CkRhdE5ACgDeeG0D1DXfRE6CAs/XF1vtKUvgVaxFxXJL49JivVFiBc4y0CMw=
X-Received: by 2002:a17:903:240d:b0:183:9bab:9c3 with SMTP id
 e13-20020a170903240d00b001839bab09c3mr48456898plo.48.1666858185167; Thu, 27
 Oct 2022 01:09:45 -0700 (PDT)
MIME-Version: 1.0
References: <20221020045903.19950-1-kinga.tanska@intel.com>
 <D036A378-7504-46EF-9EB6-802EA147CCB9@suse.de> <20221021121322.00002cee@intel.linux.com>
In-Reply-To: <20221021121322.00002cee@intel.linux.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Thu, 27 Oct 2022 16:09:33 +0800
Message-ID: <CALTww29K2AjqPFoKNA69zhbmEkURADiB4C_RJ53yzxVKJGbDkw@mail.gmail.com>
Subject: Re: [PATCH] super-intel: make freesize not required for chunk size migration
To:     Kinga Tanska <kinga.tanska@linux.intel.com>
Cc:     Coly Li <colyli@suse.de>, Kinga Tanska <kinga.tanska@intel.com>,
        linux-raid@vger.kernel.org, jes@trained-monkey.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Oct 21, 2022 at 6:14 PM Kinga Tanska
<kinga.tanska@linux.intel.com> wrote:
>
> On Fri, 21 Oct 2022 14:49:16 +0800
> Coly Li <colyli@suse.de> wrote:
>
> >
> >
> > > 2022=E5=B9=B410=E6=9C=8820=E6=97=A5 12:59=EF=BC=8CKinga Tanska <kinga=
.tanska@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > Freesize is not required when chunk size migration is performed. Fix
> > > return value when superblock is not set.
> >
> > Hi Kinga,
> >
> > Could you please provide a bit more information why freesize is
> > unnecessary in this situation?
> >
> > Thanks.
> >
> > Coly Li
> >
> >
> > >
> > > Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> > > ---
> > > super-intel.c | 10 +++++-----
> > > 1 file changed, 5 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/super-intel.c b/super-intel.c
> > > index 4d82af3d..37c59da5 100644
> > > --- a/super-intel.c
> > > +++ b/super-intel.c
> > > @@ -7714,11 +7714,11 @@ static int validate_geometry_imsm(struct
> > > supertype *st, int level, int layout, struct intel_super *super =3D
> > > st->sb;
> > >
> > >             /*
> > > -            * Autolayout mode, st->sb and freesize must be
> > > set.
> > > +            * Autolayout mode, st->sb must be set.
> > >              */
> > > -           if (!super || !freesize) {
> > > -                   pr_vrb("freesize and superblock must be
> > > set for autolayout, aborting\n");
> > > -                   return 1;
> > > +           if (!super) {
> > > +                   pr_vrb("superblock must be set for
> > > autolayout, aborting\n");
> > > +                   return 0;
> > >             }
> > >
> > >             if (!validate_geometry_imsm_orom(st->sb, level,
> > > layout, @@ -7726,7 +7726,7 @@ static int
> > > validate_geometry_imsm(struct supertype *st, int level, int layout,
> > > verbose)) return 0;
> > >
> > > -           if (super->orom) {
> > > +           if (super->orom && freesize) {
> > >                     imsm_status_t rv;
> > >                     int count =3D count_volumes(super->hba,
> > > super->orom->dpa, verbose);
> > > --
> > > 2.26.2
> > >
> >
>
> Hi,
>
> freesize is needed to be set for migrations where size of RAID could be
> changed - expand. It tells how many free space is determined
> for members. In chunk size migration freesize is not needed to
> be set, so we shouldn't check if pointer exists. I moved this
> check to condition which contains size calculations, instead of
> checking it always at the first step.
> We've tested it internally with both, chunk size migration and expand
> and freesize is checked only when is really needed now.
>
> Regards,
> Kinga Tanska
>

Hi Kinga

Could you send the v2 with the detailed explanation?

Regards
Xiao

