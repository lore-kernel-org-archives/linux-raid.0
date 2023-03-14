Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE658C6FD1C
	for <linux-raid@archiver.kernel.org>; Tue, 14 Mar 2023 15:59:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjCNP75 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Mar 2023 11:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbjCNP7r (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Mar 2023 11:59:47 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA212A161
        for <linux-raid@vger.kernel.org>; Tue, 14 Mar 2023 08:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678809586; x=1710345586;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PXZIzUssPqVYgGgbhdpU0WWPcBMgmNTgsjLkReclPnk=;
  b=ZFDsxEMhQIv0F7aOiBy6zAzbcw5vq3d8JV+c4wOF/TfcdV+RKb5gQUx+
   ZXuphDqJYQb9BPFFWJjjiNHVC1+urrUCEUomy+FwOhsauUIEkngml1Vpr
   E4jjksvWPZqPKGWmJOKpCzNhRolzkKPYPdFsxR0Mv9OJ4c6k9avLcTBom
   g4mZB5S/LTi/iIt+yZ/nZ/euO5OLF4/fMlMcMcY4998ROpRyquox35Gx3
   Y9tWiI1SYA8m8PivZ8fZkXedxIX0LrZTcB+vb5m1HURhxTtl4u2vlZJXw
   yi9nAAiodKi2gI40hMZjKlApFj8PW9+kcPrnpbPLER1QBmoUCgA2DhtJG
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="334952881"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="334952881"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 08:59:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="656397045"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="656397045"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.32.139])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 08:59:42 -0700
Date:   Tue, 14 Mar 2023 16:59:38 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Martin Wilck <mwilck@suse.com>
Cc:     Li Xiao Keng <lixiaokeng@huawei.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>, Coly Li <colyli@suse.de>,
        linux-raid@vger.kernel.org, linfeilong <linfeilong@huawei.com>,
        louhongxiang@huawei.com,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        miaoguanqin <miaoguanqin@huawei.com>
Subject: Re: [QUESTION] How to fix the race of "mdadm --add" and "mdadm
 mdadm --incremental --export"
Message-ID: <20230314165938.00003030@linux.intel.com>
In-Reply-To: <c00c211a3126d7a30c662117d28f3a4a9c81f7dc.camel@suse.com>
References: <252cdcda-afcd-ce76-00cf-c138136e70ab@huawei.com>
        <c00c211a3126d7a30c662117d28f3a4a9c81f7dc.camel@suse.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 14 Mar 2023 16:04:23 +0100
Martin Wilck <mwilck@suse.com> wrote:

> On Tue, 2023-03-14 at 22:58 +0800, Li Xiao Keng wrote:
> > Hi,
> > =C2=A0=C2=A0 Here we meet a question. When we add a new disk to a raid,=
 it may
> > return
> > -EBUSY.
> > =C2=A0=C2=A0 The main process of --add=EF=BC=88for example md0, sdf):
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1.dev_open(sdf)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2.add_to_super
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3.write_init_super
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4.fsync(fd)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 5.close(fd)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 6.ioctl(ADD_NEW_DISK).
> > =C2=A0=C2=A0 However, there will be some udev(change of sdf) event afte=
r step5.
> > Then
> > "/usr/sbin/mdadm --incremental --export $devnode --offroot
> > $env{DEVLINKS}"
> > will be run, and the sdf will be added to md0. After that, step6 will
> > return
> > -EBUSY.
> > =C2=A0=C2=A0 It is a problem to user. First time adding disk does not r=
eturn
> > success
> > but disk is actually added. And I have no good idea to deal with it.
> > Please
> > give some great advice. =20
>=20
> I haven't looked at the code in detail, but off the top of my head, it
> should help to execute step 5 after step 6. The close() in step 5
> triggers the uevent via inotify; doing it after the ioctl should avoid
> the above problem.
Hi,
That will result in EBUSY in everytime. mdadm will always handle
descriptor and kernel will refuse to add the drive.

>=20
> Another obvious workaround in mdadm would be to check the state of the
> array in the EBUSY case and find out that the disk had already been
> added.
>=20
> But again, this was just a high-level guess.
>=20
> Martin
>=20

Hmm... I'm not a native expert but why we cannot write metadata after adding
drive to array? Why kernel can't handle that?

Ideally, we should lock device and block udev- I know that there is flock
based API to do that but I'm not sure if flock() won't cause the same probl=
em.

There is also something like "udev-md-raid-creating.rules". Maybe we can re=
use
it?

Thanks,
Mariusz
