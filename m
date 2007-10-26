From: Doug Ledford <dledford@redhat.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Fri, 26 Oct 2007 18:58:47 -0400
Message-ID: <1193439527.10336.321.camel@firewall.xsintricity.com>
References: <1192813877.1666.79.camel@firewall.xsintricity.com>
	 <18200.63987.514073.184865@stoffel.org> <471E7DC6.7050206@tmr.com>
	 <1193184555.10336.3.camel@firewall.xsintricity.com>
	 <18207.56169.769976.512617@notabene.brown> <471FDEB1.8040401@garzik.org>
	 <47204F45.4010205@dgreaves.com> <18209.34365.375059.602828@notabene.brown>
	 <4721F742.1090301@tmr.com>
	 <1193424116.10336.281.camel@firewall.xsintricity.com>
	 <20071026222012.GA8210@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zVRTt1WCPn+9whJtXi82"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071026222012.GA8210@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: Bill Davidsen <davidsen@tmr.com>, Neil Brown <neilb@suse.de>, David Greaves <david@dgreaves.com>, Jeff Garzik <jeff@garzik.org>, John Stoffel <john@stoffel.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-zVRTt1WCPn+9whJtXi82
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-10-27 at 00:20 +0200, Gabor Gombas wrote:
> On Fri, Oct 26, 2007 at 02:41:56PM -0400, Doug Ledford wrote:
>=20
> > * When using lilo to boot from a raid device, it automatically installs
> > itself to the mbr, not to the partition.  This can not be changed.  Onl=
y
> > 0.90 and 1.0 superblock types are supported because lilo doesn't
> > understand the offset to the beginning of the fs otherwise.
>=20
> Huh? I have several machines that boot with LILO and the root is on
> RAID1. All install LILO to the boot sector of the mdX device (having
> "boot=3D/dev/mdX" in lilo.conf), while the MBR is installed by
> install-mbr. Since install-mbr has its own prompt that is displayed
> before LILO's prompt on boot, I can be pretty sure that LILO did not
> write anything to the MBR...

Then this has changed.  It used to only install lilo to the mbr.
However, even if it installs to the partition, it doesn't change the
rest of what I said about it not understanding the offset from partition
to file system on 1.1 and 1.2 superblocks.

> What you say is only true for "skewed" RAID setups, but I always
> considered such a setup too risky for anything critical (not because of
> LILO, but because of the increased administrative complexity).
>=20
> Gabor
>=20
--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-zVRTt1WCPn+9whJtXi82
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHInEnTzP9PM7pjw8RAhwnAJ41kr9VgpM5KWynvRtsDPP78J95BgCZATjh
fUysW17gbrCo3UFkJPHpfjc=
=MZ39
-----END PGP SIGNATURE-----

--=-zVRTt1WCPn+9whJtXi82--

