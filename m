From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Rebuild events while scrubbing - problems or just informational?
Date: Tue, 10 Dec 2013 08:52:25 +0000
Message-ID: <20131210085225.GA441@cthulhu.home.robinhill.me.uk>
References: <CAK2H+ed3vEJVF8To8FWD_Ltj7jGKgrBAvz-Aum4viR=VZE+gww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK2H+ed3vEJVF8To8FWD_Ltj7jGKgrBAvz-Aum4viR=VZE+gww@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Dec 09, 2013 at 02:27:09PM -0800, Mark Knecht wrote:

> Hi,
>    A few weeks back I set up cron to do a weekly scrub on my home
> machine. I've since noticed these rebuild event messages in the logs
> for each scrub that's occurred so far. Are they just part of the
> normal process of mdadm doing it's work or are they pointing to some
> sort of problem I'm not yet recognizing? I found it interesting that
> they were all almost exactly 33 minutes, 20 seconds apart. Are the 5
> messages related to the 5 drives in my RAID6?
>=20
>    I found numerous others who have seen this over the years and say
> it's not indicative of any problem but did recommend running smartctl
> so I've done smartctl -t long tests on all the drives and didn't see
> anything special getting reported. All tests completed without errors
> so I'm hoping these messages just part of the normal reporting but
> don't remember seeing them in the past. Note that for a long time (a
> year maybe?) I completely forgot about scrubbing so there is a big gap
> in my memory here.
>=20
>    I'm running a more or less stable Gentoo amd64 box. The kernel is
> 3.10.22 and mdadm is version 3.2.6-r1 which is the latest stable
> version in portage.
>=20
> Thanks in advance,
> Mark
>=20
> c2RAID6 log # cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md3 : active raid6 sdb3[9] sdf3[5] sde3[6] sdd3[7] sdc3[8]
>       1452264480 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5] [=
UUUUU]
>=20
> unused devices: <none>
> c2RAID6 log #
>=20
>=20
> Dec  8 14:30:01 c2RAID6 kernel: [29557.910269] md: data-check of RAID arr=
ay md3
> Dec  8 14:30:01 c2RAID6 kernel: [29557.910272] md: minimum
> _guaranteed_  speed: 1000 KB/sec/disk.
> Dec  8 14:30:01 c2RAID6 kernel: [29557.910274] md: using maximum
> available idle IO bandwidth (but not more than 200000 KB/sec) for
> data-check.
> Dec  8 14:30:01 c2RAID6 kernel: [29557.910278] md: using 128k window,
> over a total of 484088160k.
>=20
>=20
> Dec  8 14:30:01 c2RAID6 mdadm[1838]: RebuildStarted event detected on
> md device /dev/md/3
> Dec  8 15:03:21 c2RAID6 mdadm[1838]: Rebuild26 event detected on md
> device /dev/md/3
> Dec  8 15:36:41 c2RAID6 mdadm[1838]: Rebuild49 event detected on md
> device /dev/md/3
> Dec  8 16:10:01 c2RAID6 mdadm[1838]: Rebuild70 event detected on md
> device /dev/md/3
> Dec  8 16:43:21 c2RAID6 mdadm[1838]: Rebuild87 event detected on md
> device /dev/md/3
>=20

They're perfectly normal if you're doing a repair - I don't think they
should be there for a check though. It's just mdadm in monitor mode
reporting the progress (the numbers are the percentage completed) to
syslog.  According to the manual the default reporting interval is 20
percent, but I think it actually triggers on a completed stripe (or
block of stripes) so the numbers aren't exactly on the interval.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlKm1kgACgkQShxCyD40xBL7ugCbBRYrDi7xCteKaXaLO0ytiGZ6
Km4AoKWQwttB+I3OwPi1lDoyUdgAxtUN
=qUhf
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
