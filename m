Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C937C7EE2C
	for <linux-raid@archiver.kernel.org>; Fri, 25 Aug 2023 09:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239431AbjHYJ6A (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 25 Aug 2023 05:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243181AbjHYJ54 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 25 Aug 2023 05:57:56 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5FD61B9
        for <linux-raid@vger.kernel.org>; Fri, 25 Aug 2023 02:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692957474; x=1724493474;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QVrx0Uot/fgf/XyfOHnglzq+PknnYH6/vrFeaKoj09U=;
  b=Z5nCl9cG/WQRc0JVwBFJ8fP9kLgIMiMHcotR6xx+LuPzVSMqSNM62hoW
   9tDXt0fstuIcMZcJ9Q/cXfl6vbnldDQBSnWEP2FE0zwR/y8r4qx4rb7Qh
   QpkYQ0Wh6KZgPHydU1p2FG/XLklYr48jHV+FykK/NMXc+b5VyAhZgkLdi
   LkJD/ZhbyJaKOIWK3U0IL46Ba+PB0vjZiwNX7cJkldTazuOb4S4q7sAB1
   ps4Bt47uG9JhqgSytOL5sZCxMEz6AsDeMmXl9qH3eGdSeOM/jn3qZ7hEw
   uADb8Aa5cyalRSnKcJxCKD86KoRwFl43SrnfIX8+bwgRZ6KFwkDnAUVa9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="461040502"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="461040502"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 02:57:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="730998477"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="730998477"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.128.196])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 02:57:50 -0700
Date:   Fri, 25 Aug 2023 11:57:47 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org
Subject: Re: [PATCH 1/1] Stop mdcheck_continue timer when mdcheck_start
 service can finish check
Message-ID: <20230825115747.00000c14@linux.intel.com>
In-Reply-To: <CALTww2-sb5VnN2cN1=wRiEnrdXavgK9v8TQ7DO52KJaG2mfPHg@mail.gmail.com>
References: <20230508133010.42313-1-xni@redhat.com>
        <20230823160905.00004d3c@linux.intel.com>
        <CALTww2-sb5VnN2cN1=wRiEnrdXavgK9v8TQ7DO52KJaG2mfPHg@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 25 Aug 2023 17:00:19 +0800
Xiao Ni <xni@redhat.com> wrote:

> On Wed, Aug 23, 2023 at 10:09=E2=80=AFPM Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
> >
> > Hi Xiao,
> > some nits:
> >
> > On Mon,  8 May 2023 21:30:10 +0800
> > Xiao Ni <xni@redhat.com> wrote:
> > =20
> > > mdcheck_continue is triggered by mdcheck_start timer. It's used to
> > > continue check action if the raid is too big and mdcheck_start
> > > service can't finish check action. If mdcheck start can finish check
> > > action, it doesn't need to mdcheck continue service anymore. So stop
> > > it when mdcheck start service can finish check action.
> > >
> > > Signed-off-by: Xiao Ni <xni@redhat.com>
> > > ---
> > >  misc/mdcheck | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/misc/mdcheck b/misc/mdcheck
> > > index 700c3e252e72..f56972c8ed10 100644
> > > --- a/misc/mdcheck
> > > +++ b/misc/mdcheck
> > > @@ -140,7 +140,13 @@ do
> > >               echo $a > $fl
> > >               any=3Dyes
> > >       done
> > > -     if [ -z "$any" ]; then exit 0; fi
> > > +     if [ -z "$any" ]; then
> > > +             #mdcheck_continue.timer is started by mdcheck_start.tim=
er.
> > > +             #When he check action can be finished in =20
> > 's/he/the/g'
> > I think that there should be space after '#' but it is preferred to use=
 /*
> > */ Could you please send v2? =20
>=20
> Hi Mariusz
>=20
> diff --git a/misc/mdcheck b/misc/mdcheck
> index 700c3e252e72..f87999d3e797 100644
> --- a/misc/mdcheck
> +++ b/misc/mdcheck
> @@ -140,7 +140,13 @@ do
>                 echo $a > $fl
>                 any=3Dyes
>         done
> -       if [ -z "$any" ]; then exit 0; fi
> +       # mdcheck_continue.timer is started by mdcheck_start.timer.
> +       # When the check action can be finished in mdcheck_start.service,
> +       # it doesn't need mdcheck_continue anymore.
> +       if [ -z "$any" ]; then
> +               systemctl stop mdcheck_continue.timer
> +               exit 0;
> +       fi
>         sleep 120
>  done
>=20
> How about this one?
>=20
> Regards
> Xiao
> >
> > Thanks,
> > Mariusz
> > =20
>=20
LGTM
Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Mariusz
