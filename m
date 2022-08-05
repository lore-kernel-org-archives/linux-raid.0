Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DF46C00140
	for <linux-raid@archiver.kernel.org>; Fri,  5 Aug 2022 10:03:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236370AbiHEKDB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 5 Aug 2022 06:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232412AbiHEKC7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 5 Aug 2022 06:02:59 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9265A896
        for <linux-raid@vger.kernel.org>; Fri,  5 Aug 2022 03:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659693778; x=1691229778;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n74WVAtQIHYaasHKci+cRlH5R/ZWZLJdeX0a5cMcJlk=;
  b=Z1CglA6bqbpPEOBZr6Pfl+4VQet+56+JwwLEK0XWhz7GtXZmhOUVNbtX
   9PWjWlTG6zhBUQzhmRFQ7DgdxbHGojmzCOVm1OIl+TO8+pNPy0/Bu+o+h
   1EBbD+gLNYpKUfdAcS75YnrkXTAObEerfxy5GYRdGNx2x7I3J97Aupyug
   t3mvcmm4jWWCRcY6tjpVy75Q5oqNH7EBhM/SMEtQ3ihTRXI7IG6SbGeUo
   WL8UsKTbBUDpWVIqgkxrnrQw7s54GM3SseeSwOb5NiZ7tOUmzuIvFyeAN
   QujDfguX9FMU+T4AqMzkkcEyaXVLG2UqrBwOkjsHFLdHsMcvmdjDCL2BC
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10429"; a="290942966"
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="290942966"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 03:02:57 -0700
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="579449001"
Received: from ktanska-mobl1.ger.corp.intel.com (HELO intel.linux.com) ([10.213.19.214])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 03:02:56 -0700
Date:   Fri, 5 Aug 2022 12:02:53 +0200
From:   Kinga Tanska <kinga.tanska@linux.intel.com>
To:     Coly Li <colyli@suse.de>, Hannes Reinecke <hare@suse.de>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 19/23] mdadm: enable Intel Alderlake RSTe configuration
Message-ID: <20220805120119.00000087@intel.linux.com>
In-Reply-To: <20220728122101.28744-20-colyli@suse.de>
References: <20220728122101.28744-1-colyli@suse.de>
 <20220728122101.28744-20-colyli@suse.de>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 28 Jul 2022 20:20:57 +0800
Coly Li <colyli@suse.de> wrote:

> From: Hannes Reinecke <hare@suse.de>
> 
> Alderlake has a slightly different RST configuration; the UEFI
> variable is name 'RstVmdV', and the AHCI controller shows up as
> a child device of the VMD bridge, but continues to use the 'AHCI HBA'
> PCI class (and not the RAID class as RSTe would normally do).
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Acked-by: Coly Li <colyli@suse.de>
> ---
>  platform-intel.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/platform-intel.c b/platform-intel.c
> index 5a8729e7..a4d55a38 100644
> --- a/platform-intel.c
> +++ b/platform-intel.c
> @@ -512,12 +512,14 @@ static const struct imsm_orom
> *find_imsm_hba_orom(struct sys_dev *hba) #define AHCI_PROP "RstSataV"
>  #define AHCI_SSATA_PROP "RstsSatV"
>  #define AHCI_TSATA_PROP "RsttSatV"
> +#define AHCI_RST_PROP "RstVmdV"
>  #define VMD_PROP "RstUefiV"
>  
>  #define VENDOR_GUID \
>  	EFI_GUID(0x193dfefa, 0xa445, 0x4302, 0x99, 0xd8, 0xef, 0x3a,
> 0xad, 0x1a, 0x04, 0xc6) 
>  #define PCI_CLASS_RAID_CNTRL 0x010400
> +#define PCI_CLASS_SATA_HBA 0x010601
>  
>  static int read_efi_var(void *buffer, ssize_t buf_size,
>  			const char *variable_name, struct efi_guid
> guid) @@ -604,7 +606,8 @@ const struct imsm_orom
> *find_imsm_efi(struct sys_dev *hba) struct imsm_orom orom;
>  	struct orom_entry *ret;
>  	static const char * const sata_efivars[] = {AHCI_PROP,
> AHCI_SSATA_PROP,
> -						    AHCI_TSATA_PROP};
> +						    AHCI_TSATA_PROP,
> +						    AHCI_RST_PROP};
>  	unsigned long i;
>  
>  	if (check_env("IMSM_TEST_AHCI_EFI") ||
> check_env("IMSM_TEST_SCU_EFI")) @@ -622,7 +625,8 @@ const struct
> imsm_orom *find_imsm_efi(struct sys_dev *hba) 
>  		return NULL;
>  	case SYS_DEV_SATA:
> -		if (hba->class != PCI_CLASS_RAID_CNTRL)
> +		if (hba->class != PCI_CLASS_RAID_CNTRL &&
> +		    hba->class != PCI_CLASS_SATA_HBA)
>  			return NULL;
>  
>  		for (i = 0; i < ARRAY_SIZE(sata_efivars); i++) {


Hi,

This patch causes a regression. I've checked how SATA controllers will
be visible in --detail-platform output for IMSM. If RAID mode will be
turned on for one of the SATA controllers, rest of them will be also
visible as supported ones.
Please analyze this scenario.

Regards,
Kinga Tanska
