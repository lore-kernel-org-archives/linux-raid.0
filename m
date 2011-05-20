From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Software raid, booting and bios
Date: Fri, 20 May 2011 14:56:23 +0600
Message-ID: <20110520145623.749b4781@natsu>
References: <9067914580344941270@unknownmsgid>
	<ir58vs$9qp$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cuNGxQpiNyROU4bxpislme2"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ir58vs$9qp$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Paul van der Vlis <paul@vandervlis.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/cuNGxQpiNyROU4bxpislme2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 20 May 2011 10:33:00 +0200
Paul van der Vlis <paul@vandervlis.nl> wrote:

> You can select the "boot device priority" where you can choose about
> devices types (DVD, harddisk, USB, network) but you can choose only one
> SATA disk. Study it, and you will see I am right. I've asked it to my
> rackserver-vendor, they say: "that's always the case".

How about just not buying crappy hardware from this lying vendor anymore.
http://ompldr.org/vOHB6Zw/bios4.jpg <- this is present in majority of
motherboard BIOSes since forever.

> But I think I have had systems in the past, what could do it. An
> interesting question is then: how well is it tested?  What when e.g. a
> disk boots, and then gives an I/O error? I am looking for a well-tested
> way to solve this, and I am willing to pay for it or choose another
> hardware vendor for it.

Yes, I think it is conceivable that if a disk fails in a 'bad' way, i.e. by
locking up on reads, or reading the first sector but not the next ones it c=
an
prevent the system from booting even with this priority system. I don't know
if chances of that are high, considering that quite often disks fail by also
ceasing to be detectable in BIOS, in which case your boot-up would proceed
normally.

--=20
With respect,
Roman

--Sig_/cuNGxQpiNyROU4bxpislme2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3WLLcACgkQTLKSvz+PZwhQpQCffePO21odZcLztzepUYLT89de
wFYAoIx1DJn3uvPatWEgSFcGalFk1eX2
=S+zH
-----END PGP SIGNATURE-----

--Sig_/cuNGxQpiNyROU4bxpislme2--
