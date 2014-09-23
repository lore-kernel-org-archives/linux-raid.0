From: NeilBrown <neilb@suse.de>
Subject: Re: Moving root to raid, weird raid behaviour
Date: Tue, 23 Sep 2014 10:37:04 +1000
Message-ID: <20140923103704.7116d112@notabene.brown>
References: <54206A9A.8010308@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/YWtUxB4hnAdS7j7oRvR+xdB"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54206A9A.8010308@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/YWtUxB4hnAdS7j7oRvR+xdB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Sep 2014 19:29:46 +0100 Wols Lists <antlists@youngman.org.uk>
wrote:

> I'm not sure if this is weird raid, stupid grub2 or incompetent newbie,
> but whatever ... and the system is my development/test system so if it
> gets trashed it's no disaster, but I would like to understand what is
> going on ...
>=20
> Old setup
> / =3D sdb2
> /var =3D sdc2
> /home =3D mdX (sdb3, sdc3), mirror
>=20
> I added sdd and made a new
> / =3D mdY (sdd3, missing) mirror
> and added sdd4 to mdX
> /home =3D mdX (sdb3 sdc3 sdd4)
>=20
> Weirdo one - sdd4 mirrored and synced fine. Then I rebooted ...
> mdX =3D (sdb3 sdc3 missing)
> mdZ =3D (sdd4 missing missing)

You probably have something silly in your initrd which is making invalid
assumptions.
What does /etc/mdadm.conf in your initrd/initramfs contain?

>=20
> wtf?!?!? - oh and both of them share the same uuid. The obvious (but it
> shouldn't make any difference?) possibility is that sdb and sdc are
> 500Gb, partitioned identically. sdd is 1Tb, so sdd4 is twice the size of
> the other two.
>=20
> The other weirdo is I'm trying to migrate from grub/mbr to grub2/gpt. Of
> course that's causing me fun, but I've managed to get the system booting
> fine from mdY. Only snag is, when I list /dev, mdY isn't there! mount
> shows it as mounted on / but that's the only place I can find it!

udev should create it.  'udevadm trigger' should cause udev to create device
files for all devices.  That should  be done as part of the boot sequence.
If you run "udevadm trigger" does /dev/mdX get created?


>=20
> mdadm v3.2.6
> kernel 3.14.14-gentoo
>=20
> Any ideas what's going on? I've googled, but everything I find looks out
> of date or not relevant.

"out of date or not relevant"?? You must have been looking on the
Internet ?!?! :-)

NeilBrown


>=20
> Cheers,
> Wol
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/YWtUxB4hnAdS7j7oRvR+xdB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCDAsDnsnt1WYoG5AQIO/A/7B9m5ndE77y+z9/mT/6djlj9lS2Jy3oHY
Yb42Tq1fItThabyO9W6jvvX8KH71uhBhhOK0CNOSKFupcBhODBno3SpQURrhGVD3
wZNXcpUtXS8Ow4mQMN+eNS8mzVSDd7VVDXSo04Xgd/d7NYYH947opJvzU+uj4te5
RJ0KxEfdN9uegodMghZqlI875ql7aX0jlxWJ8Bxy7rFCmf0pe0WOyX1iPDMJSpUW
GaTXL0a+rCpTTBfb16V/jYpr5P07uL/5NIOp4vjDSASqKGNrWEwdtSQhTIhnTL+w
NrP5yQ6gOU6cLMQ/7JSi/ak9t6TcgvUe8qndRl0YgI1SYKd5RDwI3q/1p6z8/cm6
3Cgc2oxJZjxfZaKzYu4zQY1xkuD1apCP3EfC8coZTui5LeOMjCIVsGaXqQVicDqX
QCiHKtZFzSaos8wf1ZQRIFRCtxtnVHsMrrvKFF3lzOFbd7KIvQs/frcjKXOQJU9O
KDoQAcik9vA4fPysTyJCpIFvVHsj/cT6yPjgvlmawVadVpK3Rs+FdylUoSEW3S7P
+1PpHvMGtz+6qHtCkgX2SBUxtScMnaXy4nt16BGvzy5cs2Y0pDM658T3bw0yib/R
WvXUoFunsQGUNo4srR7z7ZverX14XAplxVG1vMZ5uOXXsotvgN3eblj6Dt1pvhsE
Ozbwkwg513M=
=QiVC
-----END PGP SIGNATURE-----

--Sig_/YWtUxB4hnAdS7j7oRvR+xdB--
