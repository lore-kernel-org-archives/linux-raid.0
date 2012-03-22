From: NeilBrown <neilb@suse.de>
Subject: Re: RAID-10 explicitly defined drive pairs?
Date: Thu, 22 Mar 2012 21:31:14 +1100
Message-ID: <20120322213114.61fd4e44@notabene.brown>
References: <20111212115459.GC20730@fi.muni.cz>
	<4EE61EAE.20101@anonymous.org.uk>
	<20120106150823.GX25976@fi.muni.cz>
	<20120107075526.59ed433c@notabene.brown>
	<CAGRgLy4Q5FhHMAeU3egqEfFKR_h1HneReg0sD_+hCmsF3WDzQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/NYAs_HyH1M9Y.kVUUezHJvG"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy4Q5FhHMAeU3egqEfFKR_h1HneReg0sD_+hCmsF3WDzQw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: Jan Kasprzak <kas@fi.muni.cz>, linux-raid <linux-raid@vger.kernel.org>, John Robinson <john.robinson@anonymous.org.uk>
List-Id: linux-raid.ids

--Sig_/NYAs_HyH1M9Y.kVUUezHJvG
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 22 Mar 2012 12:01:48 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Neil,
>=20
> > =A0echo frozen > /sys/block/mdN/md/sync_action
> > =A0mdadm --add /dev/mdN /dev......
> > =A0echo recover > /sys/block/mdN/md/sync_action
> >
> > it should do them all at once.
> >
> > I should teach mdadm about this..
>=20
> What is required to do that from mdadm? I don't see any other place
> where MD_RECOVERY_FROZEN is set, except via sysfs. So do you suggest
> that mdadm use sysfs for that?

Yes.

http://neil.brown.name/git?p=3Dmdadm;a=3Dcommitdiff;h=3D9f58469128c99c0d7f4=
34d28657f86789334f253

> Also, what should be done if mdadm succeeds to "freeze" the array, but
> fails to "unfreeze" it for some reason?

What could possibly cause that?
I guess if someone kills mdadm while it was running..


NeilBrown

--Sig_/NYAs_HyH1M9Y.kVUUezHJvG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT2r/eDnsnt1WYoG5AQIocRAAsX4+g0LZLWdWiWJfrAEYBw1U2qPZpoZS
V3/v8f1E4fqbeq9KwV0FP95jYtFTF5PPsKwBV7YNWtnLoMwKlx2Y01cPyX7xks3w
TpQyHk9Ic4GBiIMr38oLCIrT7PSunlod3gOYHoaRe5K4lenGI1TeDiw9xLQQBEVv
l65LDQsh9PT84EEm5bN0IajK9iurCNkZN3tgIIzWRwJYBNKm4LeniTWBCri1h/SS
B9b4q7zt7ocgx+dUPuWUe2jNosSUVGPkvjDtwDLBLTsU/kq5T6D2LldhXZBtPjiM
Q4hfSCpV40dmmYpgY9my7ergYtIcBolo5n0yqpiXUnIV05ALjPoqvjxzs+/uia8b
faq2/dLTdbwpLmPyVlqbOtnQfbQmyV77mqSPXj77h0Hn1sHmGopkj6Rh5nDKYO8U
8KrDSBKaC6bkAiQ0bSYbna8KyV7IU4h/aDO5Pofdww6PImOJx1Uww6X7FLV3Quup
T4egBezpz2mCX3KMN+2n5S1T9KbGKz1bbJxdnLRoF7IA0EQyOz6xTVjG0/8e0YW9
ignYyoaMlDVw1FKsJ77gHS+Mv0LkhJXacXE9hGyemNge+GjwtA95qU6Bhf+lVYmy
wQdmKjZFHjycpO7OWJo+ofrnBnzLtSYj4yage70zT/MSNJoYllKsDplUYbhu+Jgl
9uLBHlWX8Jg=
=xL8d
-----END PGP SIGNATURE-----

--Sig_/NYAs_HyH1M9Y.kVUUezHJvG--
