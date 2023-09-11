Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E029CA0ED2
	for <linux-raid@archiver.kernel.org>; Mon, 11 Sep 2023 22:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355428AbjIKV7d (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 11 Sep 2023 17:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242868AbjIKQ10 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 11 Sep 2023 12:27:26 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63589CCD
        for <linux-raid@vger.kernel.org>; Mon, 11 Sep 2023 09:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694449641; x=1725985641;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fLe1eVF0AyQjKFE2tRHJ1P6Lg3GSKkOCJmYP0mm4GKo=;
  b=ZlV/pDFwkxOEVp7I7+uu70+I5g+t+RlARjLclYzNdaNcN1nrzIn21SAF
   nbu9+kjkyR/uSf0wlALRI+Z4ohuHSGP5vVAxzPq/F0d9zAtcu5bG1pBfJ
   Z+SLc4NXLMHJzOyC29SM6sPOHXO6O341hJPY+aie94sHSP+oisO0SP2nD
   CdGL8CnXzJUOBzPrt+bOyVH/BajSaIksJKlcDojs2/cGxu0Q0YDE3B3HT
   jAWDRga19YiHw3YCR/PSHXkR+l1VOXkQGWDsptSy/gJRxRp8YeAgRyoXq
   o5AMuUVPPWBHCg5ru/LYCNU2usJxoECfYyHz88WZ+99DC8nAw9KiYmwxe
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="380829242"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="380829242"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 09:00:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="990139590"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="990139590"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.141.71])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 09:00:36 -0700
Date:   Mon, 11 Sep 2023 18:00:32 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Li Xiao Keng <lixiaokeng@huawei.com>
Cc:     Jes Sorensen <jes@trained-monkey.org>,
        Martin Wilck <mwilck@suse.com>, Coly Li <colyli@suse.de>,
        <linux-raid@vger.kernel.org>, <louhongxiang@huawei.com>,
        miaoguanqin <miaoguanqin@huawei.com>
Subject: Re: [PATCH v3] Fix race of "mdadm --add" and "mdadm --incremental"
Message-ID: <20230911180032.00007bbb@linux.intel.com>
In-Reply-To: <a25e4d75-ebc3-0841-832c-34b8e5f4cbb7@huawei.com>
References: <a25e4d75-ebc3-0841-832c-34b8e5f4cbb7@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 7 Sep 2023 19:37:44 +0800
Li Xiao Keng <lixiaokeng@huawei.com> wrote:

> There is a raid1 with sda and sdb. And we add sdc to this raid,
> it may return -EBUSY.
>=20
> The main process of --add:
> 1. dev_open=EF=BC=88sdc) in Manage_add
> 2. store_super1(st, di->fd) in write_init_super1
> 3. fsync(fd) in store_super1
> 4. close(di->fd) in write_init_super1
> 5. ioctl(ADD_NEW_DISK)
>=20
> Step 2 and 3 will add sdc to metadata of raid1. There will be
> udev(change of sdc) event after step4. Then "/usr/sbin/mdadm
> --incremental --export $devnode --offroot $env{DEVLINKS}"
> will be run, and the sdc will be added to the raid1. Then
> step 5 will return -EBUSY because it checks if device isn't
> claimed in md_import_device()->lock_rdev()->blkdev_get_by_dev()
> ->blkdev_get(). =20
>=20
> It will be confusing for users because sdc is added first time.
> The "incremental" will get map_lock before add sdc to raid1.
> So we add map_lock before write_init_super in "mdadm --add"
> to fix the race of "add" and "incremental".
>=20
> Signed-off-by: Li Xiao Keng <lixiaokeng@huawei.com>
> Signed-off-by: Guanqin Miao <miaoguanqin@huawei.com>

Hello Li Xiao Keng,
Thanks for the patch, I'm trying to get my head around this.
As I understand, you added a mapfile locking and you are failing when the l=
og
is already claimed, but you prefer to return -1 and print error instead of
returning EBUSY, right?

If yes, it has nothing to do with fixing. It is just a obscure hack to make=
 it,
let say more reliable. We can either get EBUSY and know that is expected. I
see no difference, your solution is same confusing as current implementatio=
n.

Also, you used map_lock(). I remember that initially I proposed - my bad.
We also rejected udev locking, as a buggy. In fact- I don't see ready
synchronization method to avoid this race in mdadm right now.

The best way, I see is:
1. Write metadata.
2. Give udev chance to process the device.
3. Add it manually if udev failed (or D_NO_UDEV).

If it does not work for you, we need to add synchronization, I know that th=
ere
is pidfile used for mdmon, perhaps we can reuse it? We don't need something
fancy, just something to keep all synchronised and block incremental to led
--add finish the action.

We cannot use map_lock() and map_unlock() in this context. It claims lock on
mapfile which describes every array in your system (base details, there is =
no
info about members), see /var/run/mdadm. Add is just a tiny action to add d=
isk
and we are not going to update the map. Taking this lock will make --add
more vulnerable, for example it will fail because another array is assemble=
d or
created in the same time (I know that it will be hard to achieve but it is
another race - we don't want it).

And we cannot allow for partially done action, you added this lock after
writing metadata (according to description), we are not taking this lock to
complete the action, just to hide race. Lock should be taken before
writing metadata, but we know that it will not hide an issue.

In this for it cannot be merged I don't see a gain, we are returning -1 ins=
tead
-22, what is the difference? I don't see error message as more meaningful n=
ow.

Thanks,
Mariusz
