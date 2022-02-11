Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F7CC433F5
	for <linux-raid@archiver.kernel.org>; Fri, 11 Feb 2022 08:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348212AbiBKIvx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 11 Feb 2022 03:51:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348204AbiBKIvw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 11 Feb 2022 03:51:52 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6CBE8B
        for <linux-raid@vger.kernel.org>; Fri, 11 Feb 2022 00:51:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644569511; x=1676105511;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WpbeT2w1ZU766Pl/K7FTZYYlhga6UjjQCcesQyZsqJw=;
  b=RlRifg/puht5+MOiOnPN4osq1DgT8PPdw4gcZrWgnFAQLoUF2BrjVHV9
   ChpW0piwu0VCkaGXeXwJJGdo+O24oPT43j5BDbLQPLMlHrqZq+0k8l4ix
   mfgnOSC17xszgya7xsAL02vtz9PstxMXk2XUqvRFpGdRxefe9TApcePgT
   O+323TtrmaoUGPC83iPG1akdv1dwk6gpqkqUkp33ttKSX5FIu+RDNxFvh
   hr1YJRA3C3wWX6OatsYOisPKD5LsEf71rlRpWb5vJeE8JpjmyF2BPi0N9
   uJx2SozCOkJbqmVp9srbB4ORDuLaYFnwkFop9kdvHan9Ogh0jardvjT9H
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10254"; a="249900027"
X-IronPort-AV: E=Sophos;i="5.88,360,1635231600"; 
   d="scan'208";a="249900027"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 00:51:51 -0800
X-IronPort-AV: E=Sophos;i="5.88,360,1635231600"; 
   d="scan'208";a="542003594"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.11.10])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 00:51:49 -0800
Date:   Fri, 11 Feb 2022 09:51:44 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     Song Liu <song@kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        linux-raid <linux-raid@vger.kernel.org>
Subject: Re: fail_last_dev and FailFast/LastDev flag incompatibility
Message-ID: <20220211095144.0000258c@linux.intel.com>
In-Reply-To: <CALTww2-UxsgNBdUJ0EHrmPUyvnO+Q04DsxnOdfExN5dFmjMsfw@mail.gmail.com>
References: <20220209104046.00004427@linux.intel.com>
        <CALTww2-OLe4y1kjBnz7CTBQiNerd-y9XrEc34rjO1sm5tEV5VA@mail.gmail.com>
        <CALTww2-+JcA24BAt5PkFyOG1Un_fU-Jxy2LpkCuRPk3ici1pbw@mail.gmail.com>
        <CALTww2-UxsgNBdUJ0EHrmPUyvnO+Q04DsxnOdfExN5dFmjMsfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 11 Feb 2022 15:53:42 +0800
Xiao Ni <xni@redhat.com> wrote:

> After thinking for a while, my words from my last email don't
> describe properly. For raid1/raid10, if fail_last_dev is true. The
> bios which are sent to member disks all have MD_FAILFAST. If there
> are no errors, failfast works well until the last device failure. It
> will not re-send the bio without MD_FAILFAST when fail_last_dev is
> true, because the last device has been set faulty. There is no
> meaning to send the bio again in this situation. So it should be
> right to only check faulty flag here.

Hi Xiao,
Thanks for clarification.

Mariusz

> 
> On Fri, Feb 11, 2022 at 3:24 PM Xiao Ni <xni@redhat.com> wrote:
> >
> > And for raid1/raid10, it looks like fail_last_dev and FailFast want
> > to do opposite things.
> > It can fail the last and it doesn't send a rewrite bio when
> > fail_last_dev is true. Because the
> > last dev has been set faulty. There is no meaning to send the
> > rewrite bio. So FailFast only
> > works when fail_last_dev is false.
> >
> > On Fri, Feb 11, 2022 at 2:48 PM Xiao Ni <xni@redhat.com> wrote:
> > >
> > > Hi Marisuz
> > >
> > > We don't need to consider MD_FAILFAST for raid456. Because only
> > > raid1 and raid10 support it.
> > > MD_FAILFAST_SUPPORTED is only set in raid1_run/raid10_run. So
> > > LastDev only be useful for
> > > raid1/raid10. It should be good to only check Faulty here.
> > >
> > > Best Regards
> > > Xiao
> > >
> > > On Wed, Feb 9, 2022 at 5:40 PM Mariusz Tkaczyk
> > > <mariusz.tkaczyk@linux.intel.com> wrote:
> > > >
> > > > Hi All,
> > > > During my work under failed arrays handling[1] improvements, I
> > > > discovered potential issue with "failfast" and metadata writes.
> > > > In commit message[2] Neil mentioned that:
> > > > "If we get a failure writing metadata but the device doesn't
> > > > fail, it must be the last device so we re-write without
> > > > FAILFAST".
> > > >
> > > > Obviously, this is not true for RAID456 (again)[1] but it is
> > > > also not true for RAID1 and RAID10 with "fail_las_dev"[3]
> > > > functionality enabled.
> > > >
> > > > I did a quick check and can see that setter for "LastDev" flag
> > > > is called if "Faulty" on device is not set. I proposed some
> > > > changes in the area in my patchset[4] but after discussion we
> > > > decided to drop changes here. Current approach is not correct
> > > > for all branches, so my proposal is to change:
> > > >
> > > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > > index 7b024912f1eb..3daec14ef6b2 100644
> > > > --- a/drivers/md/md.c
> > > > +++ b/drivers/md/md.c
> > > > @@ -931,7 +931,7 @@ static void super_written(struct bio *bio)
> > > >                 pr_err("md: %s gets error=%d\n", __func__,
> > > >                        blk_status_to_errno(bio->bi_status));
> > > >                 md_error(mddev, rdev);
> > > > -               if (!test_bit(Faulty, &rdev->flags)
> > > > +               if (test_bit(MD_BROKEN, mddev->flag)
> > > >                     && (bio->bi_opf & MD_FAILFAST)) {
> > > >                         set_bit(MD_SB_NEED_REWRITE,
> > > > &mddev->sb_flags); set_bit(LastDev, &rdev->flags);
> > > >
> > > >
> > > > It will force "LastDev" to be set on every metadata rewrite if
> > > > mddevice is known to be failed.
> > > > Do you have any other suggestions?
> > > >
> > > > + Guoqing - author of fail_last_dev.
> > > > + Xiao - you are familiarized with FailFast so please take a
> > > > look.
> > > >
> > > > [1]https://lore.kernel.org/linux-raid/CAPhsuW54_9CTR6sh7mnQ6O77F2HNArLHGWHYsUdbNGy7pXgipQ@mail.gmail.com/T/#m8cf7c57429b6fd332220157186151900ce23865d
> > > > [2]https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?id=46533ff7fefb7e9e3539494f5873b00091caa8eb
> > > > [3]https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?id=9a567843f7ce
> > > > [4]https://lore.kernel.org/linux-raid/CAPhsuW5bV+Bz=Od9jomNHoedaEMFAXymN11J80G62GVPwSp41g@mail.gmail.com/
> > > >
> > > > Thanks,
> > > > Mariusz
> > > >
> 

