From: NeilBrown <neilb@suse.de>
Subject: Re: Successfully recovered Raid5 no longer boots
Date: Thu, 9 May 2013 15:09:28 +1000
Message-ID: <20130509150928.51689192@notabene.brown>
References: <CALzQTgJZ0t018RAYvymP7=Po6-2N6RdiP=qgdojnMri_4mKzaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/RR/jDiavufV+i55L6A/v0bT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALzQTgJZ0t018RAYvymP7=Po6-2N6RdiP=qgdojnMri_4mKzaw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ricky <rickyorbixx@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/RR/jDiavufV+i55L6A/v0bT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 7 May 2013 00:35:10 +0100 Ricky <rickyorbixx@gmail.com> wrote:

> Hello everybody,
>=20
> First time posting to this list, so please forgive any oversights with
> etiquette and missing information and such.
>=20
> I've not long recovered a Raid-5 array compromising of 4 disks with 2
> failing (not failed) disks, with a 1-by-1 swap-out of new matching
> disks. I did this with a live CD and the data was totally fine,
> mountable, no issues at all.
>=20
> Then I go to boot it back up, and kernel output shows that only 2 of the
> 4 disks could be brought up and the raid could naturally not be brought
> online, resulting in obvious failure. I panic, go back to the live CD,
> but nope, the raid is totally fine according to all the output.
>=20
> I spoke to a friendly person on freenode's ##linux who suggested
> checking if all disks including the new ones were using the 0.9
> superblock that my older disks were, I jumped the gun a bit and decided
> to upgrade them all to 1.0, only to find the kernel of the system on
> disk did not have a version of md that supports that new superblock, so
> I downgraded it. I performed this by offlining the array and recreating
> it based on the output of --detail but specifically passing the
> superblock parameter, as per your Wiki instructions, still no good
> however. Didn't mess up the recreation as the partition still totally
> accessible via the live CD.
>=20
> It's at this point that I'm stuck, I've no idea what to do next and hope
> you can advise. Details below:
>=20
> System: CentOS 5.9, kernel 2.6.34.6

You probably need to find someone who knows something about the boot sequen=
ce
of Centos.
Maybe  you need to create a new initrd with a new mdadm.conf in it.  Or may=
be
you just need to install grub onto the mbr or something.

NeilBrown


>=20
> mdadm --examine /dev/sd*2
> /dev/sda2:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 06dc023e:47dbfdaa:a4d2adc2:26fd5302 (local to host
> localhost)
>   Creation Time : Mon May  6 23:45:15 2013
>      Raid Level : raid5
>   Used Dev Size : 1462512576 (1394.76 GiB 1497.61 GB)
>      Array Size : 4387537728 (4184.28 GiB 4492.84 GB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 0
>=20
>     Update Time : Mon May  6 23:47:24 2013
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : bdf0c5f1 - correct
>          Events : 1
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>       Number   Major   Minor   RaidDevice State
> this     0       8        2        0      active sync   /dev/sda2
>=20
>    0     0       8        2        0      active sync   /dev/sda2
>    1     1       8       18        1      active sync   /dev/sdb2
>    2     2       8       34        2      active sync   /dev/sdc2
>    3     3       8       50        3      active sync   /dev/sdd2
> /dev/sdb2:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 06dc023e:47dbfdaa:a4d2adc2:26fd5302 (local to host
> localhost)
>   Creation Time : Mon May  6 23:45:15 2013
>      Raid Level : raid5
>   Used Dev Size : 1462512576 (1394.76 GiB 1497.61 GB)
>      Array Size : 4387537728 (4184.28 GiB 4492.84 GB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 0
>=20
>     Update Time : Mon May  6 23:47:24 2013
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : bdf0c603 - correct
>          Events : 1
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>       Number   Major   Minor   RaidDevice State
> this     1       8       18        1      active sync   /dev/sdb2
>=20
>    0     0       8        2        0      active sync   /dev/sda2
>    1     1       8       18        1      active sync   /dev/sdb2
>    2     2       8       34        2      active sync   /dev/sdc2
>    3     3       8       50        3      active sync   /dev/sdd2
> /dev/sdc2:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 06dc023e:47dbfdaa:a4d2adc2:26fd5302 (local to host
> localhost)
>   Creation Time : Mon May  6 23:45:15 2013
>      Raid Level : raid5
>   Used Dev Size : 1462512576 (1394.76 GiB 1497.61 GB)
>      Array Size : 4387537728 (4184.28 GiB 4492.84 GB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 0
>=20
>     Update Time : Mon May  6 23:47:24 2013
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : bdf0c615 - correct
>          Events : 1
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>       Number   Major   Minor   RaidDevice State
> this     2       8       34        2      active sync   /dev/sdc2
>=20
>    0     0       8        2        0      active sync   /dev/sda2
>    1     1       8       18        1      active sync   /dev/sdb2
>    2     2       8       34        2      active sync   /dev/sdc2
>    3     3       8       50        3      active sync   /dev/sdd2
> /dev/sdd2:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 06dc023e:47dbfdaa:a4d2adc2:26fd5302 (local to host
> localhost)
>   Creation Time : Mon May  6 23:45:15 2013
>      Raid Level : raid5
>   Used Dev Size : 1462512576 (1394.76 GiB 1497.61 GB)
>      Array Size : 4387537728 (4184.28 GiB 4492.84 GB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 0
>=20
>     Update Time : Mon May  6 23:47:24 2013
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : bdf0c627 - correct
>          Events : 1
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>       Number   Major   Minor   RaidDevice State
> this     3       8       50        3      active sync   /dev/sdd2
>=20
>    0     0       8        2        0      active sync   /dev/sda2
>    1     1       8       18        1      active sync   /dev/sdb2
>    2     2       8       34        2      active sync   /dev/sdc2
>    3     3       8       50        3      active sync   /dev/sdd2
>=20
> mdadm --detail /dev/md0
> /dev/md0:
>         Version : 0.90
>   Creation Time : Mon May  6 23:45:15 2013
>      Raid Level : raid5
>      Array Size : 4387537728 (4184.28 GiB 4492.84 GB)
>   Used Dev Size : 1462512576 (1394.76 GiB 1497.61 GB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 0
>     Persistence : Superblock is persistent
>=20
>     Update Time : Mon May  6 23:47:24 2013
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>            UUID : 06dc023e:47dbfdaa:a4d2adc2:26fd5302 (local to host
> localhost)
>          Events : 0.1
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8        2        0      active sync   /dev/sda2
>        1       8       18        1      active sync   /dev/sdb2
>        2       8       34        2      active sync   /dev/sdc2
>        3       8       50        3      active sync   /dev/sdd2
>=20
> Many thanks in advance for any advice you have,
> Ricky Burgin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/RR/jDiavufV+i55L6A/v0bT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUYsviDnsnt1WYoG5AQJfmQ//e3jDaiC15Es1rm03Io8h9UHipfw/nXta
G7WRaI3pNjIc7U6RRDjENdn4bGwZ1oLnpCCkOx0DcYJ4Ea7Z55Orc4kw0zX2sbug
Ta2bAr7SU4znFl0hAf82xkIX2243xZEO8VOGCXS8jGNOcfsFmEyI7CoZLseTSfUc
OVF7G7hV8Np7BFDoJE9KtJsNQGxjv4MIs9dGCAn6BH3skogpPGc0M9Btfo8mk8PA
l3V1NL7OIVnu0kMNqu2u+SYKf9jBSiU9hH5ab9wxAOXEJMDLyyjyq30kxaAwVTHI
b3ENxYJP0cgbHz6bLZUjiH5pp9Mo/TO7EfcsOyBe31QTcEP079gnzyO2CWZIH6Kl
lEFsfAFKepYbnap2eDvmTuK+aKY+gPKDM40ljl6JOlpagQHkcdq73cscF+HGGvyf
Zms8LwD0ANn5MqjVXoS/6JjPLqT1Ee02eZhfYL6lJWSZZzbr53Wl/YoBMouS3cvv
5v3xFsdPsQEaBLEpy25IhIa6TwcGF53U+tdpYsfWUXJyzrpt1el/J6D3o8SHbWd9
44diF+TMEvllrGst61DL8xS/M0ZjQxBNA7gZaZDXsBUVoWZRVIvvcdfMG0uq1JZI
hGZErWxqrfrFNro/xWR2ylC/2+VhLf2ZJYlxgUphupDIfuUYXixudCyoBncqC0+M
pGpzmfxdK60=
=ZTKD
-----END PGP SIGNATURE-----

--Sig_/RR/jDiavufV+i55L6A/v0bT--
