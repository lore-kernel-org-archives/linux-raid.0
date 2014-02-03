From: travis+ml-linux-raid@subspacefield.org
Subject: md raid0 with overwritten superblock on 1/4 disks
Date: Sun, 2 Feb 2014 16:41:37 -0800
Message-ID: <20140203004137.GA7193@subspacefield.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

So, I ran "parted" and "mklabel" on the wrong disk; I did it on a
RAID0 member where I had used the entire disk (instead of a partition
as is the convention).

Even though I quit without saving, the damage was done.

On reboot, the RAID would not assemble.

mdadm --examine looks something like this:

/dev/sda:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 4c59a1bc:9cfbe61a:c08ad011:3fda9db6
           Name : hostname:volname
  Creation Time : Sun May 12 20:27:33 2013
     Raid Level : raid0
   Raid Devices : 4

 Avail Dev Size : 5860531120 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 6c0fbaf1:314a4802:429dc206:648ef11b

    Update Time : Sun May 12 20:27:33 2013
       Checksum : 381d9692 - correct
         Events : 0

     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing)

There are active devices 1,2,3 which only leaves 0.

So, I basically reviewed these links:
https://raid.wiki.kernel.org/index.php/RAID_Recovery
https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID

And that second link was a huge win; using overlay files is a brilliant mov=
e.

Aside:

I made a bone-headed move while trying to follow the directions
without GNU parallel, and ended up trying to mdadm --create on
$DEVICES instead of $OVERLAYS but for whatever reason mdadm.super1
failed due to resource in use (by losetup, presumably) on one of the
disks so I think I'm okay.

So, anyway, I can re-create the RAID using:
UUID=3D4c59a1bc:9cfbe61a:c08ad011:3fda9db6
DEVICES=3D"/dev/sdc /dev/sdd /dev/sda /dev/sdb" (they are in different orde=
r now)
parallel 'test -e /dev/loop{#} || mknod -m 660 /dev/loop{#} b 7 {#}' ::: $D=
EVICES
parallel 'size=3D$(blockdev --getsize {}); loop=3D$(losetup -f --show -- ov=
erlay-{/}); echo 0 $size snapshot {} $loop P 8 | dmsetup create {/}' ::: $D=
EVICE
OVERLAYS=3D$(parallel echo /dev/mapper/{/} ::: $DEVICES) # /dev/mapper/sdc =
/dev/mapper/sdd /dev/mapper/sda /dev/mapper/sdb

Then I create using overlays:
# mdadm --create /dev/md127  -v -l 0 -n 4 $OVERLAYS
mdadm: chunk size defaults to 512K
mdadm: /dev/mapper/sdc appears to be part of a raid array:
    level=3Draid0 devices=3D0 ctime=3DWed Dec 31 16:00:00 1969
mdadm: partition table exists on /dev/mapper/sdc but will be lost or
       meaningless after creating array
mdadm: /dev/mapper/sdd appears to be part of a raid array:
    level=3Draid0 devices=3D4 ctime=3DSun May 12 20:27:33 2013
mdadm: /dev/mapper/sda appears to be part of a raid array:
    level=3Draid0 devices=3D4 ctime=3DSun May 12 20:27:33 2013
mdadm: /dev/mapper/sdb appears to be part of a raid array:
    level=3Draid0 devices=3D4 ctime=3DSun May 12 20:27:33 2013
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md127 started.

However, the LUKS on it won't work:
# cryptsetup luksOpen /dev/md127 c =20
Device /dev/md127 is not a valid LUKS device.

And I think I know the reason for this.

The LUKS header is here:

# dd if=3D/dev/md127 bs=3D1M count=3D1 | hexdump -C | grep LUKS
0002e000  4c 55 4b 53 ba be 00 01  61 65 73 00 00 00 00 00  |LUKS....aes...=
=2E.|

And by comparison, the LUKS header on a similarly-organized (4 disk SW
RAID0 partition) that I just created for scratch space looks like this:

# dd if=3D/dev/md126 bs=3D1M count=3D1 | hexdump -C | grep LUKS
00000000  4c 55 4b 53 ba be 00 01  61 65 73 00 00 00 00 00  |LUKS....aes...=
=2E.|

So, there's an obvious problem with offsets involved; possibly the RAID was
created with a different chunk size as the default one, so when I re-create
a RAID on top of it, I get things at strange offsets.

I am quite confident the drives are in the right order, since:

# dd if=3D/dev/sdc bs=3D1M count=3D1 | hexdump -C | grep LUKS
00030000  4c 55 4b 53 ba be 00 01  61 65 73 00 00 00 00 00  |LUKS....aes...=
=2E.|

No such LUKS header exists on the first 1M of any of the other disks.

However, I do find it a bit odd that the new, similar RAID has this
(note this RAID is installed into a partition on every drive):

# dd if=3D/dev/sdf1 bs=3D1M count=3D1 | hexdump -C | grep LUKS
00002000  4c 55 4b 53 ba be 00 01  61 65 73 00 00 00 00 00  |LUKS....aes...=
=2E.|

Which suggests to me that there's something a bit off in the header or chun=
king.

Oddly:

# dd if=3D/dev/sdc bs=3D1M count=3D100 | hexdump -C | grep LUKS
00030000  4c 55 4b 53 ba be 00 01  61 65 73 00 00 00 00 00  |LUKS....aes...=
=2E.|
00100000  4c 55 4b 53 ba be 00 01  61 65 73 00 00 00 00 00  |LUKS....aes...=
=2E.|

It's somewhat possible that one of these is left over from another
time because I did not prefill the disks.  I am quite sure that the
disks in the RAID which failed were not partitioned.

Incidentally, the "break" between unencrypted and encrypted data in each sy=
stem is:

/dev/sdd:
00005790  20 53 61 74 20 4d 61 72  20 20 39 20 31 39 3a 35  | Sat Mar  9 19=
:5|
000057a0  37 3a 34 35 20 32 30 31  33 0a 0a 00 00 00 00 00  |7:45 2013.....=
=2E.|
000057b0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..............=
=2E.|
*
00030000  0a d0 1e 45 be 9b e6 89  3c 5b c1 ae 6c 11 61 64  |...E....<[..l.=
ad|
00030010  94 b2 84 8a c4 3e 25 32  a3 68 43 d8 8a 7a 2b de  |.....>%2.hC..z=
+.|
00030020  a2 4d e9 86 3c 78 08 c3  be 75 f2 bf 76 d0 12 33  |.M..<x...u..v.=
=2E3|
00030030  a6 99 58 21 1f b5 ae d6  47 c9 6c 72 18 48 b9 b0  |..X!....G.lr.H=
=2E.|
00030040  2c 5d a8 43 a5 64 5e 9c  6d e3 dc 3e 63 fe f1 1a  |,].C.d^.m..>c.=
=2E.|
00030050  e7 f0 72 29 60 e1 75 74  4d 90 b6 b0 d8 70 0e ff  |..r)`.utM....p=
=2E.|
00030060  f4 10 dd 00 09 3d 52 a1  a0 c0 16 52 9c a7 62 96  |.....=3DR....R=
=2E.b.|

/dev/sda:
0002fc00  0e 0e 0e 0e 0e 0e 0e 0e  0e 0e 0e 0e 0e 0e 0e 0e  |..............=
=2E.|
*
0002fe00  0f 0f 0f 0f 0f 0f 0f 0f  0f 0f 0f 0f 0f 0f 0f 0f  |..............=
=2E.|
*
00030000  1a ae e4 a0 e0 35 54 fc  bb 12 68 1a 4d 2f 5b e7  |.....5T...h.M/=
[.|
00030010  ef cb 96 45 95 8c bd 05  4f cd 95 4e c9 46 80 be  |...E....O..N.F=
=2E.|
00030020  f3 b4 fc 45 06 d7 84 ee  9b 42 57 92 65 4c 29 2c  |...E.....BW.eL=
),|

/dev/sdb:
00000260  00 00 00 00 00 00 00 00  00 10 00 00 00 00 00 00  |..............=
=2E.|
00000270  00 f0 02 00 00 00 00 00  00 00 00 00 00 00 00 00  |..............=
=2E.|
00000280  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..............=
=2E.|
*
00000800  4a be d0 23 57 a8 4b bc  7e 02 05 bd 59 4c 00 07  |J..#W.K.~...YL=
=2E.|
00000810  03 48 e9 92 2b 3a 16 1f  f5 f3 37 f3 25 46 b0 14  |.H..+:....7.%F=
=2E.|

It's a bit strange that /dev/sdb has some encrypted data before offset
0x30000, but given the fact that these disks were reused without
clearing or prefilling, and that /dev/sda and /dev/sdd start encrypted
data at 0x30000, chances are good that's left over from a previous
use.

Anyone got any ideas on how to recover it?

It would be trivial to partition /dev/sdc and in so doing, ignore the first
0x30000 or 0x100000 bytes, but since none of the other disks are partitione=
d,
I don't think that's the way it was configured initially.

FWIW, I may have configured this RAID initially on an older debian
ARMv5TE system and migrated it to a more conventional x64_64 Ubuntu
when the ARMv5/OpenRD box proved unstable.
--=20
http://www.subspacefield.org/~travis/
Remediating... LIKE A BOSS



--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (OpenBSD)

iQIcBAEBAgAGBQJS7uXBAAoJEGQVZZEDJt9HSMAP/3ieXvT2MEsPJnNMIgo1EdJj
VxCpqKFsB2TSEYi0cTybz7NTZPg5X2zyTOo95CAiTEYO1FzkZGTdDBcnwvxp4AYF
jE0SeCtRG10d4XZ8+Cpu21Crlp5YlZoX3CsMEUrTwaRRG98j5f67yATYBe+yLKxk
nBhdjHyGKZegHHFItpBCpw9VlZWDitFvwhjLtm6qT9zntibhKBFl/UdEz4D22ctu
8fqJG+SlOIruM5AOFEAPHJl5aQMmx8Jnufiu4aOZZz85pPItbnnY3yVOLuhX2IVZ
jrbEr7gZKjeCDwDZ3vsXlOwrU8KJldj6pO8h6exsKEDn66Q7DnqoZDEmORTb+ENQ
P17TqSB5sEwTgNq6To0kqSusBtdHUnDyMWFZHmCPloFGoQTRc/ywCGMX8kQPDyhp
AkqKCxmPAooJ/RD1sRpsWXI/Zqb4mGRXXMDbo3xCnyo60fRVpoti9y1390BzjgEX
HxYQT8IUHOJr6r943LB1fm3u9++U2CegL/27aTl1CgBOxzM1by7tXA/7YXke0loS
gXFmYXnyWRLVBN33gndc1xR+2HRej1eZLSmfNF6gdJHtWKRvyzLb0hHr2F+nD11N
bd2hXvso7x2HpYMgOP/AMGHOnEAJkCI84oNjft1WOwlEAjQGAPB+PtSGdtQK7e0Y
XXf5Yk+1E4RVdoA7sDfN
=Yksw
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
