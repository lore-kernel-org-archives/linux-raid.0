Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C70C77B7E
	for <linux-raid@archiver.kernel.org>; Thu,  1 Jun 2023 09:53:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbjFAJxh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 1 Jun 2023 05:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbjFAJxQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 1 Jun 2023 05:53:16 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D961A2
        for <linux-raid@vger.kernel.org>; Thu,  1 Jun 2023 02:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685613166; x=1717149166;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qZGX9FszCU4qCssYJ00kQoH6597/sfoGUvU54Zx3Q78=;
  b=Uxt8Jfw/mnNYUt+/nhh7e7/dROT+PB3y4GnNyvP7S3zztadiF/5rzjAH
   PUn41JTD6n6mp6FPrbfXvuRCiB7JfJiZcEf1Gp/lglgVpsMnpPuew9dPW
   HPvLK/itOSdNpNWI73DjR+vKWtGwfozLECLHIka9bUX1Z2PyxCEmzfv1k
   4vjnBe39sGOB8DXZnUXFpjG2Eo1QFoETXspIcPFCrEpztBSGqpY4VYUlN
   l7O8c4kWChi0MpIv/S3dGTKI41ArvwP5aABjXI3o3cdglm0pFsrxpW9Fu
   xE4drjxhDLejMgrLv/LaWkVDn+4MF1A+LgbJ4eYp5VRxOhvPWBBrfK30d
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="441874060"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="441874060"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 02:52:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="707272778"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="707272778"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.155.196])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 02:52:44 -0700
Date:   Thu, 1 Jun 2023 11:52:39 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org, colyli@suse.de
Subject: Re: [PATCH v2 0/6] mdadm: POSIX portable naming rules
Message-ID: <20230601115239.00000713@linux.intel.com>
In-Reply-To: <e9001902-22aa-0b87-5201-d590738d450d@molgen.mpg.de>
References: <20230601072750.20796-1-mariusz.tkaczyk@linux.intel.com>
        <e9001902-22aa-0b87-5201-d590738d450d@molgen.mpg.de>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 1 Jun 2023 10:57:47 +0200
Paul Menzel <pmenzel@molgen.mpg.de> wrote:

> Dear Mariusz,
>=20
>=20
> Am 01.06.23 um 09:27 schrieb Mariusz Tkaczyk:
>=20
> > To avoid problem with udev and VROC UEFI driver I developed stronger
> > naming policy, basing on POSIX portable names standard. Verification is=
 =20
>=20
> s/basing/based/

Noted, thanks.

>=20
> > added for names and config entries. In case of an issue, user can update
> > name to make it compatible (for IMSM and native). =20
>=20
> What is the VROC UEFI driver, and what is the problem exactly to risk=20
> regressions on the user side? Why can=E2=80=99t the UEFI driver be fixed?

Thanks for your question. I should mark this as [RFC].

VROC solution (called IMSM here, or super-intel) comes with UEFI support. Y=
ou
can manipulate arrays in UEFI, for example you can create an array to have =
it
available as installation destination for new OS.

I decided that it is worth to mention that we have UEFI driver and there are
some differences in allowed names. Now I think, that it is irrelevant in th=
is
context because my main concern is udevd. The "POSIX portable names" are st=
rict
and that should prevent any differences in names.

Current form is aggressive (do not allow at all) and if you think that I sh=
ould
lower the requirements or bring the option to pass without verification to
ensure backward compatibility- will do, just let me know.

I would like to add exceptions based on community input because it affect
multiple metadata formats.
I think that we should require to follow those rules for new arrays.

Thanks,
Mariusz
>=20
>=20
> Kind regards,
>=20
> Paul
>=20
>=20
> > The changes here may cause /dev/md/ link will be different than before
> > mdadm update. To make any of that happen user need to use unusual naming
> > convention, like:
> > - special, non standard signs like, $,%,&,* or space.
> > - '-' used as first sign.
> > - locals.
> >=20
> > Note: I didn't analyze configurations with "names=3D1". If name cannot =
be
> > determined mdadm should fallback to default numbered dev creation.
> >=20
> > If you are planning release soon then feel free to merge it after the
> > release. It is a potential regression point.
> >=20
> > It is a new version of [1] but it is strongly rebuild. Here is a list
> > of changes:
> > 1. negative and positive test scenarios for both create and config
> >     entries are added.
> > 2. Save parsed parameters in dedicated structs. It is a way to control
> >     what is parsed, assuming that we should use dedicated set_* functio=
n.
> > 3. Verification for config entries is added.
> > 5. Improved error logging for names:
> >     - during creation, these messages are errors, printed to stderr.
> >     - for config entries, messages are just a warnings printed to stdou=
t.
> > 6. Error messages reworked.
> > 7. Updates in manual.
> >=20
> > [1]
> > https://lore.kernel.org/linux-raid/20221221115019.26276-1-mariusz.tkacz=
yk@linux.intel.com/
> >=20
> > Mariusz Tkaczyk (6):
> >    tests: create names_template
> >    tests: create 00confnames
> >    mdadm: set ident.devname if applicable
> >    mdadm: refactor ident->name handling
> >    mdadm: define ident_set_devname()
> >    mdadm: Follow POSIX Portable Character Set
> >=20
> >   Build.c                        |  21 ++--
> >   Create.c                       |  35 +++----
> >   Detail.c                       |  17 ++-
> >   config.c                       | 184 +++++++++++++++++++++++++++------
> >   lib.c                          |  76 +++++++++++---
> >   mdadm.8.in                     |  70 ++++++-------
> >   mdadm.c                        |  73 +++++--------
> >   mdadm.conf.5.in                |   4 -
> >   mdadm.h                        |  36 ++++---
> >   super-intel.c                  |  47 +++++----
> >   tests/00confnames              | 107 +++++++++++++++++++
> >   tests/00createnames            |  89 ++++------------
> >   tests/templates/names_template |  80 ++++++++++++++
> >   13 files changed, 551 insertions(+), 288 deletions(-)
> >   create mode 100644 tests/00confnames
> >   create mode 100644 tests/templates/names_template
> >  =20

