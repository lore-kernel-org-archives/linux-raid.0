From: NeilBrown <neilb@suse.de>
Subject: Re: Is this stupid?
Date: Mon, 5 Dec 2011 17:01:14 +1100
Message-ID: <20111205170114.49cf7437@notabene.brown>
References: <D4.5D.10364.904FBDE4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/PFTGFnrT7ME0zez0/O7B+cs"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D4.5D.10364.904FBDE4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/PFTGFnrT7ME0zez0/O7B+cs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 4 Dec 2011 16:28:25 -0600 "Leslie Rhorer" <lrhorer@satx.rr.com> wro=
te:

> I have a system - one that is not expandable - that has relatively limited
> RAM, comparatively speaking, and must boot from a usb stick.  The system
> hosts a RAID array, but one cannot assume the RAID array is available when
> the system boots.  IOW, I want to be able to take down the RAID array for
> maintenance, possibly booting the system with no array created, at all.
>=20
> On the other hand, USB sticks have a limited number of writes available
> before they fail, so I don't want the system to be thrashing the flash dr=
ive
> any more than necessary.  At this time,  I have /var/run, /var/log,
> /var/lock, and /tmp mounted as tmpfs file systems.  What I propose is to =
run
> an init script that checks to see if the array is mounted, and if so appe=
nds
> files in the aforementioned directories to existing directories on the ar=
ray
> and then remounts and binds the directories on the array.  The stop call =
in
> the script will reverse the process so the system can shutdown or so I can
> take the array offline after booting for maintenance.  Is this unwise?  A=
m I
> missing something crucial that might cause the system to blow up?

Sounds reasonably sane.

After the bind mount you would need to make sure any process with a file
open in one of those directories re-opens the file.  So you might want to
restart syslogd.

NeilBrown

--Sig_/PFTGFnrT7ME0zez0/O7B+cs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTtxeKjnsnt1WYoG5AQKLMA//YXnia+IchksnWb7ZgNsj52EUNV39k87C
8rKYYqc+YwYkWw54aSC0+QFH+lj8dt2tX1iTB7VKAqz07MlsTmlQgvOJi8qopenK
cpzXszXCUFhPoV18yA0SfRYJzPFPE7S6KOXIwWgLtPjf0ZfJLtnNYESYwctoxMFj
j8tpJeH9jFFrh6NNY0l/5IHZI/vkrLXDEhqaL3+w3ngnRHhQqt6Pl9QRS3XrUFbc
Vo4DbzykWec0n3pOAcfxcx4kl3lscQvEgvBc4dJi3Fyb7OLiFG2/zBRV1axIe+go
twWywrOVz3HOW13bGLGRYBIjp/vUaae39D6cHelxldwu61gKU6OQkpng8GXsIiLh
oVG7Uh5wAXiI/Vw+mDqN2u11VxRssOPx/Ve2+vH1Umcd5SGKv/u2oOKiUeDz865g
z3mXwErRXV6UwieD1jN0iJe/cNjgjzB2YD6/+WY+cczXAwS/IiCeUKZy8ZlzCPR0
fmUJqHWj137WkWTUMoiWkUNK/oZbYFdLdYU766KuB2BsnOCnzI8LzTf/DYg0brNI
SXewNCFdXLVQO8KxaV5WvcavoNzMrYNq2AEZCIwNEOfNBkj0CK+eDAlVpxYX/i+9
ZjvlxPQsKCRbPdyoFtKqpp1QZDHNr8jxXpz3/PDeSHpZY6PX3CgnskGoD6ktTFAJ
yXZaCSGlmXE=
=lBnf
-----END PGP SIGNATURE-----

--Sig_/PFTGFnrT7ME0zez0/O7B+cs--
