Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67767C00140
	for <linux-raid@archiver.kernel.org>; Fri,  5 Aug 2022 11:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbiHEL4K (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 5 Aug 2022 07:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiHEL4I (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 5 Aug 2022 07:56:08 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267CE2F029
        for <linux-raid@vger.kernel.org>; Fri,  5 Aug 2022 04:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659700567; x=1691236567;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k5UYo73EM1d8EtIaAHNW3SsDeJnRs5dnrxahBffdgsQ=;
  b=ZllYFHMR1Px5FwSBr+jv5XZyC0xl0XtPTPittoz1D5MLJRWz/RLUFaiI
   o9s02G8+UDktesvb+Zoa5uoD5uFNqjVsyvdbhNiM2L5ZVIeHP92ouEHZg
   SGw2dcqIuueBRFmRiorfp608adaBsoGI59ylje3m4NcPS18l07FzZdNau
   AK3FnqanNudtoqHm4MtM2qdZnupDhzUAZzo8tbJaQjPwpLPwT4hautU9K
   8a1dPv10pwOLpOxkp3brKU/yR4JSY88ZvYgYCCVF8CoUjhLdblcifILGZ
   FB4GReYnvlGdZ1Ha6uXBlZ1iv7nsS45ptHtV77aKci+kIaLRVHBOXo+Uc
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10429"; a="269955954"
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="269955954"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 04:56:06 -0700
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="554087408"
Received: from ktanska-mobl1.ger.corp.intel.com (HELO intel.linux.com) ([10.213.19.214])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 04:56:05 -0700
Date:   Fri, 5 Aug 2022 13:56:03 +0200
From:   Kinga Tanska <kinga.tanska@linux.intel.com>
To:     =?UTF-8?Q?Old=C5=99ich_Jedli=C4=8Dka?= <oldium.pro@gmail.com>
Cc:     linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/1] mdadm: enable Intel Alderlake RST VMD configuration
Message-ID: <20220805135603.00002723@intel.linux.com>
In-Reply-To: <20220805100545.9369-2-oldium.pro@gmail.com>
References: <20220805100545.9369-1-oldium.pro@gmail.com>
        <20220805100545.9369-2-oldium.pro@gmail.com>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri,  5 Aug 2022 12:05:45 +0200
Old=C5=99ich Jedli=C4=8Dka <oldium.pro@gmail.com> wrote:

> Alderlake changed UEFI variable name to 'RstVmdV' also and for VMD
> devices, so check the updated name for VMD devices like it is done in
> the SATA case.
>=20
> Signed-off-by: Old=C5=99ich Jedli=C4=8Dka <oldium.pro@gmail.com>
> ---
>  platform-intel.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
>=20
> diff --git a/platform-intel.c b/platform-intel.c
> index a4d55a3..2f8e6af 100644
> --- a/platform-intel.c
> +++ b/platform-intel.c
> @@ -512,8 +512,8 @@ static const struct imsm_orom
> *find_imsm_hba_orom(struct sys_dev *hba) #define AHCI_PROP "RstSataV"
>  #define AHCI_SSATA_PROP "RstsSatV"
>  #define AHCI_TSATA_PROP "RsttSatV"
> -#define AHCI_RST_PROP "RstVmdV"
> -#define VMD_PROP "RstUefiV"
> +#define RST_VMD_PROP "RstVmdV"
> +#define RST_UEFI_PROP "RstUefiV"
> =20
>  #define VENDOR_GUID \
>  	EFI_GUID(0x193dfefa, 0xa445, 0x4302, 0x99, 0xd8, 0xef, 0x3a,
> 0xad, 0x1a, 0x04, 0xc6) @@ -607,7 +607,8 @@ const struct imsm_orom
> *find_imsm_efi(struct sys_dev *hba) struct orom_entry *ret;
>  	static const char * const sata_efivars[] =3D {AHCI_PROP,
> AHCI_SSATA_PROP, AHCI_TSATA_PROP,
> -						    AHCI_RST_PROP};
> +						    RST_VMD_PROP};
> +	static const char * const vmd_efivars[] =3D {RST_UEFI_PROP,
> RST_VMD_PROP}; unsigned long i;
> =20
>  	if (check_env("IMSM_TEST_AHCI_EFI") ||
> check_env("IMSM_TEST_SCU_EFI")) @@ -640,10 +641,14 @@ const struct
> imsm_orom *find_imsm_efi(struct sys_dev *hba)=20
>  		break;
>  	case SYS_DEV_VMD:
> -		if (!read_efi_variable(&orom, sizeof(orom), VMD_PROP,
> -				       VENDOR_GUID))
> -			break;
> -		return NULL;
> +		for (i =3D 0; i < ARRAY_SIZE(vmd_efivars); i++) {
> +			if (!read_efi_variable(&orom, sizeof(orom),
> +						vmd_efivars[i],
> VENDOR_GUID))
> +				break;
> +		}
> +		if (i =3D=3D ARRAY_SIZE(vmd_efivars))
> +			return NULL;
> +		break;
>  	default:
>  		return NULL;
>  	}

Hi,

please have a look at the following mail:
https://marc.info/?l=3Dlinux-raid&m=3D165969352101643&w=3D2

Regards,
Kinga Tanska
