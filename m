Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6030C19F2A
	for <linux-raid@archiver.kernel.org>; Thu, 11 Aug 2022 10:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234511AbiHKKSr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 11 Aug 2022 06:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234492AbiHKKSq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 11 Aug 2022 06:18:46 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF996DFA4
        for <linux-raid@vger.kernel.org>; Thu, 11 Aug 2022 03:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660213124; x=1691749124;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MRWUTOLA0u4dz2bw4O8DQhHymyWHqFQbtIPedYQMhYw=;
  b=GxQV627dtPxgIkNZWDZnXnrRkI3bZpnDM/QXeGSmCcqVA5wVB7axe8Fu
   g8vaNWZohnHPHlL62P6E5A58+zBPtSwVnPDosX17/P46WvbE9O+Z+6ohA
   HsHrKhbcZyZRvMawfp25SminXqmKxlM5oT/Gviz7sQpvBwSLVzrXlScd/
   aEqRmtJCVu9p/UXdo2KnbcrzEcMzyOiHRYj50fHJXNr4/okjGJNKMreze
   KIie9MJcgnMC4kq4nswXDQH/rnQl+JtDDDulgN52O31zjT36qdyOccnjw
   IUugR5+KGS/QKTVC0igeuWv2rjYwsVb130l8wZSL+dCzQ46KwLj+v5mS9
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10435"; a="274368484"
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="274368484"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 03:18:44 -0700
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="581616564"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.130.243])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 03:18:43 -0700
Date:   Thu, 11 Aug 2022 12:18:38 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     =?UTF-8?Q?Old=C5=99ich_Jedli=C4=8Dka?= <oldium.pro@gmail.com>
Cc:     Kinga Tanska <kinga.tanska@linux.intel.com>,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/1] mdadm: enable Intel Alderlake RST VMD configuration
Message-ID: <20220811121838.0000585e@linux.intel.com>
In-Reply-To: <CALdrqORp1vTu+c8C9Pydn_ftGuSL_6QH1hhKe=Gd7Vo4AdrNKQ@mail.gmail.com>
References: <20220805100545.9369-1-oldium.pro@gmail.com>
        <20220805100545.9369-2-oldium.pro@gmail.com>
        <20220805135603.00002723@intel.linux.com>
        <CALdrqORp1vTu+c8C9Pydn_ftGuSL_6QH1hhKe=Gd7Vo4AdrNKQ@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Old=C5=99ich,

On Fri, 5 Aug 2022 14:50:36 +0200
Old=C5=99ich Jedli=C4=8Dka <oldium.pro@gmail.com> wrote:

> p=C3=A1 5. 8. 2022 v 13:56 odes=C3=ADlatel Kinga Tanska
> <kinga.tanska@linux.intel.com> napsal:
> >
> > On Fri,  5 Aug 2022 12:05:45 +0200
> > Old=C5=99ich Jedli=C4=8Dka <oldium.pro@gmail.com> wrote:
> >
> > > Alderlake changed UEFI variable name to 'RstVmdV' also and for VMD
> > > devices, so check the updated name for VMD devices like it is done in
> > > the SATA case.

Alderlake is RST so it doesn't changed, it is different. It is a support for
RST family product.
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
> > > *find_imsm_hba_orom(struct sys_dev *hba) #define AHCI_PROP "RstSataV"
> > >  #define AHCI_SSATA_PROP "RstsSatV"
> > >  #define AHCI_TSATA_PROP "RsttSatV"
> > > -#define AHCI_RST_PROP "RstVmdV"
> > > -#define VMD_PROP "RstUefiV"
> > > +#define RST_VMD_PROP "RstVmdV"
> > > +#define RST_UEFI_PROP "RstUefiV"

There are two products RSTe/ VROC and RST.  Here you are adding support for=
 RST
platform. Please name it accordingly (yeah, I know that naming is confusing=
).
I propose:

#define RST_VMD_PROP "RstVmdV"
#define VROC_VMD_PROP "RstUefiV"

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
> > > -             if (!read_efi_variable(&orom, sizeof(orom), VMD_PROP,
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
>=20
> Hi, the described issue applies specifically in the SYS_DEV_SATA (SATA
> configuration) case, so it should not apply to SYS_DEV_VMD (VMD configura=
tion)
> one.
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
> Without the patch the platform isn't even recognized. Common to both chan=
ges
> is the usage of the new UEFI variable 'RstVmdV', not the changes to the
> controller.
>=20

This version is different than one sent by Coly. We will test that to see i=
f it
doesn't cause regression in our VROC product.
I noted  some nits, we will test this version anyway.

Thanks,
Mariusz

