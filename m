From: Jameson Graef Rollins <jrollins@finestructure.net>
Subject: Re: Bug#624343: linux-image-2.6.38-2-amd64: frequent message "bio too big device md0 (248 > 240)" in kern.log
Date: Sun, 01 May 2011 15:06:45 -0700
Message-ID: <8739kyf53e.fsf@servo.factory.finestructure.net>
References: <20110427161901.27049.31001.reportbug@servo.factory.finestructure.net> <1304051980.3105.46.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1304051980.3105.46.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: 624343@bugs.debian.org, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 29 Apr 2011 05:39:40 +0100, Ben Hutchings <ben@decadent.org.uk> wro=
te:
> On Wed, 2011-04-27 at 09:19 -0700, Jameson Graef Rollins wrote:
> > I run what I imagine is a fairly unusual disk setup on my laptop,
> > consisting of:
> >=20
> >   ssd -> raid1 -> dm-crypt -> lvm -> ext4
> >=20
> > I use the raid1 as a backup.  The raid1 operates normally in degraded
> > mode.  For backups I then hot-add a usb hdd, let the raid1 sync, and
> > then fail/remove the external hdd.=20
>=20
> Well, this is not expected to work.  Possibly the hot-addition of a disk
> with different bio restrictions should be rejected.  But I'm not sure,
> because it is safe to do that if there is no mounted filesystem or
> stacking device on top of the RAID.

Hi, Ben.  Can you explain why this is not expected to work?  Which part
exactly is not expected to work and why?

> I would recommend using filesystem-level backup (e.g. dirvish or
> backuppc).  Aside from this bug, if the SSD fails during a RAID resync
> you will be left with an inconsistent and therefore useless 'backup'.

I appreciate your recommendation, but it doesn't really have anything to
do with this bug report.  Unless I am doing something that is
*expressly* not supposed to work, then it should work, and if it doesn't
then it's either a bug or a documentation failure (ie. if this setup is
not supposed to work then it should be clearly documented somewhere what
exactly the problem is).

> The block layer correctly returns an error after logging this message.
> If it's due to a read operation, the error should be propagated up to
> the application that tried to read.  If it's due to a write operation, I
> would expect the error to result in the RAID becoming desynchronised.
> In some cases it might be propagated to the application that tried to
> write.

Can you say what is "correct" about the returned error?  That's what I'm
still not understanding.  Why is there an error and what is it coming
from?

jamie.

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJNvdl1AAoJEO00zqvie6q8e7YP/0jerOnezmqjSi8S4CtYoerg
S+R8vX23Lf1uRNpwcB4SXZa1U7COAsmQxaNpUFgf9dq1MD2e4HZxiSKGMIbfQi+K
SkS+wH9ukuri76tHd8D7iGyiTKJfQHhv6qCi2nwcfJl4JhcntMX779cn92buFBKj
JoogJT4C10S1P58T+qCQB0ZTenYbVnJNmVh19lnfdmDhn/FRAW/qbCZTh8s0rimU
zF7yHz6EbXUi2LErks3M51X5bMRCpr2eYdJ7K6hVWBsCR8PLr+w4Da4sa63V0A4T
tCk7a5t7fkRjbOgKrTUsoPwZDWlFQvFTmeZtxUxNCdybGa1OIiZKrwv1dnpokNVs
KYODLM5RT697nmZeuiQ0k6wxSNimkEBWZan3sgapjWkOzqwzlbO3RVp5oXzlWeS4
6TZ3d5doKo/z7pm5z/dAgsD3VdfeEKvBL0ishFpLR09Mi9trkop2XnrpehsICzyn
KKVWlcRgIzt+3KYmjtaa3EZPj/jekOAHZkuQIhyR27XXrR+6tg1fGSkIsOL+mhN8
gFUfeP4zahglzkDg2GH57P8tsgkZvZFTtAJF8QmBf9JlSQ0YqQmodNROcwjEnrcH
k20F7H7SZxlsgkkqL51/cM1NgNRybTP9d0U4fZJTOsigmMEK19BW+fBgfuOdp4lO
gG7VjFchx15qZ5m6so6T
=7j5t
-----END PGP SIGNATURE-----
--=-=-=--
