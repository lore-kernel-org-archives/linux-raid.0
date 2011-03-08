From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 02/14] Platform-intel: support for OROM SAS and AHCI
 controller
Date: Tue, 08 Mar 2011 15:17:37 -0800
Message-ID: <1299626257.5920.290.camel@dwillia2-linux>
References: <905EDD02F158D948B186911EB64DB3D17A8AEC8B@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D17A8AEC8B@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: NeilBrown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Tue, 2011-03-08 at 07:20 -0800, Labun, Marcin wrote:
> -static struct imsm_orom imsm_orom;
> +static struct imsm_orom imsm_orom[SYS_DEV_MAX];
> +static int populated_orom[SYS_DEV_MAX];
> +
>  static int scan(const void *start, const void *end, const void *data)
>  {
>  	int offset;
>  	const struct imsm_orom *imsm_mem;
> +	int dev;
>  	int len = (end - start);
>  	struct pciExpDataStructFormat *ptr= (struct pciExpDataStructFormat *)data;

Why add another parameter to this function?  The scan routine can simply
look at offset 0x18 right?
 
> @@ -187,46 +194,85 @@ static int scan(const void *start, const void *end, const void *data)
>  		(ulong) __le16_to_cpu(ptr->vendorID),
>  		(ulong) __le16_to_cpu(ptr->deviceID));
>  
> -	if (!((__le16_to_cpu(ptr->vendorID) == 0x8086) &&
> -	      (__le16_to_cpu(ptr->deviceID) == 0x2822)))
> +	if ((__le16_to_cpu(ptr->vendorID) == 0x8086) &&
> +	    (__le16_to_cpu(ptr->deviceID) == 0x2822))
> +		dev = SYS_DEV_SATA;
> +	else if ((__le16_to_cpu(ptr->vendorID) == 0x8086) &&
> +		 (__le16_to_cpu(ptr->deviceID) == 0x1D60))
> +		dev = SYS_DEV_SAS;
> +	else

Are you sure this list is sufficient?  I don't think we want to get into
the responsibility of maintaining pci device ids in mdadm.  There are
many ahci raid devices, and at least 14 other sas device ids that might
match.  The orom might also be using the device list, i.e. the first id
in the pci firmware data structure might not match the pci device in the
system.

The driver will always have the latest knowledge of the supported device
ids so we can always rely on it to identify our raid controller (i.e.
pci devices with vendor id == 0x8086 and driven by isci or ahci)

I recently submitted a patch to update the kernel's probe_roms interface
[1].  It might be cleaner and more future-proof if find_imsm_orom() took
a parameter as to which orom it should find, like pci_map_biosrom.  At
alloc_super() time we would just find all the relevant oroms based on
what devices are in the system, rather than blindly scanning option-rom
space and comparing against a device id list that may get out of date.

--
Dan

[1]: http://marc.info/?l=linux-kernel&m=129960935312751&w=2


