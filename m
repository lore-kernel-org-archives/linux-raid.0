From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: New mailing list for 2.6 Medley RAID (Silicon Image 3112 etc.) BIOS RAID development
Date: Mon, 9 Feb 2004 13:11:44 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040209121144.GA24503@devserv.devel.redhat.com>
References: <1076320246.4444.0.camel@laptop.fenrus.com> <Pine.LNX.4.40.0402091155040.8715-100000@jehova.dsm.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.40.0402091155040.8715-100000@jehova.dsm.dk>
To: Thomas Horsten <thomas@horsten.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 09, 2004 at 12:01:55PM +0000, Thomas Horsten wrote:
> On Mon, 9 Feb 2004, Arjan van de Ven wrote:
>=20
> > > The reason I insist on autodetection is that I think it's important t=
hat if
> > > the BIOS will reckognise the drive without additional intervention, s=
o will
> > > Linux. This will make the entry route for newbies much simpler.
> >
> > do you call running devicemapper tools from the initrd autodetection ?
>=20
> Probably not. I am working with several ways of doing it, and that's why I
> wanted to have a discussion about this.
>=20
> Ideally I'd want something like the MD autodetect code, so that the whole
> thing can be set up by the kernel at boot-time if the necessary drivers
> are compiled in (by reading the Medley superblock the same way it's done
> for 0xfe partitions).

I (and I suspect a lot of other folks) rather get rid of such autodetect and
move it to userspace. Either via initrd or initramfs.

> Having autodetection at kernel level would make it possible to boot from a
> kernel on a floppy disk without initrd support, and in general make a
> system easier to set up.

initrd/initramfs is increasingly becoming mandatory sort of, and it's
actually easy if not even default to set up. (Eg on Fedora / Red Hat even
just typing make install will auto-create this for you)

> But the reason I wanted this discussion is to figure out the best way to
> go about it, and if there are some good arguments against autodetecting in
> the kernel I'll listen to them.

It doesn't really belong there.
--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAJ3j/xULwo51rQBIRAqNZAJ0aHEF7cuHAATseYUKfz2ie1Pc1pwCgojf/
f9AB6yE9A6qZgT16CSM3Bdw=
=0Ztj
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
