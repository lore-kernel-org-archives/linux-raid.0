From: =?iso-8859-1?Q?Jan_Kundr=E1t?= <jkt@flaska.net>
Subject: External USB-SATA bridge rewriting logical block sizes
Date: Mon, 03 Mar 2014 06:02:20 +0100
Message-ID: <f533c037-b72b-4039-9ef7-f2c61a0de3e6@flaska.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
I'm having troubles using WD40EZRX [1] in a USB3 -> SATA dock. The trou=
ble=20
I'm hitting is that the data I get back when reading the first partitio=
n=20
differ depending on whether I access the drive via the enclosure, or=20
directly as a SATA disk.

Here is how it looks directly attached:

plejtvak ~ # sg_readcap -l /dev/sdc
Read Capacity results:
   Protection: prot_en=3D0, p_type=3D0, p_i_exponent=3D0
   Logical block provisioning: lbpme=3D0, lbprz=3D0
   Last logical block address=3D7814037167 (0x1d1c0beaf), Number of log=
ical=20
blocks=3D7814037168
   Logical block length=3D512 bytes
   Logical blocks per physical block exponent=3D3
   Lowest aligned logical block address=3D0
Hence:
   Device size: 4000787030016 bytes, 3815447.8 MiB, 4000.79 GB

And this is how it looks through the USB convertor:

svist ~ # sg_readcap -l /dev/sdb
Read Capacity results:
   Protection: prot_en=3D0, p_type=3D0, p_i_exponent=3D0
   Logical block provisioning: lbpme=3D0, lbprz=3D0
   Last logical block address=3D976754645 (0x3a3817d5), Number of logic=
al=20
blocks=3D976754646
   Logical block length=3D4096 bytes
   Logical blocks per physical block exponent=3D0
   Lowest aligned logical block address=3D0
Hence:
   Device size: 4000787030016 bytes, 3815447.8 MiB, 4000.79 GB

My partition table is probably borked -- IIRC I created it via `cfdisk`=
=20
over the USB connection, but I am not sure about that anymore. This is =
what=20
gdisk reports when directly attached:

Command (? for help): p
Disk /dev/sdc: 7814037168 sectors, 3.6 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): AD1C809E-45FC-4CDD-A9EC-2855D4AF1E6E
Partition table holds up to 128 entries
=46irst usable sector is 34, last usable sector is 7814037134
Partitions will be aligned on 8-sector boundaries
Total free space is 4294972395 sectors (2.0 TiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1              63      3519064768   1.6 TiB     0700  Linux/Windows =
data

=2E..and through the USB dock:

Command (? for help): p
Disk /dev/sdb: 976754646 sectors, 3.6 TiB
Logical sector size: 4096 bytes
Disk identifier (GUID): DFE2C96D-8A4C-4516-86B2-4F6DA0EB8609
Partition table holds up to 128 entries
=46irst usable sector is 6, last usable sector is 976754640
Partitions will be aligned on 8-sector boundaries
Total free space is 57 sectors (228.0 KiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1              63      3519064768   13.1 TiB    8300  Linux filesyst=
em

I have a filesystem on the first partition. Accessing it works fine via=
 the=20
USB reduction, but mount refuses to proceed when accessing the SATA dis=
k=20
directly. I assume that this is because the partition starts at byte=20
(63*4096) from the beginning of the disk, which matches the detected=20
partition start when using the USB thingy. However, when accessing the =
disk=20
directly over SATA, the partition is presumably expected to begin at=20
(63*512), which is a very different location, and stuff therefore break=
s.

I have already read the discussion from January [3] and believe that th=
is=20
is a different situation -- I haven't disassembled anything, this is a=20
standalone USB->SATA convertor and a standalone SATA disk.

I would appreciate a couple of pointers here:

- Did I screw up somehow? If so, how? Perhaps by using wrong partition=20
table layout, i.e. by tying myself to logical blocks?

- Can I salvage the data by rewriting the partition table in some magic=
 way=20
which would work with both "physical 4k, logic 4k" and "physical 512, l=
ogic=20
4k" modes at the same time?

- Is the USB enclosure which I'm using just a crappy piece of hardware =
that=20
I should stay away from?

- What is the cleanest way of accessing the drive in the safest possibl=
e=20
manner? I would like to put my backups in there, and I wasn't really ha=
ppy=20
when I plugged the drive directly in order to test the contents and fou=
nd=20
out that it won't even mount.

- I guess I could just give up on partitioning altogether and use=20
filesystem on the whole device without much trouble. However, I'm afrai=
d=20
that this might confuse the kernel's partition layout detection, and it=
=20
also seems a bit ugly.

Help is much appreciated. There's an unsolved Stackoverflow post at [4]=
=20
which appears to be dealing with the exactly same problem, btw.

With kind regards,
Jan

[1] WD40EZRX-00SPEB0, a 4TB WD Green
[2] "174c:5106 ASMedia Technology Inc. Transcend StoreJet 25M3" (lsusb)=
,=20
also known as "IcyBox IB-116StU3-B" (label)
[3] http://www.spinics.net/lists/raid/msg45555.html
[4]=20
http://superuser.com/questions/679725/how-to-correct-512-byte-sector-mb=
r-on-a-4096-byte-sector-disk

--=20
Trojit=C3=A1, a fast Qt IMAP e-mail client -- http://trojita.flaska.net=
/
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
