Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C10C83F10
	for <linux-raid@archiver.kernel.org>; Thu, 31 Aug 2023 09:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243949AbjHaJZK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 31 Aug 2023 05:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234793AbjHaJZK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 31 Aug 2023 05:25:10 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7670D194
        for <linux-raid@vger.kernel.org>; Thu, 31 Aug 2023 02:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693473907; x=1725009907;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TNL7VW9Dqc0f9hOXIxghYSGkK0v6VK8rdwdJMym9+Uc=;
  b=Lb3yH9zn+PzN37uVZbMYV0BY1YDlAyiBgNJgjHAVLe+ygYKukWRxoMsW
   vFnsCpCxRL6PtW31LwCnkhhlKGMZLvtThFkR8YrSAJVtckwh64coynesb
   qpE+/K9x3Fl7LZvrs/cP+C697EOwv1T2eEUGYlC4MdLdcj3hDEcGMYqjs
   80zhJvTKcveHf3bFblLIukjZSNTdJhOSQ5Dwe+ZMWLX0Rh6Z5rW84msIW
   5EHN5oijvkxV/4/D0saSZrS62q0Z8gxQrfM4dDNoljLJH/r23z1B7GlpM
   Z1nxr1le9YFQJdgFhjlbNBJTuBcNAzS6pTznNj/BCZh7xC44pMhWPz+Qs
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10818"; a="406869556"
X-IronPort-AV: E=Sophos;i="6.02,216,1688454000"; 
   d="scan'208";a="406869556"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2023 02:25:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10818"; a="854081604"
X-IronPort-AV: E=Sophos;i="6.02,216,1688454000"; 
   d="scan'208";a="854081604"
Received: from ktanska-mobl1.ger.corp.intel.com (HELO intel.linux.com) ([10.213.14.128])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2023 02:25:05 -0700
Date:   Thu, 31 Aug 2023 11:25:03 +0200
From:   Kinga Tanska <kinga.tanska@linux.intel.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        linux-raid <linux-raid@vger.kernel.org>
Subject: Re: The imsm regression tests fail
Message-ID: <20230831112411.0000561e@intel.linux.com>
In-Reply-To: <CALTww28VmeQXbTn4ONxE4Y9M3rR6OkQhcE6AMUkw_5LSOTPuLg@mail.gmail.com>
References: <CALTww2_FrkmafTkObCX4W1SXVeJiy45h7TR68iHUMpzfAOseHQ@mail.gmail.com>
 <20230803090429.0000046a@linux.intel.com>
 <CALTww28VmeQXbTn4ONxE4Y9M3rR6OkQhcE6AMUkw_5LSOTPuLg@mail.gmail.com>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 3 Aug 2023 19:41:47 +0800
Xiao Ni <xni@redhat.com> wrote:

> On Thu, Aug 3, 2023 at 3:12=E2=80=AFPM Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
> >
> > On Thu, 3 Aug 2023 11:27:57 +0800
> > Xiao Ni <xni@redhat.com> wrote:
> > =20
> > > Hi Mariusz
> > >
> > > Now most imsm regression tests fail.
> > >
> > > +++ /home/mdadm/mdadm --quiet --create --run /dev/md/vol0
> > > --auto=3Dmd --level=3D0 --size=3D5120 --chunk=3D64 --raid-disks=3D3
> > > /dev/loop0 /dev/loop1 /dev/loop2 --auto=3Dyes
> > > +++ rv=3D0
> > > +++ case $* in
> > > +++ cat /var/tmp/stderr
> > > mdadm: timeout waiting for /dev/md/vol0
> > >
> > > +++ echo '**Fatal**: Array member /dev/md/vol0 not found'
> > > **Fatal**: Array member /dev/md/vol0 not found
> > >
> > > Could you have a look at this problem?
> > >
> > > Best Regards
> > > Xiao
> > > =20
> >
> > Hi Xiao,
> > Please provide (I guess it is md126):
> > # mdadm -D --export /dev/md126
> >
> > If there is no MD_DEVNAME property then udev has no content to make
> > the link.
> >
> > Do you have this one applied?
> > https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=3Def623=
6da232e968dcf08b486178cd20d5ea97e2a
> >
> > Thanks,
> > Mariusz
> > =20
>=20
> Hi Mariusz
>=20
> I re-complied the codes and the failure disappeared. Thanks for your
> feedback.
>=20
> Regards
> Xiao
>=20

Hi,

I've met similar issue, there was a timeout while creating a
container.
I've realized that I have been used IMSM_DEVNAME_AS_SERIAL flag while
creating a container, but I haven't exported this flag globally. Udev
has not this flag set while "mdadm --detail --no-devices --export
/dev/md127" was called, and, from some reason, mdadm do not fill
MD_DEVNAME property in this case, and, as a result, do not create a
link.
I'm looking for a root cause in mdadm now, why MD_DEVNAME property is
not set always. If you have used this flag to test, it may be the
same issue.

Regards,
Kinga Tanska
