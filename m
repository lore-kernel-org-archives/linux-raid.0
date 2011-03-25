From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: Please update mdadm 3.2.1 release
Date: Fri, 25 Mar 2011 15:58:22 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D1920D93D4@irsmsx503.ger.corp.intel.com>
References: <66C59AD0932712458090B447266D638C012841F2C3@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66C59AD0932712458090B447266D638C012841F2C3@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

Hi Neil, 
Please include both fixes in mdadm 3.2.1 release:
RE: [PATCH 1/2] imsm: remove OEM table from detection of OROM and EFI.
RE: [PATCH 2/2] imsm: reading of UEFI variables needs an update

The first one removes OEM parameter table reading. We no longer scan OROM for "$OEM" string or read EFI "RstScuO" variable.
They do not contain the information that we are looking for.
The second one sets correct directory and file name for EFI RST version table.

The fixes are a minor change to mdadm as whole, but enable proper handling of EFI/OROM information.

Thank you,
Marcin Labun



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Hawrylewicz Czarnowski, Przemyslaw
> Sent: Friday, March 25, 2011 4:18 PM
> To: NeilBrown
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Neubauer, Wojciech
> Subject: [PATCH 1/2] imsm: remove OEM table from detection of OROM and
> EFI.
> 
> OEM table does not suit our needs so it cannot be used.
> This patch removes feature added in commit 8a0bf4f378c8b.
> 
> Signed-off-by: Przemyslaw Czarnowski
> <przemyslaw.hawrylewicz.czarnowski@intel.com>
> ---
>  platform-intel.c |   10 +---------
>  1 files changed, 1 insertions(+), 9 deletions(-)
> 
> diff --git a/platform-intel.c b/platform-intel.c
> index 64542b9..fe6785c 100644
> --- a/platform-intel.c
> +++ b/platform-intel.c
> @@ -236,8 +236,7 @@ static int scan(const void *start, const void *end,
> const void *data)
> 
>  	for (offset = 0; offset < len; offset += 4) {
>  		imsm_mem = start + offset;
> -		if ((memcmp(imsm_mem->signature, "$VER", 4) == 0) ||
> -		    (memcmp(imsm_mem->signature, "$OEM", 4) == 0)) {
> +		if ((memcmp(imsm_mem->signature, "$VER", 4) == 0)) {
>  			imsm_orom[dev] = *imsm_mem;
>  			populated_orom[dev] = 1;
>  			return populated_orom[SYS_DEV_SATA] &&
> populated_orom[SYS_DEV_SAS];
> @@ -349,7 +348,6 @@ static const struct imsm_orom
> *find_imsm_hba_orom(enum sys_dev_type hba_id)
> 
>  #define SYS_EFI_VAR_PATH "/sys/firmware/efi/vars"
>  #define SCU_PROP "RstScuV"
> -#define SCU_PROP_OEM "RstScuO"
>  #define AHCI_PROP "RstSataV"
> 
>  #define VENDOR_GUID \
> @@ -395,12 +393,6 @@ const struct imsm_orom *find_imsm_efi(enum
> sys_dev_type hba_id)
> 
>  	dprintf("EFI VAR: path=%s\n", path);
>  	dfd = open(path, O_RDONLY);
> -	if ((dfd < 0) && (hba_id == SYS_DEV_SAS)) {
> -		/* check OEM parameters */
> -		snprintf(path, PATH_MAX, "%s/%s-%s", SYS_EFI_VAR_PATH,
> SCU_PROP_OEM, guid_str(buf, VENDOR_GUID));
> -		dfd = open(path, O_RDONLY);
> -		dprintf("EFI VAR: path=%s\n", path);
> -	}
>  	if (dfd < 0) {
>  		populated_efi[hba_id] = 0;
>  		return NULL;
> --
> 1.7.3.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
