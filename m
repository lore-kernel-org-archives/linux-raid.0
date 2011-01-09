From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?=
	<phcoder@gmail.com>
Subject: Re: Bug#597563: grub-common: grub-probe segfaults scanning lvm devices
Date: Sun, 09 Jan 2011 22:32:01 +0100
Message-ID: <4D2A2951.5020902@gmail.com>
References: <20100920202854.27101.8288.reportbug@cheetah.fastcat.org>	<4D274FF9.8010004@gmail.com>	<alpine.DEB.2.00.1101072241560.25170@cheetah.fastcat.org>	<4D285B79.9040100@gmail.com>	<alpine.DEB.2.00.1101081739500.14736@cheetah.fastcat.org> <20110110075543.4969998e@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig20F2D1285165113064892802"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110110075543.4969998e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Matthew Gabeler-Lee <cheetah@cheetah.fastcat.org>, 597563@bugs.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig20F2D1285165113064892802
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 01/09/2011 09:55 PM, NeilBrown wrote:
> On Sat, 8 Jan 2011 17:53:07 -0500 (EST) Matthew Gabeler-Lee
> <cheetah@cheetah.fastcat.org> wrote:
>
>  =20
>> On Sat, 8 Jan 2011, Vladimir '=CF=86-coder/phcoder' Serbinenko wrote:
>>
>>    =20
>>> As was recommended I forward the remaining part to linux-raid mailing=
 list.
>>> In short: on his system mdraid, raid5, 4 devices, metadata (presumabl=
y)
>>> 0.90, two devices have index 0.
>>>      =20
> What do you mean by "two devices have index 0" ??? I could see nothing =
in any
> of the posts you sent that could be interpreted that way.
>
>  =20
Sorry, I forgot this part:
grub-core/disk/raid.c:699: Scanning for RAID devices on disk hd2
grub-core/kern/disk.c:245: Opening `hd2'...
=2E/grub-probe: info: the size of hd2 is 1465149168.
error: found two disks with the number 0.
grub-core/kern/disk.c:330: Closing `hd2'.

Trouble comes from followint part:
$ sudo mdadm --examine /dev/sdb
/dev/sdb:
          Magic : a92b4efc
        Version : 0.90.03
           UUID : 9364f7a2:d74695d5:7d8db3a0:3b5f9e48
  Creation Time : Mon Mar 27 14:03:04 2006
     Raid Level : raid1
  Used Dev Size : 979840 (957.04 MiB 1003.36 MB)
     Array Size : 979840 (957.04 MiB 1003.36 MB)
   Raid Devices : 2
  Total Devices : 3
Preferred Minor : 0

    Update Time : Thu Jan  8 00:34:39 2009
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 5b8134eb - correct
         Events : 9446738
So sdb as whole pretends to be a part of the following array:
$ sudo mdadm -QD /dev/md0
/dev/md0:
        Version : 0.90
  Creation Time : Mon Mar 27 14:03:04 2006
     Raid Level : raid1
     Array Size : 2008000 (1961.27 MiB 2056.19 MB)
  Used Dev Size : 2008000 (1961.27 MiB 2056.19 MB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sat Jan  8 18:35:47 2011
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

           UUID : 9364f7a2:d74695d5:7d8db3a0:3b5f9e48
         Events : 0.10758124

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       2       8        1        2      active sync   /dev/sda1
       3       8       49        3      active sync   /dev/sdd1


As you can see there is a stalled superblock approximately 2 years old.
I don't know if it's some kind of freak accident or operator error. If
it's later then probably zero-filling over stalled superblock will solve
the problems

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko



--------------enig20F2D1285165113064892802
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk0qKVEACgkQNak7dOguQgnYiwD+L858dwg9O0aUHLNNPD9QXAIc
QI7DCVmsZe+zYWN9JakA/0ascDre/MxX2I2oiC6v2Flwy512+R/9VEIZTW7QIl7e
=w3Lo
-----END PGP SIGNATURE-----

--------------enig20F2D1285165113064892802--
