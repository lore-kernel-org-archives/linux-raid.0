From: NeilBrown <neilb@suse.de>
Subject: Re: Two Questions about Linux MD
Date: Sat, 19 Jul 2014 19:21:57 +1000
Message-ID: <20140719192157.48487e7c@notabene.brown>
References: <53CA304E.4040908@megasoft.be>
	<53CA31C4.2020705@megasoft.be>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Ogoqs=aZ3chROZMIIk0/k3V"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53CA31C4.2020705@megasoft.be>
Sender: linux-raid-owner@vger.kernel.org
To: Killian De Volder <killian.de.volder@megasoft.be>, Henry Cai <henryplusplus@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Ogoqs=aZ3chROZMIIk0/k3V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 19 Jul 2014 10:52:20 +0200 Killian De Volder
<killian.de.volder@megasoft.be> wrote:

>=20
>=20
> See answser below:
>=20
> Ps. You added extra spaces on the bit line ? Why did you do this ?
> You should be using monospace fonts / fixed-with for mailing lists.
>=20
> Killian De Volder
>=20
> On 19-07-14 05:15, Henry Cai wrote:
> > 1> The first question, as the wiki:
> > https://raid.wiki.kernel.org/index.php/Initial_Array_Creation
> >
> > There has the sentence, "For raid5 there is an optimisation: mdadm
> > takes one of the disks and marks it as 'spare' ", what I want to know
> > is the optimisation for what? The result of the optimisation is that
> > when initial create, the RAID5 is do recovery not resync.
> >
> > And in the mdadm man
> > page:http://www.linuxmanpages.com/man8/mdadm.8.php, also has an option
> > --force, describe as follow: "Normally mdadm will not allow creation
> > of an array with only one device, and will try to create a raid5 array
> > with one missing drive (as this makes the initial resync work faster).
> > With --force, mdadm will not try to be so clever. "
> Don't know how this is faster, sorry, maybe someone else on the mailing
> list know.

I suspect you can work it out if you try.
Think about the exact sequence of IO requests needed to correct the parity
blocks assuming the are not correct.
Now think of the exact sequence of IO requests needed to recover to a spare.
Remember the seeking is slow on rotating storage.
Remember also that the parity block changes device every chunk.

I'm sure you'll work it out.



> > Last, if bitmap save on all disks, how to keep the bitmap consistent?
> > How to address the situation that the bitmaps are different when read
> > from the disks after system boot?
> If linux-raid has troubles keeping the bitmap consistent,
> I'd be a lot more concerned about your data :)
> Also they probably use some tricks with write barriers, and flushes
> and other data to figure out which ones to use.
>=20
> That's for someone smarter on the list.

If the different copies of the bitmap contain different contents, then it
must be safe to use any of them.

Think through the different scenarios that could result in an inconsistency
and see if this is true.

Remember that when we bit is set in the bitmap (to say that we intend to
write to the corresponding region), we wait until the new bitmap has been
written to all devices before permitting the write to commence.

NeilBrown


--Sig_/Ogoqs=aZ3chROZMIIk0/k3V
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU8o4tjnsnt1WYoG5AQK61g//bCoxRX0oTLl6j/9kYIQPKmd/rDv56iBw
kimslTAb8MTHsAeHy6Gm7EgOywMgez+nfzFWC691zzmRcqLZZbBVNsEkfR2m7sTP
OUk/K/pVyN80Yc8R+cqNRb3c1EOgXyqo2W1bZmNuqh9i4dv4CTwh32aWLL4bDkg/
eZMhVZVOIayHLCmoYyszk13fIZ1zPzXo2U1M+CUwLzrSm5t6pL/VMjroP1QGX27e
OZj2oZogqjdE/K2ADVnyVYa4b8n818DZSemEVknINwdCNXv4vYDFiZxJQ3O13BKY
pYcN2xaR4wwJ3sVY7irscI9Qfp9xmMfDNOLxFBEsgm67doiFFI+hUwjfk0IphDan
PqwOyOkUqouPN+rGcpupzMHTK7+VhC/dvng/K7d+G0of69i78AWoZd02N/iNjpxo
CieG2izJg6VcCpVFi359Sg/+xWIek1EQJFMkj3Q+rN8uhgQEp+//W+Mdy/o5aPFk
YmKxEZUOK6PUuKxopVpB9nmD9dtHtaQfN+FvJMSi7N4VEC45mv7C3wfjE21CTXBd
0dfEbJXTtfwsDWW5ksNV7Ap0/wMr8R+L8QpScUSDr1IEbEd5c6DwrCvDJJeZG63x
RsDu9v6iDyOyyl6vkBNNDWV0v4OK1hwYYHeY1IIQneG1zxdo7hHomgtOoZpB4zgv
fS6fkfHo8IE=
=8Ozy
-----END PGP SIGNATURE-----

--Sig_/Ogoqs=aZ3chROZMIIk0/k3V--
