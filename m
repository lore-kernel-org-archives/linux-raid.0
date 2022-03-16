Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CAE8C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 16 Mar 2022 12:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355549AbiCPMEa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 16 Mar 2022 08:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355524AbiCPME3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 16 Mar 2022 08:04:29 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26331E3C9
        for <linux-raid@vger.kernel.org>; Wed, 16 Mar 2022 05:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647432195; x=1678968195;
  h=message-id:date:from:to:subject:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=TAelhbEmSFsN+yiBt0ve69UtIs56TEdGKB7SCjozvL4=;
  b=kzWi0VSFiRxEkeSZOZky6MbZjIFVxUbJfcfAgdwQ25xYRixvVcK2T4ED
   U3G2ajxerJjbUCGy3wpdCQaNkLiLFPAhHlMBRYod8T+MfPpd10OJ+A0oj
   mxWNBKgmFa26hE/CkDH5YHiS8+pUTY66EbmAF3DheKgB7uqgVH8vbCsm5
   I2lCFSUzc8d1rD+e77sQYu1x/E6rjqnm+A+yJXOdjRg2dUq0rL4IDU9Li
   U0uy/wG33k1mG3sIj9dyBEY42kTh/P2xJD+Ek5f0giLMP3KDzapc+VLSP
   AScEe7l+5NCU0YjJHi1s+DCKidVKjR+6BHayym8+vq1F30Lk/BS8vZX63
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="256513636"
X-IronPort-AV: E=Sophos;i="5.90,186,1643702400"; 
   d="scan'208";a="256513636"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 05:03:04 -0700
Message-Id: <722c05$g3qed5@orsmga007-auth.jf.intel.com>
X-IronPort-AV: E=Sophos;i="5.90,186,1643702400"; 
   d="scan'208";a="540883365"
Received: from lflorcza-mobl.ger.corp.intel.com (HELO intel.linux.com) ([10.213.5.226])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 05:03:02 -0700
Date:   Wed, 16 Mar 2022 13:03:00 +0100
From:   Lukasz Florczak <lukasz.florczak@linux.intel.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>, linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/2] mdadm: Respect config file location in man.
In-Reply-To: <91ed523b-9518-1beb-039d-ab00b1bb0b44@molgen.mpg.de>
References: <20220315085549.59693-1-lukasz.florczak@linux.intel.com>
        <20220315085549.59693-2-lukasz.florczak@linux.intel.com>
        <91ed523b-9518-1beb-039d-ab00b1bb0b44@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Paul,
Thanks for reviewing my patch.=20

On Tue, 15 Mar 2022 13:39:25 +0100, Paul Menzel <pmenzel@molgen.mpg.de>
wrote:

> Dear Lukasz,
>=20
>=20
> Thank you for your patches.
>=20
> Am 15.03.22 um 09:55 schrieb Lukasz Florczak:
>=20
> It=E2=80=99d be great if you removed the dot/period at the end of the git
> commit message summaries [1]. (Also in second patch.)

Noted.

>=20
> > Default config file location could differ depending on OS (e.g.
> > Debian family). =20
>=20
> What is it an Debian?

Could you elaborate?

>=20
>  [...] =20
>=20
> Looks like an independent fix. Please separate into a separate commit.

It's just adding a missing option. I don't think that it deserves a
separate commit. How about I will update the commit body to include
this particular change?

>=20
> > +"  create, auto                                 used when creating
> > device names in /dev\n" +"  homehost, policy, part-policy
> >      used to guide policy in various\n" +"
> >                      situations\n" +"\n"
> > +"For more details see mdadm.conf(5).\n"
> >   "\n"
> >   ;
> >  =20
> > diff --git a/mdadm.8.in b/mdadm.8.in
> > index be902dba..d41b3ca7 100644
> > --- a/mdadm.8.in
> > +++ b/mdadm.8.in
> > @@ -267,13 +267,13 @@ the exact meaning of this option in different
> > contexts. .TP
> >   .BR \-c ", " \-\-config=3D
> >   Specify the config file or directory.  Default is to use
> > -.B /etc/mdadm.conf
> > +.B {CONFFILE}
> >   and
> > -.BR /etc/mdadm.conf.d ,
> > +.BR {CONFFILE}.d ,
> >   or if those are missing then
> > -.B /etc/mdadm/mdadm.conf
> > +.B {CONFFILE2}
> >   and
> > -.BR /etc/mdadm/mdadm.conf.d .
> > +.BR {CONFFILE2}.d .
> >   If the config file given is
> >   .B "partitions"
> >   then nothing will be read, but
> > @@ -2009,9 +2009,9 @@ The config file is only used if explicitly
> > named with or requested with (a possibly implicit)
> >   .BR \-\-scan .
> >   In the later case,
> > -.B /etc/mdadm.conf
> > +.B {CONFFILE}
> >   or
> > -.B /etc/mdadm/mdadm.conf
> > +.B {CONFFILE2}
> >   is used.
> >  =20
> >   If
> > @@ -3339,7 +3339,7 @@ uses this to find arrays when
> >   is given in Misc mode, and to monitor array reconstruction
> >   on Monitor mode.
> >  =20
> > -.SS /etc/mdadm.conf
> > +.SS {CONFFILE} (or {CONFFILE2})
> >  =20
> >   The config file lists which devices may be scanned to see if
> >   they contain MD super block, and gives identifying information
> > @@ -3347,7 +3347,7 @@ they contain MD super block, and gives
> > identifying information .BR mdadm.conf (5)
> >   for more details.
> >  =20
> > -.SS /etc/mdadm.conf.d
> > +.SS {CONFFILE}.d (or {CONFFILE2}.d)
> >  =20
> >   A directory containing configuration files which are read in
> > lexical order.
> > diff --git a/mdadm.conf.5 b/mdadm.conf.5.in
> > similarity index 99%
> > rename from mdadm.conf.5
> > rename to mdadm.conf.5.in
> > index 74a21c5f..83edd008 100644
> > --- a/mdadm.conf.5
> > +++ b/mdadm.conf.5.in
> > @@ -8,7 +8,7 @@
> >   .SH NAME
> >   mdadm.conf \- configuration for management of Software RAID with
> > mdadm .SH SYNOPSIS
> > -/etc/mdadm.conf
> > +{CONFFILE}
> >   .SH DESCRIPTION
> >   .PP
> >   .I mdadm =20
>=20
> The rest looks good.
>=20
>=20
> Kind regards,
>=20
> Paul
>=20
>=20
> [1]: https://chris.beams.io/posts/git-commit/

Regards,

Lukasz


