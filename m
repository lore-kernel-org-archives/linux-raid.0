Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 470CBC00140
	for <linux-raid@archiver.kernel.org>; Wed, 24 Aug 2022 12:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237726AbiHXM6G (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Aug 2022 08:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbiHXM6E (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 Aug 2022 08:58:04 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1AD979C1
        for <linux-raid@vger.kernel.org>; Wed, 24 Aug 2022 05:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661345883; x=1692881883;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/tB/zROSvYKPWYF2MjP1cN5UlYNxHKwqglxmhQHdJjw=;
  b=evyvwesUx7qM4QmZRF/08HlCH8oOgnf6czQAKtYfn+0gqNz0WpIcBAK0
   AEyALFGm66hf/BN9dgWZHeXbuSDpfoQcFb1GCUOGxocsAWoJhGcevdl30
   TiLRsYuM540HebzdOYYpXMCBnnkV290BNQQsUioaC4dQjURxXbhQmXYf1
   BgawfZNZod/pUTBgrTW9gknuMKYLwwJxZduMz8LokOxJXdnkCKZR+iRDO
   KFoTtIGhrd/RY7r3I0hGpFdF/n+SFHIwEbXLorvUGdsVi88Uis+BhLE+B
   KMP849FJtEQHpJZOE/RiuQ2PZKm6aUv0v7BqdAAhhpmejfrfcSpQJCvYl
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="292700352"
X-IronPort-AV: E=Sophos;i="5.93,260,1654585200"; 
   d="scan'208";a="292700352"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 05:58:03 -0700
X-IronPort-AV: E=Sophos;i="5.93,260,1654585200"; 
   d="scan'208";a="937895606"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.39.240])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 05:58:01 -0700
Date:   Wed, 24 Aug 2022 14:57:56 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc:     NeilBrown <neilb@suse.de>, Coly Li <colyli@suse.de>,
        linux-raid@vger.kernel.org, Benjamin Brunner <bbrunner@suse.com>,
        Franck Bui <fbui@suse.de>,
        Jes Sorensen <jes@trained-monkey.org>, Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH] mdadm/systemd: remove KillMode=none from service file
Message-ID: <20220824145756.000048f8@linux.intel.com>
In-Reply-To: <20220824120325.GA19154@blackbody.suse.cz>
References: <20220215133415.4138-1-colyli@suse.de>
        <20220728095535.00007b7b@linux.intel.com>
        <165905971898.4359.3905352912598347760@noble.neil.brown.name>
        <20220802174305.00000336@linux.intel.com>
        <Yv62jwZwp7kNPSUF@blackbook>
        <20220824115239.00004ac4@linux.intel.com>
        <20220824120325.GA19154@blackbody.suse.cz>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 24 Aug 2022 14:03:25 +0200
Michal Koutn=FD <mkoutny@suse.com> wrote:

> On Wed, Aug 24, 2022 at 11:52:39AM +0200, Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
> > I removed those setting but it was something like:
> >=20
> > Before=3Dinitrd-switch-root.target dev-%I.device
> >=20
> > I can test more if you have suggestions. =20
>=20
> Sorry, I realize it won't work, device deps are restricted [1]. (I
> considered relaxing that [2] in order to terminate loop devs properly.)
>=20
> > Will check but it can be considered as workaround, not as a solution. V=
ROC
> > arrays are automatically configured in installers, also users may mount=
 them
> > manually, without any additional settings (as standalone disk). We need=
 to
> > resolve it globally. =20
>=20
> It's not the only setup when a device requires a userspace daemon.
> There is a generic solution for root devices [3] (when the daemon is
> marked to run indefinitely).

Yes, I know that trick and we are setting '@' to prevent systemd from killi=
ng
it[1] but we do mdmon@ service restart after switch root. This is the simpl=
est
way to reopen descriptors. We can try to change that.

It will be great if you can really prove that the mechanism is working. Do =
you
know any project which really uses this functionality?

>
> The device job ordering dependencies during shutdown would need better
> handling in systemd. (But I don't understand how much
> mdmon@.serice is necessary for device existence and teardown.)
>=20

We need to handle dirty clean transaction. On shutdown, when umount is
requested them filesystem could flush in flight data, and them kernel is
waiting for mdmon to acknowledge the change in metadata[2].

Thanks,
Mariusz

[1] https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/mdmon.c#n342
[2] https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/mdmon-design.=
txt
