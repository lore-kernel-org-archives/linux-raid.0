Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71A0C6FD1D
	for <linux-raid@archiver.kernel.org>; Mon, 20 Mar 2023 16:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233338AbjCTQD0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Mar 2023 12:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233305AbjCTQDG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Mar 2023 12:03:06 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22FB658C
        for <linux-raid@vger.kernel.org>; Mon, 20 Mar 2023 08:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679327541; x=1710863541;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=chyLW3Lo7zkYu/6OtpaFPQkIA2axrlU0IgRfvpmMdpI=;
  b=Uc5G343isgPuqTAXu+HcI96FV8VCgniytOMwhWZ2X6WRKX1xFFJ9zXdR
   SuJ3Q2SCpySQG/vPWF6G8AkYmcr0brGReHGz/1FIqJwXvfFceO2/FGz9v
   g9rDvG62RWzqPL0sRFKZH+S9cbKRzI+ISQgr3NM09gOFWp30siPj39E/P
   YTUmZ7EAKli+I4hpxncgEfvTSAsbYZ23O+QkK+d8mr85fVp46C9xBsDQJ
   Gjo3FpitdO30zBe4jx4WzfWRDISfuji9CJ9VQmeeOxnEl2Fm/ZH/+h5Rh
   nmOOpwIx8oAk51OiKgrZo74+PpL0i4SyRbEcgqiXaTtUxFgNLTpVL6yNM
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="341060513"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="341060513"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 08:51:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="658388219"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="658388219"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.82])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 08:51:21 -0700
Date:   Mon, 20 Mar 2023 16:51:17 +0100
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
Message-ID: <20230320165117.000011d5@linux.intel.com>
In-Reply-To: <b3b124db659115dd2523dab828ad463d88afbe54.camel@suse.com>
References: <252cdcda-afcd-ce76-00cf-c138136e70ab@huawei.com>
        <c00c211a3126d7a30c662117d28f3a4a9c81f7dc.camel@suse.com>
        <20230314165938.00003030@linux.intel.com>
        <04a4cc6aac10cd24d5bc0b3485d47f6ccb752eab.camel@suse.com>
        <20230315111027.0000372d@linux.intel.com>
        <cbea1358-768d-d5f7-5733-06687ad3243a@huawei.com>
        <c3d451cc0c96d1a8c8d129448c1d7c3e340e8fac.camel@suse.com>
        <5fe3dfca-10ad-989a-717d-3007b04163ed@huawei.com>
        <e5e2cf8fc9903aab6a781c5b925d12023a59b387.camel@suse.com>
        <20230316114314.00003004@linux.intel.com>
        <b3b124db659115dd2523dab828ad463d88afbe54.camel@suse.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 20 Mar 2023 16:36:44 +0100
Martin Wilck <mwilck@suse.com> wrote:

> On Thu, 2023-03-16 at 11:44 +0100, Mariusz Tkaczyk wrote:
> > On Wed, 15 Mar 2023 16:01:26 +0100
> > Martin Wilck <mwilck@suse.com> wrote: =20
> > >=20
> > > Normally this is what you want to happen if a change uevent for a
> > > MD
> > > member device is processed.
> > >=20
> > > The case you're looking at is the exception, as another instance of
> > > mdamn is handling the device right at this point in time.
> > >=20
> > > Martin
> > >  =20
> > Hi,
> > Code snipped from Incremental, devname seems to be our disk:
> >=20
> > =A0=A0=A0=A0=A0=A0=A0=A0/* 4/ Check if array exists.
> > =A0=A0=A0=A0=A0=A0=A0=A0 */
> > =A0=A0=A0=A0=A0=A0=A0=A0if (map_lock(&map))
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pr_err("failed to get e=
xclusive lock on mapfile\n");
> > =A0=A0=A0=A0=A0=A0=A0=A0/* Now check we can get O_EXCL.=A0 If not, prob=
ably "mdadm -A"
> > has
> > =A0=A0=A0=A0=A0=A0=A0=A0 * taken over
> > =A0=A0=A0=A0=A0=A0=A0=A0 */
> > =A0=A0=A0=A0=A0=A0=A0=A0dfd =3D dev_open(devname, O_RDONLY|O_EXCL);
> >=20
> > The map_lock in --add should resolve your issue. It seems to be
> > simplest
> > option. I we cannot lock udev effectively then it seems to be the
> > best one.
> > We need to control adding the device because external metadata is
> > quite
> > different and for example in IMSM the initial metadata doesn't point
> > to
> > container wanted by user. Hope it clarifies all objections here.
> >=20
> > I don't see any blocker from using locking mechanism for --add. =20
>=20
>=20
> AFAICS it would only help if the code snipped above did not only
> pr_err() but exit if it can't get an exclusive lock.
>=20
> Martin
>=20

Indeed. I missed that... Thanks for catching. My idea is no longer valid.

Mariusz
