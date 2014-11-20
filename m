From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/5] imsm: support for OROMs shared by multiple HBAs
Date: Thu, 20 Nov 2014 14:07:48 +1100
Message-ID: <20141120140748.6daa763a@notabene.brown>
References: <1416401610-16209-1-git-send-email-artur.paszkiewicz@intel.com>
	<1416401610-16209-2-git-send-email-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/MZUfbdwFC9.XDX_2H=Vjh8m"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1416401610-16209-2-git-send-email-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

--Sig_/MZUfbdwFC9.XDX_2H=Vjh8m
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 19 Nov 2014 13:53:26 +0100 Artur Paszkiewicz
<artur.paszkiewicz@intel.com> wrote:

> HBAs can share OROMs (e.g. SATA/sSATA). They are matched by PCI device
> id. Removed populated_orom/efi and imsm_orom/efi arrays - they are
> replaced by oroms array and functions get_orom_by_device_id(),
> add_orom(), add_orom_device_id().
>=20
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>

Hi,
 this patch seems to make a lot more changes that the above brief descripti=
on
 seems to suggest.
 Is there any chance of breaking it up into two or three parts, or at least
 describing everything that is being changed.

 I'm half tempted to just accept it as it is, as it is just "your" code that
 that is being changed, but I'd like to understand it if I can.

Thanks,
NeilBrown


> ---
>  platform-intel.c | 248 ++++++++++++++++++++++++++++++++-----------------=
------
>  platform-intel.h |   5 +-
>  super-intel.c    | 134 +++++++++++++++++++++---------
>  3 files changed, 243 insertions(+), 144 deletions(-)
>=20
> diff --git a/platform-intel.c b/platform-intel.c
> index f347382..f779d02 100644
> --- a/platform-intel.c
> +++ b/platform-intel.c
> @@ -59,6 +59,7 @@ struct sys_dev *find_driver_devices(const char *bus, co=
nst char *driver)
>  	struct sys_dev *list =3D NULL;
>  	enum sys_dev_type type;
>  	unsigned long long dev_id;
> +	unsigned long long class;
> =20
>  	if (strcmp(driver, "isci") =3D=3D 0)
>  		type =3D SYS_DEV_SAS;
> @@ -99,6 +100,9 @@ struct sys_dev *find_driver_devices(const char *bus, c=
onst char *driver)
>  		if (devpath_to_ll(path, "device", &dev_id) !=3D 0)
>  			continue;
> =20
> +		if (devpath_to_ll(path, "class", &class) !=3D 0)
> +			continue;
> +
>  		/* start / add list entry */
>  		if (!head) {
>  			head =3D xmalloc(sizeof(*head));
> @@ -114,6 +118,7 @@ struct sys_dev *find_driver_devices(const char *bus, =
const char *driver)
>  		}
> =20
>  		list->dev_id =3D (__u16) dev_id;
> +		list->class =3D (__u32) class;
>  		list->type =3D type;
>  		list->path =3D realpath(path, NULL);
>  		list->next =3D NULL;
> @@ -127,16 +132,6 @@ struct sys_dev *find_driver_devices(const char *bus,=
 const char *driver)
>  static struct sys_dev *intel_devices=3DNULL;
>  static time_t valid_time =3D 0;
> =20
> -static enum sys_dev_type device_type_by_id(__u16 device_id)
> -{
> -	struct sys_dev *iter;
> -
> -	for(iter =3D intel_devices; iter !=3D NULL; iter =3D iter->next)
> -		if (iter->dev_id =3D=3D device_id)
> -			return iter->type;
> -	return SYS_DEV_UNKNOWN;
> -}
> -
>  static int devpath_to_ll(const char *dev_path, const char *entry, unsign=
ed long long *val)
>  {
>  	char path[strlen(dev_path) + strlen(entry) + 2];
> @@ -209,16 +204,79 @@ struct pciExpDataStructFormat {
>  	__u8  ver[4];
>  	__u16 vendorID;
>  	__u16 deviceID;
> +	__u16 devListOffset;
>  } __attribute__ ((packed));
> =20
> -static struct imsm_orom imsm_orom[SYS_DEV_MAX];
> -static int populated_orom[SYS_DEV_MAX];
> +struct devid_list {
> +	__u16 devid;
> +	struct devid_list *next;
> +};
> +
> +struct orom_entry {
> +	struct imsm_orom orom;
> +	struct devid_list *devid_list;
> +};
> +
> +static struct orom_entry oroms[SYS_DEV_MAX];
> +
> +const struct imsm_orom *get_orom_by_device_id(__u16 dev_id)
> +{
> +	int i;
> +	struct devid_list *list;
> +
> +	for (i =3D 0; i < SYS_DEV_MAX; i++) {
> +		for (list =3D oroms[i].devid_list; list; list =3D list->next) {
> +			if (list->devid =3D=3D dev_id)
> +				return &oroms[i].orom;
> +		}
> +	}
> +	return NULL;
> +}
> +
> +static const struct imsm_orom *add_orom(const struct imsm_orom *orom)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < SYS_DEV_MAX; i++) {
> +		if (&oroms[i].orom =3D=3D orom)
> +			return orom;
> +		if (oroms[i].orom.signature[0] =3D=3D 0) {
> +			oroms[i].orom =3D *orom;
> +			return &oroms[i].orom;
> +		}
> +	}
> +	return NULL;
> +}
> +
> +static void add_orom_device_id(const struct imsm_orom *orom, __u16 dev_i=
d)
> +{
> +	int i;
> +	struct devid_list *list;
> +	struct devid_list *prev =3D NULL;
> +
> +	for (i =3D 0; i < SYS_DEV_MAX; i++) {
> +		if (&oroms[i].orom =3D=3D orom) {
> +			for (list =3D oroms[i].devid_list; list; prev =3D list, list =3D list=
->next) {
> +				if (list->devid =3D=3D dev_id)
> +					return;
> +			}
> +			list =3D xmalloc(sizeof(struct devid_list));
> +			list->devid =3D dev_id;
> +			list->next =3D NULL;
> +
> +			if (prev =3D=3D NULL)
> +				oroms[i].devid_list =3D list;
> +			else
> +				prev->next =3D list;
> +			return;
> +		}
> +	}
> +}
> =20
>  static int scan(const void *start, const void *end, const void *data)
>  {
>  	int offset;
> -	const struct imsm_orom *imsm_mem;
> -	int dev;
> +	const struct imsm_orom *imsm_mem =3D NULL;
>  	int len =3D (end - start);
>  	struct pciExpDataStructFormat *ptr=3D (struct pciExpDataStructFormat *)=
data;
> =20
> @@ -231,81 +289,83 @@ static int scan(const void *start, const void *end,=
 const void *data)
>  		(ulong) __le16_to_cpu(ptr->vendorID),
>  		(ulong) __le16_to_cpu(ptr->deviceID));
> =20
> -	if (__le16_to_cpu(ptr->vendorID) =3D=3D 0x8086) {
> -		/* serach  attached intel devices by device id from OROM */
> -		dev =3D device_type_by_id(__le16_to_cpu(ptr->deviceID));
> -		if (dev =3D=3D SYS_DEV_UNKNOWN)
> -			return 0;
> -	}
> -	else
> +	if (__le16_to_cpu(ptr->vendorID) !=3D 0x8086)
>  		return 0;
> =20
>  	for (offset =3D 0; offset < len; offset +=3D 4) {
> -		imsm_mem =3D start + offset;
> -		if ((memcmp(imsm_mem->signature, "$VER", 4) =3D=3D 0)) {
> -			imsm_orom[dev] =3D *imsm_mem;
> -			populated_orom[dev] =3D 1;
> -			return populated_orom[SYS_DEV_SATA] && populated_orom[SYS_DEV_SAS];
> +		const void *mem =3D start + offset;
> +
> +		if ((memcmp(mem, IMSM_OROM_SIGNATURE, 4) =3D=3D 0)) {
> +			imsm_mem =3D mem;
> +			break;
>  		}
>  	}
> +
> +	if (!imsm_mem)
> +		return 0;
> +
> +	const struct imsm_orom *orom =3D add_orom(imsm_mem);
> +
> +	if (ptr->devListOffset) {
> +		const __u16 *dev_list =3D (void *)ptr + ptr->devListOffset;
> +		int i;
> +
> +		for (i =3D 0; dev_list[i] !=3D 0; i++)
> +			add_orom_device_id(orom, dev_list[i]);
> +	} else {
> +		add_orom_device_id(orom, __le16_to_cpu(ptr->deviceID));
> +	}
> +
>  	return 0;
>  }
> =20
> -const struct imsm_orom *imsm_platform_test(enum sys_dev_type hba_id, int=
 *populated,
> -					   struct imsm_orom *imsm_orom)
> +const struct imsm_orom *imsm_platform_test(struct sys_dev *hba)
>  {
> -	memset(imsm_orom, 0, sizeof(*imsm_orom));
> -	imsm_orom->rlc =3D IMSM_OROM_RLC_RAID0 | IMSM_OROM_RLC_RAID1 |
> -				IMSM_OROM_RLC_RAID10 | IMSM_OROM_RLC_RAID5;
> -	imsm_orom->sss =3D IMSM_OROM_SSS_4kB | IMSM_OROM_SSS_8kB |
> -				IMSM_OROM_SSS_16kB | IMSM_OROM_SSS_32kB |
> -				IMSM_OROM_SSS_64kB | IMSM_OROM_SSS_128kB |
> -				IMSM_OROM_SSS_256kB | IMSM_OROM_SSS_512kB |
> -				IMSM_OROM_SSS_1MB | IMSM_OROM_SSS_2MB;
> -	imsm_orom->dpa =3D IMSM_OROM_DISKS_PER_ARRAY;
> -	imsm_orom->tds =3D IMSM_OROM_TOTAL_DISKS;
> -	imsm_orom->vpa =3D IMSM_OROM_VOLUMES_PER_ARRAY;
> -	imsm_orom->vphba =3D IMSM_OROM_VOLUMES_PER_HBA;
> -	imsm_orom->attr =3D imsm_orom->rlc | IMSM_OROM_ATTR_ChecksumVerify;
> -	*populated =3D 1;
> +	struct imsm_orom orom =3D {
> +		.signature =3D IMSM_OROM_SIGNATURE,
> +		.rlc =3D IMSM_OROM_RLC_RAID0 | IMSM_OROM_RLC_RAID1 |
> +					IMSM_OROM_RLC_RAID10 | IMSM_OROM_RLC_RAID5,
> +		.sss =3D IMSM_OROM_SSS_4kB | IMSM_OROM_SSS_8kB |
> +					IMSM_OROM_SSS_16kB | IMSM_OROM_SSS_32kB |
> +					IMSM_OROM_SSS_64kB | IMSM_OROM_SSS_128kB |
> +					IMSM_OROM_SSS_256kB | IMSM_OROM_SSS_512kB |
> +					IMSM_OROM_SSS_1MB | IMSM_OROM_SSS_2MB,
> +		.dpa =3D IMSM_OROM_DISKS_PER_ARRAY,
> +		.tds =3D IMSM_OROM_TOTAL_DISKS,
> +		.vpa =3D IMSM_OROM_VOLUMES_PER_ARRAY,
> +		.vphba =3D IMSM_OROM_VOLUMES_PER_HBA
> +	};
> +	orom.attr =3D orom.rlc | IMSM_OROM_ATTR_ChecksumVerify;
> =20
>  	if (check_env("IMSM_TEST_OROM_NORAID5")) {
> -		imsm_orom->rlc =3D IMSM_OROM_RLC_RAID0 | IMSM_OROM_RLC_RAID1 |
> +		orom.rlc =3D IMSM_OROM_RLC_RAID0 | IMSM_OROM_RLC_RAID1 |
>  				IMSM_OROM_RLC_RAID10;
>  	}
> -	if (check_env("IMSM_TEST_AHCI_EFI_NORAID5") && (hba_id =3D=3D SYS_DEV_S=
AS)) {
> -		imsm_orom->rlc =3D IMSM_OROM_RLC_RAID0 | IMSM_OROM_RLC_RAID1 |
> +	if (check_env("IMSM_TEST_AHCI_EFI_NORAID5") && (hba->type =3D=3D SYS_DE=
V_SAS)) {
> +		orom.rlc =3D IMSM_OROM_RLC_RAID0 | IMSM_OROM_RLC_RAID1 |
>  				IMSM_OROM_RLC_RAID10;
>  	}
> -	if (check_env("IMSM_TEST_SCU_EFI_NORAID5") && (hba_id =3D=3D SYS_DEV_SA=
TA)) {
> -		imsm_orom->rlc =3D IMSM_OROM_RLC_RAID0 | IMSM_OROM_RLC_RAID1 |
> +	if (check_env("IMSM_TEST_SCU_EFI_NORAID5") && (hba->type =3D=3D SYS_DEV=
_SATA)) {
> +		orom.rlc =3D IMSM_OROM_RLC_RAID0 | IMSM_OROM_RLC_RAID1 |
>  				IMSM_OROM_RLC_RAID10;
>  	}
> =20
> -	return imsm_orom;
> +	const struct imsm_orom *ret =3D add_orom(&orom);
> +
> +	add_orom_device_id(ret, hba->dev_id);
> +
> +	return ret;
>  }
> =20
> -static const struct imsm_orom *find_imsm_hba_orom(enum sys_dev_type hba_=
id)
> +static const struct imsm_orom *find_imsm_hba_orom(struct sys_dev *hba)
>  {
>  	unsigned long align;
> =20
> -	if (hba_id >=3D SYS_DEV_MAX)
> -		return NULL;
> +	if (check_env("IMSM_TEST_OROM"))
> +		return imsm_platform_test(hba);
> =20
> -	/* it's static data so we only need to read it once */
> -	if (populated_orom[hba_id]) {
> -		dprintf("OROM CAP: %p, pid: %d pop: %d\n",
> -			&imsm_orom[hba_id], (int) getpid(), populated_orom[hba_id]);
> -		return &imsm_orom[hba_id];
> -	}
> -	if (check_env("IMSM_TEST_OROM")) {
> -		dprintf("OROM CAP: %p,  pid: %d pop: %d\n",
> -			&imsm_orom[hba_id], (int) getpid(), populated_orom[hba_id]);
> -		return imsm_platform_test(hba_id, &populated_orom[hba_id], &imsm_orom[=
hba_id]);
> -	}
>  	/* return empty OROM capabilities in EFI test mode */
> -	if (check_env("IMSM_TEST_AHCI_EFI") ||
> -	    check_env("IMSM_TEST_SCU_EFI"))
> +	if (check_env("IMSM_TEST_AHCI_EFI") || check_env("IMSM_TEST_SCU_EFI"))
>  		return NULL;
> =20
>  	find_intel_devices();
> @@ -325,9 +385,7 @@ static const struct imsm_orom *find_imsm_hba_orom(enu=
m sys_dev_type hba_id)
>  	scan_adapter_roms(scan);
>  	probe_roms_exit();
> =20
> -	if (populated_orom[hba_id])
> -		return &imsm_orom[hba_id];
> -	return NULL;
> +	return get_orom_by_device_id(hba->dev_id);
>  }
> =20
>  #define GUID_STR_MAX	37  /* according to GUID format:
> @@ -347,9 +405,7 @@ static const struct imsm_orom *find_imsm_hba_orom(enu=
m sys_dev_type hba_id)
>  #define VENDOR_GUID \
>  	EFI_GUID(0x193dfefa, 0xa445, 0x4302, 0x99, 0xd8, 0xef, 0x3a, 0xad, 0x1a=
, 0x04, 0xc6)
> =20
> -int populated_efi[SYS_DEV_MAX] =3D { 0, 0 };
> -
> -static struct imsm_orom imsm_efi[SYS_DEV_MAX];
> +#define PCI_CLASS_RAID_CNTRL 0x010400
> =20
>  int read_efi_variable(void *buffer, ssize_t buf_size, char *variable_nam=
e, struct efi_guid guid)
>  {
> @@ -395,54 +451,40 @@ int read_efi_variable(void *buffer, ssize_t buf_siz=
e, char *variable_name, struc
>  	return 0;
>  }
> =20
> -const struct imsm_orom *find_imsm_efi(enum sys_dev_type hba_id)
> +const struct imsm_orom *find_imsm_efi(struct sys_dev *hba)
>  {
> -	if (hba_id >=3D SYS_DEV_MAX)
> -		return NULL;
> +	struct imsm_orom orom;
> +	const struct imsm_orom *ret;
> =20
> -	dprintf("EFI CAP: %p,  pid: %d pop: %d\n",
> -		&imsm_efi[hba_id], (int) getpid(), populated_efi[hba_id]);
> +	if (check_env("IMSM_TEST_AHCI_EFI") || check_env("IMSM_TEST_SCU_EFI"))
> +		return imsm_platform_test(hba);
> =20
> -	/* it's static data so we only need to read it once */
> -	if (populated_efi[hba_id]) {
> -		dprintf("EFI CAP: %p, pid: %d pop: %d\n",
> -			&imsm_efi[hba_id], (int) getpid(), populated_efi[hba_id]);
> -		return &imsm_efi[hba_id];
> -	}
> -	if (check_env("IMSM_TEST_AHCI_EFI") ||
> -	    check_env("IMSM_TEST_SCU_EFI")) {
> -		dprintf("OROM CAP: %p,  pid: %d pop: %d\n",
> -			&imsm_efi[hba_id], (int) getpid(), populated_efi[hba_id]);
> -		return imsm_platform_test(hba_id, &populated_efi[hba_id], &imsm_efi[hb=
a_id]);
> -	}
>  	/* OROM test is set, return that there is no EFI capabilities */
>  	if (check_env("IMSM_TEST_OROM"))
>  		return NULL;
> =20
> -	if (read_efi_variable(&imsm_efi[hba_id], sizeof(imsm_efi[0]), hba_id =
=3D=3D SYS_DEV_SAS ? SCU_PROP : AHCI_PROP, VENDOR_GUID)) {
> -		populated_efi[hba_id] =3D 0;
> +	if (hba->type =3D=3D SYS_DEV_SATA && hba->class !=3D PCI_CLASS_RAID_CNT=
RL)
>  		return NULL;
> -	}
> =20
> -	populated_efi[hba_id] =3D 1;
> -	return &imsm_efi[hba_id];
> -}
> +	if (read_efi_variable(&orom, sizeof(orom), hba->type =3D=3D SYS_DEV_SAS=
 ? SCU_PROP : AHCI_PROP, VENDOR_GUID))
> +		return NULL;
> =20
> -/*
> - * backward interface compatibility
> - */
> -const struct imsm_orom *find_imsm_orom(void)
> -{
> -	return find_imsm_hba_orom(SYS_DEV_SATA);
> +	ret =3D add_orom(&orom);
> +	add_orom_device_id(ret, hba->dev_id);
> +
> +	return ret;
>  }
> =20
> -const struct imsm_orom *find_imsm_capability(enum sys_dev_type hba_id)
> +const struct imsm_orom *find_imsm_capability(struct sys_dev *hba)
>  {
> -	const struct imsm_orom *cap=3DNULL;
> +	const struct imsm_orom *cap =3D get_orom_by_device_id(hba->dev_id);
> +
> +	if (cap)
> +		return cap;
> =20
> -	if ((cap =3D find_imsm_efi(hba_id)) !=3D NULL)
> +	if ((cap =3D find_imsm_efi(hba)) !=3D NULL)
>  		return cap;
> -	if ((cap =3D find_imsm_hba_orom(hba_id)) !=3D NULL)
> +	if ((cap =3D find_imsm_hba_orom(hba)) !=3D NULL)
>  		return cap;
>  	return NULL;
>  }
> diff --git a/platform-intel.h b/platform-intel.h
> index 8226be3..e41f386 100644
> --- a/platform-intel.h
> +++ b/platform-intel.h
> @@ -22,6 +22,7 @@
>  /* The IMSM Capability (IMSM AHCI and ISCU OROM/EFI variable) Version Ta=
ble definition */
>  struct imsm_orom {
>  	__u8 signature[4];
> +	#define IMSM_OROM_SIGNATURE "$VER"
>  	__u8 table_ver_major; /* Currently 2 (can change with future revs) */
>  	__u8 table_ver_minor; /* Currently 2 (can change with future revs) */
>  	__u16 major_ver; /* Example: 8 as in 8.6.0.1020 */
> @@ -180,6 +181,7 @@ struct sys_dev {
>  	char *path;
>  	char *pci_id;
>  	__u16  dev_id;
> +	__u32  class;
>  	struct sys_dev *next;
>  };
> =20
> @@ -201,10 +203,11 @@ static inline char *guid_str(char *buf, struct efi_=
guid guid)
>  char *diskfd_to_devpath(int fd);
>  struct sys_dev *find_driver_devices(const char *bus, const char *driver);
>  struct sys_dev *find_intel_devices(void);
> -const struct imsm_orom *find_imsm_capability(enum sys_dev_type hba_id);
> +const struct imsm_orom *find_imsm_capability(struct sys_dev *hba);
>  const struct imsm_orom *find_imsm_orom(void);
>  int disk_attached_to_hba(int fd, const char *hba_path);
>  int devt_attached_to_hba(dev_t dev, const char *hba_path);
>  char *devt_to_devpath(dev_t dev);
>  int path_attached_to_hba(const char *disk_path, const char *hba_path);
>  const char *get_sys_dev_type(enum sys_dev_type);
> +const struct imsm_orom *get_orom_by_device_id(__u16 device_id);
> diff --git a/super-intel.c b/super-intel.c
> index e28ac7d..dabf011 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -555,11 +555,26 @@ static int attach_hba_to_super(struct intel_super *=
super, struct sys_dev *device
>  	if (super->hba =3D=3D NULL) {
>  		super->hba =3D alloc_intel_hba(device);
>  		return 1;
> -	} else
> -		/* IMSM metadata disallows to attach disks to multiple
> -		 * controllers.
> -		 */
> +	}
> +
> +	hba =3D super->hba;
> +	/* Intel metadata allows for all disks attached to the same type HBA.
> +	 * Do not sypport odf HBA types mixing
> +	 */
> +	if (device->type !=3D hba->type)
> +		return 2;
> +
> +	/* Multiple same type HBAs can be used if they share the same OROM */
> +	const struct imsm_orom *device_orom =3D get_orom_by_device_id(device->d=
ev_id);
> +
> +	if (device_orom !=3D super->orom)
>  		return 2;
> +
> +	while (hba->next)
> +		hba =3D hba->next;
> +
> +	hba->next =3D alloc_intel_hba(device);
> +	return 1;
>  }
> =20
>  static struct sys_dev* find_disk_attached_hba(int fd, const char *devnam=
e)
> @@ -1886,13 +1901,12 @@ static int detail_platform_imsm(int verbose, int =
enumerate_only, char *controlle
>  		if (!list)
>  			return 2;
>  		for (hba =3D list; hba; hba =3D hba->next) {
> -			orom =3D find_imsm_capability(hba->type);
> -			if (!orom) {
> -				result =3D 2;
> +			if (find_imsm_capability(hba)) {
> +				result =3D 0;
>  				break;
>  			}
>  			else
> -				result =3D 0;
> +				result =3D 2;
>  		}
>  		return result;
>  	}
> @@ -1909,7 +1923,7 @@ static int detail_platform_imsm(int verbose, int en=
umerate_only, char *controlle
>  	for (hba =3D list; hba; hba =3D hba->next) {
>  		if (controller_path && (compare_paths(hba->path,controller_path) !=3D =
0))
>  			continue;
> -		orom =3D find_imsm_capability(hba->type);
> +		orom =3D find_imsm_capability(hba);
>  		if (!orom)
>  			pr_err("imsm capabilities not found for controller: %s (type %s)\n",
>  				hba->path, get_sys_dev_type(hba->type));
> @@ -1954,7 +1968,7 @@ static int export_detail_platform_imsm(int verbose,=
 char *controller_path)
>  	for (hba =3D list; hba; hba =3D hba->next) {
>  		if (controller_path && (compare_paths(hba->path,controller_path) !=3D =
0))
>  			continue;
> -		orom =3D find_imsm_capability(hba->type);
> +		orom =3D find_imsm_capability(hba);
>  		if (!orom) {
>  			if (verbose > 0)
>  				pr_err("IMSM_DETAIL_PLATFORM_ERROR=3DNO_IMSM_CAPABLE_DEVICE_UNDER_%s=
\n",hba->path);
> @@ -3087,13 +3101,18 @@ static int compare_super_imsm(struct supertype *s=
t, struct supertype *tst)
>  	 * use the same Intel hba
>  	 * If not on Intel hba at all, allow anything.
>  	 */
> -	if (!check_env("IMSM_NO_PLATFORM")) {
> -		if (first->hba && sec->hba &&
> -		    strcmp(first->hba->path, sec->hba->path) !=3D 0)  {
> +	if (!check_env("IMSM_NO_PLATFORM") && first->hba && sec->hba) {
> +		if (first->hba->type !=3D sec->hba->type) {
> +			fprintf(stderr,
> +				"HBAs of devices do not match %s !=3D %s\n",
> +				get_sys_dev_type(first->hba->type),
> +				get_sys_dev_type(sec->hba->type));
> +			return 3;
> +		}
> +		if (first->orom !=3D sec->orom) {
>  			fprintf(stderr,
> -				"HBAs of devices does not match %s !=3D %s\n",
> -				first->hba ? first->hba->path : NULL,
> -				sec->hba ? sec->hba->path : NULL);
> +				"HBAs of devices do not match %s !=3D %s\n",
> +				first->hba->pci_id, sec->hba->pci_id);
>  			return 3;
>  		}
>  	}
> @@ -3832,14 +3851,13 @@ static int find_intel_hba_capability(int fd, stru=
ct intel_super *super, char *de
>  					fprintf(stderr, ", ");
>  				hba =3D hba->next;
>  			}
> -
> -			fprintf(stderr, ").\n");
> -			cont_err("Mixing devices attached to multiple controllers "
> -				 "is not allowed.\n");
> +			fprintf(stderr, ").\n"
> +				"    Mixing devices attached to different controllers "
> +				"is not allowed.\n");
>  		}
>  		return 2;
>  	}
> -	super->orom =3D find_imsm_capability(hba_name->type);
> +	super->orom =3D find_imsm_capability(hba_name);
>  	if (!super->orom)
>  		return 3;
>  	return 0;
> @@ -9061,32 +9079,68 @@ int open_backup_targets(struct mdinfo *info, int =
raid_disks, int *raid_fds,
>   ***********************************************************************=
*******/
>  int validate_container_imsm(struct mdinfo *info)
>  {
> -	if (!check_env("IMSM_NO_PLATFORM")) {
> -		struct sys_dev *idev;
> -		struct mdinfo *dev;
> -		char *hba_path =3D NULL;
> -		char *dev_path =3D devt_to_devpath(makedev(info->disk.major,
> -										info->disk.minor));
> +	if (check_env("IMSM_NO_PLATFORM"))
> +		return 0;
> =20
> -		for (idev =3D find_intel_devices(); idev; idev =3D idev->next) {
> -			if (strstr(dev_path, idev->path)) {
> -				hba_path =3D idev->path;
> -				break;
> -			}
> +	struct sys_dev *idev;
> +	struct sys_dev *hba =3D NULL;
> +	struct sys_dev *intel_devices =3D find_intel_devices();
> +	char *dev_path =3D devt_to_devpath(makedev(info->disk.major,
> +									info->disk.minor));
> +
> +	for (idev =3D intel_devices; idev; idev =3D idev->next) {
> +		if (dev_path && strstr(dev_path, idev->path)) {
> +			hba =3D idev;
> +			break;
>  		}
> +	}
> +	if (dev_path)
>  		free(dev_path);
> =20
> -		if (hba_path) {
> -			for (dev =3D info->next; dev; dev =3D dev->next) {
> -				if (!devt_attached_to_hba(makedev(dev->disk.major,
> -						dev->disk.minor), hba_path)) {
> -					pr_err("WARNING - IMSM container assembled with disks under differe=
nt HBAs!\n"
> -						"       This operation is not supported and can lead to data loss.=
\n");
> -					return 1;
> -				}
> +	if (!hba) {
> +		pr_err("WARNING - Cannot detect HBA for device %s!\n",
> +				devid2kname(makedev(info->disk.major, info->disk.minor)));
> +		return 1;
> +	}
> +
> +	const struct imsm_orom *orom =3D get_orom_by_device_id(hba->dev_id);
> +	struct mdinfo *dev;
> +
> +	for (dev =3D info->next; dev; dev =3D dev->next) {
> +		dev_path =3D devt_to_devpath(makedev(dev->disk.major, dev->disk.minor)=
);
> +
> +		struct sys_dev *hba2 =3D NULL;
> +		for (idev =3D intel_devices; idev; idev =3D idev->next) {
> +			if (dev_path && strstr(dev_path, idev->path)) {
> +				hba2 =3D idev;
> +				break;
>  			}
>  		}
> +		if (dev_path)
> +			free(dev_path);
> +
> +		const struct imsm_orom *orom2 =3D hba2 =3D=3D NULL ? NULL :
> +				get_orom_by_device_id(hba2->dev_id);
> +
> +		if (hba2 && hba->type !=3D hba2->type) {
> +			pr_err("WARNING - HBAs of devices do not match %s !=3D %s\n",
> +				get_sys_dev_type(hba->type), get_sys_dev_type(hba2->type));
> +			return 1;
> +		}
> +
> +		if (orom !=3D orom2) {
> +			pr_err("WARNING - IMSM container assembled with disks under different=
 HBAs!\n"
> +				"       This operation is not supported and can lead to data loss.\n=
");
> +			return 1;
> +		}
> +
> +		if (!orom) {
> +			pr_err("WARNING - IMSM container assembled with disks under HBAs with=
out IMSM platform support!\n"
> +				"       This operation is not supported and can lead to data loss.\n=
");
> +			return 1;
> +		}
>  	}
> +
>  	return 0;
>  }
>  #ifndef MDASSEMBLE


--Sig_/MZUfbdwFC9.XDX_2H=Vjh8m
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVG1bBDnsnt1WYoG5AQIPjBAAvYsv5T0yWBTeyQySnM4PoDCHlXg4rAhG
YVoYcaOJWiWAduusNjGgmpqzQ4dIw8iOyv/W335wNfPglniAgTPo7Guil/bqQqdA
x18CgLxC33wnXi1bKLNte5fZVt+j1USwTYqEtxhh7IXgrqlzzK8zik1NUuhbb73f
S3xpaqGKQ866BzdMgwEyI6op4fYIPPai5qoN6ho+gxQXWhSQ3kuIMDj8HzgPc0AS
S7P7rxgRpASymAs2z6aOCsWN/MZdPGsrxQIRpNZb+9yrR7b3LvS3upfXCVN8baid
p3qQ37+jT7xICb1uYHHp+DIhPF98hHB85mBojFljQh1hQgavyXVdZwX3bAC2GaGg
8cmruU64gAQmlpeOfYLJ0z8d6ZjsdwvQmf4Em4OG+9DJ1K5ClJh3Q5peIpoiwWAj
CUMEHUTLLLHHeN0PNqHbJELcD7ZhI2QZ22dxY42c5lVQT5UTyXEtvCUz56mj1gx9
Bx+uJ1GICpJGOH2XeG2piJr3rABXZjEM4oWvDd75xwIm0KOMTQhbDwsa+UHgu/of
JV9qfWEQwtYNW+4pMfBo1Qob69mkk8A4H/b/e+PXkICIPhJr6Om9aG+gSFXZSNMQ
zV5rjjPYDFDJRy1AehqfCcCX3Q3Dx4FW77+3jzwsqcVZ4+McgfgUsnwYco+6vMhm
kDJXdCWFdms=
=bi1c
-----END PGP SIGNATURE-----

--Sig_/MZUfbdwFC9.XDX_2H=Vjh8m--
