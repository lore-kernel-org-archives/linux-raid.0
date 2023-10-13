Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63BA7CDB485
	for <linux-raid@archiver.kernel.org>; Fri, 13 Oct 2023 08:48:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjJMIsU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 13 Oct 2023 04:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbjJMIsT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 13 Oct 2023 04:48:19 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D9595
        for <linux-raid@vger.kernel.org>; Fri, 13 Oct 2023 01:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697186898; x=1728722898;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P9CgaW68QxGKjcZggLHyiF313FM+hriHoacPWBmBQTg=;
  b=NWIpQyTIlRVqpNQjNCl6MpWR0ZPuf8//n2YHDKNDuWnYJYnDfSJWmJfn
   /7eXbxJ019YSrqzbpS4gDaBADd59NuejVezqtOR0QFq+nuQLvguL9Q1BW
   OAq+LbDTRN7UjqHY8VsSn7qvP9QXHFfR5BnLxaSxJs2MqJUXjEoPqfrl7
   BbuH2DNBMr/8EobvOi2+JV6AlkGcCDJOZE4bZWhtQENHzu76IUcyNXo6S
   PyykK8mfu12q7hIOHFQg6Re/NeadV5R0y3d6mX0FczUHTufnH+5dT7G2s
   zCNl4dUVNRmP46GZDsxblXCHe8lwbALIMo7j1Tmn7dT+ayRXaGDDm/zMW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10861"; a="365395887"
X-IronPort-AV: E=Sophos;i="6.03,221,1694761200"; 
   d="scan'208";a="365395887"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2023 01:48:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10861"; a="758413137"
X-IronPort-AV: E=Sophos;i="6.03,221,1694761200"; 
   d="scan'208";a="758413137"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.156.199])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2023 01:48:15 -0700
Date:   Fri, 13 Oct 2023 10:48:10 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/1] mdadm/ddf: Abort when raid disk is smaller in
 getinfo_super_ddf
Message-ID: <20231013104810.00003a60@linux.intel.com>
In-Reply-To: <CALTww28hforasc+v3GUWPdoyFyvFZOK8KXeZBKykr_u-2T3K9A@mail.gmail.com>
References: <20231011130332.78933-1-xni@redhat.com>
        <CALTww28hforasc+v3GUWPdoyFyvFZOK8KXeZBKykr_u-2T3K9A@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 11 Oct 2023 21:25:37 +0800
Xiao Ni <xni@redhat.com> wrote:

> Sorry, the title should be [PATCH 1/1] mdadm/ddf: Abort when raid disk
> is smaller than 0 in getinfo_super_ddf
>=20
> If you want me to send v2, I can do it.
>=20
> Best Regards
> Xiao
>=20
>=20
> On Wed, Oct 11, 2023 at 9:06=E2=80=AFPM Xiao Ni <xni@redhat.com> wrote:
> >
> > The metadata is corrupted when the raid_disk<0. So abort directly.
> > This also can avoid a building error:
> > super-ddf.c:1988:58: error: array subscript -1 is below array bounds of
> > =E2=80=98struct phys_disk_entry[0]=E2=80=99
> >
> > Suggested-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> > Ackedy-by: Xiao Ni <xni@redhat.com>
> > ---
> >  super-ddf.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/super-ddf.c b/super-ddf.c
> > index 7213284e0a59..7b98333ecd51 100644
> > --- a/super-ddf.c
> > +++ b/super-ddf.c
> > @@ -1984,12 +1984,14 @@ static void getinfo_super_ddf(struct supertype =
*st,
> > struct mdinfo *info, char *m info->disk.number =3D
> > be32_to_cpu(ddf->dlist->disk.refnum); info->disk.raid_disk =3D find_phy=
s(ddf,
> > ddf->dlist->disk.refnum);
> >
> > +               if (info->disk.raid_disk < 0)
> > +                       return;
> > +
> >                 info->data_offset =3D be64_to_cpu(ddf->phys->
> >                                                   entries[info->disk.ra=
id_disk].
> >                                                   config_size);
> >                 info->component_size =3D ddf->dlist->size - info->data_=
offset;
> > -               if (info->disk.raid_disk >=3D 0)
> > -                       pde =3D ddf->phys->entries + info->disk.raid_di=
sk;
> > +               pde =3D ddf->phys->entries + info->disk.raid_disk;
> >                 if (pde &&
> >                     !(be16_to_cpu(pde->state) & DDF_Failed) &&
> >                     !(be16_to_cpu(pde->state) & DDF_Missing))
> > --
> > 2.32.0 (Apple Git-132)
> > =20
>=20

Hi Xiao,
I don't see a need to send v2. Moving to awaiting upstream:

Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Thanks,
Mariusz
