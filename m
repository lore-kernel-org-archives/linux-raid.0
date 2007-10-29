From: Doug Ledford <dledford@redhat.com>
Subject: Re: Raid-10 mount at startup always has problem
Date: Mon, 29 Oct 2007 10:31:30 -0400
Message-ID: <1193668290.10336.416.camel@firewall.xsintricity.com>
References: <46D3147D.2040201@amfes.com> <46D49F1A.7030409@tmr.com>
	 <46E4A39C.8040509@amfes.com> <46E4A5F0.9090407@sauce.co.nz>
	 <46E4A7C3.1040902@amfes.com> <471F5542.3020504@amfes.com>
	 <471FA485.6010705@tmr.com> <47202D17.3040000@amfes.com>
	 <1193294406.10336.76.camel@firewall.xsintricity.com>
	 <20071026091513.GB32550@percy.comedia.it>
	 <1193426793.10336.302.camel@firewall.xsintricity.com>
	 <4725278E.1050306@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2oX5NqSNEvSzdDTw9s83"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4725278E.1050306@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Luca Berra <bluca@comedia.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-2oX5NqSNEvSzdDTw9s83
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-10-28 at 20:21 -0400, Bill Davidsen wrote:
> Doug Ledford wrote:
> > On Fri, 2007-10-26 at 11:15 +0200, Luca Berra wrote:
> >  =20
> >> On Thu, Oct 25, 2007 at 02:40:06AM -0400, Doug Ledford wrote:
> >>    =20
> >>> The partition table is the single, (mostly) universally recognized
> >>> arbiter of what possible data might be on the disk.  Having a partiti=
on
> >>> table may not make mdadm recognize the md superblock any better, but =
it
> >>> keeps all that other stuff from even trying to access data that it
> >>> doesn't have a need to access and prevents random luck from turning y=
our
> >>> day bad.
> >>>      =20
> >> on a pc maybe, but that is 20 years old design.
> >>    =20
> >
> > So?  Unix is 35+ year old design, I suppose you want to switch to Vista
> > then?
> >
> >  =20
> >> partition table design is limited because it is still based on C/H/S,
> >> which do not exist anymore.
> >> Put a partition table on a big storage, say a DMX, and enjoy a 20%
> >> performance decrease.
> >>    =20
> >
> > Because you didn't stripe align the partition, your bad.
> >  =20
> Align to /what/ stripe? Hardware (CHS is fiction), software (of the RAID=20
> you're about to create), or ??? I don't notice my FC6 or FC7 install=20
> programs using any special partition location to start, I have only run=20
> (tried to run) FC8-test3 for the live CD, so I can't say what it might=20
> do. CentOS4 didn't do anything obvious, either, so unless I really=20
> misunderstand your position at redhat, that would be your bad.  ;-)
>=20
> If you mean start a partition on a pseudo-CHS boundary, fdisk seems to=20
> use what it thinks are cylinders for that.
>=20
> Please clarify what alignment provides a performance benefit.

Luca was specifically talking about the big multi-terabyte to petabyte
hardware arrays on the market.  DMX, DDN, and others.  When they export
a volume to the OS, there is an underlying stripe layout to that volume.
If you don't use any partition table at all, you are automatically
aligned with their stripes.  However, if you do, then you have to align
your partition on a chunk boundary or else performance drops pretty
dramatically as a result of more writes than not crossing chunk
boundaries unnecessarily.  It's only relevant when you are talking about
a raid device that shows the OS a single logical disk made from lots of
other disks.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-2oX5NqSNEvSzdDTw9s83
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHJe7BTzP9PM7pjw8RAlUeAJ9bqPll3PhkXgRcH5QGcp1O/NdgNwCeO9R6
u7ikfOzycimIuFv+WQSpn2w=
=VE7C
-----END PGP SIGNATURE-----

--=-2oX5NqSNEvSzdDTw9s83--

