Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F893C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 17 May 2022 07:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbiEQHyc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 17 May 2022 03:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242201AbiEQHy1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 17 May 2022 03:54:27 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8483048E55
        for <linux-raid@vger.kernel.org>; Tue, 17 May 2022 00:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652774066; x=1684310066;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fmPHdNf86KJ63yVODTLQRDux/FQhBz51SZnlWIfi5YY=;
  b=N1sETlyO3AArDCyZrsrUCkDc8nP5xHf7lCizyUKbKWu9FJWv9kfwbTnW
   wPDCC2N7hjBwUitp7jJ5ge02s9/3GBcUWcBoB4fEdnE4bH5k1JtqgNUYz
   WNB1XTjHKsTPDncyyuN46qPYc33ZFC3hXbpyvOL1ruXmwIoUCgTT/TiUl
   S77dLKk4Pyme48TvruRtHX17GRZO9RgFXGWnjpx9USmXwAK+SJDWSRKpM
   6sRslhgACpKeETXzbZqbtQyhAaC8a9H7sZv2JfpviafmFx90rHff00d5s
   /amcTpQe1HPtqoMXlRm+tu3vgDG2F96DVof96cLSSaZD2Hd0Lyu0JooJ8
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="334146258"
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="334146258"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 00:54:26 -0700
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="544785727"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.213.22.206])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 00:54:24 -0700
Date:   Tue, 17 May 2022 09:54:19 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     =?utf-8?Q?=E2=80=AAColy_Li=E2=80=AC?= <colyli@suse.de>
Cc:     Xiao Ni <xni@redhat.com>, Nigel Croxon <ncroxon@redhat.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        linux-raid <linux-raid@vger.kernel.org>
Subject: Re: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9Amdadm?= test suite
 improvements
Message-ID: <20220517095419.00004b30@linux.intel.com>
In-Reply-To: <-laavsfgtlo10lebdsj460ptakf7ob3swf0up-4xyanlxfob29oebwn0um9140l133r8-rukduq-tekz50-og1qjp-za66of-qnod9a-cdghzt8enrbc-ei4sg9-7sa12trdyicp-e03x62jcjj2j-h0xih6.1652752832458@email.android.com>
References: <20220516160941.00004e83@linux.intel.com>
        <CALTww2-mbfZRcHu_95Q+WANXZ9ayRwjXvyvqP5Gseeb86dEy=w@mail.gmail.com>
        <-laavsfgtlo10lebdsj460ptakf7ob3swf0up-4xyanlxfob29oebwn0um9140l133r8-rukduq-tekz50-og1qjp-za66of-qnod9a-cdghzt8enrbc-ei4sg9-7sa12trdyicp-e03x62jcjj2j-h0xih6.1652752832458@email.android.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,
I wanted to add it to the mdadm repo, let say under directory
"python_tests". I didn't started work yet. Those tests should stay with mda=
dm,
so we can develop them with Coly using mdadm-ci and later ask Jes to merge =
the
branch.

I don't have any details, I just asked to gather feedback. Seems that there=
 is
big interest in this change. If there is any volunteer to take this topic a=
nd
prepare python API for testing and first tests- I will be pleased to help.

I could take long time before I will start this topic.

Thanks,
Mariusz

On Tue, 17 May 2022 10:00:32 +0800
=E2=80=AAColy Li=E2=80=AC <colyli@suse.de> wrote:

> Hi Xiao,
>=20
> Yes there is a git repo specific for test scripts, to test the mdadm-ci r=
epo.
> It is located on kernel.org git server, which currently only contains bash
> scripts copied from mdadm.
>=20
> Coly
>=20
> From my phone
>=20
>=20
>=20
> -------- =E5=8E=9F=E5=A7=8B=E9=82=AE=E4=BB=B6 --------
> =E5=8F=91=E4=BB=B6=E4=BA=BA=EF=BC=9A Xiao Ni <xni@redhat.com>
> =E6=97=A5=E6=9C=9F=EF=BC=9A 2022=E5=B9=B45=E6=9C=8817=E6=97=A5=E5=91=A8=
=E4=BA=8C =E4=B8=8A=E5=8D=889:48
> =E6=94=B6=E4=BB=B6=E4=BA=BA=EF=BC=9A Mariusz Tkaczyk <mariusz.tkaczyk@lin=
ux.intel.com>
> =E6=8A=84=E9=80=81=EF=BC=9A Nigel Croxon <ncroxon@redhat.com>, Coly Li <c=
olyli@suse.de>, Jes
> Sorensen <jes@trained-monkey.org>, linux-raid <linux-raid@vger.kernel.org=
> =E4=B8=BB
> =E9=A2=98=EF=BC=9A Re: mdadm test suite improvements Hi Mariusz
> >=20
> > Thanks for the effort. Have you init the git project to start this? If
> > so, you can send it, so we can
> > work together about this.
> >=20
> > Best Regards
> > Xiao
> >=20
> > On Mon, May 16, 2022 at 10:09 PM Mariusz Tkaczyk
> > <mariusz.tkaczyk@linux.intel.com> wrote:
> > >
> > > Hello All,
> > > I'm working on names handling in mdadm and I need to add some new tes=
t to
> > > the mdadm scope - to verify that it is working as desired.
> > > Bash is not best choice for testing and in current form, our tests ar=
e not
> > > friendly for developers. I would like to introduce another python bas=
ed
> > > test scope and add it to repository. I will integrate it with current
> > > framework.
> > >
> > > I can see that currently test are not well used and they aren't often
> > > updated. I want to bring new life to them. Adopting more modern appro=
ach
> > > seems to be good start point.
> > > Any thoughts?
> > >
> > > Thanks in advance,
> > > Mariusz
> > >
> >=20
> >=20

