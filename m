Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 998DFC77B7C
	for <linux-raid@archiver.kernel.org>; Fri,  5 May 2023 07:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbjEEHoS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 5 May 2023 03:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbjEEHoR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 5 May 2023 03:44:17 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FA715691
        for <linux-raid@vger.kernel.org>; Fri,  5 May 2023 00:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683272656; x=1714808656;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gzg17aqAOr5ijxGv3g5j/9IcUGftsXaoL00u9luM//U=;
  b=PbzFB5y6swxgbnYxStEeJ7l0UnjhsG7Bjm0UfuawinA1YiVhOhYj9eIz
   r9pR5J9JxuOSfAULTH60fgiC9m62vBsJyFNwz5XGtabVXUILBdSSteetf
   6r9iOLQT7H3wqrv8EUfTm3bzeghAorPuImr4RNJYHfm9Mp7ZGHpUbqbU3
   JOOiDERqIWbndkdFGmC7i64sOis54UwdWU35bCgaeOVcJ27cgGtRbPJKz
   S+2gKAtNn/UnQlYg75YXE9J3aJE4242H8gjFLEv3lQT24kImZt3+tOGpI
   7WITCjXoGK4O5eqTa2zz6T0fjp0vsI8bDQB6+08YpmgLBdf151IJR16Cj
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10700"; a="329513837"
X-IronPort-AV: E=Sophos;i="5.99,251,1677571200"; 
   d="scan'208";a="329513837"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2023 00:44:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10700"; a="700288128"
X-IronPort-AV: E=Sophos;i="5.99,251,1677571200"; 
   d="scan'208";a="700288128"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.139.56])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2023 00:44:15 -0700
Date:   Fri, 5 May 2023 09:44:10 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Kevin Friedberg <kev.friedberg@gmail.com>
Cc:     Kinga Tanska <kinga.tanska@linux.intel.com>,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH] enable RAID for SATA under VMD
Message-ID: <20230505094410.00001aa3@linux.intel.com>
In-Reply-To: <CAEJbB41BxMdU1bYWAhHh8KLL2_P_M5DCJaDBt3f_YdphmpN4yQ@mail.gmail.com>
References: <20230216044134.30581-1-kev.friedberg@gmail.com>
        <CAEJbB426WWdu5KESE1T+T0JHSKx3CGjUcpdZ5yhppsxyXNJDvw@mail.gmail.com>
        <20230320093545.000016cc@linux.intel.com>
        <20230428093056.00006ca2@intel.linux.com>
        <CAEJbB41BxMdU1bYWAhHh8KLL2_P_M5DCJaDBt3f_YdphmpN4yQ@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 5 May 2023 03:31:11 -0400
Kevin Friedberg <kev.friedberg@gmail.com> wrote:

> On Fri, Apr 28, 2023 at 3:31=E2=80=AFAM Kinga Tanska
> <kinga.tanska@linux.intel.com> wrote:
>=20
> > Hi,
> >
> > We've been able to test this change and we haven't found problems.
> >
> > Regards,
> > Kinga =20
>=20
> Great!  What are the next steps to get it included in a future release?
See patchwork:
https://patchwork.kernel.org/project/linux-raid/patch/20230216044134.30581-=
1-kev.friedberg@gmail.com/

I moved the patch to "awaiting upstream". Now it is up to Jes.
You will get mail, like here:
https://lore.kernel.org/linux-raid/5f493463-6e69-419f-affc-b0de8424fa1a@tra=
ined-monkey.org/

Thanks,
Mariusz
