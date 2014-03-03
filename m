From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: External USB-SATA bridge rewriting logical block sizes
Date: Mon, 03 Mar 2014 08:26:24 -0600
Message-ID: <53149110.7090008@hardwarefreak.com>
References: <f533c037-b72b-4039-9ef7-f2c61a0de3e6@flaska.net>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f533c037-b72b-4039-9ef7-f2c61a0de3e6@flaska.net>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Jan_Kundr=E1t?= <jkt@flaska.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/2/2014 11:02 PM, Jan Kundr=E1t wrote:
> Hi,
> I'm having troubles using WD40EZRX [1] in a USB3 -> SATA dock. The
> trouble I'm hitting is that the data I get back when reading the firs=
t
> partition differ depending on whether I access the drive via the
> enclosure, or directly as a SATA disk.
>
> Here is how it looks directly attached:
>=20
> plejtvak ~ # sg_readcap -l /dev/sdc
> Read Capacity results:
>   Protection: prot_en=3D0, p_type=3D0, p_i_exponent=3D0
>   Logical block provisioning: lbpme=3D0, lbprz=3D0
>   Last logical block address=3D7814037167 (0x1d1c0beaf), Number of lo=
gical
> blocks=3D7814037168
>   Logical block length=3D512 bytes
>   Logical blocks per physical block exponent=3D3
>   Lowest aligned logical block address=3D0
> Hence:
>   Device size: 4000787030016 bytes, 3815447.8 MiB, 4000.79 GB
>=20
> And this is how it looks through the USB convertor:
>=20
> svist ~ # sg_readcap -l /dev/sdb
> Read Capacity results:
>   Protection: prot_en=3D0, p_type=3D0, p_i_exponent=3D0
>   Logical block provisioning: lbpme=3D0, lbprz=3D0
>   Last logical block address=3D976754645 (0x3a3817d5), Number of logi=
cal
> blocks=3D976754646
>   Logical block length=3D4096 bytes
>   Logical blocks per physical block exponent=3D0
>   Lowest aligned logical block address=3D0
> Hence:
>   Device size: 4000787030016 bytes, 3815447.8 MiB, 4000.79 GB
>=20
> My partition table is probably borked -- IIRC I created it via `cfdis=
k`
> over the USB connection, but I am not sure about that anymore. This i=
s
> what gdisk reports when directly attached:
>=20
> Command (? for help): p
> Disk /dev/sdc: 7814037168 sectors, 3.6 TiB
> Logical sector size: 512 bytes
> Disk identifier (GUID): AD1C809E-45FC-4CDD-A9EC-2855D4AF1E6E
> Partition table holds up to 128 entries
> First usable sector is 34, last usable sector is 7814037134
> Partitions will be aligned on 8-sector boundaries
> Total free space is 4294972395 sectors (2.0 TiB)
>=20
> Number  Start (sector)    End (sector)  Size       Code  Name
>   1              63      3519064768   1.6 TiB     0700  Linux/Windows=
 data
>=20
> ...and through the USB dock:
>=20
> Command (? for help): p
> Disk /dev/sdb: 976754646 sectors, 3.6 TiB
> Logical sector size: 4096 bytes
> Disk identifier (GUID): DFE2C96D-8A4C-4516-86B2-4F6DA0EB8609
> Partition table holds up to 128 entries
> First usable sector is 6, last usable sector is 976754640
> Partitions will be aligned on 8-sector boundaries
> Total free space is 57 sectors (228.0 KiB)
>=20
> Number  Start (sector)    End (sector)  Size       Code  Name
>   1              63      3519064768   13.1 TiB    8300  Linux filesys=
tem
>=20
> I have a filesystem on the first partition. Accessing it works fine v=
ia
> the USB reduction, but mount refuses to proceed when accessing the SA=
TA
> disk directly. I assume that this is because the partition starts at
> byte (63*4096) from the beginning of the disk, which matches the
> detected partition start when using the USB thingy. However, when
> accessing the disk directly over SATA, the partition is presumably
> expected to begin at (63*512), which is a very different location, an=
d
> stuff therefore breaks.
>=20
> I have already read the discussion from January [3] and believe that
> this is a different situation -- I haven't disassembled anything, thi=
s
> is a standalone USB->SATA convertor and a standalone SATA disk.
>=20
> I would appreciate a couple of pointers here:
>=20
> - Did I screw up somehow? If so, how?=20

Yes.

> - Can I salvage the data by rewriting the partition table in some mag=
ic
> way which would work with both "physical 4k, logic 4k" and "physical
> 512, logic 4k" modes at the same time?

Presumably you have some md raid level with fault tolerance, since you
posted this to the linux-raid list.  Why not simply kick the drive from
the array, install it "direct" inside the chassis, repartition it the
same as the other members of the array that are direct connected to the
SATA controller, re-add the partition to the array, and rebuild.

> - Is the USB enclosure which I'm using just a crappy piece of hardwar=
e
> that I should stay away from?

All USB drive enclosures are crap.  Why you prepped this drive in it
with intention of moving it into the PC chassis leaves me scratching my
head.  Is this some habit you developed years ago?  Prepping a new driv=
e
in a USB before permanently installing it in the chassis?  If so, I'd
recommend using a hot swap SATA chassis that installs in a 5.25" drive
bay instead.  They're $15-30 USD, cheaper, and more reliable, than a US=
B
dock, by far.

Never use USB connected disk drives for RAID.  This is but one of many
problems you'll run into.

> - What is the cleanest way of accessing the drive in the safest possi=
ble
> manner? I would like to put my backups in there, and I wasn't really
> happy when I plugged the drive directly in order to test the contents
> and found out that it won't even mount.

See above.

> - I guess I could just give up on partitioning altogether and use
> filesystem on the whole device without much trouble. However, I'm afr=
aid
> that this might confuse the kernel's partition layout detection, and =
it
> also seems a bit ugly.

The problem isn't use of partitions, but use a USB.

> Help is much appreciated.

Cheers.

--=20
Stan

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
