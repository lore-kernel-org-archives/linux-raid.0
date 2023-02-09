Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81939C636CC
	for <linux-raid@archiver.kernel.org>; Thu,  9 Feb 2023 00:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbjBIAk0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Feb 2023 19:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbjBIAkY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Feb 2023 19:40:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988BC16316
        for <linux-raid@vger.kernel.org>; Wed,  8 Feb 2023 16:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675903175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=25vwbWqR9Q+FewVoKOP31oIU4M8ObyhqsQgxkQoO82Q=;
        b=WymJOfFIA4u22DVq7qZSS4IjkrrG/cx7O0FVK93H+iJaawXaMFIDLS8ie8UJ/jdLiIX3gq
        rcbPQtzqxIh0z4Ue2kM76rP5NpegQ6yLGyDFH3ppOxVrMuCQAJBt22JZYyfrM26wdHfPfJ
        Y37dTN/0flz9DyJXwZ/HKWoGHN1NQJM=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-550-G3WlyU1pOh6oEiF0eo3MvA-1; Wed, 08 Feb 2023 19:39:34 -0500
X-MC-Unique: G3WlyU1pOh6oEiF0eo3MvA-1
Received: by mail-pl1-f200.google.com with SMTP id jb5-20020a170903258500b00199226cbbdeso327174plb.19
        for <linux-raid@vger.kernel.org>; Wed, 08 Feb 2023 16:39:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=25vwbWqR9Q+FewVoKOP31oIU4M8ObyhqsQgxkQoO82Q=;
        b=C1M+Q3/4lbQhX8Gynrrd6Wy2JLjBerD4Q4ufAGK828+XjrUVLI9dUCDfq+GEnO4x+y
         Qwz6zbnmsQRdQzs02HSW+ar8+WE7YDhq5g6dUdHq7KsaAbmAniG++h/fiCYsr9aVIv/S
         2FXPBCMoN3FCigsYjbaBVHt98RsvziUWFI+LOg2EJnXYLQWpxCKT26AQz0FZf+H5tAqE
         i7kIM/6VLhLU+oJ7BKX+NDM3It5csqoMWjn/gYHl9QPqSRVjxkdIEaE2RyZeBUAzDNlL
         DMSBX+YUJiAMJWTqCRhv8E7Nm7fBGvquu3OG+Q7barwtew5F1B7fPQs9uYuxQFcSenK3
         10uw==
X-Gm-Message-State: AO0yUKX5lDxIGjZUXwNHcN9AdrLXJ793FaiNLqf2jDsTEE7IuwZSfeD3
        PGtV0ETpYLcfc8TwjwHNNApSF2chyGaG9xZUXHf7V5TNrGyNPhxShyPQEbV6TG6jO0cWE2P/3OY
        hi2bWseCGsCeFdxWrjWCx8MH5yYQgeN7jvmO0E6616EZ4zIsB
X-Received: by 2002:aa7:9686:0:b0:593:c9b8:4cc8 with SMTP id f6-20020aa79686000000b00593c9b84cc8mr2191225pfk.42.1675903173124;
        Wed, 08 Feb 2023 16:39:33 -0800 (PST)
X-Google-Smtp-Source: AK7set8hfTUz6DmJUbrTxmKx2gXeesgKsGd1W6Lqp/MR2bDgIwjKMmkYRbs5Xy6UCN1MdqxwxKP+9WYLaV5gkiZOjYk=
X-Received: by 2002:aa7:9686:0:b0:593:c9b8:4cc8 with SMTP id
 f6-20020aa79686000000b00593c9b84cc8mr2191219pfk.42.1675903172827; Wed, 08 Feb
 2023 16:39:32 -0800 (PST)
MIME-Version: 1.0
References: <20230126021659.3801-1-kev.friedberg@gmail.com> <20230207094423.00001a30@linux.intel.com>
In-Reply-To: <20230207094423.00001a30@linux.intel.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Thu, 9 Feb 2023 08:39:21 +0800
Message-ID: <CALTww2_yqAMN-_XmS7ib-utkty903evi=ynyGtFksjXKCwGLJQ@mail.gmail.com>
Subject: Re: [PATCH] treat AHCI controllers under VMD as part of VMD
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Kevin Friedberg <kev.friedberg@gmail.com>,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Feb 7, 2023 at 4:46 PM Mariusz Tkaczyk
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


Hi Mariusz

Through the description of VMD
(https://www.chipict.com/intel_vmd_vroc/), it looks like VMD only
supports pcie nvme devices. Can it also connect sata devices?

And what's PoV?

Best Regards
Xiao

