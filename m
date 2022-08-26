Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 765F8ECAAA3
	for <linux-raid@archiver.kernel.org>; Fri, 26 Aug 2022 08:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343556AbiHZIMy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 26 Aug 2022 04:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343559AbiHZIMu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 26 Aug 2022 04:12:50 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07448D3ED1
        for <linux-raid@vger.kernel.org>; Fri, 26 Aug 2022 01:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661501569; x=1693037569;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4QUAa4WkvDt/6UsW2g6IvFEVBhI1N8XHOVDFuNLAhIg=;
  b=kt/Vk81MrdaFfD/h6Ci7CF2fKWmdRlCDLMr/TTscd9q3KM6apzLlj6bR
   26u433S9j8/bGyuDYAmbYFHyBs7h3MfaoYg94+op0oTwpWToRS0iUh1zl
   3soYyggbF7F7N74dSuaRJJ4VWbDGS/m6BUECRkCfobHiedpmmGHgySrCO
   sBtO3s2r9acC26qS3Kiqb1s/KK071NirnKYUA5q6Jn1l8FaEIg+kPZEF7
   PhJinX90GyBEoxPdLs8RsTw4P/K0/ymOoSG+KQhxymS8dBoKxPeR0gGCV
   wJmoJUMlWQnptK57r2bfDe2T4GuogvnYAVl0xU8kgkHDV1Ao6goM/VmfI
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="277467478"
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="277467478"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 01:12:48 -0700
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="671370827"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.40.220])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 01:12:46 -0700
Date:   Fri, 26 Aug 2022 10:12:42 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Logan Gunthorpe <logan@eideticom.com>, Coly Li <colyli@suse.de>,
        Lukasz Florczak <lukasz.florczak@linux.intel.com>,
        linux-raid@vger.kernel.org
Subject: Re: Python tests
Message-ID: <20220826101242.000055d0@linux.intel.com>
In-Reply-To: <f40217bd-5db4-65e9-0829-5d652281f3f2@suse.de>
References: <11ab82$jvatnj@fmsmga008-auth.fm.intel.com>
        <8C1AB1D5-54FD-406C-BBA3-509F669C9116@suse.de>
        <494eee73-5da3-55c9-c374-4166f0117288@eideticom.com>
        <f40217bd-5db4-65e9-0829-5d652281f3f2@suse.de>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 25 Aug 2022 08:15:14 +0200
Hannes Reinecke <hare@suse.de> wrote:

> On 8/24/22 22:40, Logan Gunthorpe wrote:
> > Hi,
> >=20
> > On 2022-08-24 10:23, Coly Li wrote: =20
> >>
> >> =20
> >>> 2022=E5=B9=B48=E6=9C=8824=E6=97=A5 16:15=EF=BC=8CLukasz Florczak <luk=
asz.florczak@linux.intel.com>
> >>> =E5=86=99=E9=81=93=EF=BC=9A
> >>>
> >>> Hi Coly,
> >>> I want to write some mdadm tests for assemblation and incremental
> >>> regarding duplicated array names in config and I'd like to do it in
> >>> python. I've seen that some time ago[1] you said that you could try to
> >>> integrate the python tests framework into the mdadm ci. I was wonderi=
ng
> >>> how is it going? Do you need any help with this subject?
> >>>
> >>> Thanks,
> >>> Lukasz
> >>>
> >>> [1] https://marc.info/?l=3Dlinux-raid&m=3D165277539509464&w=3D2 =20
> >>
> >> Hi Lukasz,
> >>
> >> Now I just make some of the existed mdadm test scripts running, which =
are
> >> copied from upstream mdadm. There won=E2=80=99t be any conflict for th=
e python
> >> testing code between you and me, because now I am just studying Python
> >> again and not do any useful thing yet.
> >>
> >> As I said if no one works on the testing framework, I will do it, but =
it
> >> may take time. How about posting out the python code once you make it,
> >> then let=E2=80=99s put it into mdadm-test to test mdadm-CI, and improv=
e whole
> >> things step by step.=20
> >=20
> > I'm not sure if this is of use to anyone but we are very slowly growing
> > a testing framework written mostly in python. Its focused on raid5 at
> > the moment and still is a fairly sizable mess, but we've caught a lot of
> > bugs with it and continue to run it, clean it up and make improvements.
> >=20
> > https://github.com/Eideticom/raid5-tests/
> >=20
> > The 'md.py 'file provides a nice interface to setup an array based on
> > ram, loop or block devices and provides methods to degrade, recover or
> > grow the array. 'test3' does grow/degrade tests while running IO,
> > 'test_all' runs all the tests with an array of different settings.
> >=20
> > Feel free to use anything from it that you may find useful.
> >  =20
> When developing 'md_monitor' (https://github.com/hreinecke/md_monitor)=20
> I've also created an extensive testsuite for it.
> The one thing which I found particularly painful is error handling once=20
> mdadm fails. It's really hard to figure out _what_ went wrong, and more=20
> often than not mdadm simply locked up on me (try to stall I/O on one=20
> component device while md is running and you are in a world of pain).
>=20
> That's when I started to split mdadm into a library, as then we could=20
> have a python binding and the life would so much more fun.
> So maybe I should resurrect that patchset.
>=20
Hi Hannes,

Will be great if you can handle this. Beside library part you did huge code
rearrangement and divides one big mdadm.h header into separate ones which is
also great improvement. mdadm.h is still growing.

It is hard to do this separately, one by one due to cross references between
files.

Thanks,
Mariusz
