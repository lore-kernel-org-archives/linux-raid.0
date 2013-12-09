From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm rebuild
Date: Mon, 9 Dec 2013 11:16:51 +1100
Message-ID: <20131209111651.664635f9@notabene.brown>
References: <B49ACD0F-BAD8-4D61-B87C-A06295B58A56@gmail.com>
	<20131209085554.262006d5@notabene.brown>
	<CAJ1=nZfUBQ0_T1s3deG+HOU7BQeayibWcW8y5h5bEjFt2tvhnA@mail.gmail.com>
	<20131209095328.0d39e6ad@notabene.brown>
	<CA74C8FD-DBDC-428B-9645-E2DD2300EE9D@gmail.com>
	<20131209101752.33deb603@notabene.brown>
	<52A50730.4030301@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Q0+142bnrB23rmLzV4lijsq"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52A50730.4030301@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Hai Wu <haiwu.us@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Q0+142bnrB23rmLzV4lijsq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 09 Dec 2013 10:56:32 +1100 Adam Goryachev
<mailinglists@websitemanagers.com.au> wrote:

> On 09/12/13 10:17, NeilBrown wrote:
> > On Sun, 8 Dec 2013 17:03:22 -0600 Hai Wu <haiwu.us@gmail.com> wrote:
> >
> >> This is something I am not aware of, thanks!
> >>
> >> In this case, do I have to worry about cases where the new drive might=
 not be able to boot (this is raid1 with 2 drives, and both drives need to =
be able to boot up the server by themselves in case the other drive fails l=
ater)? I remember I had to do the following before for the new drive:
> >>
> >> grub> root (hd0,0)
> >>
> >> Is that still the case here if marking it as 'spare'?
> > If you want the new drive to boot and the boot sector is not covered by=
 any
> > md array, then you have to update the boot sector yourself.
> >
> > You can presumably get udev to run some command which will write a boot
> > sector out.  However I'm not an expert on boot sector management so can=
not
> > really advise you.
> Hi Neil,
>=20
> I like the way you phrased that :)
>=20
> I just wanted to clarify one point, it there a specific MD metadata=20
> version (I'm assuming either 1.0 or 1.2) which could be applied to an=20
> entire device MD array which would allow the automatic sync of the boot=20
> sectors/etc
>=20
> ie, something like:
> mdadm --create /dev/md3 --level=3Draid1 --metadata=3D1.2 /dev/sda /dev/sdb
>=20
> then writing the boot sector information to /dev/md3
> mdadm --manage /dev/md3 --fail /dev/sdb
> mdadm --manage /dev/md3 --remove /dev/sdb
> mdadm --manage /dev/md3 --add /dev/sdc
>=20
> Then, shutdown, remove sda and sdb
>=20
> Would you expect the system to boot successfully from sdc (assuming the=20
> BIOS will boot from it, and that the OS will "find" the correct boot and=
=20
> root device....
>=20
> In the past I've always used partitions for MD, but this might be a good=
=20
> reason to use whole devices if it would solve the issue of the boot=20
> sector information.
>=20
> Regards,
> Adam

If you use --metadata=3D1.0 then everything from the very start of the devi=
ce
to near the end is mirrored.
If having identical boot blocks on every device works (which I think it doe=
s,
but I'm no expert), then using=20
  --level=3Draid1 --metadata=3D1.0
on whole devices (not partitions) would remove the need to worry further
about boot sectors.

NeilBrown

--Sig_/Q0+142bnrB23rmLzV4lijsq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUqUL8znsnt1WYoG5AQIDkg//e+9eAtiIzBYjviIdF8JWVbNR1tdHBecB
Z9JojGHRTbcFDSz4iGZuW8V3MEcsKMj8/R9qFkJF1NNjCLlDdXeCz3i9dAH/EG3Y
tm8HOQZlntl4jdbtUsI7MyEU3ibloiWASSlQPdKnKfdpJOMb86p76HMKwuHgFAHe
BK1wUlg7edOklz05mqbpwkww8BqJxTMGSapxYFUCDGs/qjyTWMNiQ5erA5+aPW2G
bToUUmPpSaw599l6qpWQVoCCwE7OVbUbX9pua2BEqPcOQ0QipJhCjrpkz3UHwYt+
b8kU/ysLCcxallsMn3JXBnWBpMOfF3csdm2nSt0d6TrgEOycjxjQiHsrHmlnYLlr
8EYFwoa7vhcqjbL/uvIgrtMnbmN5U1a0cU/XRMDfHONcI3e+xZBChn1jhEMmMJre
M+xmTrS9OMb+EsgWXSkUDRpu/1QmHFjM9fpOknSmFr6h3RQSrwy718la+b6Ncybt
4k7iiOpDNresHlSxo/91SdARhMOaUUPaigZmdqcXumo1GFfoZxd1o7buj5s2/d67
wghADt+kHgdWQihzWxDuj92eqkcKHNS+O9yLubmAeTqfNdqzqmu1D4l+OApjst0p
XYygY4E0A7xVUkE+JpSydoGrrAMEltgazu/tQ3yZiGsbhjiMpaeZjfptWBOkdxQK
Nuk+nagptbU=
=kxfP
-----END PGP SIGNATURE-----

--Sig_/Q0+142bnrB23rmLzV4lijsq--
