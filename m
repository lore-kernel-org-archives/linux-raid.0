Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E21E95A91
	for <linux-raid@archiver.kernel.org>; Mon,  9 Oct 2023 07:59:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345420AbjJIH7n (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 9 Oct 2023 03:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbjJIH7n (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 9 Oct 2023 03:59:43 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DED94
        for <linux-raid@vger.kernel.org>; Mon,  9 Oct 2023 00:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696838380; x=1728374380;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=44k7HxrI/6zJ0VwM6iZsGZS3ELzrP4bfNrsh0rzKKFM=;
  b=DknliAzZ5URFUC3j5KgNAL4KmgHXejnRpHT+9xnOxv5qGZ9m49xjBaYJ
   UV+65XVLHBV/Rhv0tvLRBxVXzJuk3ljwWEVtkb0K68XZ00uFdEDBbEUR7
   1x5QUIg/Odeb8Fbbu/BuE0Asn1deLbjIbUAPx3TARC1XZeMeknCCBj5u7
   FvYxMuEZFDIdKvelsm8PMqvVboDO3/QmNzIVbsx3GxZELHu/xaIbv29us
   8BUoQemBa4e6BBrcAKSC1dikBMkNKtDP268IjehAz0f+IDGyBWFbP7OSL
   0qeOhNAmZ0J+Tb6LX9dtm9QF2S71qo3fXgRUsii/YT/Gk6jqvs8HVGbE+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10857"; a="382967433"
X-IronPort-AV: E=Sophos;i="6.03,209,1694761200"; 
   d="scan'208";a="382967433"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2023 00:59:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10857"; a="746583065"
X-IronPort-AV: E=Sophos;i="6.03,209,1694761200"; 
   d="scan'208";a="746583065"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.93])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2023 00:59:39 -0700
Date:   Mon, 9 Oct 2023 09:59:35 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 3/4] mdadm: Avoid array bounds check of gcc
Message-ID: <20231009095935.000047cd@linux.intel.com>
In-Reply-To: <CALTww29bA29qPUR108O+JJ+rcwjrPqxG1oNA5ewKGGm_p7NApg@mail.gmail.com>
References: <20230927025219.49915-1-xni@redhat.com>
        <20230927025219.49915-4-xni@redhat.com>
        <20230928114149.000016a1@linux.intel.com>
        <CALTww29bA29qPUR108O+JJ+rcwjrPqxG1oNA5ewKGGm_p7NApg@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, 7 Oct 2023 21:26:22 +0800
Xiao Ni <xni@redhat.com> wrote:

> On Thu, Sep 28, 2023 at 5:42=E2=80=AFPM Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
> >
> > On Wed, 27 Sep 2023 10:52:18 +0800
> > Xiao Ni <xni@redhat.com> wrote:
> > =20
> > > With gcc version 13.2.1 20230918 (Red Hat 13.2.1-3) (GCC), it reports
> > > error: super-ddf.c:1988:58: error: array subscript -1 is below array
> > > bounds of =E2=80=98struct phys_disk_entry[0]=E2=80=99 [-Werror=3Darra=
y-bounds=3D]
> > > The subscrit is defined as int type. And it can be smaller than 0. =20
> >
> > If it can be smaller that 0 then it is something we need to fix.
> > I think that it comes from here:
> >                 info->disk.raid_disk =3D find_phys(ddf,
> > ddf->dlist->disk.refnum); info->data_offset =3D be64_to_cpu(ddf->phys->
> >                                                   entries[info->disk.ra=
id_disk].
> >                                                   config_size);
> >
> > find_phys can return -1.
> > It is handled few lines bellow. I don't see reason why we cannot handle=
 it
> > here too.
> >
> >                 if (info->disk.raid_disk >=3D 0)
> >                         pde =3D ddf->phys->entries + info->disk.raid_di=
sk;
> >
> > I think that it will be fair to abort because metadata seems to be
> > corrupted. We are referring to info->disk.raid_disk from many places. We
> > cannot return error because it is void, we can just return. =20
>=20
> Hi Mariusz
>=20
> You mean something like this?
>=20
> diff --git a/super-ddf.c b/super-ddf.c
> index 7213284e0a59..b6e514042055 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -1984,6 +1984,9 @@ static void getinfo_super_ddf(struct supertype
> *st, struct mdinfo *info, char *m
>                 info->disk.number =3D be32_to_cpu(ddf->dlist->disk.refnum=
);
>                 info->disk.raid_disk =3D find_phys(ddf,
> ddf->dlist->disk.refnum);
>=20
> +               if (info->disk.raid_disk < 0)
> +                       return;
> +
>                 info->data_offset =3D be64_to_cpu(ddf->phys->
>                                                   entries[info->disk.raid=
_disk].
>                                                   config_size);
>=20

Yes, LGTM!

Mariusz

