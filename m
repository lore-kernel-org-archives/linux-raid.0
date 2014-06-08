From: Davide Guarisco <guarisco@sbcglobal.net>
Subject: Re: Recovering RAID set after OS disk failed
Date: Sat, 7 Jun 2014 21:57:33 -0700
Message-ID: <E3419417-9682-4F30-922E-9EBA0C2B4B0D@sbcglobal.net>
References: <7C19F7E4-7354-4C2C-A53E-DA546B569201@sbcglobal.net> <000801cf7e5f$53ffce20$fbff6a60$@kovari.priv.hu> <A2FAF98E-1CEC-41C5-8AA4-9CE707A477F6@sbcglobal.net> <538D65AC.1090706@eyal.emu.id.au> <A5637DAF-91A1-4313-9314-13058D65F0C0@sbcglobal.net> <538EAC90.9030201@eyal.emu.id.au>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: multipart/signed; boundary="Apple-Mail=_72443A69-8256-4C8C-B76A-745FC09E2996"; protocol="application/pgp-signature"; micalg=pgp-sha1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <538EAC90.9030201@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Apple-Mail=_72443A69-8256-4C8C-B76A-745FC09E2996
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252


On Jun 3, 2014, at 22:20, Eyal Lebedinsky <eyal@eyal.emu.id.au> wrote:

>=20
>=20
> On 06/04/14 15:00, Davide Guarisco wrote:
>>=20
>> On Jun 2, 2014, at 23:05, Eyal Lebedinsky <eyal@eyal.emu.id.au> =
wrote:
>>=20
>> [=85]
>>=20
>> OK, I am lost now.
>>=20
>> Davide
>=20
> So you do not have an fstab entry, no problem. File systems usually =
mount just fine
> with automatic detection (replace mountPoint with the directory where =
it usually mounts).
> 	sudo mount -o ro /dev/md0 /mountPoint
> [if it looks good then you can remove the readonly option '-o ro']
>=20
> Or you can check the array directly:
> 	sudo file -s /dev/md0
>=20
> For me I get:
>=20
> $ sudo file -s /dev/md0
> /dev/md0: Linux rev 1.0 ext4 filesystem data, =
UUID=3D1db56f55-de4f-435e-80ed-e525f07d30df, volume name "data1" (needs =
journal recovery) (extents) (64bit) (large files) (huge files)
>=20
> If there is no fs showing then you probably did have some partitions. =
Or it did
> not assemble correctly (hope not).
>=20
> cheers


I was busy for the last few days=85.

So, yes, it is working !!!!

davide@gecko:~$ sudo mdadm --detail /dev/md0
/dev/md0:
        Version : 0.90
  Creation Time : Tue Mar  3 23:27:50 2009
     Raid Level : raid5
     Array Size : 2930279808 (2794.53 GiB 3000.61 GB)
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed May 28 21:52:54 2014
          State : clean=20
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

           UUID : f8a943c7:2ffa13d0:9770de34:eca2e81c (local to host =
gecko)
         Events : 0.46

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       2       8       49        2      active sync   /dev/sdd1
       3       8       65        3      active sync   /dev/sde1


And of course, I need to mount it=85.

davide@gecko:~$ sudo mkdir /gecko
davide@gecko:~$ sudo mount /dev/md0 /gecko

cd /gecko, ls shows me all my files!

Now all is left to do is to save the fstab entry and install netatalk.

Thanks a lot to all who helped me out!

Davide


--Apple-Mail=_72443A69-8256-4C8C-B76A-745FC09E2996
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJTk+09AAoJEOP6S0R9UICWpo0P/iSbR31YDyifJThvcuYgflGv
jaipIJ49AyYc2muVcn4+Ai4D6k0BV4qjnMfXP2S0GKYPhFSonhmFhr80F48WPM2x
TSq1Mmf56iZR75hBit5X/IhnHT7IGbVoPBHf6Asg5FAJjd86X+J47FWN5xBtBmD2
bsN4Y4SKIwqSguFwY26iBoOyI7xa5WkoiuBZe4RooUTdSlxXrbY6Gja+V5pI7/kx
ZuOVO8mXf6oYTwyp0eAAOEG5CAQ64wIahLB07rlvZCD6kz74JZzPiur4g4Gzy7LI
kxn0YDwcOw9t737SXp4vufXQtBSfRHDSQSqrAifIH4Fc34tbiSKasQo/UnF5TckE
wkWecDBHCaEJ7VFjRnvpl4aWzJTj4t7+/1D98RD2x5BJ/uThXHQ/5M1UrbNTstOE
s2AdkhkhTP5akTP7haE0prJP9t3YSZWa0Nn9eKMWa3OKRPnUVGQhGg6f9aEM9UHp
jUiNeEzjVnQPFK4/S4tLxgpTDqvFn21Y0OIMYQcqq8MqhRfOb7Dcoz72MxFV9opy
apRDB6D4e301V0VkiAh3+0J/XkJxGe1s0HpN/fPYHJnrMOSON1kJaKWAe1PW1+I1
swXR5U3OYgX6gyQbqUM8d/ubkcxicnoGKCuMpEPtYaEsBmFa6FCcER9/C/MCNRVX
3mKjtvsZgu0LsmpkEPhx
=xdZ2
-----END PGP SIGNATURE-----

--Apple-Mail=_72443A69-8256-4C8C-B76A-745FC09E2996--
