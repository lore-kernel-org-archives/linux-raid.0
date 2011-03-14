From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] platfrom_intel: find OROM based on Intel AHCI and SAS
 driver device id
Date: Mon, 14 Mar 2011 18:22:29 +1100
Message-ID: <20110314182229.4bbc8792@notabene.brown>
References: <905EDD02F158D948B186911EB64DB3D17A919051@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D17A919051@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Fri, 11 Mar 2011 17:00:04 +0000 "Labun, Marcin" <Marcin.Labun@intel.com>
wrote:

> Hi Neil,
> This patch is answer to the Dan's proposal to NOT maintain the device ids in the mdadm code:
> > The driver will always have the latest knowledge of the supported device ids so we can always rely on it to identify our raid controller (i.e.
> > pci devices with vendor id == 0x8086 and driven by isci or ahci).
> Therefore, we get the device id from sysfs entry "device" exposed by Intel AHCI or SAS driver. The retrieved device id is compared the one in the PCI Express Data Structure.
> In consequence, the respective OROM properties can be found by mdadm when AHCI or SAS driver are loaded in the system.
> Additionally, Intel devices are retried before each OROM scan and released right after the scan.
> 
> I have prepared it and tested on top of your devel-3.2 branch (commit	ca6529edf6f721600386 Merge branch 'master' into devel-3.2).
> 
> Thanks,
> Marcin Labun


Applied- thanks.

NeilBrown




> 
> 
> 
> >From dc8efff073b4f8333ff8903cbd11159f7d779dc4 Mon Sep 17 00:00:00 2001
> From: Marcin Labun <marcin.labun@intel.com>
> Date: Fri, 11 Mar 2011 17:28:02 +0100
> Subject: [PATCH] platfrom_intel: find OROM based on Intel AHCI and SAS driver device id
> 
> We use PCI device id exposed by AHCI and ISCU drivers (SAS controller)
> to find OROM version table.
> In this way there is no need to maintain AHCI and ISCU device id list
> in mdadm. The consequence is that the OROM properties can be found by mdadm when AHCI or 
> SAS drivers are loaded in the system.
> 
> Signed-off-by: Marcin Labun <marcin.labun@intel.com>
> ---
>  platform-intel.c |   79 +++++++++++++++++++++++++++++++++++++++++-------------
>  platform-intel.h |    1 +
>  2 files changed, 61 insertions(+), 19 deletions(-)
> 
> diff --git a/platform-intel.c b/platform-intel.c
> index 0595382..c24dcf8 100644
> --- a/platform-intel.c
> +++ b/platform-intel.c
> @@ -31,6 +31,9 @@
>  #include <limits.h>
>  
>  
> +static int devpath_to_ll(const char *dev_path, const char *entry,
> +			 unsigned long long *val);
> +
>  static __u16 devpath_to_vendor(const char *dev_path);
>  
>  void free_sys_dev(struct sys_dev **list)
> @@ -56,6 +59,7 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
>  	struct sys_dev *head = NULL;
>  	struct sys_dev *list = NULL;
>  	enum sys_dev_type type;
> +	unsigned long long dev_id;
>  
>  	if (strcmp(driver, "isci") == 0)
>  		type = SYS_DEV_SAS;
> @@ -93,6 +97,9 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
>  		if (devpath_to_vendor(path) != 0x8086)
>  			continue;
>  
> +		if (devpath_to_ll(path, "device", &dev_id) != 0)
> +			continue;
> +
>  		/* start / add list entry */
>  		if (!head) {
>  			head = malloc(sizeof(*head));
> @@ -107,6 +114,7 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
>  			break;
>  		}
>  
> +		list->dev_id = (__u16) dev_id;
>  		list->type = type;
>  		list->path = canonicalize_file_name(path);
>  		list->next = NULL;
> @@ -118,6 +126,35 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
>  }
>  
>  
> +static struct sys_dev *intel_devices=NULL;
> +
> +static enum sys_dev_type device_type_by_id(__u16 device_id)
> +{
> +	struct sys_dev *iter;
> +
> +	for(iter = intel_devices; iter != NULL; iter = iter->next)
> +		if (iter->dev_id == device_id)
> +			return iter->type;
> +	return SYS_DEV_UNKNOWN;
> +}
> +
> +static int devpath_to_ll(const char *dev_path, const char *entry, unsigned long long *val)
> +{
> +	char path[strlen(dev_path) + strlen(entry) + 2];
> +	int fd;
> +	int n;
> +
> +	sprintf(path, "%s/%s", dev_path, entry);
> +
> +	fd = open(path, O_RDONLY);
> +	if (fd < 0)
> +		return -1;
> +	n = sysfs_fd_get_ll(fd, val);
> +	close(fd);
> +	return n;
> +}
> +
> +
>  static __u16 devpath_to_vendor(const char *dev_path)
>  {
>  	char path[strlen(dev_path) + strlen("/vendor") + 1];
> @@ -160,17 +197,6 @@ struct sys_dev *find_intel_devices(void)
>  	return ahci;
>  }
>  
> -static int platform_has_intel_devices(void)
> -{
> -	struct sys_dev *devices;
> -	devices = find_intel_devices();
> -	if (devices) {
> -		free_sys_dev(&devices);
> -		return 1;
> -	}
> -	return 0;
> -}
> -
>  /*
>   * PCI Expansion ROM Data Structure Format */
>  struct pciExpDataStructFormat {
> @@ -190,16 +216,21 @@ static int scan(const void *start, const void *end, const void *data)
>  	int len = (end - start);
>  	struct pciExpDataStructFormat *ptr= (struct pciExpDataStructFormat *)data;
>  
> +	if (data + 0x18 > end) {
> +		dprintf("cannot find pciExpDataStruct \n");
> +		return 0;
> +	}
> +	  
>  	dprintf("ptr->vendorID: %lx __le16_to_cpu(ptr->deviceID): %lx \n",
>  		(ulong) __le16_to_cpu(ptr->vendorID),
>  		(ulong) __le16_to_cpu(ptr->deviceID));
>  
> -	if ((__le16_to_cpu(ptr->vendorID) == 0x8086) &&
> -	    (__le16_to_cpu(ptr->deviceID) == 0x2822))
> -		dev = SYS_DEV_SATA;
> -	else if ((__le16_to_cpu(ptr->vendorID) == 0x8086) &&
> -		 (__le16_to_cpu(ptr->deviceID) == 0x1D60))
> -		dev = SYS_DEV_SAS;
> +	if (__le16_to_cpu(ptr->vendorID) == 0x8086) {
> +		/* serach  attached intel devices by device id from OROM */
> +		dev = device_type_by_id(__le16_to_cpu(ptr->deviceID));
> +		if (dev == SYS_DEV_UNKNOWN)
> +			return 0;
> +	}
>  	else
>  		return 0;
>  
> @@ -275,7 +306,13 @@ static const struct imsm_orom *find_imsm_hba_orom(enum sys_dev_type hba_id)
>  	    check_env("IMSM_TEST_SCU_EFI"))
>  		return NULL;
>  
> -	if (!platform_has_intel_devices())
> +	
> +	if (intel_devices != NULL)
> +		free_sys_dev(&intel_devices);
> +
> +	intel_devices = find_intel_devices();
> +
> +	if (intel_devices == NULL)
>  		return NULL;
>  
>  	/* scan option-rom memory looking for an imsm signature */
> @@ -286,10 +323,14 @@ static const struct imsm_orom *find_imsm_hba_orom(enum sys_dev_type hba_id)
>  	if (probe_roms_init(align) != 0)
>  		return NULL;
>  	probe_roms();
> -	/* ignore result - True is returned if both are found */
> +	/* ignore return value - True is returned if both adapater roms are found */
>  	scan_adapter_roms(scan);
>  	probe_roms_exit();
>  
> +	if (intel_devices != NULL)
> +		free_sys_dev(&intel_devices);
> +	intel_devices = NULL;
> +
>  	if (populated_orom[hba_id])
>  		return &imsm_orom[hba_id];
>  	return NULL;
> diff --git a/platform-intel.h b/platform-intel.h
> index 0cba6c7..e24ae37 100644
> --- a/platform-intel.h
> +++ b/platform-intel.h
> @@ -194,6 +194,7 @@ struct sys_dev {
>  	enum sys_dev_type type;
>  	char *path;
>  	char *pci_id;
> +	__u16  dev_id;
>  	struct sys_dev *next;
>  };
>  

