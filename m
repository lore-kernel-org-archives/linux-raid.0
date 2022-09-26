Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20F6DC32771
	for <linux-raid@archiver.kernel.org>; Mon, 26 Sep 2022 08:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbiIZIT3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 26 Sep 2022 04:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbiIZIT2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 26 Sep 2022 04:19:28 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EC9237CA
        for <linux-raid@vger.kernel.org>; Mon, 26 Sep 2022 01:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664180366; x=1695716366;
  h=message-id:date:from:to:cc:subject:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CY6EqXwLY64IJr0FbjC+ERepncJUBR8Z9ilmrqiZNVQ=;
  b=L6u6185MqJ5jEM0+eBkP7ZQB4TvSpJ5ndMc9Lqgn4SOh4Vkag6cmALV5
   Ksdg09ceoSvSFtBh+mxrEIkcajPBVgIvtQANF90XKqMB0t+MZqKqvhvSh
   FelElsLbiy8Gqgh8V+A3yvUkWjMD3r9r0MML3fZDRiAhNwIwsK/sLF7/i
   M26GLCmzk9v7/PCQPMV+HOrxgHFRUSBuJTgsDbvLX67kyiHFYrWwQBNdA
   ZXmW/9FHzna0stEkuQ5HvVpkw3TM3YOB9/vq4yq+gRaXZK3Dig4HWRCYL
   r+Ms472ktchwVfzBEUIUAFpoq4z0ge49LKzDiccoTsxuYUEEN3GeNdgFA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10481"; a="299695996"
X-IronPort-AV: E=Sophos;i="5.93,345,1654585200"; 
   d="scan'208";a="299695996"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 01:19:16 -0700
Message-Id: <d46734$mnvmir@fmsmga001-auth.fm.intel.com>
X-IronPort-AV: E=McAfee;i="6500,9779,10481"; a="763353691"
X-IronPort-AV: E=Sophos;i="5.93,345,1654585200"; 
   d="scan'208";a="763353691"
Received: from lflorcza-mobl.ger.corp.intel.com (HELO intel.linux.com) ([10.237.140.89])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 01:19:15 -0700
Date:   Mon, 26 Sep 2022 10:19:11 +0200
From:   Lukasz Florczak <lukasz.florczak@linux.intel.com>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Logan Gunthorpe <logan@eideticom.com>,
        Hannes Reinecke <hare@suse.de>, Coly Li <colyli@suse.de>,
        linux-raid@vger.kernel.org
Subject: Re: Python tests
In-Reply-To: <20220826101242.000055d0@linux.intel.com>
References: <11ab82$jvatnj@fmsmga008-auth.fm.intel.com>
        <8C1AB1D5-54FD-406C-BBA3-509F669C9116@suse.de>
        <494eee73-5da3-55c9-c374-4166f0117288@eideticom.com>
        <f40217bd-5db4-65e9-0829-5d652281f3f2@suse.de>
        <20220826101242.000055d0@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 26 Aug 2022 10:12:42 +0200, Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:

> On Thu, 25 Aug 2022 08:15:14 +0200
> Hannes Reinecke <hare@suse.de> wrote:
>=20
> > On 8/24/22 22:40, Logan Gunthorpe wrote: =20
> > > Hi,
> > >=20
> > > On 2022-08-24 10:23, Coly Li wrote:   =20
> > >>
> > >>   =20
> > >>> 2022=E5=B9=B48=E6=9C=8824=E6=97=A5 16:15=EF=BC=8CLukasz Florczak
> > >>> <lukasz.florczak@linux.intel.com> =E5=86=99=E9=81=93=EF=BC=9A
> > >>>
> > >>> Hi Coly,
> > >>> I want to write some mdadm tests for assemblation and
> > >>> incremental regarding duplicated array names in config and I'd
> > >>> like to do it in python. I've seen that some time ago[1] you
> > >>> said that you could try to integrate the python tests framework
> > >>> into the mdadm ci. I was wondering how is it going? Do you need
> > >>> any help with this subject?
> > >>>
> > >>> Thanks,
> > >>> Lukasz
> > >>>
> > >>> [1] https://marc.info/?l=3Dlinux-raid&m=3D165277539509464&w=3D2   =
=20
> > >>
> > >> Hi Lukasz,
> > >>
> > >> Now I just make some of the existed mdadm test scripts running,
> > >> which are copied from upstream mdadm. There won=E2=80=99t be any
> > >> conflict for the python testing code between you and me, because
> > >> now I am just studying Python again and not do any useful thing
> > >> yet.
> > >>
> > >> As I said if no one works on the testing framework, I will do
> > >> it, but it may take time. How about posting out the python code
> > >> once you make it, then let=E2=80=99s put it into mdadm-test to test
> > >> mdadm-CI, and improve whole things step by step.  =20
> > >=20
> > > I'm not sure if this is of use to anyone but we are very slowly
> > > growing a testing framework written mostly in python. Its focused
> > > on raid5 at the moment and still is a fairly sizable mess, but
> > > we've caught a lot of bugs with it and continue to run it, clean
> > > it up and make improvements.
> > >=20
> > > https://github.com/Eideticom/raid5-tests/
> > >=20
> > > The 'md.py 'file provides a nice interface to setup an array
> > > based on ram, loop or block devices and provides methods to
> > > degrade, recover or grow the array. 'test3' does grow/degrade
> > > tests while running IO, 'test_all' runs all the tests with an
> > > array of different settings.
> > >=20
> > > Feel free to use anything from it that you may find useful.
> > >    =20
> > When developing 'md_monitor'
> > (https://github.com/hreinecke/md_monitor) I've also created an
> > extensive testsuite for it. The one thing which I found
> > particularly painful is error handling once mdadm fails. It's
> > really hard to figure out _what_ went wrong, and more often than
> > not mdadm simply locked up on me (try to stall I/O on one component
> > device while md is running and you are in a world of pain).
> >=20
> > That's when I started to split mdadm into a library, as then we
> > could have a python binding and the life would so much more fun.
> > So maybe I should resurrect that patchset.
> >  =20
> Hi Hannes,
>=20
> Will be great if you can handle this. Beside library part you did
> huge code rearrangement and divides one big mdadm.h header into
> separate ones which is also great improvement. mdadm.h is still
> growing.
>=20
> It is hard to do this separately, one by one due to cross references
> between files.
>=20
> Thanks,
> Mariusz

Hi,
I'm writing with a little update. I was trying to work with python
libraries pytest and ctypes. They look promising to me as with them
you can load shared objects and create unit tests. Unfortunately I
didn't manage to compile mdadm sources as library yet.
I don't think I can manage to work more on this topic anymore due to
structural changes on my team at work, so this must be postponed from
my side. Maybe one of my collegues will try to take this subject
further in the near future.=20

Thanks,
Lukasz
