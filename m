From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] platform_intel: support EFI SCU OEM variable
Date: Sun, 20 Mar 2011 15:49:32 +1100
Message-ID: <20110320154932.48065c4a@notabene.brown>
References: <905EDD02F158D948B186911EB64DB3D17AA31B27@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D17AA31B27@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Fri, 18 Mar 2011 14:34:22 +0000 "Labun, Marcin" <Marcin.Labun@intel.com>
wrote:

> >From 0d5cf1adbe2fb966db199aef5f135d9cf8cc72b9 Mon Sep 17 00:00:00 2001
> From: Marcin Labun <marcin.labun@intel.com>
> Date: Fri, 18 Mar 2011 13:58:24 +0100
> Subject: [PATCH] platform_intel: support EFI SCU OEM variable
> 
> RstScuV and RstScuO variable names are supported.
> First try reading from RstScuV, when it fails try RstScuO.
> 
> Signed-off-by: Marcin Labun <marcin.labun@intel.com>
> Tested-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
> ---
>  platform-intel.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/platform-intel.c b/platform-intel.c
> index 8003da6..64542b9 100644
> --- a/platform-intel.c
> +++ b/platform-intel.c
> @@ -349,6 +349,7 @@ static const struct imsm_orom *find_imsm_hba_orom(enum sys_dev_type hba_id)
>  
>  #define SYS_EFI_VAR_PATH "/sys/firmware/efi/vars"
>  #define SCU_PROP "RstScuV"
> +#define SCU_PROP_OEM "RstScuO"
>  #define AHCI_PROP "RstSataV"
>  
>  #define VENDOR_GUID \
> @@ -393,8 +394,14 @@ const struct imsm_orom *find_imsm_efi(enum sys_dev_type hba_id)
>  		snprintf(path, PATH_MAX, "%s/%s-%s", SYS_EFI_VAR_PATH, AHCI_PROP, guid_str(buf, VENDOR_GUID));
>  
>  	dprintf("EFI VAR: path=%s\n", path);
> -
> -	if ((dfd = open(path, O_RDONLY)) < 0) {
> +	dfd = open(path, O_RDONLY);
> +	if ((dfd < 0) && (hba_id == SYS_DEV_SAS)) {
> +		/* check OEM parameters */
> +		snprintf(path, PATH_MAX, "%s/%s-%s", SYS_EFI_VAR_PATH, SCU_PROP_OEM, guid_str(buf, VENDOR_GUID));
> +		dfd = open(path, O_RDONLY);
> +		dprintf("EFI VAR: path=%s\n", path);
> +	}
> +	if (dfd < 0) {
>  		populated_efi[hba_id] = 0;
>  		return NULL;
>  	}


Applied, thanks.

NeilBrown
