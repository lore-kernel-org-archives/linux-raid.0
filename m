From: John Crisp <jcrisp@safeandsoundit.co.uk>
Subject: Re: Raid 6 recovery
Date: Tue, 31 Oct 2017 18:42:41 +0100
Message-ID: <1f997b50-f271-a238-2d7e-1684a0c64e66@safeandsoundit.co.uk>
References: <cf135ab9-1111-65cd-1074-5259a7eb133d@safeandsoundit.co.uk>
 <59F8A47E.2000405@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="qxQVxxOHONrRSMTBtqgkWhxGQ5lAaeRln"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59F8A47E.2000405@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qxQVxxOHONrRSMTBtqgkWhxGQ5lAaeRln
Content-Type: multipart/mixed; boundary="UkjPEcO7igbQleT91TH3fPUV5uH46alV0";
 protected-headers="v1"
From: John Crisp <jcrisp@safeandsoundit.co.uk>
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
Message-ID: <1f997b50-f271-a238-2d7e-1684a0c64e66@safeandsoundit.co.uk>
Subject: Re: Raid 6 recovery
References: <cf135ab9-1111-65cd-1074-5259a7eb133d@safeandsoundit.co.uk>
 <59F8A47E.2000405@youngman.org.uk>
In-Reply-To: <59F8A47E.2000405@youngman.org.uk>

--UkjPEcO7igbQleT91TH3fPUV5uH46alV0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

On 31/10/17 17:27, Wols Lists wrote:
> On 31/10/17 15:42, John Crisp wrote:
>> Hi,
>>
>> Returning once again to this list for some help and advice.
>=20
> Doing a first-responder job ... :-)

Aww thanks :-) Thunderbirds to the rescue !


>>
>> Long story short I have a failed Raid 6 array that I would like to try=

>> and recover. The data is not vitally important as I have most of it in=
 a
>> number of other places, but I'd like to try and resurrect the array if=

>> possible, as much to learn as anything.
>>
> Looks very promising ...

I hope so....
>=20
> Okay. That makes 5 data drives, 2 parity, one spare. I'm wondering if
> one drive failed a while back and was rebuilt, so you didn't have the
> spare you think you did. I'm half-hoping that's the case, because if it=

> fell over in the middle of a rebuild, that could be a problem ...

Quite possibly.

>> root@garage:~# mdadm --assemble --force /dev/md127 $OVERLAYS
>> mdadm: clearing FAULTY flag for device 3 in /dev/md127 for /dev/mapper=
/sdh
>> mdadm: Marking array /dev/md127 as 'clean'
>> mdadm: failed to add /dev/mapper/sde to /dev/md127: Invalid argument
>> mdadm: failed to add /dev/mapper/sdi to /dev/md127: Invalid argument
>> mdadm: /dev/md127 assembled from 2 drives and  1 rebuilding - not enou=
gh
>> to start the array.
>>
> This worries me. We have 5 drives, which would normally be enough to
> recreate the array - a quick "--force" and we're up and running. Except=

> one drive is rebuilding, so we have one drive's worth of data scattered=

> across two drives :-(
>=20

Oh yuck.....


> Examine tells us that sdd, sdg, and sdj have been partitioned. What doe=
s
> "fdisk -l" tell us about those drives? Assuming they have one large
> partition each, what does "--examine" tell us about sdd1, sdg1 and sdj1=

> (assuming that's what the partitions are)?

mdadm --examine was pasted at the bottom of my original post.


cat /etc/fstab

# <file system> <mount point>   <type>  <options>       <dump>  <pass>
/dev/mapper/xubuntu-vg__raider-root / ext4 errors=3Dremount-ro 0 1
# /boot was on /dev/sda1 during installation
UUID=3D86b99e91-e21e-4381-97e3-9b38ea8dae1b /boot ext2 defaults 0 2
/dev/mapper/xubuntu-vg__raider-swap_1 none swap sw 0 0
UUID=3Db19a1b13-e650-4288-864a-b84a3a86edad /media/Data ext4 rw,noatime 0=
 0


fdisk:

root@garage:~# fdisk -l /dev/sd[cdefghij]

Disk /dev/sdc: 300.0 GB, 300000000000 bytes
255 heads, 63 sectors/track, 36472 cylinders, total 585937500 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000b5cc0

   Device Boot      Start         End      Blocks   Id  System

Disk /dev/sdd: 300.0 GB, 300000000000 bytes
255 heads, 63 sectors/track, 36472 cylinders, total 585937500 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System

Disk /dev/sde: 300.0 GB, 300000000000 bytes
255 heads, 63 sectors/track, 36472 cylinders, total 585937500 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x0003fdad

   Device Boot      Start         End      Blocks   Id  System

Disk /dev/sdf: 300.0 GB, 300000000000 bytes
255 heads, 63 sectors/track, 36472 cylinders, total 585937500 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00098c62

   Device Boot      Start         End      Blocks   Id  System

Disk /dev/sdg: 300.0 GB, 300000000000 bytes
255 heads, 63 sectors/track, 36472 cylinders, total 585937500 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000c9bb4

   Device Boot      Start         End      Blocks   Id  System

Disk /dev/sdh: 300.0 GB, 300000000000 bytes
255 heads, 63 sectors/track, 36472 cylinders, total 585937500 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000ae9f1

   Device Boot      Start         End      Blocks   Id  System

Disk /dev/sdi: 300.0 GB, 300000000000 bytes
255 heads, 63 sectors/track, 36472 cylinders, total 585937500 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00040d18

   Device Boot      Start         End      Blocks   Id  System

Disk /dev/sdj: 300.0 GB, 300000000000 bytes
255 heads, 63 sectors/track, 36472 cylinders, total 585937500 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000924c0

   Device Boot      Start         End      Blocks   Id  System




>>
>> (Two drives have older Events)
>>
> Do you mean the two with 1910? That's no great shakes.

OK.

>> root@garage:~# mdadm --examine /dev/sd[cdefghij]
>> /dev/sdc:
>=20
> Snip the details ... :-)
>=20
> First things first, I'd suggest going out and getting a 3TB drive. Once=

> we've worked out where the data is hiding on sdd, sdg, and sdj you can
> ddrescue all that into partitions on this drive and still have space
> left over. That way you've got your original drives untouched, you've
> got a copy of everything on a fresh drive that's not going to die on yo=
u
> (touch wood), and you've got spare space left over. (Even better, a 4TB=

> drive and then you can probably backup the array into the space left
> over!). That'll set you back just over =C2=A3100 for a Seagate Ironwolf=
 or
> similar.

I'm not sure I can add another drive in the existing rig (which is a bit
of a jury rig - the original box died so I have a bog standard PC with a
the 2 SATA drives with the OS and then a PCI raid card plugged in to
fire up the array cage on the old box. It's serious open heart surgery
here !)

If you want to laugh look here (I told you it was bad....)
http://picpaste.com/20171031-0F5Z1t5c.jpg

I could dd over ssh to my main server which has a few TB of space.

>=20
> Second, as I say, work out where that data is hiding - I strongly
> suspect those drives have been partitioned.
>=20

See fdisk -l above - there are no partitions on the drives. This was a
data array only and was mounted after booting the OS

> And lastly, go back to the wiki. The page you read was the last in a
> series - it would pay you to read the lot.
>=20
> https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn
>=20
> Note especially the utility lsdrv, which will tell the experts here
> straight away where your data has decided to play hide-and-seek.
>=20

I had read through most stuff I think but you miss stuff sometimes (the
grey cells are getting old!)

OK - grabbed a copy of lsdrv and results pasted below - for ref I did:

git clone https://github.com/pturmel/lsdrv.git

I ran the script and realised it wanted sginfo which comes in the
s3g-utils package which I then installed.


> ESPECIALLY if you've ddrescued the data to a new drive, I suspect it
> will be a simple matter of "--assemble --force" and your array will bac=
k
> up and running in a flash - well, maybe not a flash, it's got to rebuil=
d
> and sort itself out, but it'll be back and working.
>=20
> (And then, of course, if you have built a new raid with a bunch of
> partitions all on one disk, you need to backup the data, tear down the
> raid, and re-organise the disk(s) into a more sensible long-term
> configuration).
>=20

OK.... here's hoping :-)

> Oh - and putting LVM on top of a raid is perfectly sensible behaviour.
> We have a problem with the raid - let's fix the raid and your LVM shoul=
d
> just come straight back.
>=20

OK - nice to know.


Note below sda and sdb are a mirror with the OS. Drives sd[cdefghij] are
the Raid 6 data volume.

root@garage:/home/john/git/lsdrv# ./lsdrv
PCI [ata_piix] 00:1f.1 IDE interface: Intel Corporation 82801G (ICH7
Family) IDE Controller (rev 01)
=E2=94=9Cscsi 0:x:x:x [Empty]
=E2=94=94scsi 1:x:x:x [Empty]
PCI [ata_piix] 00:1f.2 IDE interface: Intel Corporation NM10/ICH7 Family
SATA Controller [IDE mode] (rev 01)
=E2=94=9Cscsi 2:0:0:0 ATA      Maxtor 6L300S0   {L6159N1H}
=E2=94=82=E2=94=94sda 279.48g [8:0] Partitioned (dos)
=E2=94=82 =E2=94=9Csda1 243.00m [8:1] MD raid1 (1/2) (w/ sdb1) in_sync 'g=
arage:0'
{90624393-3b63-8ad8-9aeb-81cafa3caafc}
=E2=94=82 =E2=94=82=E2=94=94md0 242.81m [9:0] MD v1.2 raid1 (2) clean
{90624393:3b638ad8:9aeb81ca:fa3caafc}
=E2=94=82 =E2=94=82 =E2=94=82                 ext2 {86b99e91-e21e-4381-97=
e3-9b38ea8dae1b}
=E2=94=82 =E2=94=82 =E2=94=94Mounted as /dev/md0 @ /boot
=E2=94=82 =E2=94=9Csda2 1.00k [8:2] Partitioned (dos)
=E2=94=82 =E2=94=94sda5 279.24g [8:5] MD raid1 (1/2) (w/ sdb5) in_sync 'g=
arage:1'
{f624610a-b711-ff4b-3b12-6550a8f78732}
=E2=94=82  =E2=94=94md1 279.12g [9:1] MD v1.2 raid1 (2) clean
{f624610a:b711ff4b:3b126550:a8f78732}
=E2=94=82   =E2=94=82                 PV LVM2_member 279.11g used, 0 free=

{sBqZxo-ybSN-5axJ-VKtQ-HVlJ-KSRd-rQKw5b}
=E2=94=82   =E2=94=94VG xubuntu-vg__raider 279.11g 0 free
{uSpmjO-b5cC-UfQU-7J5h-ZOMo-M6H6-Gb0qOp}
=E2=94=82    =E2=94=9Cdm-0 269.21g [252:0] LV root ext4
{ce84b80b-a8cc-48ed-b8b6-5264c211feaf}
=E2=94=82    =E2=94=82=E2=94=94Mounted as /dev/dm-0 @ /
=E2=94=82    =E2=94=94dm-1 9.90g [252:1] LV swap_1 swap
{20e81f82-d6f9-4f46-8c34-5cece8fc6126}
=E2=94=94scsi 3:0:0:0 ATA      Maxtor 6L300S0   {L6159ETH}
 =E2=94=94sdb 279.48g [8:16] Partitioned (dos)
  =E2=94=9Csdb1 243.00m [8:17] MD raid1 (0/2) (w/ sda1) in_sync 'garage:0=
'
{90624393-3b63-8ad8-9aeb-81cafa3caafc}
  =E2=94=82=E2=94=94md0 242.81m [9:0] MD v1.2 raid1 (2) clean
{90624393:3b638ad8:9aeb81ca:fa3caafc}
  =E2=94=82                   ext2 {86b99e91-e21e-4381-97e3-9b38ea8dae1b}=

  =E2=94=9Csdb2 1.00k [8:18] Partitioned (dos)
  =E2=94=94sdb5 279.24g [8:21] MD raid1 (0/2) (w/ sda5) in_sync 'garage:1=
'
{f624610a-b711-ff4b-3b12-6550a8f78732}
   =E2=94=94md1 279.12g [9:1] MD v1.2 raid1 (2) clean
{f624610a:b711ff4b:3b126550:a8f78732}
                      PV LVM2_member 279.11g used, 0 free
{sBqZxo-ybSN-5axJ-VKtQ-HVlJ-KSRd-rQKw5b}

PCI [aic7xxx] 03:02.0 SCSI storage controller: Adaptec AIC-7892A U160/m
(rev 02)
=E2=94=9Cscsi 4:0:0:0 COMPAQ   BD30089BBA       {DA01P770DB4P0726}
=E2=94=82=E2=94=94sdc 279.40g [8:32] MD raid6 (7) inactive 'garage:Data'
{1a2f92b0-d7c1-a540-165b-9ab70baed449}
=E2=94=9Cscsi 4:0:1:0 COMPAQ   BD30089BBA       {DA01P760D7FW0724}
=E2=94=82=E2=94=94sdd 279.40g [8:48] Partitioned (dos)
=E2=94=9Cscsi 4:0:2:0 COMPAQ   BD30089BBA       {DA01P760DABG0726}
=E2=94=82=E2=94=94sde 279.40g [8:64] MD raid6 (7) inactive 'garage:Data'
{1a2f92b0-d7c1-a540-165b-9ab70baed449}
=E2=94=9Cscsi 4:0:3:0 COMPAQ   BD30089BBA       {DA01P760D9NR0726}
=E2=94=82=E2=94=94sdf 279.40g [8:80] MD  (none/) (w/ sdh) spare 'garage:D=
ata'
{1a2f92b0-d7c1-a540-165b-9ab70baed449}
=E2=94=82 =E2=94=94md127 0.00k [9:127] MD v1.2  () inactive, None (None) =
None {None}
=E2=94=82                      Empty/Unknown
=E2=94=9Cscsi 4:0:4:0 COMPAQ   BD30089BBA       {DA01P760DAKA0726}
=E2=94=82=E2=94=94sdg 279.40g [8:96] Partitioned (dos)
=E2=94=9Cscsi 4:0:5:0 COMPAQ   BD30089BBA       {DA01P770DB4C0726}
=E2=94=82=E2=94=94sdh 279.40g [8:112] MD  (none/) (w/ sdf) spare 'garage:=
Data'
{1a2f92b0-d7c1-a540-165b-9ab70baed449}
=E2=94=82 =E2=94=94md127 0.00k [9:127] MD v1.2  () inactive, None (None) =
None {None}
=E2=94=82                      Empty/Unknown
=E2=94=9Cscsi 4:0:6:0 COMPAQ   BD30089BBA       {DA01P760D9NJ0726}
=E2=94=82=E2=94=94sdi 279.40g [8:128] MD raid6 (7) inactive 'garage:Data'=

{1a2f92b0-d7c1-a540-165b-9ab70baed449}
=E2=94=94scsi 4:0:9:0 COMPAQ   BD30089BBA       {DA01P770DBB80727}
 =E2=94=94sdj 279.40g [8:144] Partitioned (dos)

Other Block Devices
=E2=94=9Cloop0 0.00k [7:0] Empty/Unknown
=E2=94=9Cloop1 0.00k [7:1] Empty/Unknown
=E2=94=9Cloop2 0.00k [7:2] Empty/Unknown
=E2=94=9Cloop3 0.00k [7:3] Empty/Unknown
=E2=94=9Cloop4 0.00k [7:4] Empty/Unknown
=E2=94=9Cloop5 0.00k [7:5] Empty/Unknown
=E2=94=9Cloop6 0.00k [7:6] Empty/Unknown
=E2=94=94loop7 0.00k [7:7] Empty/Unknown




--UkjPEcO7igbQleT91TH3fPUV5uH46alV0--

--qxQVxxOHONrRSMTBtqgkWhxGQ5lAaeRln
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAEBAgAGBQJZ+LYSAAoJEE8bo8Tv0FrJJscH/i6+8QB7xntzUVaIQsSEm6nS
Zyux1RswK3ZM/KHjgCi1TRnTmepKwBVE+ML8kZA741+XygkFpqQZH3UE4C9cjH83
P+SbhpmKPogqkyC63aJoY+vmvS83b5Gi/5o/KHgo9Nkmxb04iX3nZsI3MP6+fSrY
cUdeFsp3o42Bw6e1VQyAxtvjANK1WcuWLZ4vaCeJwWWFeTkecEtvBXhhnuWrTORr
rGodiUgyliGabaQ7eMMYKPXRjykXWltHAe0ZGpePy3l1jk/CRJM9KWdE1EddlrZJ
1CZvAZK/JHZvjH8TrI1eowLHrFdSmf0f3QZWSROOhQKj7tbU2QCgZzgm7PQumao=
=hacw
-----END PGP SIGNATURE-----

--qxQVxxOHONrRSMTBtqgkWhxGQ5lAaeRln--
