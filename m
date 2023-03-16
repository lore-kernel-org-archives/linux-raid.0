Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B85BC6FD1F
	for <linux-raid@archiver.kernel.org>; Thu, 16 Mar 2023 10:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbjCPKon (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 16 Mar 2023 06:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjCPKom (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 16 Mar 2023 06:44:42 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BADB6189C
        for <linux-raid@vger.kernel.org>; Thu, 16 Mar 2023 03:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678963481; x=1710499481;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rhh6+VGHnJtxwC2vtynZKLLqia9SHRP6Ck9aXpmA9jY=;
  b=YFIrSa1KhhcallyuFYq+5Y9bT3+33M2jlUrIWWmle8f9lIV0vcZ+srqS
   HtMytOt+qOd0H5LqoMOqylVISITPVGtWh01CuYBIhyIMfQ8ry073Lbffz
   1b915MGgprmmO4NYNOIWkivXtlu8FVZO+VLnA8W3xJi3+MEBzyHe9ri7M
   JMK35rwvssczUelm0VHYrVIRmYq1c+FPckB7oW93c4uyXay4xBgFS4bdv
   SFlVD7fiGJocq6+o1MHIYC9F10h9v8HEw5piMeV1e2eeMJe0BJLkWCkMg
   mDeJ8riQZiHDEGOy7ghppa13dG1Pnq0Q819lKbXL1V0j2lCuvOq/xq8hS
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="339479027"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="339479027"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 03:44:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="710056694"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="710056694"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.63.81])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 03:44:37 -0700
Date:   Thu, 16 Mar 2023 11:44:32 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Martin Wilck <mwilck@suse.com>
Cc:     Li Xiao Keng <lixiaokeng@huawei.com>, Song Liu <song@kernel.org>,
        Jes Sorensen <jes@trained-monkey.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>, Coly Li <colyli@suse.de>,
        linux-raid@vger.kernel.org, linfeilong <linfeilong@huawei.com>,
        louhongxiang@huawei.com,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        miaoguanqin <miaoguanqin@huawei.com>
Subject: Re: [QUESTION] How to fix the race of "mdadm --add" and "mdadm
 mdadm --incremental --export"
Message-ID: <20230316114314.00003004@linux.intel.com>
In-Reply-To: <e5e2cf8fc9903aab6a781c5b925d12023a59b387.camel@suse.com>
References: <252cdcda-afcd-ce76-00cf-c138136e70ab@huawei.com>
        <c00c211a3126d7a30c662117d28f3a4a9c81f7dc.camel@suse.com>
        <20230314165938.00003030@linux.intel.com>
        <04a4cc6aac10cd24d5bc0b3485d47f6ccb752eab.camel@suse.com>
        <20230315111027.0000372d@linux.intel.com>
        <cbea1358-768d-d5f7-5733-06687ad3243a@huawei.com>
        <c3d451cc0c96d1a8c8d129448c1d7c3e340e8fac.camel@suse.com>
        <5fe3dfca-10ad-989a-717d-3007b04163ed@huawei.com>
        <e5e2cf8fc9903aab6a781c5b925d12023a59b387.camel@suse.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 15 Mar 2023 16:01:26 +0100
Martin Wilck <mwilck@suse.com> wrote:

> On Wed, 2023-03-15 at 22:57 +0800, Li Xiao Keng wrote:
> >=20
> >=20
> > On 2023/3/15 22:14, Martin Wilck wrote: =20
> > > On Wed, 2023-03-15 at 21:10 +0800, Li Xiao Keng wrote: =20
> > > > >  =20
> > > > =A0 I test move close() after ioctl(). The reason of EBUSY is that
> > > > mdadm
> > > > open(sdf) with O_EXCL. So fd should be closed before ioctl. When
> > > > I
> > > > remove
> > > > O_EXCL, ioctl() will return success. =20
> > >=20
> > > This makes sense. I suppose mdadm must use O_EXCL if it modifies
> > > RAID
> > > meta data, otherwise data corruption is just too likely. It is also
> > > impossible to drop the O_EXCL flag with fcntl() without closing the
> > > fd.
> > >=20
> > > So, if mdadm must close the fd before calling ioctl(), the race can
> > > hardly be avoided. The close() will cause a uevent, and nothing
> > > prevents the udev rules from running before the ioctl() returns.
> > >  =20
> > =A0 Now I find that close() cause a change udev. Is it necessary to
> > import
> > "mdadm --incremental --export" when change udev cause? Can we ignore
> > it? =20
>=20
> Normally this is what you want to happen if a change uevent for a MD
> member device is processed.
>=20
> The case you're looking at is the exception, as another instance of
> mdamn is handling the device right at this point in time.
>=20
> Martin
>=20
Hi,
Code snipped from Incremental, devname seems to be our disk:

	/* 4/ Check if array exists.
	 */
	if (map_lock(&map))
		pr_err("failed to get exclusive lock on mapfile\n");
	/* Now check we can get O_EXCL.  If not, probably "mdadm -A" has
	 * taken over
	 */
	dfd =3D dev_open(devname, O_RDONLY|O_EXCL);

The map_lock in --add should resolve your issue. It seems to be simplest
option. I we cannot lock udev effectively then it seems to be the best one.
We need to control adding the device because external metadata is quite
different and for example in IMSM the initial metadata doesn't point to
container wanted by user. Hope it clarifies all objections here.

I don't see any blocker from using locking mechanism for --add.

Thanks,
Mariusz
