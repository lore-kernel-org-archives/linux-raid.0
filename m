Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5052C6FD1D
	for <linux-raid@archiver.kernel.org>; Tue, 21 Mar 2023 10:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjCUKSx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 21 Mar 2023 06:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjCUKSw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 21 Mar 2023 06:18:52 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935362D5B
        for <linux-raid@vger.kernel.org>; Tue, 21 Mar 2023 03:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679393915; x=1710929915;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cASLssMQ6cOJBv9AS4b1yR2UafZyK8CE9NLbVObbnSs=;
  b=Htyaw1MmcKFatVxmOs08zKJ8FdVNG6wAtwa+CC0GoID81vdckxdHK8Bm
   5ntUyHo/QWEPCYG+vIKl6bGiRDK5TvLFdYt27jZm7OrMQMf2zk/0vWpP0
   FJmS/5926UP4lz0qPDTAJXIMSeQ9gt0nQyapQ0lEwqfdacUY6lwBWPh4q
   8EFzg60aY7eM2qPKZuTLWdSC2z6ZgxbAmUfQBmQXV8vS0Wz3+ZylppV2z
   o0xBXGz9WbOUpCPZDSgBeVt+ABbRRR3Cn4H4Ad4WF9gUSaBSHEZvkxCh8
   WhedkGEysuu3XzeeQs2fc1Kh+adlbPOEGTdZh2B7V+I25ummGHYlAQDos
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="336408583"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="336408583"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 03:18:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="711748873"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="711748873"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.37.33])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 03:18:33 -0700
Date:   Tue, 21 Mar 2023 11:18:28 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Wu Guanghao <wuguanghao3@huawei.com>
Cc:     <song@kernel.org>, <linux-raid@vger.kernel.org>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        <louhongxiang@huawei.com>
Subject: Re: [PATCH] raid0: fix set_disk_faulty doesn't return -EBUSY
Message-ID: <20230321111828.0000172d@linux.intel.com>
In-Reply-To: <df1fc8d7-0a34-aef7-aeeb-db4f59755f78@huawei.com>
References: <df1fc8d7-0a34-aef7-aeeb-db4f59755f78@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 21 Mar 2023 16:56:37 +0800
Wu Guanghao <wuguanghao3@huawei.com> wrote:

> The latest kernel version will not report an error through mdadm
> set_disk_faulty.
>=20
> $ lsblk
> sdb                                           8:16   0   10G  0 disk
> =E2=94=94=E2=94=80md0                                         9:0    0 19=
.9G  0 raid0
> sdc                                           8:32   0   10G  0 disk
> =E2=94=94=E2=94=80md0                                         9:0    0 19=
.9G  0 raid0
>=20
> old kernel:
> ...
> $ mdadm /dev/md0 -f /dev/sdb
> mdadm: set device faulty failed for /dev/sdb:  Device or resource busy
> ...
>=20
> latest kernel:
> ...
> $ mdadm /dev/md0 -f /dev/sdb
> mdadm: set /dev/sdb faulty in /dev/md0
> ...
>=20
> The old kernel judges whether the Faulty flag is set in rdev->flags,
> and returns -EBUSY if not. And The latest kernel only return -EBUSY
> if the MD_BROKEN flag is set in mddev->flags. raid0 doesn't set error_han=
dler,
> so MD_BROKEN will not be set, it will return 0.
>=20
> So if error_handler isn't set for a raid type, also return -EBUSY.
Hi,
Please test with:
https://lore.kernel.org/linux-raid/20230306130317.3418-1-mariusz.tkaczyk@li=
nux.intel.com/

Thanks,
Mariusz

>=20
> Fixes: 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10")
> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> ---
>  drivers/md/md.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 927a43db5dfb..b1786ff60d97 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2928,10 +2928,10 @@ state_store(struct md_rdev *rdev, const char *buf,
> size_t len) int err =3D -EINVAL;
>         bool need_update_sb =3D false;
>=20
> -       if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
> -               md_error(rdev->mddev, rdev);
> +       if (cmd_match(buf, "faulty") && mddev->pers) {
> +               md_error(mddev, rdev);
>=20
> -               if (test_bit(MD_BROKEN, &rdev->mddev->flags))
> +               if (!mddev->pers->error_handler || test_bit(MD_BROKEN,
> &mddev->flags)) err =3D -EBUSY;
>                 else
>                         err =3D 0;
> @@ -7421,7 +7421,7 @@ static int set_disk_faulty(struct mddev *mddev, dev=
_t
> dev) err =3D  -ENODEV;
>         else {
>                 md_error(mddev, rdev);
> -               if (test_bit(MD_BROKEN, &mddev->flags))
> +               if (!mddev->pers->error_handler || test_bit(MD_BROKEN,
> &mddev->flags)) err =3D -EBUSY;
>         }
>         rcu_read_unlock();
> --
> 2.27.0
> .

