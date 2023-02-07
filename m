Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5BEAC636CD
	for <linux-raid@archiver.kernel.org>; Tue,  7 Feb 2023 08:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbjBGIod (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Feb 2023 03:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbjBGIoc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Feb 2023 03:44:32 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587BC37550
        for <linux-raid@vger.kernel.org>; Tue,  7 Feb 2023 00:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675759470; x=1707295470;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fLO2SwPMbukc4NtUZ+XRkDguNqelp/VspDHICQHeYrg=;
  b=P1Yjw0wdr+nJDhPCpVyaJhsH7QXRT7Gxw3huxoSFUuF19BSdECbQluxn
   MBtHDkwHsXR6AlPfu/EHi32o6P4jg8kjGn9sgyIzQD/jnOQCP38qGSI/M
   Lmr4crsUi0k42IcqFYzoGtotBeH4abrhehK61EreMnnNGNyfkP/ykOq09
   z31vXy8PP8DhaYwh0FZIpiGmLdMEVCig3nOQFn19GbFyFHU5VkBQ5uM5d
   C8Nkz8EvoLBpYHZ8OTj3kxGuVsKYIEmfCHDGuD5sl33kDZyS+bmeHN1mn
   TjcJD3pxBHAh0DJTEye0YmwIckr6n6e1djYBOV6Pedze4vy6YKIkivFGq
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="328090952"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="328090952"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 00:44:29 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="912246877"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="912246877"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.37.29])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 00:44:28 -0800
Date:   Tue, 7 Feb 2023 09:44:23 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Kevin Friedberg <kev.friedberg@gmail.com>
Cc:     linux-raid@vger.kernel.org
Subject: Re: [PATCH] treat AHCI controllers under VMD as part of VMD
Message-ID: <20230207094423.00001a30@linux.intel.com>
In-Reply-To: <20230126021659.3801-1-kev.friedberg@gmail.com>
References: <20230126021659.3801-1-kev.friedberg@gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Kevin,
I found time to take a look into it closer. I think that it is not complete
solution. Please see my comments.

On Wed, 25 Jan 2023 21:16:59 -0500
Kevin Friedberg <kev.friedberg@gmail.com> wrote:

> Detect when a SATA controller has been mapped under Intel Alderlake RST
> VMD and list it as part of the domain, instead of independently, so that
> it can use the VMD controller's RAID capabilities.
> 
> Signed-off-by: Kevin Friedberg <kev.friedberg@gmail.com>
> ---
>  platform-intel.c | 15 +++++++++------
>  super-intel.c    | 25 ++++++++++++++++++++++++-
>  2 files changed, 33 insertions(+), 7 deletions(-)
> 
> diff --git a/platform-intel.c b/platform-intel.c
> index 757f0b1b..859bf743 100644
> --- a/platform-intel.c
> +++ b/platform-intel.c
> @@ -64,10 +64,12 @@ struct sys_dev *find_driver_devices(const char *bus,
> const char *driver) 
>  	if (strcmp(driver, "isci") == 0)
>  		type = SYS_DEV_SAS;
> -	else if (strcmp(driver, "ahci") == 0)
> +	else if (strcmp(driver, "ahci") == 0) {
> +		/* if looking for sata devs, ignore vmd */
> +		vmd = find_driver_devices("pci", "vmd");
>  		type = SYS_DEV_SATA;
> -	else if (strcmp(driver, "nvme") == 0) {
> -		/* if looking for nvme devs, first look for vmd */
> +	} else if (strcmp(driver, "nvme") == 0) {
> +		/* if looking for nvme devs, also look for vmd */
>  		vmd = find_driver_devices("pci", "vmd");
>  		type = SYS_DEV_NVME;
>  	} else if (strcmp(driver, "vmd") == 0)
> @@ -104,8 +106,8 @@ struct sys_dev *find_driver_devices(const char *bus,
> const char *driver) sprintf(path, "/sys/bus/%s/drivers/%s/%s",
>  			bus, driver, de->d_name);
>  
> -		/* if searching for nvme - skip vmd connected one */
> -		if (type == SYS_DEV_NVME) {
> +		/* if searching for nvme or ahci - skip vmd connected one */
> +		if (type == SYS_DEV_NVME || type == SYS_DEV_SATA) {
>  			struct sys_dev *dev;
>  			char *rp = realpath(path, NULL);
>  			for (dev = vmd; dev; dev = dev->next) {
> @@ -166,7 +168,8 @@ struct sys_dev *find_driver_devices(const char *bus,
> const char *driver) }
>  	closedir(driver_dir);
>  
> -	if (vmd) {
> +	/* VMD adopts multiple types but should only be listed once */
> +	if (vmd && type == SYS_DEV_NVME) {
>  		if (list)
>  			list->next = vmd;
>  		else

The SATA behind VMD deserves own type, let say SYS_DEV_SATA_VMD. We cannot use
SYS_DEV_VMD because it will allow to use NVME devices behind VMD in SATA Raid
array. It means that if you have them connected, like:
VMD___ NVME0
    |_ NVME1
    |_ SATA___SATA0
           |__SATA1
You will be able to mix SATA and NVME drives together in RAID. Mdmonitor
could mix them too (if appropriate policy is set). That is not allowed from at
least VROC requirements PoV.

> diff --git a/super-intel.c b/super-intel.c
> index 89fac626..4ef8f0d8 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -2680,6 +2680,8 @@ static void print_imsm_capability_export(const struct
> imsm_orom *orom) printf("IMSM_MAX_VOLUMES_PER_CONTROLLER=%d\n",orom->vphba);
>  }
>  
> +#define PCI_CLASS_AHCI_CNTRL "0x010601"
This should be defined in platform-intel.h

> +
>  static int detail_platform_imsm(int verbose, int enumerate_only, char
> *controller_path) {
>  	/* There are two components to imsm platform support, the ahci SATA
> @@ -2752,11 +2754,32 @@ static int detail_platform_imsm(int verbose, int
> enumerate_only, char *controlle for (hba = list; hba; hba = hba->next) {
>  				if (hba->type == SYS_DEV_VMD) {
>  					char buf[PATH_MAX];
> +					struct dirent *ent;
> +					DIR *dir;
> +
>  					printf(" I/O Controller : %s (%s)\n",
>  						vmd_domain_to_controller(hba,
> buf), get_sys_dev_type(hba->type));
> +					dir = opendir(hba->path);
> +					for (ent = readdir(dir); ent; ent =
> readdir(dir)) {
> +						char ent_path[PATH_MAX];
> +
> +						sprintf(ent_path, "%s/%s",
> hba->path, ent->d_name);
> +						devpath_to_char(ent_path,
> "class", buf, sizeof(buf), 0);
> +						if (strcmp(buf,
> PCI_CLASS_AHCI_CNTRL) == 0) {
> +							host_base =
> ahci_get_port_count(ent_path, &port_count);
> +							if
> (ahci_enumerate_ports(ent_path, port_count, host_base, verbose)) {
> +								if (verbose
> > 0)
> +
> pr_err("failed to enumerate ports on VMD SATA controller at %s.\n",
> +
> hba->pci_id);
> +								result |= 2;
> +							}
> +						}
> +					}
> +					closedir(dir);
> +
>  					if (print_nvme_info(hba)) {
>  						if (verbose > 0)
> -							pr_err("failed to
> get devices attached to VMD domain.\n");
> +							pr_err("failed to
> get NVMe devices attached to VMD domain.\n"); result |= 2;
>  					}
>  				}
Similar logic is already there:
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/super-intel.c#n2780
I would like to reuse it instead of adding new code branch. Could you please
extract similar parts to new function and use it in both places?

Thanks,
Mariusz
