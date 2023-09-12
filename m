Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F7EECA0EC3
	for <linux-raid@archiver.kernel.org>; Tue, 12 Sep 2023 08:01:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbjILIBd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Sep 2023 04:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbjILIAb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 12 Sep 2023 04:00:31 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7637E1717
        for <linux-raid@vger.kernel.org>; Tue, 12 Sep 2023 00:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694505516; x=1726041516;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x1HRLRDo4weF5KU+2VBJNq4yIO6hos/ApCVtYHPZRtU=;
  b=Y++c6v+0LpzDFGJ4CCOo5TMC9lb4VvznDFcQdHvv5r13fO+lWJuCyIbw
   4yzI096B7hJbRMUrjDLDBSbw4Hkyg/dGTnQm796CeWScjmqvk3mbRk3oY
   +VZTwwCUVpuQOxBN/m7cqG9X1AgjI6lTeLo2IlPU5ucKux0Ot6HWiTmhh
   YrrieD06MtZuQqgcSNLqHpFB7fADsmkj2xLWkFeu89qkv+NAsYwwSpNyV
   gfaj4SQE3KcYQlNEQLCMZq3YBtfApRxFIQl29CLfT4IKZ0S6d/maJrVhA
   I6HPVyZIl1tWL9DfVwaI9unYImt5cSlCOxbJe8U23szSPsU4hw7MUvZ0A
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="357739897"
X-IronPort-AV: E=Sophos;i="6.02,245,1688454000"; 
   d="scan'208";a="357739897"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2023 00:58:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="737042765"
X-IronPort-AV: E=Sophos;i="6.02,245,1688454000"; 
   d="scan'208";a="737042765"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.141.64])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2023 00:58:33 -0700
Date:   Tue, 12 Sep 2023 09:58:28 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Li Xiao Keng <lixiaokeng@huawei.com>
Cc:     Jes Sorensen <jes@trained-monkey.org>,
        Martin Wilck <mwilck@suse.com>, Coly Li <colyli@suse.de>,
        <linux-raid@vger.kernel.org>, <louhongxiang@huawei.com>,
        miaoguanqin <miaoguanqin@huawei.com>
Subject: Re: [PATCH v3] Fix race of "mdadm --add" and "mdadm --incremental"
Message-ID: <20230912095828.000002a5@linux.intel.com>
In-Reply-To: <d1744e2f-0476-153e-11b6-662f16d54b73@huawei.com>
References: <a25e4d75-ebc3-0841-832c-34b8e5f4cbb7@huawei.com>
        <20230911180032.00007bbb@linux.intel.com>
        <d1744e2f-0476-153e-11b6-662f16d54b73@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 12 Sep 2023 15:18:33 +0800
Li Xiao Keng <lixiaokeng@huawei.com> wrote:

> On 2023/9/12 0:00, Mariusz Tkaczyk wrote:
> > On Thu, 7 Sep 2023 19:37:44 +0800
> > Li Xiao Keng <lixiaokeng@huawei.com> wrote:
> >  =20
> >> There is a raid1 with sda and sdb. And we add sdc to this raid,
> >> it may return -EBUSY.
> >>
> >> The main process of --add:
> >> 1. dev_open=EF=BC=88sdc) in Manage_add
> >> 2. store_super1(st, di->fd) in write_init_super1
> >> 3. fsync(fd) in store_super1
> >> 4. close(di->fd) in write_init_super1
> >> 5. ioctl(ADD_NEW_DISK)
> >>
> >> Step 2 and 3 will add sdc to metadata of raid1. There will be
> >> udev(change of sdc) event after step4. Then "/usr/sbin/mdadm
> >> --incremental --export $devnode --offroot $env{DEVLINKS}"
> >> will be run, and the sdc will be added to the raid1. Then
> >> step 5 will return -EBUSY because it checks if device isn't
> >> claimed in md_import_device()->lock_rdev()->blkdev_get_by_dev() =20
> >> ->blkdev_get().   =20
> >>
> >> It will be confusing for users because sdc is added first time.
> >> The "incremental" will get map_lock before add sdc to raid1.
> >> So we add map_lock before write_init_super in "mdadm --add"
> >> to fix the race of "add" and "incremental".
> >>
> >> Signed-off-by: Li Xiao Keng <lixiaokeng@huawei.com>
> >> Signed-off-by: Guanqin Miao <miaoguanqin@huawei.com> =20
> >=20
> > Hello Li Xiao Keng,
> > Thanks for the patch, I'm trying to get my head around this.
> > As I understand, you added a mapfile locking and you are failing when t=
he
> > log is already claimed, but you prefer to return -1 and print error ins=
tead
> > of returning EBUSY, right? =20
> No, I do not prefer to return -1 and print error instead of returning EBU=
SY.
> At first, I had the same idea as Martin, thinking that map_lock() would f=
ail
> when it is locked by someone else.Actually it is not fail but block. So n=
ow I
> just print error and go ahead if map_lock() fails, like map_lock() elsewh=
ere.

Ok, thanks now it have more sense!

> >=20
> > If yes, it has nothing to do with fixing. It is just a obscure hack to =
make
> > it, let say more reliable. We can either get EBUSY and know that is
> > expected. I see no difference, your solution is same confusing as curre=
nt
> > implementation.
> >=20
> > Also, you used map_lock(). I remember that initially I proposed - my ba=
d.
> > We also rejected udev locking, as a buggy. In fact- I don't see ready
> > synchronization method to avoid this race in mdadm right now.
> >=20
> > The best way, I see is:
> > 1. Write metadata.
> > 2. Give udev chance to process the device.
> > 3. Add it manually if udev failed (or D_NO_UDEV). =20
> Is there any command to only write metadata?  Or change implementation of
> --add ?

I think that we should change implementation for --add.

> >=20
> > If it does not work for you, we need to add synchronization, I know that
> > there is pidfile used for mdmon, perhaps we can reuse it? We don't need
> > something fancy, just something to keep all synchronised and block
> > incremental to led --add finish the action.
> >=20
> > We cannot use map_lock() and map_unlock() in this context. It claims lo=
ck on
> > mapfile which describes every array in your system (base details, there=
 is
> > no info about members), see /var/run/mdadm. Add is just a tiny action to
> > add disk and we are not going to update the map. Taking this lock will =
make
> > --add more vulnerable, for example it will fail because another array is
> > assembled or created in the same time (I know that it will be hard to
> > achieve but it is another race - we don't want it). =20
> When I test this patch, I find map_lock(=EF=BC=89in --incremental is bloc=
k but not
> fail. So I think it will not fail when another array is assembled.

Oh, it seems that flock() is waiting for the lock to be acquired, it is
blocking function. Now I read the documentation and I confirmed it.

> >=20
> > And we cannot allow for partially done action, you added this lock after
> > writing metadata (according to description), we are not taking this loc=
k to
> > complete the action, just to hide race. Lock should be taken before
> > writing metadata, but we know that it will not hide an issue. =20
> Here I add map_lock() before writing metadata and ulock it until finish. =
Do
> you mean it should be before attempt_re_add()?

Indeed you wrote "before write_init_super in "mdadm --add". I was
against taking a map_lock() but now, when I understand that other processes=
 will
wait I see this as a simplest way to keep all synchronized.=20

After your clarification- I don't have an objections to take this. Taking
map_lock is not the best approach because we lock all mddevices but I don't=
 see
a strong need to have something better. --add is a user action, low risk of
race with other --add or --assemble/--incremental.

I was against it because I thought that it is not blocking0, i.e. we are fa=
iling
if lock cannot be obtained.=20

Reviewed-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Thanks,
Mariusz
