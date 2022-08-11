Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB4DC19F2A
	for <linux-raid@archiver.kernel.org>; Thu, 11 Aug 2022 19:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235402AbiHKTjk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 11 Aug 2022 15:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234698AbiHKTjj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 11 Aug 2022 15:39:39 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC919AF98
        for <linux-raid@vger.kernel.org>; Thu, 11 Aug 2022 12:39:38 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id o2so19559716lfb.1
        for <linux-raid@vger.kernel.org>; Thu, 11 Aug 2022 12:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=j1GHuKHsIkGyq+OjYmT+kriXS5csDuQBOD1YjTBVqTE=;
        b=lAoIlxvE20HpbLYP8QszfTrZiCz9EeXBFsrNte3cyPd9ter6rAOSxPQaRT1GX4gA/0
         S67WqZ3AiUZ486o9iZGl3MCaf20p2/gW9LPftkZI6GoMu1Ks9E8ai8Cjqk6F6wwWHsrY
         LOAdVS0PWeDikjZilsFkJRtCBNImqwXGMp3P9VSxQFP+xvkUp3ZSO5I0066jsn0YEQbN
         x+GQBaWGAPNEmgHugbeZB4qUKGj9BuRr4Jru4W0pIn8yXBKY2ivCXjZ/orfpk0mQasKt
         nk8CfiFoR3dnFGCXhtitJxkhPZvd6NNaS9qrlTjLYKZJoRjTbhMG/srLQQyiAiOn7AYP
         Fa0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=j1GHuKHsIkGyq+OjYmT+kriXS5csDuQBOD1YjTBVqTE=;
        b=QX20NyixBbvocyRdkfdGp/7Rc0rRAulsenq5ldEttOB4DIAGDm27XPMBRA5KJwEzIo
         lCFjbqbQIKNfYQbQkuAsfs71zu9k8cYjdXOAfZEwP9zyJug0C4AiQXZQ0qM9F5pfw5U6
         ef11KRz8Z7V3iYo+HqVQq7vbsEkmLwJh5NUyqEDtt6IE/oGDMyxkI4T9wW4BMWIzfaZ1
         Pwwu+4F09ykc7xAMB6RIW8ZbR8/KLpoPsa3IaSRmCCVg6gG6yW7WepinH5J5ewnrbDl1
         aj2ivnur9rgvnk9Om0UyZXFAs8LqjU+ZJrVbu2O85PJtN5znS6/2AV6HY5uzhqL2WFE2
         7zfg==
X-Gm-Message-State: ACgBeo21RNDXy2Y7+Cc3oTvtTh29pnSiV0QWzoItJcfj54fYoWv7OSMa
        i6/hA9DYEj6DgmPQB1IyFQGKTRJvrN2/aOOjYqlJJenjSTCoYQ==
X-Google-Smtp-Source: AA6agR7wMwcrGEADW9FowGgGuYS5HPI5FF2/sDPro7KjwcS6qA/5BRl1xSh886d2p6fgj6uwkiTokDTgD5+yVh4+vYg=
X-Received: by 2002:ac2:4ad9:0:b0:48b:95eb:c4df with SMTP id
 m25-20020ac24ad9000000b0048b95ebc4dfmr248925lfp.637.1660246776416; Thu, 11
 Aug 2022 12:39:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220805100545.9369-1-oldium.pro@gmail.com> <20220805100545.9369-2-oldium.pro@gmail.com>
 <20220805135603.00002723@intel.linux.com> <CALdrqORp1vTu+c8C9Pydn_ftGuSL_6QH1hhKe=Gd7Vo4AdrNKQ@mail.gmail.com>
 <20220811121838.0000585e@linux.intel.com>
In-Reply-To: <20220811121838.0000585e@linux.intel.com>
From:   =?UTF-8?B?T2xkxZlpY2ggSmVkbGnEjWth?= <oldium.pro@gmail.com>
Date:   Thu, 11 Aug 2022 21:38:59 +0200
Message-ID: <CALdrqOTQjLmpF42dTfEG4cDE0W+02X=GB5JYkxJRHb4RtsXGWQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] mdadm: enable Intel Alderlake RST VMD configuration
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Kinga Tanska <kinga.tanska@linux.intel.com>,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Mariusz,

=C4=8Dt 11. 8. 2022 v 12:18 odes=C3=ADlatel Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> napsal:
>
> Hello Old=C5=99ich,
>
> On Fri, 5 Aug 2022 14:50:36 +0200
> Old=C5=99ich Jedli=C4=8Dka <oldium.pro@gmail.com> wrote:
>
> > p=C3=A1 5. 8. 2022 v 13:56 odes=C3=ADlatel Kinga Tanska
> > <kinga.tanska@linux.intel.com> napsal:
> > >
> > > On Fri,  5 Aug 2022 12:05:45 +0200
> > > Old=C5=99ich Jedli=C4=8Dka <oldium.pro@gmail.com> wrote:
> > >
> > > > Alderlake changed UEFI variable name to 'RstVmdV' also and for VMD
> > > > devices, so check the updated name for VMD devices like it is done =
in
> > > > the SATA case.
>
> Alderlake is RST so it doesn't changed, it is different. It is a support =
for
> RST family product.
> > > >
> > > > Signed-off-by: Old=C5=99ich Jedli=C4=8Dka <oldium.pro@gmail.com>
> > > > ---
> > > >  platform-intel.c | 19 ++++++++++++-------
> > > >  1 file changed, 12 insertions(+), 7 deletions(-)
> > > >
> > > > diff --git a/platform-intel.c b/platform-intel.c
> > > > index a4d55a3..2f8e6af 100644
> > > > --- a/platform-intel.c
> > > > +++ b/platform-intel.c
> > > > @@ -512,8 +512,8 @@ static const struct imsm_orom
> > > > *find_imsm_hba_orom(struct sys_dev *hba) #define AHCI_PROP "RstSata=
V"
> > > >  #define AHCI_SSATA_PROP "RstsSatV"
> > > >  #define AHCI_TSATA_PROP "RsttSatV"
> > > > -#define AHCI_RST_PROP "RstVmdV"
> > > > -#define VMD_PROP "RstUefiV"
> > > > +#define RST_VMD_PROP "RstVmdV"
> > > > +#define RST_UEFI_PROP "RstUefiV"
>
> There are two products RSTe/ VROC and RST.  Here you are adding support f=
or RST
> platform. Please name it accordingly (yeah, I know that naming is confusi=
ng).
> I propose:
>
> #define RST_VMD_PROP "RstVmdV"
> #define VROC_VMD_PROP "RstUefiV"
>
> > > >
> > > >  #define VENDOR_GUID \
> > > >       EFI_GUID(0x193dfefa, 0xa445, 0x4302, 0x99, 0xd8, 0xef, 0x3a,
> > > > 0xad, 0x1a, 0x04, 0xc6) @@ -607,7 +607,8 @@ const struct imsm_orom
> > > > *find_imsm_efi(struct sys_dev *hba) struct orom_entry *ret;
> > > >       static const char * const sata_efivars[] =3D {AHCI_PROP,
> > > > AHCI_SSATA_PROP, AHCI_TSATA_PROP,
> > > > -                                                 AHCI_RST_PROP};
> > > > +                                                 RST_VMD_PROP};
> > > > +     static const char * const vmd_efivars[] =3D {RST_UEFI_PROP,
> > > > RST_VMD_PROP}; unsigned long i;
> > > >
> > > >       if (check_env("IMSM_TEST_AHCI_EFI") ||
> > > > check_env("IMSM_TEST_SCU_EFI")) @@ -640,10 +641,14 @@ const struct
> > > > imsm_orom *find_imsm_efi(struct sys_dev *hba)
> > > >               break;
> > > >       case SYS_DEV_VMD:
> > > > -             if (!read_efi_variable(&orom, sizeof(orom), VMD_PROP,
> > > > -                                    VENDOR_GUID))
> > > > -                     break;
> > > > -             return NULL;
> > > > +             for (i =3D 0; i < ARRAY_SIZE(vmd_efivars); i++) {
> > > > +                     if (!read_efi_variable(&orom, sizeof(orom),
> > > > +                                             vmd_efivars[i],
> > > > VENDOR_GUID))
> > > > +                             break;
> > > > +             }
> > > > +             if (i =3D=3D ARRAY_SIZE(vmd_efivars))
> > > > +                     return NULL;
> > > > +             break;
> > > >       default:
> > > >               return NULL;
> > > >       }
> > >
> > > Hi,
> > >
> > > please have a look at the following mail:
> > > https://marc.info/?l=3Dlinux-raid&m=3D165969352101643&w=3D2
> >
> >
> > Hi, the described issue applies specifically in the SYS_DEV_SATA (SATA
> > configuration) case, so it should not apply to SYS_DEV_VMD (VMD configu=
ration)
> > one.
> >
> > For me, the platform output looks reasonable (I have RAID 0 active):
> >
> > #> sudo mdadm --detail-platform
> >        Platform : Intel(R) Rapid Storage Technology
> >         Version : 19.0.7.5579
> >     RAID Levels : raid0 raid1 raid10 raid5
> >     Chunk Sizes : 4k 8k 16k 32k 64k 128k
> >     2TB volumes : supported
> >       2TB disks : supported
> >       Max Disks : 32
> >     Max Volumes : 2 per array, 4 per controller
> >  3rd party NVMe : supported
> >  I/O Controller : /sys/devices/pci0000:00/0000:00:0e.0 (VMD)
> >  NVMe under VMD : /dev/nvme0n1 (S6P1NS0T318266R)
> >  NVMe under VMD : /dev/nvme1n1 (S6P1NS0T318223V)
> >
> > Without the patch the platform isn't even recognized. Common to both ch=
anges
> > is the usage of the new UEFI variable 'RstVmdV', not the changes to the
> > controller.
> >
>
> This version is different than one sent by Coly. We will test that to see=
 if it
> doesn't cause regression in our VROC product.
> I noted  some nits, we will test this version anyway.

Should I update the description (to just mention adding support for
Alderlake RST on VMD platform), change the defines in the patch, and
send V2, or you will send (possibly) updated version after your
testing?

The patch was tested on my Dell Precision 3570 notebook with Intel
i7-1255U CPU and two 2TB NVMe disks.

Cheers,
Old=C5=99ich.

> Thanks,
> Mariusz
>
