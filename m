From: Joao Luis Meloni Assirati <assirati@nonada.if.usp.br>
Subject: Re: Software RAID partitions not detected at boot time with linux 2.6.25.1.
Date: Mon, 5 May 2008 15:22:02 -0300
Message-ID: <200805051522.03079.assirati@nonada.if.usp.br>
References: <200805032245.57084.assirati@nonada.if.usp.br> <18461.45667.588613.443564@notabene.brown> <1209990570.6975.5.camel@linux.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1209990570.6975.5.camel@linux.site>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Neil Brown <neilb@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Em Segunda 05 Maio 2008 09:29, Kay Sievers escreveu:
> Care to test/fix/improve the following. I just booted a normal disk,
> didn't test a partitioned md device.

It works!:

md: Autodetecting RAID arrays.
md: Scanned 3 and added 3 devices.
md: autorun ...
md: considering sdc2 ...
md:  adding sdc2 ...
md:  adding sdb2 ...
md:  adding sda2 ...
md: created md_d0
md: bind<sda2>
md: bind<sdb2>
md: bind<sdc2>
md: running: <sdc2><sdb2><sda2>
raid5: device sdc2 operational as raid disk 2
raid5: device sdb2 operational as raid disk 1
raid5: device sda2 operational as raid disk 0
raid5: allocated 3224kB for md_d0
raid5: raid level 5 set md_d0 active with 3 out of 3 devices, algorithm=
 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda2
 disk 1, o:1, dev:sdb2
 disk 2, o:1, dev:sdc2
md: ... autorun DONE.
 md_d0: p1 p2 p3 p4 < p5 p6 p7 >

I will test it in another machine with raid1 later. If something
goes wrong there, I will report.

> Thanks,
> Kay

Thank you,
Jo=E3o Luis.

>=20
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: block: do_mounts - accept root=3D<non-existant partition>
>=20
> Some devices, like md, may create partitions only at first access,
> so allow root=3D to be set to a valid non-existant partition of an
> existing disk. This applies only to non-initramfs root mounting.
>=20
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> ---
>=20
> diff --git a/block/genhd.c b/block/genhd.c
> index fda9c7a..129ad93 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -653,7 +653,7 @@ void genhd_media_change_notify(struct gendisk *di=
sk)
>  EXPORT_SYMBOL_GPL(genhd_media_change_notify);
>  #endif  /*  0  */
> =20
> -dev_t blk_lookup_devt(const char *name)
> +dev_t blk_lookup_devt(const char *name, int part)
>  {
>  	struct device *dev;
>  	dev_t devt =3D MKDEV(0, 0);
> @@ -661,7 +661,11 @@ dev_t blk_lookup_devt(const char *name)
>  	mutex_lock(&block_class_lock);
>  	list_for_each_entry(dev, &block_class.devices, node) {
>  		if (strcmp(dev->bus_id, name) =3D=3D 0) {
> -			devt =3D dev->devt;
> +			struct gendisk *disk =3D dev_to_disk(dev);
> +
> +			if (part < disk->minors)
> +				devt =3D MKDEV(MAJOR(dev->devt),
> +					     MINOR(dev->devt) + part);
>  			break;
>  		}
>  	}
> @@ -669,7 +673,6 @@ dev_t blk_lookup_devt(const char *name)
> =20
>  	return devt;
>  }
> -
>  EXPORT_SYMBOL(blk_lookup_devt);
> =20
>  struct gendisk *alloc_disk(int minors)
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index ecd2bf6..612a790 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -524,7 +524,7 @@ struct unixware_disklabel {
>  #define ADDPART_FLAG_RAID	1
>  #define ADDPART_FLAG_WHOLEDISK	2
> =20
> -extern dev_t blk_lookup_devt(const char *name);
> +extern dev_t blk_lookup_devt(const char *name, int part);
>  extern char *disk_name (struct gendisk *hd, int part, char *buf);
> =20
>  extern int rescan_partitions(struct gendisk *disk, struct block_devi=
ce *bdev);
> @@ -552,7 +552,7 @@ static inline struct block_device *bdget_disk(str=
uct gendisk *disk, int index)
> =20
>  static inline void printk_all_partitions(void) { }
> =20
> -static inline dev_t blk_lookup_devt(const char *name)
> +static inline dev_t blk_lookup_devt(const char *name, int part)
>  {
>  	dev_t devt =3D MKDEV(0, 0);
>  	return devt;
> diff --git a/init/do_mounts.c b/init/do_mounts.c
> index 3885e70..660c1e5 100644
> --- a/init/do_mounts.c
> +++ b/init/do_mounts.c
> @@ -76,6 +76,7 @@ dev_t name_to_dev_t(char *name)
>  	char s[32];
>  	char *p;
>  	dev_t res =3D 0;
> +	int part;
> =20
>  	if (strncmp(name, "/dev/", 5) !=3D 0) {
>  		unsigned maj, min;
> @@ -106,7 +107,31 @@ dev_t name_to_dev_t(char *name)
>  	for (p =3D s; *p; p++)
>  		if (*p =3D=3D '/')
>  			*p =3D '!';
> -	res =3D blk_lookup_devt(s);
> +	res =3D blk_lookup_devt(s, 0);
> +	if (res)
> +		goto done;
> +
> +	/*
> +	 * try non-existant, but valid partition, which may only exist
> +	 * after revalidating the disk, like partitioned md devices
> +	 */
> +	while (p > s && isdigit(p[-1]))
> +		p--;
> +	if (p =3D=3D s || !*p || *p =3D=3D '0')
> +		goto fail;
> +
> +	/* try disk name without <part number> */
> +	part =3D simple_strtoul(p, NULL, 10);
> +	*p =3D '\0';
> +	res =3D blk_lookup_devt(s, part);
> +	if (res)
> +		goto done;
> +
> +	/* try disk name without p<part number> */
> +	if (p < s + 2 || !isdigit(p[-2]) || p[-1] !=3D 'p')
> +		goto fail;
> +	p[-1] =3D '\0';
> +	res =3D blk_lookup_devt(s, part);
>  	if (res)
>  		goto done;
> =20
>=20
>=20
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
