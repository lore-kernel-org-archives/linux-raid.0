Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FFC5C636CD
	for <linux-raid@archiver.kernel.org>; Fri, 10 Feb 2023 10:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbjBJKR1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 10 Feb 2023 05:17:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbjBJKR0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 10 Feb 2023 05:17:26 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8A46CC63
        for <linux-raid@vger.kernel.org>; Fri, 10 Feb 2023 02:17:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676024244; x=1707560244;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SKqw+eF3tXj/FppGX0R+Bg2oQaPLdh5JrDjENKxZ2eo=;
  b=FsrPQiUFqXqoXPP3oB0gB78vzuVP/cyKtTUsdBk+I3/uecTsn9VdDEf8
   PrMbbv2vyNMEyNvBQY3Tii13Fozqg88Le2fFzafXfwiKhEVYn4YlQFBpL
   NBmZl4AEs3PSsZdeJ/Yy3LP74IyQRz3FcLyGOukK+Y6c6nxtMIo9pfvGb
   Gx1kCjlMeDATeBOD6i1GnDpmmDeK6yIbGF2w+Fj8XRCTHwK/81oFAa14C
   JTA7BqUiUvBBFER1EYjPguVDQSbA5svVY3/39+c3gB7Z9/vcwtzj6vB/V
   uJJLvQ6brG34CKx+wMtH5z6dABT69ivwXKe45pWMPEtMhZ1rp3lc4SajY
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="394990355"
X-IronPort-AV: E=Sophos;i="5.97,286,1669104000"; 
   d="scan'208";a="394990355"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 02:17:24 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="996913618"
X-IronPort-AV: E=Sophos;i="5.97,286,1669104000"; 
   d="scan'208";a="996913618"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.49.23])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 02:17:23 -0800
Date:   Fri, 10 Feb 2023 11:17:18 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     Kevin Friedberg <kev.friedberg@gmail.com>,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH] treat AHCI controllers under VMD as part of VMD
Message-ID: <20230210111718.00003c87@linux.intel.com>
In-Reply-To: <CALTww2_yqAMN-_XmS7ib-utkty903evi=ynyGtFksjXKCwGLJQ@mail.gmail.com>
References: <20230126021659.3801-1-kev.friedberg@gmail.com>
        <20230207094423.00001a30@linux.intel.com>
        <CALTww2_yqAMN-_XmS7ib-utkty903evi=ynyGtFksjXKCwGLJQ@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 9 Feb 2023 08:39:21 +0800
Xiao Ni <xni@redhat.com> wrote:

> On Tue, Feb 7, 2023 at 4:46 PM Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
> >
> > Hi Kevin,
> > I found time to take a look into it closer. I think that it is not complete
> > solution. Please see my comments.
> >
> > On Wed, 25 Jan 2023 21:16:59 -0500
> > Kevin Friedberg <kev.friedberg@gmail.com> wrote:
> >  
> > > Detect when a SATA controller has been mapped under Intel Alderlake RST
> > > VMD and list it as part of the domain, instead of independently, so that
> > > it can use the VMD controller's RAID capabilities.
> > >
> > > Signed-off-by: Kevin Friedberg <kev.friedberg@gmail.com>
> > > ---
> > >  platform-intel.c | 15 +++++++++------
> > >  super-intel.c    | 25 ++++++++++++++++++++++++-
> > >  2 files changed, 33 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/platform-intel.c b/platform-intel.c
> > > index 757f0b1b..859bf743 100644
> > > --- a/platform-intel.c
> > > +++ b/platform-intel.c
> > > @@ -64,10 +64,12 @@ struct sys_dev *find_driver_devices(const char *bus,
> > > const char *driver)
> > >       if (strcmp(driver, "isci") == 0)
> > >               type = SYS_DEV_SAS;
> > > -     else if (strcmp(driver, "ahci") == 0)
> > > +     else if (strcmp(driver, "ahci") == 0) {
> > > +             /* if looking for sata devs, ignore vmd */
> > > +             vmd = find_driver_devices("pci", "vmd");
> > >               type = SYS_DEV_SATA;
> > > -     else if (strcmp(driver, "nvme") == 0) {
> > > -             /* if looking for nvme devs, first look for vmd */
> > > +     } else if (strcmp(driver, "nvme") == 0) {
> > > +             /* if looking for nvme devs, also look for vmd */
> > >               vmd = find_driver_devices("pci", "vmd");
> > >               type = SYS_DEV_NVME;
> > >       } else if (strcmp(driver, "vmd") == 0)
> > > @@ -104,8 +106,8 @@ struct sys_dev *find_driver_devices(const char *bus,
> > > const char *driver) sprintf(path, "/sys/bus/%s/drivers/%s/%s",
> > >                       bus, driver, de->d_name);
> > >
> > > -             /* if searching for nvme - skip vmd connected one */
> > > -             if (type == SYS_DEV_NVME) {
> > > +             /* if searching for nvme or ahci - skip vmd connected one */
> > > +             if (type == SYS_DEV_NVME || type == SYS_DEV_SATA) {
> > >                       struct sys_dev *dev;
> > >                       char *rp = realpath(path, NULL);
> > >                       for (dev = vmd; dev; dev = dev->next) {
> > > @@ -166,7 +168,8 @@ struct sys_dev *find_driver_devices(const char *bus,
> > > const char *driver) }
> > >       closedir(driver_dir);
> > >
> > > -     if (vmd) {
> > > +     /* VMD adopts multiple types but should only be listed once */
> > > +     if (vmd && type == SYS_DEV_NVME) {
> > >               if (list)
> > >                       list->next = vmd;
> > >               else  
> >
> > The SATA behind VMD deserves own type, let say SYS_DEV_SATA_VMD. We cannot
> > use SYS_DEV_VMD because it will allow to use NVME devices behind VMD in
> > SATA Raid array. It means that if you have them connected, like:
> > VMD___ NVME0
> >     |_ NVME1
> >     |_ SATA___SATA0
> >            |__SATA1
> > You will be able to mix SATA and NVME drives together in RAID. Mdmonitor
> > could mix them too (if appropriate policy is set). That is not allowed from
> > at least VROC requirements PoV.  
> 
> 
> Hi Mariusz
> 
> Through the description of VMD
> (https://www.chipict.com/intel_vmd_vroc/), it looks like VMD only
> supports pcie nvme devices. Can it also connect sata devices?
> 
> And what's PoV?
> 
Hi Xiao,
Not directly, there must be SATA controller behind VMD.
In VROC on server platforms we don't use that. So far I know, the reason is to
have only one driver to handle all RST devices but it could be only part of
story.

Thanks,
Mariusz
