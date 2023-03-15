Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EFB0C6FD1D
	for <linux-raid@archiver.kernel.org>; Wed, 15 Mar 2023 10:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbjCOKLo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Mar 2023 06:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbjCOKLK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Mar 2023 06:11:10 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD2E62313
        for <linux-raid@vger.kernel.org>; Wed, 15 Mar 2023 03:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678875040; x=1710411040;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DkCgGbpULSOsDRjnAmAkZRpMoLHNpyciU1NBsJGDXqQ=;
  b=DCpHpLAQtmQCayCS8miOJgYERrX3PcihJMC+PBkWJF8fiepR6Cg9+kwA
   E5fvyRuQvkyiFhEEHj9PQEjEEx75bhGb3BKraOzOwaS65bo+tL2LN2dp0
   WoXRNfLqqzAfP7mW9rX1UM5JHf1FUG9Fot1lCz3D6jVInWXZPf3+j4Y22
   4eKKwkfahS9IflXy7hcXOyHNPy4UxDtssrGXnBPLeOIvOWMowXuNnyOJF
   jdAtDzbLQ8VLMgl/HmagcYFuApGpscFKnsdMdEq1rskGztVQ9gogOsqS7
   DkDltOqap1XYwgwUVXwXEzp412hN9PoT+jJCbXZS7DET4MFK+TY2Vln8u
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="340025728"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="340025728"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 03:10:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="925285861"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="925285861"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.62.26])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 03:10:31 -0700
Date:   Wed, 15 Mar 2023 11:10:27 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Martin Wilck <mwilck@suse.com>, Song Liu <song@kernel.org>
Cc:     Li Xiao Keng <lixiaokeng@huawei.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>, Coly Li <colyli@suse.de>,
        linux-raid@vger.kernel.org, linfeilong <linfeilong@huawei.com>,
        louhongxiang@huawei.com,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        miaoguanqin <miaoguanqin@huawei.com>
Subject: Re: [QUESTION] How to fix the race of "mdadm --add" and "mdadm
 mdadm --incremental --export"
Message-ID: <20230315111027.0000372d@linux.intel.com>
In-Reply-To: <04a4cc6aac10cd24d5bc0b3485d47f6ccb752eab.camel@suse.com>
References: <252cdcda-afcd-ce76-00cf-c138136e70ab@huawei.com>
        <c00c211a3126d7a30c662117d28f3a4a9c81f7dc.camel@suse.com>
        <20230314165938.00003030@linux.intel.com>
        <04a4cc6aac10cd24d5bc0b3485d47f6ccb752eab.camel@suse.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 14 Mar 2023 17:11:06 +0100
Martin Wilck <mwilck@suse.com> wrote:

> On Tue, 2023-03-14 at 16:59 +0100, Mariusz Tkaczyk wrote:
> > On Tue, 14 Mar 2023 16:04:23 +0100
> > Martin Wilck <mwilck@suse.com> wrote:
> >  =20
> > > On Tue, 2023-03-14 at 22:58 +0800, Li Xiao Keng wrote: =20
> > > > Hi,
> > > > =C2=A0=C2=A0 Here we meet a question. When we add a new disk to a r=
aid, it
> > > > may
> > > > return
> > > > -EBUSY.
> > > > =C2=A0=C2=A0 The main process of --add=EF=BC=88for example md0, sdf=
):
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1.dev_open(sdf)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2.add_to_super
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3.write_init_super
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4.fsync(fd)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 5.close(fd)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 6.ioctl(ADD_NEW_DISK).
> > > > =C2=A0=C2=A0 However, there will be some udev(change of sdf) event =
after
> > > > step5.
> > > > Then
> > > > "/usr/sbin/mdadm --incremental --export $devnode --offroot
> > > > $env{DEVLINKS}"
> > > > will be run, and the sdf will be added to md0. After that, step6
> > > > will
> > > > return
> > > > -EBUSY.
> > > > =C2=A0=C2=A0 It is a problem to user. First time adding disk does n=
ot
> > > > return
> > > > success
> > > > but disk is actually added. And I have no good idea to deal with
> > > > it.
> > > > Please
> > > > give some great advice.=C2=A0  =20
> > >=20
> > > I haven't looked at the code in detail, but off the top of my head,
> > > it
> > > should help to execute step 5 after step 6. The close() in step 5
> > > triggers the uevent via inotify; doing it after the ioctl should
> > > avoid
> > > the above problem. =20
> > Hi,
> > That will result in EBUSY in everytime. mdadm will always handle
> > descriptor and kernel will refuse to add the drive. =20
>=20
> Why would it cause EBUSY? Please elaborate. My suggestion would avoid
> the race described by Li Xiao Keng. I only suggested to postpone the
> close(), nothing else. The fsync() would still be done before the
> ioctl, so the metadata should be safely on disk when the ioctl is run.

Because device will be claimed in userspace by mdadm. MD may check if device
is not claimed. I checked bind_rdev_to_array() and I don't find an obvious
answer, so I could be wrong here.

Maybe someone more kernel experienced can speak here? Song, could you look?

I think that the descriptor opened by incremental block kernel from adding =
the
device to the array but also the same incremental is able to add it later
because metadata is on device. There is no retry in Manage_add() flow so it
must be added by Incremental so the question is if it is already in
array or disk is just claimed and that is the problem.

Eventually, you can test your proposal that should gives us an answer.

>=20
> This is a recurring pattern. Tools that manipulate block devices must
> be aware that close-after-write triggers an uevent, and should make
> sure that they don't close() such files prematurely.

Agree. Mdadm has this problem, descriptors are opened and closed may times.
>=20
> > >=20
> > > Another obvious workaround in mdadm would be to check the state of
> > > the
> > > array in the EBUSY case and find out that the disk had already been
> > > added.
> > >=20
> > > But again, this was just a high-level guess.
> > >=20
> > > Martin
> > >  =20
> >=20
> > Hmm... I'm not a native expert but why we cannot write metadata after
> > adding
> > drive to array? Why kernel can't handle that?
> >=20

Ok, there is an assumption in kernel that device MUST have metadata.

> > Ideally, we should lock device and block udev- I know that there is
> > flock
> > based API to do that but I'm not sure if flock() won't cause the same
> > problem. =20
>=20
> That doesn't work reliably. At least not in general. The mechanmism is
> disabled for for dm devices (e.g. multipath), for example. See
> https://github.com/systemd/systemd/blob/a5c0ad9a9a2964079a19a1db42f79570a=
3582bee/src/udev/udevd.c#L483
>=20
Yeah, I know but udev processes the disk, not MD device so the locking
should work. But if we cannot trust it, we shouldn't follow this idea.
> =20
> > There is also something like "udev-md-raid-creating.rules". Maybe we
> > can reuse
> > it?
> >  =20
>=20
> Unless I am mistaken, these rules are exactly those that cause the
> issue we are discussing. Since these rules are also part of the mdadm
> package, it might be possible to set some flag under /run that would
> indicate to the rules that auto-assembly should be skipped. But that
> might be racy, too.

Yeah, bad idea. Agree.

New day, new ideas:
- why we cannot let udev to add the device? just write metadata and finish,
  udev should handle that because metadata is there.

- incremental uses map_lock() to prevent concurrent updates, I seems to b
  missed for --add. That could be a key to prevent the behavior.Incremental=
 is
  checking if it can lock the map file. If not, it finishes gracefully. To =
lock
  array we need to read metadata first, so it goes to the first question- i=
s it
  a problem that incremental has opened descriptor?

Thanks,
Mariusz
