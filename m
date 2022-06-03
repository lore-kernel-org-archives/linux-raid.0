Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE4ADC433EF
	for <linux-raid@archiver.kernel.org>; Mon,  6 Jun 2022 06:48:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbiFFGso (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Jun 2022 02:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbiFFGsm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Jun 2022 02:48:42 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB854941B6
        for <linux-raid@vger.kernel.org>; Sun,  5 Jun 2022 23:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654498119; x=1686034119;
  h=message-id:date:from:to:cc:subject:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/PiC/W2L7LkHmyACdCiUomweymw+xV8eV2U/R1CBsas=;
  b=kTDcwkLLo6LLvygr3/D6NuUfLPu6LT3g0sHTpvTT9WAEAspFtxlfz/mX
   mx0It9BzmvXhwBJHYCwzbamI9lHx5q2CyEJCYiq2jlLZI66a9xzt8uBGO
   gO03K4TFI3Dd0a0nxAK1WVGP20JCmz90C41b/0Rpob8V0ii1uixv/ZT0m
   0+L2t49IkDSwQ96swAF9Rxy9vEyOAjdEEFFCT3Px9WEbxEPV47R8OmPeN
   Z2IybetFedmc8XoR22WznNBzQ/UzTkq9UPzzPr+G/HyH+ZpT/mqtKh+v2
   R/E/hFNcr+c6Yl0yHL5Gn9P44UVCLsc1wjvDX5f1h9GkusdrEs3irO5kf
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10369"; a="301989758"
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="301989758"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2022 23:48:36 -0700
Message-Id: <7f4525$iu0ds4@fmsmga008-auth.fm.intel.com>
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="635451268"
Received: from fbrzezin-mobl.ger.corp.intel.com (HELO intel.linux.com) ([10.249.139.175])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2022 23:48:34 -0700
Date:   Fri, 3 Jun 2022 16:30:04 +0200
From:   Lukasz Florczak <lukasz.florczak@linux.intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org,
        pmenzel@molgen.mpg.de
Subject: Re: [PATCH 1/2] mdadm: Fix array size mismatch after grow
In-Reply-To: <35B48024-E02A-45EB-AC5C-4C3DDB2055E3@suse.de>
References: <20220407142739.60198-1-lukasz.florczak@linux.intel.com>
        <20220407142739.60198-2-lukasz.florczak@linux.intel.com>
        <35B48024-E02A-45EB-AC5C-4C3DDB2055E3@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 30 May 2022 18:01:05 +0800, Coly Li <colyli@suse.de> wrote:

Hi Coly,
> Hi Lukasz,
>=20
>=20
> > 2022=E5=B9=B44=E6=9C=887=E6=97=A5 22:27=EF=BC=8CLukasz Florczak
> > <lukasz.florczak@linux.intel.com> =E5=86=99=E9=81=93=EF=BC=9A
> >=20
> > imsm_fix_size_mismatch() is invoked to fix the problem, but it
> > couldn't proceed due to migration check. This patch allows for
> > intended behavior.
>=20
>=20
> Could you please explain a bit more about why =E2=80=9Cit couldn=E2=80=99=
t proceed
> due to migration=E2=80=9D, and what is the =E2=80=9Cintended behavior=E2=
=80=9D? It may help
> me to understand your change and response faster.

The intended behavior here is to fix the array size after grow that is
displayed in mdadm detail, since there can be a mismatch if the raid
was created in EFI [1]. That is the array size is not consistent with
the formula:=20
Array_size * block_size =3D Num_stripes * Chunk_size * Num_of_data_drives=20

That fix couldn't happen as the metadata update part was efficiently
omitted with continue statement after the migration type condition was
met.=20

About migration I didn't go that much into detail, but it was an issue
that dev->vol.migr_type was still in MIGR_GEN_MIGR state even though
imsm_fix_size_mismatch() was called after migration has been finished,
at least from the mdadm's point of view. That happens because this
value is changed later, afaik, by mdmon. The initial idea here must've
been not to change the array size during migration, but that is not
valid since its state is just not updated yet.

[1]
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=3D895ffd992=
954069e4ea67efb8a85bb0fd72c3707

Thanks,
Lukasz

>=20
> Thank you in advance.
>=20
> Coly Li
>=20
> >=20
> > Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>
> > ---
> > super-intel.c | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/super-intel.c b/super-intel.c
> > index d5fad102..102689bc 100644
> > --- a/super-intel.c
> > +++ b/super-intel.c
> > @@ -11757,7 +11757,7 @@ static int imsm_fix_size_mismatch(struct
> > supertype *st, int subarray_index) unsigned long long d_size =3D
> > imsm_dev_size(dev); int u_size;
> >=20
> > -		if (calc_size =3D=3D d_size || dev->vol.migr_type =3D=3D
> > MIGR_GEN_MIGR)
> > +		if (calc_size =3D=3D d_size)
> > 			continue;
> >=20
> > 		/* There is a difference, confirm that
> > imsm_dev_size is --=20
> > 2.27.0
> >=20
>=20
