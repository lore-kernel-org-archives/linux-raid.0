Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3C76C636CC
	for <linux-raid@archiver.kernel.org>; Mon, 13 Feb 2023 07:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjBMHCP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Feb 2023 02:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBMHCO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Feb 2023 02:02:14 -0500
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2218910CB
        for <linux-raid@vger.kernel.org>; Sun, 12 Feb 2023 23:02:13 -0800 (PST)
Received: by mail-vs1-xe2c.google.com with SMTP id g8so12086359vso.3
        for <linux-raid@vger.kernel.org>; Sun, 12 Feb 2023 23:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZjI0f+p0led4/cogJVYDVw8kN8f37o19mbMEJ6DwhSQ=;
        b=VKr0Zjz+jrpPcraiXeWzoIRF8G6LB2dzhpszKrgjC2OfcybhMrniht0UceMBMAe61s
         +hGS3ItdGLuZ2GJieSTRukBs8aFl6XgY2CJ32a0l656y5yxre1cWzAQ/b0nbaOOWNIZ8
         KjYwoHIZVLR/4EoqR1W/OMD0XYW5EkcZQ3VprzrlRzxww1dtwtJOnGPsU8k+ZIPuGEf0
         rzmeHINAnCd2mLc60tZe4UGzGhGdnbF1k8Cagjza3hhW/55YdeezbCKeSTkHLvfTTcHu
         656MgFUQylsvIIj4VzPDNKr9V2+Xovak4EoVwoh/O55z54HpIF0Q2xiVk/52fgxiMxUS
         j6BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZjI0f+p0led4/cogJVYDVw8kN8f37o19mbMEJ6DwhSQ=;
        b=ahEPkZwo2zoxabXl3GVU3oOPJQyUA2SKzMRSzzhnGswAOS9RksdEhCKQEAgVum1s9r
         UHABPkxXiGklshElEU/EtCB2jKFY2z/r2yIxmNHBCOqtRi4UzlTWTp+clj9GhlBTmZlK
         lJ0LNjLoWNS4LV/RddXm9DReIdZloKRcUR+B4rY67/BXiBAzCsrg6rD9F8UtXaHsICBJ
         UmJCFo5996S/SVTfdpQek3iR2XknFt3KeQAHtBDIGoA5+jVax0Ue3m9T6SREtc18ML3h
         Eg+g/jcmJrMiOKPzxONttH5vVTSztRz/h+Gtcok9PKkMaztCXmyI4tN5+3R03G4+6h48
         PgNw==
X-Gm-Message-State: AO0yUKXMjT/z3/378DVUn4Sc/OxqJshoRJmMNsSEIFyVmi/0TLWM3ZOB
        GRj5KXIquDs+it66RycIhuvR48hDtuGJybddOUGXsLAgPwCItw==
X-Google-Smtp-Source: AK7set8I9YTxdX4q11abMFNXZsZPNduHlGMQuLezkTsTD4v7hcr4qsi6pPNuczke8dRoZpdEWHsGDw+0s3Yvfg6FssA=
X-Received: by 2002:a67:c893:0:b0:3ef:bda7:73e with SMTP id
 v19-20020a67c893000000b003efbda7073emr5216136vsk.21.1676271732141; Sun, 12
 Feb 2023 23:02:12 -0800 (PST)
MIME-Version: 1.0
References: <20230126021659.3801-1-kev.friedberg@gmail.com> <20230207094423.00001a30@linux.intel.com>
In-Reply-To: <20230207094423.00001a30@linux.intel.com>
From:   Kevin Friedberg <kev.friedberg@gmail.com>
Date:   Mon, 13 Feb 2023 02:02:01 -0500
Message-ID: <CAEJbB41vzAo_Bfs4MqsLnMNGRKvL6iddPNG66BYtQuZOf3gRqQ@mail.gmail.com>
Subject: Re: [PATCH] treat AHCI controllers under VMD as part of VMD
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Mariusz,

Thank you for the feedback.  I'm working up a replacement patch based
on your comments and should have it ready in the next couple days.  It
works in a different way and has a different commit message, so go
ahead and reject this patch if there's a process for that.

On Tue, Feb 7, 2023 at 3:44 AM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> Hi Kevin,
> I found time to take a look into it closer. I think that it is not complete
> solution. Please see my comments.
>
> On Wed, 25 Jan 2023 21:16:59 -0500
> Kevin Friedberg <kev.friedberg@gmail.com> wrote:
>
> > Detect when a SATA controller has been mapped under Intel Alderlake RST
> > VMD and list it as part of the domain, instead of independently, so that
> > it can use the VMD controller's RAID capabilities.
> >
> > Signed-off-by: Kevin Friedberg <kev.friedberg@gmail.com>
> > ---
> >  platform-intel.c | 15 +++++++++------
> >  super-intel.c    | 25 ++++++++++++++++++++++++-
> >  2 files changed, 33 insertions(+), 7 deletions(-)
> >
> > diff --git a/platform-intel.c b/platform-intel.c
> > index 757f0b1b..859bf743 100644
> > --- a/platform-intel.c
> > +++ b/platform-intel.c
> > @@ -64,10 +64,12 @@ struct sys_dev *find_driver_devices(const char *bus,
> > const char *driver)
> >       if (strcmp(driver, "isci") == 0)
> >               type = SYS_DEV_SAS;
> > -     else if (strcmp(driver, "ahci") == 0)
> > +     else if (strcmp(driver, "ahci") == 0) {
> > +             /* if looking for sata devs, ignore vmd */
> > +             vmd = find_driver_devices("pci", "vmd");
> >               type = SYS_DEV_SATA;
> > -     else if (strcmp(driver, "nvme") == 0) {
> > -             /* if looking for nvme devs, first look for vmd */
> > +     } else if (strcmp(driver, "nvme") == 0) {
> > +             /* if looking for nvme devs, also look for vmd */
> >               vmd = find_driver_devices("pci", "vmd");
> >               type = SYS_DEV_NVME;
> >       } else if (strcmp(driver, "vmd") == 0)
> > @@ -104,8 +106,8 @@ struct sys_dev *find_driver_devices(const char *bus,
> > const char *driver) sprintf(path, "/sys/bus/%s/drivers/%s/%s",
> >                       bus, driver, de->d_name);
> >
> > -             /* if searching for nvme - skip vmd connected one */
> > -             if (type == SYS_DEV_NVME) {
> > +             /* if searching for nvme or ahci - skip vmd connected one */
> > +             if (type == SYS_DEV_NVME || type == SYS_DEV_SATA) {
> >                       struct sys_dev *dev;
> >                       char *rp = realpath(path, NULL);
> >                       for (dev = vmd; dev; dev = dev->next) {
> > @@ -166,7 +168,8 @@ struct sys_dev *find_driver_devices(const char *bus,
> > const char *driver) }
> >       closedir(driver_dir);
> >
> > -     if (vmd) {
> > +     /* VMD adopts multiple types but should only be listed once */
> > +     if (vmd && type == SYS_DEV_NVME) {
> >               if (list)
> >                       list->next = vmd;
> >               else
>
> The SATA behind VMD deserves own type, let say SYS_DEV_SATA_VMD. We cannot use
> SYS_DEV_VMD because it will allow to use NVME devices behind VMD in SATA Raid
> array. It means that if you have them connected, like:
> VMD___ NVME0
>     |_ NVME1
>     |_ SATA___SATA0
>            |__SATA1
> You will be able to mix SATA and NVME drives together in RAID. Mdmonitor
> could mix them too (if appropriate policy is set). That is not allowed from at
> least VROC requirements PoV.
>
> > diff --git a/super-intel.c b/super-intel.c
> > index 89fac626..4ef8f0d8 100644
> > --- a/super-intel.c
> > +++ b/super-intel.c
> > @@ -2680,6 +2680,8 @@ static void print_imsm_capability_export(const struct
> > imsm_orom *orom) printf("IMSM_MAX_VOLUMES_PER_CONTROLLER=%d\n",orom->vphba);
> >  }
> >
> > +#define PCI_CLASS_AHCI_CNTRL "0x010601"
> This should be defined in platform-intel.h
>
> > +
> >  static int detail_platform_imsm(int verbose, int enumerate_only, char
> > *controller_path) {
> >       /* There are two components to imsm platform support, the ahci SATA
> > @@ -2752,11 +2754,32 @@ static int detail_platform_imsm(int verbose, int
> > enumerate_only, char *controlle for (hba = list; hba; hba = hba->next) {
> >                               if (hba->type == SYS_DEV_VMD) {
> >                                       char buf[PATH_MAX];
> > +                                     struct dirent *ent;
> > +                                     DIR *dir;
> > +
> >                                       printf(" I/O Controller : %s (%s)\n",
> >                                               vmd_domain_to_controller(hba,
> > buf), get_sys_dev_type(hba->type));
> > +                                     dir = opendir(hba->path);
> > +                                     for (ent = readdir(dir); ent; ent =
> > readdir(dir)) {
> > +                                             char ent_path[PATH_MAX];
> > +
> > +                                             sprintf(ent_path, "%s/%s",
> > hba->path, ent->d_name);
> > +                                             devpath_to_char(ent_path,
> > "class", buf, sizeof(buf), 0);
> > +                                             if (strcmp(buf,
> > PCI_CLASS_AHCI_CNTRL) == 0) {
> > +                                                     host_base =
> > ahci_get_port_count(ent_path, &port_count);
> > +                                                     if
> > (ahci_enumerate_ports(ent_path, port_count, host_base, verbose)) {
> > +                                                             if (verbose
> > > 0)
> > +
> > pr_err("failed to enumerate ports on VMD SATA controller at %s.\n",
> > +
> > hba->pci_id);
> > +                                                             result |= 2;
> > +                                                     }
> > +                                             }
> > +                                     }
> > +                                     closedir(dir);
> > +
> >                                       if (print_nvme_info(hba)) {
> >                                               if (verbose > 0)
> > -                                                     pr_err("failed to
> > get devices attached to VMD domain.\n");
> > +                                                     pr_err("failed to
> > get NVMe devices attached to VMD domain.\n"); result |= 2;
> >                                       }
> >                               }
> Similar logic is already there:
> https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/super-intel.c#n2780
> I would like to reuse it instead of adding new code branch. Could you please
> extract similar parts to new function and use it in both places?
>
> Thanks,
> Mariusz
