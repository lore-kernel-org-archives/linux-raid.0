Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 273ACC77B73
	for <linux-raid@archiver.kernel.org>; Thu, 20 Apr 2023 10:52:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbjDTKv5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Apr 2023 06:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234472AbjDTKvc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 20 Apr 2023 06:51:32 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AFEA277
        for <linux-raid@vger.kernel.org>; Thu, 20 Apr 2023 03:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681987753; x=1713523753;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WJUgFvSYSwraYKmlIdgPx4VC/n5vz7G6xZdOZvoHMao=;
  b=HAGKPFFwm+ifTSJmLaJVZTz63F25MwQgQpQM+sjgmEh3rqF5BHZfy45O
   eiRBrcpwxLIcId9o012sEUdd6s2JMzO7qifSXAVh5dKpw7y0sATkUHn9o
   7BiSXpKfMfG8ePMpM0pCgoiibs9C0jEVkRJjb1ux/qCgegQN+i2Y3W4Dt
   h2M+1I9lyyZCewe2+sgO5KGE83+a0pfwJ4a572/N9n7Qzcz9UuIH9q2jx
   KIqVY8AMfc0GPwKmU2T1OHQeC1zmMqSKz/A0Hj8aWA7B9eSybOzGzaM/A
   /qJUXiCr0ywMrDZfDtRjMUymT6wAP8sWNBHdE6UF2+GovU1OYut/6/3cX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="373595529"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="373595529"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 03:46:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="803299163"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="803299163"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.135.14])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 03:46:52 -0700
Date:   Thu, 20 Apr 2023 12:46:47 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org,
        colyli@suse.de
Subject: Re: [PATCH 0/4] Few config related refactors
Message-ID: <20230420124647.00004cd7@linux.intel.com>
In-Reply-To: <CALTww2-bbwpo1O=ez8+CpMV+tvKFQ3onR65EU7mrnqs+6HP-cQ@mail.gmail.com>
References: <20230323165017.27121-1-mariusz.tkaczyk@linux.intel.com>
        <CALTww2-bbwpo1O=ez8+CpMV+tvKFQ3onR65EU7mrnqs+6HP-cQ@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 24 Mar 2023 10:13:04 +0800
Xiao Ni <xni@redhat.com> wrote:

> On Fri, Mar 24, 2023 at 12:50=E2=80=AFAM Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
> >
> > Hi Jes,
> > These patches remove multiple inlines across code and replace them
> > by defines or functions. No functional changes intended. The goal
> > is to make this some code reusable for both config and cmdline
> > (mdadm.c). I next patchset I will start optimizing names verification
> > (extended v2 of previous patchset).
> >
> > Mariusz Tkaczyk (4):
> >   mdadm: define DEV_MD_DIR
> >   mdadm: define DEV_NUM_PREF
> >   mdadm: define is_devname_ignore()
> >   mdadm: numbered names verification
> >
> >  Create.c      |  7 +++----
> >  Detail.c      |  9 ++++-----
> >  Incremental.c | 10 ++++------
> >  Monitor.c     | 34 +++++++++++++++++++---------------
> >  config.c      | 43 +++++++++++++++++++++----------------------
> >  lib.c         |  4 ++--
> >  mapfile.c     | 12 ++++++------
> >  mdadm.c       |  5 ++---
> >  mdadm.h       | 21 ++++++++++++++++++++-
> >  mdopen.c      | 16 ++++++++--------
> >  super-ddf.c   |  2 +-
> >  super-intel.c |  2 +-
> >  super1.c      |  3 +--
> >  sysfs.c       |  2 +-
> >  util.c        | 44 ++++++++++++++++++++++++++++++++++++++++++++
> >  15 files changed, 137 insertions(+), 77 deletions(-)
> >
> > --
> > 2.26.2
> > =20
>=20
> Acked-by: Xiao Ni <xni@redhat.com>
>=20

Hi Jes,
Could you please take those patches?
We are working on changes in other areas and the error enum will be useful.

Thanks,
Mariusz
