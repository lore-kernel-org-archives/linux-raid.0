From: NeilBrown <neilb@suse.de>
Subject: Re: Are we forced to use bad blocks list?
Date: Thu, 7 Aug 2014 12:27:42 +1000
Message-ID: <20140807122742.571528be@notabene.brown>
References: <53DA5340.7080507@shiftmail.org>
	<20140804113859.63b5ac90@notabene.brown>
	<53DF7EA7.2070408@shiftmail.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/aiAs_/4fIQWNJUZ2yHjs_Bn"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53DF7EA7.2070408@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ethan Wilson <ethan.wilson@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/aiAs_/4fIQWNJUZ2yHjs_Bn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 04 Aug 2014 14:37:59 +0200 Ethan Wilson <ethan.wilson@shiftmail.org>
wrote:

> On 04/08/2014 03:38, NeilBrown wrote:
> > On Thu, 31 Jul 2014 16:31:28 +0200 Ethan Wilson<ethan.wilson@shiftmail.=
org>
> > wrote:
> >
> >> Dear MD developers,
> >> it seems that with mdadm 3.3.1 , if an array has bad blocks disabled
> >> ....
> >> array is configured for BBL or not, and add a spare of the same type.
> >>
> > Why don't you want bad-block-lists?
> >
> > I'm not necessarily against having some why to avoid getting them
> > automatically ... possibly a 'policy' option in mdadm.conf.
> > But I'd like to make sure I understand all of your thinking first.
> >
> > Thanks,
> > NeilBrown
>=20
> Hello Neil,
>=20
> Well... on the ML, I think that we saw the badblocks code triggered only=
=20
> once, and it was with the recent thread of Pedro Teixeira.
>=20
> It seemed to me that his error condition could indicate that there might=
=20
> be a bug in the bad blocks code. It's not clear to me how those zillions=
=20
> of bad sectors could have been stored without some bug such as an=20
> erroneous propagation of bad blocks, or erroneous handling or degraded=20
> mode (he said he operated with a doubly degraded raid6 after 3 disks=20
> dropped out).
>=20
> Additionally, when he did fsck, that should have cleared the bad blocks=20
> which were being written over, but he said that
> "When doing a fsck.ext4 of /dev/md0 it returns the following ( and I can=
=20
> do it over and over again with the exact same errors) ..... "
> I think 'exact same errors' is not supposed to happen if I understand=20
> the intent of BBL correctly.
>=20
> So, I can't be sure, but I have the feeling it's possible that there are=
=20
> still a few bugs in the BBL code. MD RAID in general is very stable and=20
> I really like it so much, but maybe on production systems I'd keep the=20
> BBL disabled still for a while, if possible.
>=20

Fair enough.  Thanks for the explanation.

http://git.neil.brown.name/?p=3Dmdadm.git;a=3Dcommitdiff;h=3De2efe9e7bc7330=
7f74a4c2e2197d6d4498dd46f0

will be in mdadm-3.3.2.

NeilBrown

--Sig_/aiAs_/4fIQWNJUZ2yHjs_Bn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+LkHjnsnt1WYoG5AQKYsw/+JIzKhIQBg9kQ1tDTxEQYsnSPdswARiI2
QuavSvLBtc+TCU8k4QsyM68hJuYr9U9pBZHFQgfSu7zrMir3C6XTwQRqlwl7ov+p
7B4UUHPygmCtT3ZPMoVRtLRt8cct5CG2Xjwi7+3VwOZIp4fXyVKH+5gSiiY1Wtdc
iWKAXbbfKL8dvG2E7jT5s/08hcjSQdF8Gnfe1AbDVYQZM++R2yqQatPHaKoDHSPZ
reekBDwn2TNywrgnWeEJA4PAbSjAHm1ZIYDcsbS1AHohEv82K6nHBxW2bWFc29a9
NQB34fZS41A8pGFy54mtlELIFIH29Qc52+/rb/3r/7RlM0XERBqQ0pQ0547AiWDg
mvvppXSBz4B0CkkGtrlAM7ffJHlfNxZyFpryFq4L9xFMCQ22z/mv+iA+zvUuPeWZ
UorKTmprrQRRcCvpfKMyt0Eq+mn/VwyK8FliWo0sKIGOnkEqsMs4T1P7LU2dzFT+
aUu44ilBkA0pdcbAwSnk9ApeXZAXAJmc3MTif0dwGOdbBZV5t7v4oYdOummRh7zF
fTjHKEH1rUoYnZEeTBYNsdXGmn6k4mNSG21KsvaTmdbZ7n/Y1CuG1v+l4n6ESBJH
nnMK7Y7f8JFDxWoDC94IqUvEDi/kwQq8fe9qFQ5N8m/j1DajMZCkv4epJcXdz8BF
FvEa9ancSTc=
=v6Lp
-----END PGP SIGNATURE-----

--Sig_/aiAs_/4fIQWNJUZ2yHjs_Bn--
