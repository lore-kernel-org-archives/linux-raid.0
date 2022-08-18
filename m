Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 561BFC00140
	for <linux-raid@archiver.kernel.org>; Thu, 18 Aug 2022 14:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245430AbiHROMI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 18 Aug 2022 10:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245222AbiHROMH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 18 Aug 2022 10:12:07 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E08857DA
        for <linux-raid@vger.kernel.org>; Thu, 18 Aug 2022 07:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660831925; x=1692367925;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DItNEUs4PhbiDqfiAdGd97bozz98lgARVhjwIVkGmNU=;
  b=ahXD+tIPj6foXKYooxdzKSzyObtB/SHWlDm61K8aysVUCQWaMAK2m7Bm
   A1jLYC43Z+xmJAkV5N69x+s5QihuE5Dhp0GA7SatVRj1AR9hTDMobx+Vh
   gpFCZbTW9HW0htyALYZCwmrr4Tnxb67dhYPwaOELMWB1kd9Kx5x6U+CsZ
   2gAQbvfLpy6DFNY4viE1RYCwDHXUNqe1RCHBy+0TsvtzncYjSMmc1aSE/
   4PIVShPp5NtJXNeA4pe0PalingAP+5hQUWdmDKk38TRto8+2wKqUQxqYq
   dwdghFUkxAVvGsSy0ICy3Cpj1hzWyHwPcn/iCKzhAP6mBqnzIGN4hdnXh
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="273157546"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="273157546"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 07:12:05 -0700
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="584221130"
Received: from ktanska-mobl1.ger.corp.intel.com (HELO intel.linux.com) ([10.213.27.72])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 07:12:04 -0700
Date:   Thu, 18 Aug 2022 16:12:02 +0200
From:   Kinga Tanska <kinga.tanska@linux.intel.com>
To:     =?UTF-8?Q?Old=C5=99ich_Jedli=C4=8Dka?= <oldium.pro@gmail.com>
Cc:     linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/1] mdadm: enable Intel Alderlake RST VMD configuration
Message-ID: <20220818161202.0000034f@intel.linux.com>
In-Reply-To: <CALdrqORp1vTu+c8C9Pydn_ftGuSL_6QH1hhKe=Gd7Vo4AdrNKQ@mail.gmail.com>
References: <20220805100545.9369-1-oldium.pro@gmail.com>
        <20220805100545.9369-2-oldium.pro@gmail.com>
        <20220805135603.00002723@intel.linux.com>
        <CALdrqORp1vTu+c8C9Pydn_ftGuSL_6QH1hhKe=Gd7Vo4AdrNKQ@mail.gmail.com>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 5 Aug 2022 14:50:36 +0200
Old=C5=99ich Jedli=C4=8Dka <oldium.pro@gmail.com> wrote:

> p=C3=A1 5. 8. 2022 v 13:56 odes=C3=ADlatel Kinga Tanska
> <kinga.tanska@linux.intel.com> napsal:
> >
> > On Fri,  5 Aug 2022 12:05:45 +0200
> > Old=C5=99ich Jedli=C4=8Dka <oldium.pro@gmail.com> wrote:
> >
> > > Alderlake changed UEFI variable name to 'RstVmdV' also and for VMD
> > > devices, so check the updated name for VMD devices like it is
> > > done in the SATA case.
> > >
> > > Signed-off-by: Old=C5=99ich Jedli=C4=8Dka <oldium.pro@gmail.com>
> > > ---
> > >  platform-intel.c | 19 ++++++++++++-------
> > >  1 file changed, 12 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/platform-intel.c b/platform-intel.c
> > > index a4d55a3..2f8e6af 100644
> > > --- a/platform-intel.c
> > > +++ b/platform-intel.c
> > > @@ -512,8 +512,8 @@ static const struct imsm_orom
> > > *find_imsm_hba_orom(struct sys_dev *hba) #define AHCI_PROP
> > > "RstSataV" #define AHCI_SSATA_PROP "RstsSatV"
> > >  #define AHCI_TSATA_PROP "RsttSatV"
> > > -#define AHCI_RST_PROP "RstVmdV"
> > > -#define VMD_PROP "RstUefiV"
> > > +#define RST_VMD_PROP "RstVmdV"
> > > +#define RST_UEFI_PROP "RstUefiV"
> > >
> > >  #define VENDOR_GUID \
> > >       EFI_GUID(0x193dfefa, 0xa445, 0x4302, 0x99, 0xd8, 0xef, 0x3a,
> > > 0xad, 0x1a, 0x04, 0xc6) @@ -607,7 +607,8 @@ const struct imsm_orom
> > > *find_imsm_efi(struct sys_dev *hba) struct orom_entry *ret;
> > >       static const char * const sata_efivars[] =3D {AHCI_PROP,
> > > AHCI_SSATA_PROP, AHCI_TSATA_PROP,
> > > -                                                 AHCI_RST_PROP};
> > > +                                                 RST_VMD_PROP};
> > > +     static const char * const vmd_efivars[] =3D {RST_UEFI_PROP,
> > > RST_VMD_PROP}; unsigned long i;
> > >
> > >       if (check_env("IMSM_TEST_AHCI_EFI") ||
> > > check_env("IMSM_TEST_SCU_EFI")) @@ -640,10 +641,14 @@ const struct
> > > imsm_orom *find_imsm_efi(struct sys_dev *hba)
> > >               break;
> > >       case SYS_DEV_VMD:
> > > -             if (!read_efi_variable(&orom, sizeof(orom),
> > > VMD_PROP,
> > > -                                    VENDOR_GUID))
> > > -                     break;
> > > -             return NULL;
> > > +             for (i =3D 0; i < ARRAY_SIZE(vmd_efivars); i++) {
> > > +                     if (!read_efi_variable(&orom, sizeof(orom),
> > > +                                             vmd_efivars[i],
> > > VENDOR_GUID))
> > > +                             break;
> > > +             }
> > > +             if (i =3D=3D ARRAY_SIZE(vmd_efivars))
> > > +                     return NULL;
> > > +             break;
> > >       default:
> > >               return NULL;
> > >       }
> >
> > Hi,
> >
> > please have a look at the following mail:
> > https://marc.info/?l=3Dlinux-raid&m=3D165969352101643&w=3D2
>=20
> Sorry for double-posting, I received rejection emails regarding HTML
> content. Gmail switched to HTML.
>=20
> Hi, the described issue applies specifically in the SYS_DEV_SATA (SATA
> configuration) case, so it should not apply to SYS_DEV_VMD (VMD
> configuration) one.
>=20
> For me, the platform output looks reasonable (I have RAID 0 active):
>=20
> #> sudo mdadm --detail-platform
>        Platform : Intel(R) Rapid Storage Technology
>         Version : 19.0.7.5579
>     RAID Levels : raid0 raid1 raid10 raid5
>     Chunk Sizes : 4k 8k 16k 32k 64k 128k
>     2TB volumes : supported
>       2TB disks : supported
>       Max Disks : 32
>     Max Volumes : 2 per array, 4 per controller
>  3rd party NVMe : supported
>  I/O Controller : /sys/devices/pci0000:00/0000:00:0e.0 (VMD)
>  NVMe under VMD : /dev/nvme0n1 (S6P1NS0T318266R)
>  NVMe under VMD : /dev/nvme1n1 (S6P1NS0T318223V)
>=20
> Without the patch the platform isn't even recognized. Common to both
> changes is the usage of the new UEFI variable 'RstVmdV', not the
> changes to the controller.
>=20
> Regards,
> Oldrich.
>=20
> >
> > Regards,
> > Kinga Tanska

Hello,

I've done test to check if your patch doesn't change way of recognizing
controllers. I've got two SATA controllers - first one with AHCI mode
and the other one with RAID MODE enabled. Command "mdadm
--detail-platform" should display info only about controller with RAID
MODE:

mdadm: imsm capabilities not found for controller:
/sys/devices/pci0000:00/0000:00:17.0 (type SATA) Platform : Intel(R)
Rapid Storage Technology enterprise Version : 5.3.0.1052
    RAID Levels : raid0 raid1 raid10 raid5
    Chunk Sizes : 4k 8k 16k 32k 64k 128k
    2TB volumes : supported
      2TB disks : supported
      Max Disks : 8
    Max Volumes : 2 per array, 8 per controller
 I/O Controller : /sys/devices/pci0000:00/0000:00:11.5 (SATA)
          Port4 : - non-disk device (TEAC DV-W28S-B) -
          Port0 : - no device attached -
          Port1 : - no device attached -
          Port2 : - no device attached -
          Port3 : - no device attached -
          Port5 : - no device attached -

       Platform : Intel(R) Rapid Storage Technology enterprise
        Version : 5.3.0.1052
    RAID Levels : raid0 raid1 raid10 raid5
    Chunk Sizes : 4k 8k 16k 32k 64k 128k
    2TB volumes : supported
      2TB disks : supported
      Max Disks : 24
    Max Volumes : 2 per array, 24 per controller
 3rd party NVMe : supported
 I/O Controller : /sys/devices/pci0000:17/0000:17:05.5 (VMD)
 I/O Controller : /sys/devices/pci0000:d7/0000:d7:05.5 (VMD)
 NVMe under VMD : /dev/nvme3n1 (PHLJ915000201P0FGN)
 NVMe under VMD : /dev/nvme2n1 (PHLJ915003201P0FGN)
 I/O Controller : /sys/devices/pci0000:85/0000:85:05.5 (VMD)
 I/O Controller : /sys/devices/pci0000:ae/0000:ae:05.5 (VMD)
 I/O Controller : /sys/devices/pci0000:5d/0000:5d:05.5 (VMD)
 NVMe under VMD : /dev/nvme0n1 (PHFT536600GT400GGN)
 NVMe under VMD : /dev/nvme1n1 (CVFT523100122P0KGN)

But with your patch this command returns info about all controllers
which is not correct:

Platform : Intel(R) Rapid Storage Technology enterprise
        Version : 5.3.0.1052
    RAID Levels : raid0 raid1 raid10 raid5
    Chunk Sizes : 4k 8k 16k 32k 64k 128k
    2TB volumes : supported
      2TB disks : supported
      Max Disks : 8
    Max Volumes : 2 per array, 8 per controller
 I/O Controller : /sys/devices/pci0000:00/0000:00:17.0 (SATA)
          Port2 : /dev/sdd (WDEBMLJ2)
          Port3 : /dev/sde (BTPR2300034W120LGN)
          Port0 : /dev/sdb (CVTS5396007S240JGN)
          Port1 : /dev/sdc (ZDE0XM9Z)
          Port4 : - no device attached -
          Port5 : - no device attached -
          Port6 : - no device attached -
          Port7 : - no device attached -

       Platform : Intel(R) Rapid Storage Technology enterprise
        Version : 5.3.0.1052
    RAID Levels : raid0 raid1 raid10 raid5
    Chunk Sizes : 4k 8k 16k 32k 64k 128k
    2TB volumes : supported
      2TB disks : supported
      Max Disks : 8
    Max Volumes : 2 per array, 8 per controller
 I/O Controller : /sys/devices/pci0000:00/0000:00:11.5 (SATA)
          Port4 : - non-disk device (TEAC DV-W28S-B) -
          Port0 : - no device attached -
          Port1 : - no device attached -
          Port2 : - no device attached -
          Port3 : - no device attached -
          Port5 : - no device attached -

       Platform : Intel(R) Rapid Storage Technology enterprise
        Version : 5.3.0.1052
    RAID Levels : raid0 raid1 raid10 raid5
    Chunk Sizes : 4k 8k 16k 32k 64k 128k
    2TB volumes : supported
      2TB disks : supported
      Max Disks : 24
    Max Volumes : 2 per array, 24 per controller
 3rd party NVMe : supported
 I/O Controller : /sys/devices/pci0000:17/0000:17:05.5 (VMD)
 I/O Controller : /sys/devices/pci0000:d7/0000:d7:05.5 (VMD)
 NVMe under VMD : /dev/nvme3n1 (PHLJ915000201P0FGN)
 NVMe under VMD : /dev/nvme2n1 (PHLJ915003201P0FGN)
 I/O Controller : /sys/devices/pci0000:85/0000:85:05.5 (VMD)
 I/O Controller : /sys/devices/pci0000:ae/0000:ae:05.5 (VMD)
 I/O Controller : /sys/devices/pci0000:5d/0000:5d:05.5 (VMD)
 NVMe under VMD : /dev/nvme0n1 (PHFT536600GT400GGN)
 NVMe under VMD : /dev/nvme1n1 (CVFT523100122P0KGN)

Please analyze it.
Regards,
Kinga Tanska
