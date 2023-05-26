Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0221C77B7A
	for <linux-raid@archiver.kernel.org>; Fri, 26 May 2023 09:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242617AbjEZJNZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 26 May 2023 05:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242954AbjEZJNX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 26 May 2023 05:13:23 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5C1198
        for <linux-raid@vger.kernel.org>; Fri, 26 May 2023 02:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685092400; x=1716628400;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K1R3teJ5NGArwGBbWhAITYXzsXt9W+9h7Bkz2lvkUo8=;
  b=AMNPY8xQutAQnSKhp+65KEge+Wmwwp8CVduILs7c/kxq3a6MCEC/aPkY
   pmfo9DRCEermv2QHt0JLash6LuTn1A0D7ZPxUIYsI9YSLJlrX9qvjeXk1
   85Qwpw4AAwAJUYbB5PvEqOKO6xfPXootUmjX3JDKhijfTlmjjt1l3Nlgo
   JtZVgOglED5tQ8DZT8AFqF99DWMRueMaIdlFz9oMYnU8kysHcoIMQjPH/
   wyz0X6YM/2pz+JvPv0n+oCiKKswxnvXwEYoAFo08c+xElNIUQ7xpDt9/b
   y1RPRoryKChrmCd2RvPpot5Z6Lq2FzsKKoN+2GakmD5gX/9Ypr6p/yjgR
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="356542724"
X-IronPort-AV: E=Sophos;i="6.00,193,1681196400"; 
   d="scan'208";a="356542724"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2023 02:13:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="705133893"
X-IronPort-AV: E=Sophos;i="6.00,193,1681196400"; 
   d="scan'208";a="705133893"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.130.205])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2023 02:13:17 -0700
Date:   Fri, 26 May 2023 11:13:12 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        "Tkaczyk, Mariusz" <mariusz.tkaczyk@intel.com>,
        Song Liu <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>
Subject: Re: The read data is wrong from raid5 when recovery happens
Message-ID: <20230526111312.000065f2@linux.intel.com>
In-Reply-To: <CALTww297Q+FAFMVBQd-1dT7neYrMjC-UZnAw8Q3UeuEoOCy6Yg@mail.gmail.com>
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
        <ebe7fa31-2e9a-74da-bbbd-3d5238590a7c@linux.dev>
        <CALTww2_ks+Ac0hHkVS0mBaKi_E2r=Jq-7g2iubtCcKoVsZEbXQ@mail.gmail.com>
        <7e9fd8ba-aacd-3697-15fe-dc0b292bd177@linux.dev>
        <CALTww297Q+FAFMVBQd-1dT7neYrMjC-UZnAw8Q3UeuEoOCy6Yg@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 26 May 2023 15:23:58 +0800
Xiao Ni <xni@redhat.com> wrote:

> On Fri, May 26, 2023 at 3:12=E2=80=AFPM Guoqing Jiang <guoqing.jiang@linu=
x.dev> wrote:
> >
> >
> >
> > On 5/26/23 14:45, Xiao Ni wrote: =20
> > > On Fri, May 26, 2023 at 11:09=E2=80=AFAM Guoqing Jiang <guoqing.jiang=
@linux.dev>
> > > wrote: =20
> > >>
> > >>
> > >> On 5/26/23 09:49, Xiao Ni wrote: =20
> > >>> Hi all
> > >>>
> > >>> We found a problem recently. The read data is wrong when recovery
> > >>> happens. Now we've found it's introduced by patch 10764815f (md: ad=
d io
> > >>> accounting for raid0 and raid5). I can reproduce this 100%. This
> > >>> problem exists in upstream. The test steps are like this:
> > >>>
> > >>> 1. mdadm -CR $devname -l5 -n4 /dev/sd[b-e] --force --assume-clean
> > >>> 2. mkfs.ext4 -F $devname
> > >>> 3. mount $devname $mount_point
> > >>> 4. mdadm --incremental --fail sdd
> > >>> 5. dd if=3D/dev/zero of=3D/tmp/pythontest/file1 bs=3D1M count=3D100=
000
> > >>> status=3Dprogress =20
> >
> > I suppose /tmp is the mount point. =20
>=20
> /tmp/pythontest is the mount point
>=20
> > =20
> > >>> 6. mdadm /dev/md126 --add /dev/sdd
> > >>> 7. create 31 processes that writes and reads. It compares the conte=
nt
> > >>> with md5sum. The test will go on until the recovery stops =20
> >
> > Could you share the test code/script for step 7? Will try it from my si=
de. =20
>=20
> The test scripts are written by people from intel.
> Hi, Mariusz. Can I share the test scripts here?

Yes. Let us know if there is something else we can do to help here.

Thanks,
Mariusz
