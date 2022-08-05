Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E25BC00140
	for <linux-raid@archiver.kernel.org>; Fri,  5 Aug 2022 12:51:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240649AbiHEMvR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 5 Aug 2022 08:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237789AbiHEMvQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 5 Aug 2022 08:51:16 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE9CB0E
        for <linux-raid@vger.kernel.org>; Fri,  5 Aug 2022 05:51:14 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id r14so2961221ljp.2
        for <linux-raid@vger.kernel.org>; Fri, 05 Aug 2022 05:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=ZJ8rkXnnomoBRQm9zJ0gZ3i3ptc4iexlZJbNULzlkrg=;
        b=nVUEEDehTqskGf70XCh47VkbQ6GZ6pPTVnIoZzcSvkBHzvAxJNw/UK4VlZUopl8XOc
         yyjZAb58vXTl7NQo6IeCMtwuVk2Hnelqslp0lmklU429ehhGVx5ZHXF0sxV4Tlu5ugap
         7ExopNg8TdJLDtFBLt/zF4kUCsPqmyHH3xbhbmZn88OofOb9o/s9c+EfHhwK24iaeb2D
         E9PcEh1HYcvjyzMdClQRYRKTSvsJgvisBw2d7erBjaY7XMMMw/GG4fWVOK+XXJQBSpHk
         AV3O0+1s+rr3TYEoJjzeca8IOiGdBqQKB/ehn/l07mkEQZexpAlAtjsGS8uQyDkCW6r6
         CHJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=ZJ8rkXnnomoBRQm9zJ0gZ3i3ptc4iexlZJbNULzlkrg=;
        b=VZ3WCL/k2TPaeDO5TH7VPwwQpZc74O6Hw0lXeQ6RboMgmm5KavqBtVBb7c159rHeBG
         htHBWK0z1nRnNl93GuG0VbXZAFS2gl5KpNC+StGKiqvh7SUtYJ1qxso7tJDxLmzgwHgN
         tzvx/8TNj5ygTGsI/TtBHgcpggbxxpmzC5gZgI277PCqTfHCLFfDk83QiIXTY3hCboPg
         yHKIqkhVD6A/2O4AsqMUN9DtZWP65qdSVC6hhBrJqeKByuLr+HmvD8B+kW5OSj2VX2/S
         iOGHVk2y4Iz5kP8+rN7w8b4HQqoZodn7sU4ysY4I8nxX67Jt5cIMq5OYwJRew1wX2Wa9
         zpZg==
X-Gm-Message-State: ACgBeo1RMv5qzl8K5uVl5COiGGsJK9Oihy3/pKmEbschy0asp/Uh0SL5
        UGSlBIjxRqW0DwkVQMbOe20WNQzH9RmvbtcjzH4IpvSA63s=
X-Google-Smtp-Source: AA6agR7gGtEzgUWJTfCWeH8daA0miZh5E/PZlsxdOlm3oo7QfUOerS3jJR9YIQW5zTxryjr8HA+p0Az4dGHDbyajUuQ=
X-Received: by 2002:a2e:a7c8:0:b0:25e:792a:6fa8 with SMTP id
 x8-20020a2ea7c8000000b0025e792a6fa8mr1160923ljp.398.1659703873224; Fri, 05
 Aug 2022 05:51:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220805100545.9369-1-oldium.pro@gmail.com> <20220805100545.9369-2-oldium.pro@gmail.com>
 <20220805135603.00002723@intel.linux.com>
In-Reply-To: <20220805135603.00002723@intel.linux.com>
From:   =?UTF-8?B?T2xkxZlpY2ggSmVkbGnEjWth?= <oldium.pro@gmail.com>
Date:   Fri, 5 Aug 2022 14:50:36 +0200
Message-ID: <CALdrqORp1vTu+c8C9Pydn_ftGuSL_6QH1hhKe=Gd7Vo4AdrNKQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] mdadm: enable Intel Alderlake RST VMD configuration
To:     Kinga Tanska <kinga.tanska@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

p=C3=A1 5. 8. 2022 v 13:56 odes=C3=ADlatel Kinga Tanska
<kinga.tanska@linux.intel.com> napsal:
>
> On Fri,  5 Aug 2022 12:05:45 +0200
> Old=C5=99ich Jedli=C4=8Dka <oldium.pro@gmail.com> wrote:
>
> > Alderlake changed UEFI variable name to 'RstVmdV' also and for VMD
> > devices, so check the updated name for VMD devices like it is done in
> > the SATA case.
> >
> > Signed-off-by: Old=C5=99ich Jedli=C4=8Dka <oldium.pro@gmail.com>
> > ---
> >  platform-intel.c | 19 ++++++++++++-------
> >  1 file changed, 12 insertions(+), 7 deletions(-)
> >
> > diff --git a/platform-intel.c b/platform-intel.c
> > index a4d55a3..2f8e6af 100644
> > --- a/platform-intel.c
> > +++ b/platform-intel.c
> > @@ -512,8 +512,8 @@ static const struct imsm_orom
> > *find_imsm_hba_orom(struct sys_dev *hba) #define AHCI_PROP "RstSataV"
> >  #define AHCI_SSATA_PROP "RstsSatV"
> >  #define AHCI_TSATA_PROP "RsttSatV"
> > -#define AHCI_RST_PROP "RstVmdV"
> > -#define VMD_PROP "RstUefiV"
> > +#define RST_VMD_PROP "RstVmdV"
> > +#define RST_UEFI_PROP "RstUefiV"
> >
> >  #define VENDOR_GUID \
> >       EFI_GUID(0x193dfefa, 0xa445, 0x4302, 0x99, 0xd8, 0xef, 0x3a,
> > 0xad, 0x1a, 0x04, 0xc6) @@ -607,7 +607,8 @@ const struct imsm_orom
> > *find_imsm_efi(struct sys_dev *hba) struct orom_entry *ret;
> >       static const char * const sata_efivars[] =3D {AHCI_PROP,
> > AHCI_SSATA_PROP, AHCI_TSATA_PROP,
> > -                                                 AHCI_RST_PROP};
> > +                                                 RST_VMD_PROP};
> > +     static const char * const vmd_efivars[] =3D {RST_UEFI_PROP,
> > RST_VMD_PROP}; unsigned long i;
> >
> >       if (check_env("IMSM_TEST_AHCI_EFI") ||
> > check_env("IMSM_TEST_SCU_EFI")) @@ -640,10 +641,14 @@ const struct
> > imsm_orom *find_imsm_efi(struct sys_dev *hba)
> >               break;
> >       case SYS_DEV_VMD:
> > -             if (!read_efi_variable(&orom, sizeof(orom), VMD_PROP,
> > -                                    VENDOR_GUID))
> > -                     break;
> > -             return NULL;
> > +             for (i =3D 0; i < ARRAY_SIZE(vmd_efivars); i++) {
> > +                     if (!read_efi_variable(&orom, sizeof(orom),
> > +                                             vmd_efivars[i],
> > VENDOR_GUID))
> > +                             break;
> > +             }
> > +             if (i =3D=3D ARRAY_SIZE(vmd_efivars))
> > +                     return NULL;
> > +             break;
> >       default:
> >               return NULL;
> >       }
>
> Hi,
>
> please have a look at the following mail:
> https://marc.info/?l=3Dlinux-raid&m=3D165969352101643&w=3D2

Sorry for double-posting, I received rejection emails regarding HTML
content. Gmail switched to HTML.

Hi, the described issue applies specifically in the SYS_DEV_SATA (SATA
configuration) case, so it should not apply to SYS_DEV_VMD (VMD configurati=
on)
one.

For me, the platform output looks reasonable (I have RAID 0 active):

#> sudo mdadm --detail-platform
       Platform : Intel(R) Rapid Storage Technology
        Version : 19.0.7.5579
    RAID Levels : raid0 raid1 raid10 raid5
    Chunk Sizes : 4k 8k 16k 32k 64k 128k
    2TB volumes : supported
      2TB disks : supported
      Max Disks : 32
    Max Volumes : 2 per array, 4 per controller
 3rd party NVMe : supported
 I/O Controller : /sys/devices/pci0000:00/0000:00:0e.0 (VMD)
 NVMe under VMD : /dev/nvme0n1 (S6P1NS0T318266R)
 NVMe under VMD : /dev/nvme1n1 (S6P1NS0T318223V)

Without the patch the platform isn't even recognized. Common to both change=
s
is the usage of the new UEFI variable 'RstVmdV', not the changes to the
controller.

Regards,
Oldrich.

>
> Regards,
> Kinga Tanska
