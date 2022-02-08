Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF182C433EF
	for <linux-raid@archiver.kernel.org>; Tue,  8 Feb 2022 11:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbiBHLZe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Feb 2022 06:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355736AbiBHJwy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 8 Feb 2022 04:52:54 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00F9C03FEC0
        for <linux-raid@vger.kernel.org>; Tue,  8 Feb 2022 01:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644313973; x=1675849973;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TfZObBbB7UeF8THv0jeZJSHLdq4juEpcK5k8gIwM14Y=;
  b=EbsV3sUQyNgK89tDN7XVDJoH2Xr4nLYz8A0cUYiaYkB1wLbThHZrceda
   7rfM3kx5fbN0JsGbCJx3D9FI94s02MkXg25SNS7WG8Vc9KPhbTsK8TtsD
   sLkbTZ4tr8sDD2pAe3V8pJ7lAb/UUcUoQ9ZsmWqLl4vXUZf5mjys0S4kF
   0lAWiL3lfyvg+GkGmhFogACcWKQetp9J0qhplVZ4O9p+M9Io3nqd2dTjf
   Yy0y4jN7K1NH31zaOMb2e73trCgbzi2mFuXGLC+fY5dlvkTXJVVRq15Qg
   rcwMHEWCLIWS0QS/jnBNJQAHCjJisI+0oWD/EXounkKDHQ4YHqctHTngp
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10251"; a="248863432"
X-IronPort-AV: E=Sophos;i="5.88,352,1635231600"; 
   d="scan'208";a="248863432"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 01:52:52 -0800
X-IronPort-AV: E=Sophos;i="5.88,352,1635231600"; 
   d="scan'208";a="525489496"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.30.243])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 01:52:51 -0800
Date:   Tue, 8 Feb 2022 10:52:46 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Lukasz Florczak <lukasz.florczak@intel.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH] Replace error prone signal() with sigaction()
Message-ID: <20220208105246.0000602a@linux.intel.com>
In-Reply-To: <17c41b6e-ed53-aeed-87e0-a6cbf96f44a2@molgen.mpg.de>
References: <20220208152915.12858-1-lukasz.florczak@intel.com>
        <17c41b6e-ed53-aeed-87e0-a6cbf96f44a2@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 8 Feb 2022 09:52:03 +0100
Paul Menzel <pmenzel@molgen.mpg.de> wrote:

> Dear Lukasz,
>=20
>=20
> Am 08.02.22 um 16:29 schrieb Lukasz Florczak:
> > Up to this date signal() was used which is deprecated [1].
> > Sigaction() call is preferred. This commit introduces replacement
> > from signal() to sigaction() by the use of signal_s() wrapper.
> > Also remove redundant signal.h header includes.
>=20
> signal(2) also says:
>=20
> >        * By  default, in glibc 2 and later, the signal() wrapper
> > function does not invoke the kernel system call.  Instead,  it
> > calls  sigaction(2) using flags that supply BSD semantics.  This
> > default behavior is pro=E2=80=90 vided  as  long  as  a  suitable  feat=
ure
> > test  macro  is   defined: _BSD_SOURCE  on  glibc  2.19  and
> > earlier or _DEFAULT_SOURCE in glibc 2.19 and later.  (By default,
> > these  macros  are  defined;  see  fea=E2=80=90 ture_test_macros(7)  for
> > details.)   If such a feature test macro is not defined, then
> > signal() provides System V semantics.
>=20
> Does that mean, it should still be replaced?
Hi Paul,

Both ways are correct. signal() is not deprecated but the behavior may
vary. It can be avoided by sigaction(), so it is better to use
sigaction() then. Do you agree?

Thanks,
Mariusz
