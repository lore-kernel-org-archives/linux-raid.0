Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87639C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 27 Jun 2022 13:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235345AbiF0NSo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 27 Jun 2022 09:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235051AbiF0NSl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 27 Jun 2022 09:18:41 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A8CCF0
        for <linux-raid@vger.kernel.org>; Mon, 27 Jun 2022 06:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656335920; x=1687871920;
  h=message-id:date:from:to:cc:subject:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WmkeQi2emKO3QJGd+vShVAtaTjfWPpfQJVRC5m9qeCY=;
  b=JrOzE91aO28wSyhHorugV8PSxv0dNYy0kiEzd4aEcJrfMcdS79XymBda
   pejpKu0yhne9coPOGKEnpJlAmWJ2bOW66GhSUmYG1UUQvYHgzpBWullxh
   77QREPiuREnowDa5A2TL+suyJxPnxNnUJ/eH/Xvk0yc3odxi7w5kdskwB
   aD9xu0fVjP5c5WrvG47oTxusCy06l43bawSfL3us/iFYP46/92D9ExFL4
   BBVjDo1jQa2sSJqHRk0MRb/birZN+/TROC1ttuPAIxu/eSE8Ub39cTegR
   z522ADX9xySkzCpWRPkn9Ub8G72nI4q5C1o4993P20HC9sKZLeyZMsNdS
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10390"; a="367762463"
X-IronPort-AV: E=Sophos;i="5.92,226,1650956400"; 
   d="scan'208";a="367762463"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 06:18:39 -0700
Message-Id: <7f4525$j8f9ri@fmsmga008-auth.fm.intel.com>
X-IronPort-AV: E=Sophos;i="5.92,226,1650956400"; 
   d="scan'208";a="646424434"
Received: from lflorcza-mobl.ger.corp.intel.com (HELO intel.linux.com) ([10.237.140.94])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 06:18:38 -0700
Date:   Mon, 27 Jun 2022 15:16:05 +0200
From:   Lukasz Florczak <lukasz.florczak@linux.intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org,
        pmenzel@molgen.mpg.de
Subject: Re: [PATCH 1/2] mdadm: Fix array size mismatch after grow
In-Reply-To: <2747A949-7F7E-4C44-816B-F2B648EB87C9@suse.de>
References: <20220407142739.60198-1-lukasz.florczak@linux.intel.com>
        <20220407142739.60198-2-lukasz.florczak@linux.intel.com>
        <35B48024-E02A-45EB-AC5C-4C3DDB2055E3@suse.de>
        <7f4525$iu0ds4@fmsmga008-auth.fm.intel.com>
        <2747A949-7F7E-4C44-816B-F2B648EB87C9@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 21 Jun 2022 00:28:18 +0800, Coly Li <colyli@suse.de> wrote:

> > 2022=E5=B9=B46=E6=9C=883=E6=97=A5 22:30=EF=BC=8CLukasz Florczak
> > <lukasz.florczak@linux.intel.com> =E5=86=99=E9=81=93=EF=BC=9A
> >=20
> > On Mon, 30 May 2022 18:01:05 +0800, Coly Li <colyli@suse.de> wrote:
> >=20
> > Hi Coly, =20
> >> Hi Lukasz,
> >>=20
> >>  =20
> >>> 2022=E5=B9=B44=E6=9C=887=E6=97=A5 22:27=EF=BC=8CLukasz Florczak
> >>> <lukasz.florczak@linux.intel.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>>=20
> >>> imsm_fix_size_mismatch() is invoked to fix the problem, but it
> >>> couldn't proceed due to migration check. This patch allows for
> >>> intended behavior. =20
> >>=20
> >>=20
> >> Could you please explain a bit more about why =E2=80=9Cit couldn=E2=80=
=99t proceed
> >> due to migration=E2=80=9D, and what is the =E2=80=9Cintended behavior=
=E2=80=9D? It may help
> >> me to understand your change and response faster. =20
> >=20
> > The intended behavior here is to fix the array size after grow that
> > is displayed in mdadm detail, since there can be a mismatch if the
> > raid was created in EFI [1]. That is the array size is not
> > consistent with the formula:=20
> > Array_size * block_size =3D Num_stripes * Chunk_size *
> > Num_of_data_drives=20
> >=20
> > That fix couldn't happen as the metadata update part was efficiently
> > omitted with continue statement after the migration type condition
> > was met.=20
> >=20
> > About migration I didn't go that much into detail, but it was an
> > issue that dev->vol.migr_type was still in MIGR_GEN_MIGR state even
> > though imsm_fix_size_mismatch() was called after migration has been
> > finished, at least from the mdadm's point of view. That happens
> > because this value is changed later, afaik, by mdmon. The initial
> > idea here must've been not to change the array size during
> > migration, but that is not valid since its state is just not
> > updated yet.
> >=20
> > [1]
> > https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=3D895ff=
d992954069e4ea67efb8a85bb0fd72c3707
> > =20
>=20
> Copied, thanks for the hint.
>=20
> BTW, now I do the imsm related test with IMSM_NO_PLATFORM=3D1 and
> IMSM_DEVNAME_AS_SERIAL=3D1. To test situation as the above text
> mentioned, do I have to find a real hardware with VROC supported?

Hi Coly,

Having a real hardware with VROC support would be the most convenient
solution here. However, you could do a quick hack to overcome this
situation. That would be commenting out the line:
array_size =3D round_size_to_mb(array_blocks, data_disks);
in init_super_imsm_volume(). Then creating RAID in OS should have the
same size mismatch issues as size per drive won't be aligned to 1MiB
(considering you create raid with size not aligned to 1MiB) - raid
size created in EFI only has to be multiple of sector size and chunk
size.
Hope this helps you.

Thanks,
Lukasz
>=20
> Coly Li
>=20
