Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1701DCE7A89
	for <linux-raid@archiver.kernel.org>; Mon, 25 Sep 2023 07:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbjIYH6t (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 25 Sep 2023 03:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbjIYH6s (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 25 Sep 2023 03:58:48 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6411101
        for <linux-raid@vger.kernel.org>; Mon, 25 Sep 2023 00:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695628721; x=1727164721;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z5VBCx0VNVg1mH/OOR+2dBjPUoJe2zuwfaMtt9dMU0g=;
  b=ADLUbCLHQWxy84UJNGyVwnI7DUhqODHvD/+MmDoCOjyDtNnTpGE63zEp
   A13ZG5OSYmUFTmXqATa/J8V6RmPjzGYXyYnkU3aS31g45hB1MWdFDGX/l
   i8cmovxnvL1ZBgLZMjU4bmYjGlutDrA/C5bVgRg+/ZBpH2A7U5W2zpzFs
   EDNpRv+2u+7Z0DOHL6hE+Ni9CvmTnDfD6fFdAiVgIl/JCJiZb0aqkyVOC
   5KGX8B2qaT2pFx5+U1v0jBS6x88hiG7zooYZ4lmmKDHviA8KPMq5YsCzA
   ZbOg/8FWK4R36/FsMKbthpHzROb6MW/1vwMF4n24E93Nna+zsgPqmNtOp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="366252241"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="366252241"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 00:58:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="777572808"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="777572808"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.90])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 00:58:39 -0700
Date:   Mon, 25 Sep 2023 09:58:35 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH] md: do not require mddev_lock() for all options
Message-ID: <20230925095835.00002fcc@linux.intel.com>
In-Reply-To: <175273eb-35a2-507d-ec0c-0685e7f6acd7@huaweicloud.com>
References: <20230913085502.17856-1-mariusz.tkaczyk@linux.intel.com>
        <CAPhsuW6qk=XbbOxtzr0FGVuZHLr4kbzODkTSPjcBmK4YYGWWKw@mail.gmail.com>
        <175273eb-35a2-507d-ec0c-0685e7f6acd7@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 25 Sep 2023 11:05:42 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> =E5=9C=A8 2023/09/23 5:04, Song Liu =E5=86=99=E9=81=93:
> > Hi Mariusz,
> >=20
> > Sorry for the late reply.
> >=20
> > On Wed, Sep 13, 2023 at 1:55=E2=80=AFAM Mariusz Tkaczyk
> > <mariusz.tkaczyk@linux.intel.com> wrote: =20
> >>
> >> We don't need to lock device to reject not supported request
> >> in array_state_store().
> >> Main motivation is to make a room for action does not require lock yet,
> >> like prepare to stop (see md_ioctl()). =20
> >=20
> > I made some changes to the commit log:
> >=20
> >      md: do not require mddev_lock() for all options
> >=20
> >      We don't need to lock device to reject not supported request
> >      in array_state_store().
> >      Main motivation is to make a room for action does not require lock=
 yet,
> >      like prepare to stop (see md_ioctl()).
> >=20
> > But I am not sure what you meant by "make a room for action does not
> > require lock yet". Could you please explain? =20
>=20
> Yes, this sounds confusing, if 'action does not require lock', then it
> shound not be blocked by array_state_store() with or without this patch.

In md_ioctl() we do some actions before stopping. We are verifying
how many holders are there (mddev->openers), we are setting MD_CLOSING and
sync_blockdev() is executed. I see that it is omitted in array_state_store(=
).
https://elixir.bootlin.com/linux/latest/source/drivers/md/md.c#L7580

I meant that with this separated switch before locking mddev it is now easy=
 to
add other actions, like mentioned code above for stopping.
>=20
> >=20
> > Otherwise, the code looks reasonable to me. =20
>=20
> Changes look good to me, after clarify commit message, feel free to add
>=20
> Reviewed-by: Yu Kuai <yukuai3@huawei.com>

Thanks!
I will send v2.

Mariusz
