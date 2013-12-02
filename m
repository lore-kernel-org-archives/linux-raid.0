From: NeilBrown <neilb@suse.de>
Subject: Re: Raid10 multi core scaling
Date: Mon, 2 Dec 2013 20:04:10 +1100
Message-ID: <20131202200410.41f50cd5@notabene.brown>
References: <20131126105859.Horde.-ppIIPYRo99SlH7zGogGx_A@webmail.aeiou.pt>
	<20131202172207.7400e03a@notabene.brown>
	<529C42A1.3010400@hesbynett.no>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BsZwRQWSE1nOy5G.ltxljqA"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <529C42A1.3010400@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Pedro Teixeira <finas@aeiou.pt>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/BsZwRQWSE1nOy5G.ltxljqA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 02 Dec 2013 09:19:45 +0100 David Brown <david.brown@hesbynett.no>
wrote:

> On 02/12/13 07:22, NeilBrown wrote:
> > On Tue, 26 Nov 2013 10:58:59 +0000 Pedro Teixeira <finas@aeiou.pt> wrot=
e:
> >=20
> >>    I created a Raid10 array with 16 sata 1TB disks and the array
> >> performance
> >> seems to be limited by the md0_raid10 taking 99% of one core and not
> >> scalling to other cores. I tried overclocing the cpu cores and this le=
ad to
> >> a small increase in performance ( but md0_raid10 keeps eating 99% of o=
ne
> >> core ).
> >=20
> > Are you really talking about general array performance, or just resync
> > performance?
> >=20
> > Because md0_raid10 doesn't do much work for normal IO so that should sc=
ale to
> > multiple processors.
> > I'm not sure that optimising resync to use more than one processor is r=
eally
> > much of a priority - is it?
> >=20
> > NeilBrown
>=20
> I think that depends a bit on whether we are talking about md raid10, or
> raid1+0.  For md raid10, resyncs and rebuilds are always going to take a
> bit of time - data has to be copied back and forth across the same
> disks, with a lot of head movement (especially for "far" layout).  I
> don't see that it would take much cpu time, however.  And this sort of
> layout is mostly for small arrays - it gives great performance when you
> have two drives, and perhaps up to about 4 drives.  But after that,
> people probably want raid1+0 layouts (i.e., raid0 stripes of raid1 pairs).
>=20
> For raid1 + 0, resync time /is/ important - it is one of the reasons
> people pick it, especially the time to resync a single replaced drive.
> But again, I can't see how that would take cpu time.
>=20
> I suppose that when doing the initial sync of this 16 disk array, you
> have to read in all data from 8 disks and write it out to the other 8
> disks.  That's a lot of IO passing through the cpus, even if there is no
> calculations going on.  But I thought each raid1 pair already had its
> own thread, so this would be scaled across 8 cores?  Is md raid10
> limited to just one thread?

For recovery the data should not pass through the CPU.  But it still has to
handle thousands of IO requests.
For resync, we read both copies and compare only writing if they differ.
This can be more efficient when the device is a lot slower than the CPU.

md/raid10 is currently limited to just one thread.

NeilBrown

>=20
> mvh.,
>=20
> David
>=20
>=20
> >=20
> >=20
> >>
> >>    I'm using:
> >>     - a phenom X6 at 3600mhz
> >>     - 16 seagate SSHDs ( sata3 7200RPM with 8GB ssd cache )
> >>     - 4x marvell 9230 sata3 controllers ( 4 ports each ) pcie 2.0 2x
> >> lanes.
> >>     - 8GB ram
> >>     - custom 3.12 kernel and mdadm compiled from latest source
> >>
> >>    what I did to test performance was to force a check on the array, a=
nd
> >> this
> >> leads to mdadm reporting a speed of about 990000K/sec. The hard disks
> >> report a 54% utilization. ( Overclocking the cpu by 200mhz increases t=
he
> >> resync speed a bit and the hdd's utilizartion to about 58% )
> >>
> >>    If I do the same with a raid5 array instead of raid10, them resync
> >> speed
> >> will be almost double of raid10, the harddisk utilization reported wil=
l be
> >> 98-100% and I can see at least two cores being used.
> >>
> >> ______________________________________________________________________=
__________
> >> Mensagem enviada atrav=C3=A9s do email gr=C3=A1tis AEIOU
> >> http://www.aeiou.pt
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20


--Sig_/BsZwRQWSE1nOy5G.ltxljqA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUpxNCjnsnt1WYoG5AQJe4A//SeYQKY7zbCPNywwaygwRy2ec+09OJNfj
SVUvCypnQcTktRbR73HSJ0GSKb3m8MGzZYzH9m0J0FfJs7Oe6Y8AXJSW2Qo/GaDM
roX3i2CyPoconHqB+MaAYYG/eFdJ6hil/v5rixd5Avos8GBoiNm0JEIqnO0/p52l
2Ku8lonFYEgVMlNLHwOBmYM/AtIRLMjW2/0zR189pibL3yA/MeOAW3A4y/N/iugL
ueK4h3VOrou1iBLYEViDWIEnbaHYTAHN+s1/IjVpwcPrbJtXalWsg2OmHzF4lRaB
8dwoT4DdgTfFnJgoJxqFUG0FDokTqgOet2UT8FqKhdf83Bp5rp+gUruC7MftwE1i
h97WFUNtZZO0GmN5aE9bzpIVnshyE3KDoZf4eLM6LCDK8E+Tos+sLBFx/ylqamf/
nkwQuRaLHCz8aXUTFC9rrOYvtdGZC+tdr9gS7Wc8SGP1s+GIPcBCJxR3QbRyCSRR
2ER2BncP763rYwQAUtuFbJ9YM3TefR04HjDmLvS+7pAkeBsiXd5NzgR2u5sOJpBx
1wL+orbdi3E0Tt+M3uyxU26yQICEDIU5PPq6WLueNVNiV4kTu0pFVDIAZeAdxGIb
//MzHBcEs8alOkGNm+oO0xOmqzguq5ChKfcdPHndKCYe62m2q7Cr9LFWXyW4j3E4
0eFJq6R3Fxc=
=dOQ3
-----END PGP SIGNATURE-----

--Sig_/BsZwRQWSE1nOy5G.ltxljqA--
