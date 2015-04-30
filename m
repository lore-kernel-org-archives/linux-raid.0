From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 04/10] Show all bitmaps while examining bitmap
Date: Thu, 30 Apr 2015 14:45:26 +1000
Message-ID: <20150430144526.35b5c5ff@notabene.brown>
References: <1429860641-5839-1-git-send-email-gqjiang@suse.com>
	<1429860641-5839-5-git-send-email-gqjiang@suse.com>
	<20150429114140.07b20a08@notabene.brown>
	<55419EC8.4030407@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/03Uh5xxhqkHswK9Ghz2NIQX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55419EC8.4030407@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqJiang@suse.com>
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

--Sig_/03Uh5xxhqkHswK9Ghz2NIQX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 30 Apr 2015 11:17:28 +0800 Guoqing Jiang <gqJiang@suse.com> wrote:

> NeilBrown wrote:
> > On Fri, 24 Apr 2015 15:30:35 +0800 gqjiang@suse.com wrote:
> >
> >  =20
> >> From: Guoqing Jiang <gqjiang@suse.com>
> >>
> >> This adds capability of exmining bitmaps corresponding to all
> >> nodes/slots on the device.
> >>
> >> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> >> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> >> ---
> >>  bitmap.c | 35 ++++++++++++++++++++++++++---------
> >>  1 file changed, 26 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/bitmap.c b/bitmap.c
> >> index b1d54a6..ab83f4e 100644
> >> --- a/bitmap.c
> >> +++ b/bitmap.c
> >> @@ -258,7 +258,7 @@ int ExamineBitmap(char *filename, int brief, struc=
t supertype *st)
> >>  	int rv =3D 1;
> >>  	char buf[64];
> >>  	int swap;
> >> -	int fd;
> >> +	int fd, i;
> >>  	__u32 uuid32[4];
> >> =20
> >>  	fd =3D bitmap_file_open(filename, &st);
> >> @@ -315,9 +315,6 @@ int ExamineBitmap(char *filename, int brief, struc=
t supertype *st)
> >>  		       uuid32[2],
> >>  		       uuid32[3]);
> >> =20
> >> -	printf("          Events : %llu\n", (unsigned long long)sb->events);
> >> -	printf("  Events Cleared : %llu\n", (unsigned long long)sb->events_c=
leared);
> >> -	printf("           State : %s\n", bitmap_state(sb->state));
> >>    =20
> >
> > Can we please leave this where it is in the case where there is only on=
e node?
> > Only move it down if there are multiple nodes to report on.
> >
> >  =20
> Yes, it could be possible. Just to make sure understand you correctly,
> what about the below?
>=20
> if (sb->nodes =3D=3D 0) {
>     /* code for more than one node */
> } else {
>    /* original code */
> }
>=20

Something a bit like that, though !=3D0 of course.

The original code put some info at the top.  When there are multiple nodes
that makes more sense  at the bottom.
So:

 if (sb->nodes =3D=3D 0) {
    original code that will be moved
 }
 more original code that isn't changing
 if (sb->nodes =3D=3D 0) {
    other original code
 } else {
    new code
 }

or something like that.

Thanks,
NeilBrown


> Thanks,
> Guoqing
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/03Uh5xxhqkHswK9Ghz2NIQX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVUGzZjnsnt1WYoG5AQITBg//QUv9wTt8T3ccGA/1nOcExghJAkzhTOr2
2f4V241PcOd9dF5xwka+auAkpL+QGaGnJTQ+c7yEPwRuBhOMxLzty7gmPLTXwaUl
H6XcbPpSS83doM99kzrVEsGFJv5w90lQYsdRh7oCj5o5cBGsuIJsF7O8gzatCchI
PWDLdmIdpAwOnoMGrrxRLS6IRnf1cnb1HbVbUQFFSTkyRICdBFCTiPndHnaT7+E1
lUYYXPc0VEK0x34JqCu3VfRRKBWEvU4Aeh2o5IYMA6CwOpT+eM3VgpoUSPvad/iH
/2bfX7SOpVtSUpWpjtFmsV+L1eWefFjVQgalLqlwqaamJtFsSej9yHcoTNd6bGUW
b5ayxJD3PuWGlWglJKoTFIQrJb3OGEmj2LZZUapdEKrsafVZeQqM7C01U7j+KbbJ
h499DaKfuAm0fhsOWDlbv4+rkXq1AlptuMlfwsUS+U1tWve4J8WqVbC52UcLYYtu
LM58reF8VCgpvXZC5aai0IMdDPZd/+n+pCg8g3/bapQwkYQwG86qyyborfuoFeNK
IrpcTnF9GnAwRMEx9QHXXauukYKSc/m6mfPYF0HpHwe8dzyHdbBOqKtZgIrd5fMa
sMQxJ3VPjTHAOsVnhKXnQzByidlf3RFvpYL0on5owO36pKw6LaHoP2tYRsZDR8rI
ODfj5/2E9WI=
=J95t
-----END PGP SIGNATURE-----

--Sig_/03Uh5xxhqkHswK9Ghz2NIQX--
