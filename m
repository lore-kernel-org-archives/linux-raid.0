Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D106C6FD1F
	for <linux-raid@archiver.kernel.org>; Wed, 22 Mar 2023 07:05:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjCVHFu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Mar 2023 03:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjCVHFt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Mar 2023 03:05:49 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984A758B60
        for <linux-raid@vger.kernel.org>; Wed, 22 Mar 2023 00:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679468748; x=1711004748;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D9qYI2yUJuU48b/Mn4fBVApxOB2BQkB+vZaQuO3fxOU=;
  b=R9d9JMFTabIQdi6iHHXQZmFOQWNE+XM1ISL1wNgpqXwnjh3XB9Y7aR/k
   hDbxTR0J3ODBpQl08j3Sv/HaWPQs7pzIz6jbDP3ZrngckiJwvGt9Pgm9T
   PQL1w9CoSXZYk5C3mh1FmeI1nEYTt3xFRJ8x/cplRyWeqUJLqbtXG6EQT
   gH+k6K/xlMqPXqGR2tSt3qM4m8jFgSdlenLO7Lq7pw0vxWTy9f0QDDUN4
   dzqtA+mJAjbOutJTMl/1OwMZbP8j8TYvdDOca6dBzByL3bnZl0Sm6XIeA
   8u6pGqUPLWCpwdvUDJkUpkKVKz54Tr7fLwkDxvq7M/KseQ4DQ2kY/eT+w
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="366880885"
X-IronPort-AV: E=Sophos;i="5.98,281,1673942400"; 
   d="scan'208";a="366880885"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 00:05:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="770944313"
X-IronPort-AV: E=Sophos;i="5.98,281,1673942400"; 
   d="scan'208";a="770944313"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.62.75])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 00:05:46 -0700
Date:   Wed, 22 Mar 2023 08:05:41 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Wu Guanghao <wuguanghao3@huawei.com>
Cc:     <song@kernel.org>, <linux-raid@vger.kernel.org>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        <louhongxiang@huawei.com>
Subject: Re: [PATCH] raid0: fix set_disk_faulty doesn't return -EBUSY
Message-ID: <20230322080541.00004e8a@linux.intel.com>
In-Reply-To: <91f6086c-249d-167c-4948-1359d7b4115b@huawei.com>
References: <df1fc8d7-0a34-aef7-aeeb-db4f59755f78@huawei.com>
        <20230321111828.0000172d@linux.intel.com>
        <91f6086c-249d-167c-4948-1359d7b4115b@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 22 Mar 2023 10:24:41 +0800
Wu Guanghao <wuguanghao3@huawei.com> wrote:

> =E5=9C=A8 2023/3/21 18:18, Mariusz Tkaczyk =E5=86=99=E9=81=93:
> > On Tue, 21 Mar 2023 16:56:37 +0800
> > Wu Guanghao <wuguanghao3@huawei.com> wrote:
> >  =20
> >> The latest kernel version will not report an error through mdadm
> >> set_disk_faulty.
> >>
> >> $ lsblk
> >> sdb                                           8:16   0   10G  0 disk
> >> =E2=94=94=E2=94=80md0                                         9:0    0=
 19.9G  0 raid0
> >> sdc                                           8:32   0   10G  0 disk
> >> =E2=94=94=E2=94=80md0                                         9:0    0=
 19.9G  0 raid0
> >>
> >> old kernel:
> >> ...
> >> $ mdadm /dev/md0 -f /dev/sdb
> >> mdadm: set device faulty failed for /dev/sdb:  Device or resource busy
> >> ...
> >>
> >> latest kernel:
> >> ...
> >> $ mdadm /dev/md0 -f /dev/sdb
> >> mdadm: set /dev/sdb faulty in /dev/md0
> >> ...
> >>
> >> The old kernel judges whether the Faulty flag is set in rdev->flags,
> >> and returns -EBUSY if not. And The latest kernel only return -EBUSY
> >> if the MD_BROKEN flag is set in mddev->flags. raid0 doesn't set
> >> error_handler, so MD_BROKEN will not be set, it will return 0.
> >>
> >> So if error_handler isn't set for a raid type, also return -EBUSY. =20
> > Hi,
> > Please test with:
> > https://lore.kernel.org/linux-raid/20230306130317.3418-1-mariusz.tkaczy=
k@linux.intel.com/
> >=20
> > Thanks,
> > Mariusz
> >  =20
>=20
> Hi, Mariusz
>=20
> Are there other patches?  There are other problems with this patch.
> https://lore.kernel.org/linux-raid/20230306130317.3418-1-mariusz.tkaczyk@=
linux.intel.com/
>=20
> md_submit_bio()
> 	...
> 	// raid0 set disk faulty failed, but MD_BROKEN flag is set=EF=BC=8C
> 	// write IO will fail.
> 	if (unlikely(test_bit(MD_BROKEN, &mddev->flags)) && (rw =3D=3D WRITE)) {
> 		bio_io_error(bio);
> 		return;
> 	}
> 	...
>=20
> old kernel:
> ...
> $ mdadm /dev/md0 -f /dev/sdb
> mdadm: set device faulty failed for /dev/sdb:  Device or resource busy
>=20
> $ mkfs.xfs /dev/md0
> log stripe unit (524288 bytes) is too large (maximum is 256KiB)
> log stripe unit adjusted to 32KiB
> meta-data=3D/dev/md0               isize=3D512    agcount=3D16, agsize=3D=
1800064 blks
>          =3D                       sectsz=3D512   attr=3D2, projid32bit=
=3D1
>          =3D                       crc=3D1        finobt=3D1, sparse=3D1,=
 rmapbt=3D0
>          =3D                       reflink=3D1    bigtime=3D0 inobtcount=
=3D0
> data     =3D                       bsize=3D4096   blocks=3D28801024, imax=
pct=3D25
>          =3D                       sunit=3D128    swidth=3D256 blks
> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
> log      =3Dinternal log           bsize=3D4096   blocks=3D14064, version=
=3D2
>          =3D                       sectsz=3D512   sunit=3D8 blks, lazy-co=
unt=3D1
> realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0
> Discarding blocks...Done.
> ...
>=20
>=20
> merged patch kernel:
> ...
> # mdadm /dev/md0 -f /dev/sdb
> mdadm: set device faulty failed for /dev/sdb:  Device or resource busy
>=20
> mkfs.xfs /dev/md0
> log stripe unit (524288 bytes) is too large (maximum is 256KiB)
> log stripe unit adjusted to 32KiB
> meta-data=3D/dev/md0               isize=3D512    agcount=3D8, agsize=3D6=
5408 blks
>          =3D                       sectsz=3D512   attr=3D2, projid32bit=
=3D1
>          =3D                       crc=3D1        finobt=3D1, sparse=3D1,=
 rmapbt=3D0
>          =3D                       reflink=3D1    bigtime=3D0 inobtcount=
=3D0
> data     =3D                       bsize=3D4096   blocks=3D523264, imaxpc=
t=3D25
>          =3D                       sunit=3D128    swidth=3D256 blks
> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
> log      =3Dinternal log           bsize=3D4096   blocks=3D2560, version=
=3D2
>          =3D                       sectsz=3D512   sunit=3D8 blks, lazy-co=
unt=3D1
> realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0
> mkfs.xfs: pwrite failed: Input/output error
> ...
>=20
>=20
Hi Wu,
Beside the kernel, there are also patches in mdadm. Please check if you have
them all.
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=3Db3e7b7eb1=
dfedd7cbd9a3800e884941f67d94c96
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=3D461fae7e7=
809670d286cc19aac5bfa861c29f93a
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=3Dfc6fd4063=
769f4194c3fb8f77b32b2819e140fb9

Some background:
--faulty (-f) is intended to be used by administrators. We cannot rely on
kernel answer because if mdadm will try to set device faulty, it results in
MD_BROKEN and every new IO will be failed (and that is intended change).

Simply, mdadm must check first if it can remove the drive and that was adde=
d by
the mentioned patches. The first patch (the last one) added verification but
brings regression, the next two patches are fixes for omitted scenarios.

Thanks,
Mariusz
