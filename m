From: NeilBrown <neilb@suse.de>
Subject: Re: udev 215 creates inactive MD devices upon
	stopping them
Date: Fri, 25 Jul 2014 08:17:16 +1000
Message-ID: <20140725081716.295635ca@notabene.brown>
References: <53D11CCA.1050602@profitbricks.com>
 <53D12AB5.5090102@profitbricks.com>
 <CAPXgP11XeMFHiWryu1kgYC9__w1YUsMsrx=F8+sg1M_tro8n4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1470888742=="
Return-path: <systemd-devel-bounces@lists.freedesktop.org>
In-Reply-To: <CAPXgP11XeMFHiWryu1kgYC9__w1YUsMsrx=F8+sg1M_tro8n4g@mail.gmail.com>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/systemd-devel>,
 <mailto:systemd-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/systemd-devel>
List-Post: <mailto:systemd-devel@lists.freedesktop.org>
List-Help: <mailto:systemd-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/systemd-devel>,
 <mailto:systemd-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: systemd-devel-bounces@lists.freedesktop.org
Sender: "systemd-devel" <systemd-devel-bounces@lists.freedesktop.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Linux RAID <linux-raid@vger.kernel.org>, artur.paszkiewicz@intel.com, systemd-devel@freedesktop.org, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Francis Moreau <francis.moro@gmail.com>
List-Id: linux-raid.ids

--===============1470888742==
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/XH.npqY/i0J2=w9_SE7+Zmw"; protocol="application/pgp-signature"

--Sig_/XH.npqY/i0J2=w9_SE7+Zmw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 24 Jul 2014 23:53:30 +0200 Kay Sievers <kay@vrfy.org> wrote:

> On Thu, Jul 24, 2014 at 5:48 PM, Sebastian Parschauer
> <sebastian.riemer@profitbricks.com> wrote:
>=20
> > as discussed on linux-raid, please fix the bug that udev 215 creates
> > inactive MD devices upon stopping them.
> >
> > Reference: http://www.spinics.net/lists/raid/msg46676.html
> > Reported-by: Francis Moreau <francis.moro@gmail.com>
> >
> > An open() call to /dev/mdX after creating it with mknod is enough to
> > create such inactive MD device.
> >
> > According to Artur the issue is caused by this change in udev:
> >
> >> commit 3ebdb81ef088afd3b4c72b516beb5610f8c93a0d
> >> Author: Kay Sievers <kay at vrfy.org>
> >> Date:   Sun Apr 13 19:54:27 2014 -0700
> >>
> >>      udev: serialize/synchronize block device event handling with file=
 locks
> >>
> >> http://cgit.freedesktop.org/systemd/systemd/commit/?id=3D3ebdb81ef088a=
fd3b4c72b516beb5610f8c93a0d
> >>
> >> It seems that they have already disabled this for dm for some reason,
> >> but not for md:
> >>
> >> commit e918a1b5a94f270186dca59156354acd2a596494
> >> Author: Kay Sievers <kay@vrfy.org>
> >> Date:   Tue Jun 3 16:49:38 2014 +0200
> >>
> >>     udev: exclude device-mapper from block device ownership event lock=
ing
> >>
> >> http://cgit.freedesktop.org/systemd/systemd/commit/?id=3De918a1b5a94f2=
70186dca59156354acd2a596494
>=20
> MD devices are excluded now from the locking logic, like dm devices alrea=
dy are.
>=20
> Instantiation of devices at open() is incompatible with udev's locking
> logic. That feature is not useful on most systems today, mknod()
> should never be done by any tools, only by the kernel itself. It
> should probably be disabled by default.

I agree that instantiating on open is an unfortunate design, but it has been
around for a long time so we cannot just ignore it or turn it off.
I have a new approach to creating md device which we might eventually be ab=
le
to transition too, and then maybe deprecate the old way.
In the mean time, thanks for teaching udev to put up with md's peculiaritie=
s.

NeilBrown


>=20
> (The locking scheme is used to support partitioning programs, to make
> sure udev will not interfere with the partitioning tool while it
> creates/removes partitions. As long as an exclusive lock is held on
> the disk device node, all udev events are suppressed, the close() of
> the disk which war opened for writing will re-read the partition table
> and synthesize all suppressed udev events for the partitions again.)
>=20
> Thanks,
> Kay
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/XH.npqY/i0J2=w9_SE7+Zmw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU9GF7Dnsnt1WYoG5AQKwUA/8D6vmIT+ygDYtcYFnU02WaO1us7Cza5ZE
AYbZfCpikaZ+9KSePHjPP9BKYPzWzfIv5QbV3KHDTvIClFJTuPxE2RDwdCz069CO
ceChwi4ELE1e1q2ugKTAyY8axyMJ5KFdBvRdG8fUblT0g/UVnKCa50oDzl7nHXM/
L72/ZjL46vw+MeVcVFlNn7haW9v+fITF1cSbAIWq7IOMC9he26AXAseN8esB3jK1
zjrLemeVeFQta2nXtvZzXdrHzzNVD526gB4W0bqgDWJ2uMl1tOykGBw//IPcYFGb
V38i4kq45Py+jUDgado+XHxdASzAqok/taGrB94TyhrOGxP1T/7t7GklXwI/uai8
emNOL61zYYPzsR63QrruR4go4CP8B69lDZ0ggRGNRVBsH9vlVa5wRKRelb3ynfHe
wYT7d+Ox4XOCA2VWeS4tNtzGX8TWDMklMwWHXIiMZEu4XWd7rnPg40RwpxOm80Mn
bgb16ODXyV00AuXqqV9qpGlDP5+99+BabrJOFN2ZKgHd4BgWtjUXj0u1YGfGY/Xj
eToWleP3Vuo4+iTPtdP8oJzhp4UFEJ805MI87Adomwsq+juu3WsT8VfhQqa2UKVL
+B38lwupxfMJ5/eAaViGfxTBEWds4Xfrg624XJsNRAeJv4zN7Ojlj2R+SbqsegjG
IAc31QU9N6A=
=XRj1
-----END PGP SIGNATURE-----

--Sig_/XH.npqY/i0J2=w9_SE7+Zmw--

--===============1470888742==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
systemd-devel mailing list
systemd-devel@lists.freedesktop.org
http://lists.freedesktop.org/mailman/listinfo/systemd-devel

--===============1470888742==--
