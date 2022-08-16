Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13DCFC25B0E
	for <linux-raid@archiver.kernel.org>; Tue, 16 Aug 2022 11:59:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiHPL7r (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 16 Aug 2022 07:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233634AbiHPL70 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 16 Aug 2022 07:59:26 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1797B3FA2C
        for <linux-raid@vger.kernel.org>; Tue, 16 Aug 2022 04:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660650215; x=1692186215;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=abzcypgiQFgCDBL8H3ULUuGqlr7FJ1l/fgakT1EgFP4=;
  b=nFm14SRTbtW1kD5C4ugqSUF6nDMugpAHrbqOJclfMldx1iV/d5K5WRo9
   I2QdGE/Mb7oMXUZsowgNsTK+uJFO0hTfUo1o5/0/9/5nHRdMGYwFI8vsQ
   ccBo/EvhAWHpiaeIljUVYbxAwU9GVaOoh2Fo6/hd72GXMKZcUxwffsSQU
   w++Vut8dhvlw2YWIOztVfR9+e5qqhiLEUHfdXNYerqisiK2/jFJl4gDTj
   udGE8H5OCLGddoOa4wcMcQz9IyyuPbuQxDk2AUGMc/QS/d1qaakXXSi+3
   2MSVbnLwshyz3YM+X42unKPxvnwO1xWPTgPZlM7WSls1vC/2Y32bUATwQ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="318190074"
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="318190074"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 04:43:34 -0700
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="667077822"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.38.225])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 04:43:33 -0700
Date:   Tue, 16 Aug 2022 13:43:29 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     =?UTF-8?Q?Old=C5=99ich_Jedli=C4=8Dka?= <oldium.pro@gmail.com>
Cc:     Kinga Tanska <kinga.tanska@linux.intel.com>,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/1] mdadm: enable Intel Alderlake RST VMD configuration
Message-ID: <20220816134329.0000183d@linux.intel.com>
In-Reply-To: <CALdrqOTQjLmpF42dTfEG4cDE0W+02X=GB5JYkxJRHb4RtsXGWQ@mail.gmail.com>
References: <20220805100545.9369-1-oldium.pro@gmail.com>
        <20220805100545.9369-2-oldium.pro@gmail.com>
        <20220805135603.00002723@intel.linux.com>
        <CALdrqORp1vTu+c8C9Pydn_ftGuSL_6QH1hhKe=Gd7Vo4AdrNKQ@mail.gmail.com>
        <20220811121838.0000585e@linux.intel.com>
        <CALdrqOTQjLmpF42dTfEG4cDE0W+02X=GB5JYkxJRHb4RtsXGWQ@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 11 Aug 2022 21:38:59 +0200
Old=C5=99ich Jedli=C4=8Dka <oldium.pro@gmail.com> wrote:

> Hi Mariusz,
>=20
> =C4=8Dt 11. 8. 2022 v 12:18 odes=C3=ADlatel Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> napsal:
> >
> > Hello Old=C5=99ich,
> >
> > On Fri, 5 Aug 2022 14:50:36 +0200
> > Old=C5=99ich Jedli=C4=8Dka <oldium.pro@gmail.com> wrote:
> > =20
> > > p=C3=A1 5. 8. 2022 v 13:56 odes=C3=ADlatel Kinga Tanska
> > > <kinga.tanska@linux.intel.com> napsal: =20
> > > >
> > > > On Fri,  5 Aug 2022 12:05:45 +0200
> > > > Old=C5=99ich Jedli=C4=8Dka <oldium.pro@gmail.com> wrote:
> > > > =20
> > > > > Alderlake changed UEFI variable name to 'RstVmdV' also and for VMD
> > > > > devices, so check the updated name for VMD devices like it is don=
e in
> > > > > the SATA case. =20
> >
> > Alderlake is RST so it doesn't changed, it is different. It is a suppor=
t for
> > RST family product. =20
> > > > >
> > > > > Signed-off-by: Old=C5=99ich Jedli=C4=8Dka <oldium.pro@gmail.com>
> > > > > ---
> > > > >  platform-intel.c | 19 ++++++++++++-------
> > > > >  1 file changed, 12 insertions(+), 7 deletions(-)
> > > > >
> > > > > diff --git a/platform-intel.c b/platform-intel.c
> > > > > index a4d55a3..2f8e6af 100644
> > > > > --- a/platform-intel.c
> > > > > +++ b/platform-intel.c
> > > > > @@ -512,8 +512,8 @@ static const struct imsm_orom
> > > > > *find_imsm_hba_orom(struct sys_dev *hba) #define AHCI_PROP "RstSa=
taV"
> > > > >  #define AHCI_SSATA_PROP "RstsSatV"
> > > > >  #define AHCI_TSATA_PROP "RsttSatV"
> > > > > -#define AHCI_RST_PROP "RstVmdV"
> > > > > -#define VMD_PROP "RstUefiV"
> > > > > +#define RST_VMD_PROP "RstVmdV"
> > > > > +#define RST_UEFI_PROP "RstUefiV" =20
> >
> > There are two products RSTe/ VROC and RST.  Here you are adding support=
 for
> > RST platform. Please name it accordingly (yeah, I know that naming is
> > confusing). I propose:
> >
> > #define RST_VMD_PROP "RstVmdV"
> > #define VROC_VMD_PROP "RstUefiV"
> > =20
> > > > >
> > > > >  #define VENDOR_GUID \
> > > > >       EFI_GUID(0x193dfefa, 0xa445, 0x4302, 0x99, 0xd8, 0xef, 0x3a,
> > > > > 0xad, 0x1a, 0x04, 0xc6) @@ -607,7 +607,8 @@ const struct imsm_orom
> > > > > *find_imsm_efi(struct sys_dev *hba) struct orom_entry *ret;
> > > > >       static const char * const sata_efivars[] =3D {AHCI_PROP,
> > > > > AHCI_SSATA_PROP, AHCI_TSATA_PROP,
> > > > > -                                                 AHCI_RST_PROP};
> > > > > +                                                 RST_VMD_PROP};
> > > > > +     static const char * const vmd_efivars[] =3D {RST_UEFI_PROP,
> > > > > RST_VMD_PROP}; unsigned long i;
> > > > >
> > > > >       if (check_env("IMSM_TEST_AHCI_EFI") ||
> > > > > check_env("IMSM_TEST_SCU_EFI")) @@ -640,10 +641,14 @@ const struct
> > > > > imsm_orom *find_imsm_efi(struct sys_dev *hba)
> > > > >               break;
> > > > >       case SYS_DEV_VMD:
> > > > > -             if (!read_efi_variable(&orom, sizeof(orom), VMD_PRO=
P,
> > > > > -                                    VENDOR_GUID))
> > > > > -                     break;
> > > > > -             return NULL;
> > > > > +             for (i =3D 0; i < ARRAY_SIZE(vmd_efivars); i++) {
> > > > > +                     if (!read_efi_variable(&orom, sizeof(orom),
> > > > > +                                             vmd_efivars[i],
> > > > > VENDOR_GUID))
> > > > > +                             break;
> > > > > +             }
> > > > > +             if (i =3D=3D ARRAY_SIZE(vmd_efivars))
> > > > > +                     return NULL;
> > > > > +             break;
> > > > >       default:
> > > > >               return NULL;
> > > > >       } =20
> > > >
> > > > Hi,
> > > >
> > > > please have a look at the following mail:
> > > > https://marc.info/?l=3Dlinux-raid&m=3D165969352101643&w=3D2 =20
> > >
> > >
> > > Hi, the described issue applies specifically in the SYS_DEV_SATA (SATA
> > > configuration) case, so it should not apply to SYS_DEV_VMD (VMD
> > > configuration) one.
> > >
> > > For me, the platform output looks reasonable (I have RAID 0 active):
> > > =20
> > > #> sudo mdadm --detail-platform =20
> > >        Platform : Intel(R) Rapid Storage Technology
> > >         Version : 19.0.7.5579
> > >     RAID Levels : raid0 raid1 raid10 raid5
> > >     Chunk Sizes : 4k 8k 16k 32k 64k 128k
> > >     2TB volumes : supported
> > >       2TB disks : supported
> > >       Max Disks : 32
> > >     Max Volumes : 2 per array, 4 per controller
> > >  3rd party NVMe : supported
> > >  I/O Controller : /sys/devices/pci0000:00/0000:00:0e.0 (VMD)
> > >  NVMe under VMD : /dev/nvme0n1 (S6P1NS0T318266R)
> > >  NVMe under VMD : /dev/nvme1n1 (S6P1NS0T318223V)
> > >
> > > Without the patch the platform isn't even recognized. Common to both
> > > changes is the usage of the new UEFI variable 'RstVmdV', not the chan=
ges
> > > to the controller.
> > > =20
> >
> > This version is different than one sent by Coly. We will test that to s=
ee
> > if it doesn't cause regression in our VROC product.
> > I noted  some nits, we will test this version anyway. =20
>=20
> Should I update the description (to just mention adding support for
> Alderlake RST on VMD platform), change the defines in the patch, and
> send V2, or you will send (possibly) updated version after your
> testing?
>=20
> The patch was tested on my Dell Precision 3570 notebook with Intel
> i7-1255U CPU and two 2TB NVMe disks.
>=20

Please do. This is your patch, so I don't want to take a your glory :)

Thanks,
Mariusz
