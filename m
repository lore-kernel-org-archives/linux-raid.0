Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DEC0C32793
	for <linux-raid@archiver.kernel.org>; Wed, 24 Aug 2022 09:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236588AbiHXJy0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Aug 2022 05:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234326AbiHXJyJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 Aug 2022 05:54:09 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084BB6C753
        for <linux-raid@vger.kernel.org>; Wed, 24 Aug 2022 02:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661334775; x=1692870775;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6ZO59X/JNjYC94enLjNEXbDBrhd9pWmQ2d+pdrWBWPo=;
  b=Aqqex52uAuXyGtVLOB2RY0N0Jyh8HSyBUwOcGWL/ieZBHdBwsLXrK98S
   GT7rhAHnG/t4ci10UIeJsYTrX54+f9a/Ve1Y4165b9tJs55oEaxY/Smjr
   p9ta2dyVNFkFo0iHNxIz/vO1c6NN2fTUNT6sIHLgUMTT0NGR8hqOFtbew
   BQ9SXjJ3FEBOKkKFn3NHPPpcWsoSvJZow82KgKbc5XKlUK9MvK9gPWYNZ
   NB0yYZSUbXQovaceTSgNTUY15ph4eNB8n8EgeVlleEZ4hvXwFQxQpaaof
   M2ROvMvh4ZpkAX/ozsZwPpVedHhPdqU9mHT5ep6OpkptpqE3OS4myJRG9
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="319982261"
X-IronPort-AV: E=Sophos;i="5.93,260,1654585200"; 
   d="scan'208";a="319982261"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 02:52:46 -0700
X-IronPort-AV: E=Sophos;i="5.93,260,1654585200"; 
   d="scan'208";a="670433356"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.39.240])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 02:52:44 -0700
Date:   Wed, 24 Aug 2022 11:52:39 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc:     NeilBrown <neilb@suse.de>, Coly Li <colyli@suse.de>,
        linux-raid@vger.kernel.org, Benjamin Brunner <bbrunner@suse.com>,
        Franck Bui <fbui@suse.de>,
        Jes Sorensen <jes@trained-monkey.org>, Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH] mdadm/systemd: remove KillMode=none from service file
Message-ID: <20220824115239.00004ac4@linux.intel.com>
In-Reply-To: <Yv62jwZwp7kNPSUF@blackbook>
References: <20220215133415.4138-1-colyli@suse.de>
        <20220728095535.00007b7b@linux.intel.com>
        <165905971898.4359.3905352912598347760@noble.neil.brown.name>
        <20220802174305.00000336@linux.intel.com>
        <Yv62jwZwp7kNPSUF@blackbook>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Michal,
Thank you for support.

On Fri, 19 Aug 2022 00:00:47 +0200
Michal Koutn=FD <mkoutny@suse.com> wrote:

> Hello.
>=20
> (Coming via
> https://lists.freedesktop.org/archives/systemd-devel/2022-August/048201.h=
tml.)
>=20
> On Tue, Aug 02, 2022 at 05:43:05PM +0200, Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
> > https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/udev-md-raid-=
arrays.rules#n41
> > but i can't find wants dependency in:
> > #systemctl show dev-md126.service
> > #systemctl show dev-md127.service =20
>=20
> Typo here
>=20
> s/service/device/
>=20
> But the Wants dependency won't help with shutdown ordering.
>=20
> > I got:
> > systemd[1]: /usr/lib/systemd/system/mdmon@.service:11: Failed to resolve
> > unit specifiers in 'dev-%I.device', ignoring: Invalid slot =20
>=20
> What was your exact directive in service unit file and what was the
> template parameter?
> (This may not work though, since there'd be no stop job for .device unit
> during shutdown to order against. (not tested))

I removed those setting but it was something like:

Before=3Dinitrd-switch-root.target dev-%I.device

I can test more if you have suggestions.

>=20
> > Probably it tries to umount every exiting .mount unit, i didn't check
> > deeply. https://www.freedesktop.org/software/systemd/man/systemd.mount.=
html
> >=20
> > I can see that we can define something for .mount units so I tried both:
> > # mount -o x-systemd.after=3Dmdmon@md127.service /dev/mapper/vg0-lvm_ra=
id /mnt
> > # mount -o x-systemd.requires=3Dmdmon@md127.service /dev/mapper/vg0-lvm=
_raid
> > /mnt
> >=20
> > but I doesn't help either. I seems that it is ignored because I cannot =
find
> > mdmon dependency in systemctl show output for mnt.mount unit. =20
>=20
> These x-* options are parsed from fstab. If you mount manually like
> this, systemd won't learn about these non-kernel options (they don't get
> through /proc/mountinfo).
>=20
> Actually, I think if you add the .mount:After=3Dmdmon@....service
> (via fstab), it should properly order the stop of mdmon after the
> particular unmount during shutdown.=20
>=20
Will check but it can be considered as workaround, not as a solution. VROC
arrays are automatically configured in installers, also users may mount them
manually, without any additional settings (as standalone disk). We need to
resolve it globally.

Thanks,
Mariusz
