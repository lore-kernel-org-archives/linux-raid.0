Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6702C433FE
	for <linux-raid@archiver.kernel.org>; Fri, 21 Oct 2022 10:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiJUKOW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 Oct 2022 06:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiJUKOD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 21 Oct 2022 06:14:03 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1AB525D649
        for <linux-raid@vger.kernel.org>; Fri, 21 Oct 2022 03:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666347231; x=1697883231;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KhbYiCTGMT46sJkVZj6Ga1VZfCR03Esp3X7/KWfWBTY=;
  b=VrPH5l0BoQ5brOQHmKSfuq4R+bwYb4XvGZndO8HpXNURJ9FXNbh2id29
   EtYsKNlftVaCvLzdcxyEIAacNocbBUF3MVdYAGV11nEHAhy5Uqn1LXOX4
   zd81bpJA31WiaGinZvAwxlsI9RMzgXoLlSwF8JdbRF8tMgguYc6WVLbR/
   ej+gUJnorRc/gmv/GVZbdS7mjgFYQofNQIj+8dwZ9XULXhZB251HHKxyW
   FCHfNC/9C0iGlgxBPgKm2IPG26yCxQD9N/2hrKHJqlMq4www+viXWUUl9
   kR8/sCNu6iKq+dQhE8ephcWszQ7htWWcuycf3CotblNBvXkPco/h8nVEP
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="333541169"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="333541169"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 03:13:27 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="630415337"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="630415337"
Received: from ktanska-mobl1.ger.corp.intel.com (HELO intel.linux.com) ([10.213.29.92])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 03:13:25 -0700
Date:   Fri, 21 Oct 2022 12:13:22 +0200
From:   Kinga Tanska <kinga.tanska@linux.intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Kinga Tanska <kinga.tanska@intel.com>, linux-raid@vger.kernel.org,
        jes@trained-monkey.org
Subject: Re: [PATCH] super-intel: make freesize not required for chunk size
 migration
Message-ID: <20221021121322.00002cee@intel.linux.com>
In-Reply-To: <D036A378-7504-46EF-9EB6-802EA147CCB9@suse.de>
References: <20221020045903.19950-1-kinga.tanska@intel.com>
        <D036A378-7504-46EF-9EB6-802EA147CCB9@suse.de>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 21 Oct 2022 14:49:16 +0800
Coly Li <colyli@suse.de> wrote:

>=20
>=20
> > 2022=E5=B9=B410=E6=9C=8820=E6=97=A5 12:59=EF=BC=8CKinga Tanska <kinga.t=
anska@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
> >=20
> > Freesize is not required when chunk size migration is performed. Fix
> > return value when superblock is not set.
>=20
> Hi Kinga,
>=20
> Could you please provide a bit more information why freesize is
> unnecessary in this situation?
>=20
> Thanks.
>=20
> Coly Li
>=20
>=20
> >=20
> > Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> > ---
> > super-intel.c | 10 +++++-----
> > 1 file changed, 5 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/super-intel.c b/super-intel.c
> > index 4d82af3d..37c59da5 100644
> > --- a/super-intel.c
> > +++ b/super-intel.c
> > @@ -7714,11 +7714,11 @@ static int validate_geometry_imsm(struct
> > supertype *st, int level, int layout, struct intel_super *super =3D
> > st->sb;
> >=20
> > 		/*
> > -		 * Autolayout mode, st->sb and freesize must be
> > set.
> > +		 * Autolayout mode, st->sb must be set.
> > 		 */
> > -		if (!super || !freesize) {
> > -			pr_vrb("freesize and superblock must be
> > set for autolayout, aborting\n");
> > -			return 1;
> > +		if (!super) {
> > +			pr_vrb("superblock must be set for
> > autolayout, aborting\n");
> > +			return 0;
> > 		}
> >=20
> > 		if (!validate_geometry_imsm_orom(st->sb, level,
> > layout, @@ -7726,7 +7726,7 @@ static int
> > validate_geometry_imsm(struct supertype *st, int level, int layout,
> > verbose)) return 0;
> >=20
> > -		if (super->orom) {
> > +		if (super->orom && freesize) {
> > 			imsm_status_t rv;
> > 			int count =3D count_volumes(super->hba,
> > super->orom->dpa, verbose);
> > --=20
> > 2.26.2
> >=20
>=20

Hi,

freesize is needed to be set for migrations where size of RAID could be
changed - expand. It tells how many free space is determined
for members. In chunk size migration freesize is not needed to
be set, so we shouldn't check if pointer exists. I moved this
check to condition which contains size calculations, instead of
checking it always at the first step.
We've tested it internally with both, chunk size migration and expand
and freesize is checked only when is really needed now.

Regards,
Kinga Tanska
