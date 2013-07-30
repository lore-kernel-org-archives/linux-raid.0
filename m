From: NeilBrown <neilb@suse.de>
Subject: Re: Suspicious test failure - mdmon misses recovery events on loop
 devices
Date: Tue, 30 Jul 2013 10:42:06 +1000
Message-ID: <20130730104206.3ffc9f00@notabene.brown>
References: <51F2E2DD.8090204@arcor.de>
	<20130729165550.53c33bf3@notabene.brown>
	<51F6D30F.7060007@arcor.de>
	<51F6D3B1.1030800@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kyB9mapQDoWD5Fs=gf3/FqQ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51F6D3B1.1030800@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/kyB9mapQDoWD5Fs=gf3/FqQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 29 Jul 2013 22:42:25 +0200 Martin Wilck <mwilck@arcor.de> wrote:

>=20
> > My current idea to solve this is yet another separate thread just for
> > monitoring kernel state changes. Don't have it ready yet, though.
>=20
> Another idea would be in manage_member, after queueing the metadata
> update and waking up the monitor, to wait for the metadata to finish
> processing before actually starting the recovery (writing "recover" to
> sync_action).
>=20
> Martin

I hope an extra thread won't be necessary :-)

I think that manage_member is the place to fix this.  However it might be
even simpler than you suggest.

We currently have

		replace_array(container, a, newa);
		sysfs_set_str(&a->info, NULL, "sync_action", "recover");

monitor subsequently takes that 'newa', looks at 'sync_action', see that it
is 'idle' and assume that the recover never happened.
Suppose we change it to:

		if (sysfs_set_str(&a->info, NULL, "sync_action", "recover") =3D=3D 0)
		        newa->prev_action =3D newa->curr_action =3D recovery;
		replace_array(container, a, newa);

Then it wouldn't matter if monitor never saw the 'recovery' state as manager
explicitly told it that recovery had started.

Could you try that?

Thanks,
NeilBrown

--Sig_/kyB9mapQDoWD5Fs=gf3/FqQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUfcL3jnsnt1WYoG5AQJspA/+OCPQ7VbKN7PjWXS7m8i50mVAqndLYi63
cYVb0V9sULSlWYXAHArSCLji3HZ6NP88TGEzt6s7lE7DCQEBaZK/tDXWgn7A3BXt
5hntU/2qLak6kUf3HTJDjQXZwYW8/QHQw13laOLl5kxaiMYcBzfr7sNrSr6D37bw
AHAwGsX1NSLgPjKDqXfAykM54dpcLJbD4UoGFVx6Ny9y0+wBNCWJjliEN/pkDiDR
st8WQMlwHSETt3U9TYOQ+87FG0ch6QLvklf3k3f8TmfWVGWUcwscNQASZq6/zCQU
R1tRL+nzt940LQQY0hCmFh5EZ4iq5B1+SOTH9Fm030CX6DegfEn6y4RzSnTDJ75J
hwCyooJZ/xoTMcKJy0xl864/tGO2bfS4T2OOk9S7fCkAs0NR9oCqEhOOrjgYCwrt
ckvUaDu5LgyTafI8d6ynl9OzMu85VI5KGVYYptP4AV/mXv8Tv5r8Iyk53Y7AhnDE
q8Za9Uglwzz2dPDLV7syco5wY69l1ZzpXmjlk4IMFBinTEWOPzcGjell+LwgXnIr
BaknDV2CCVhb5ui5+mEQgCB4mvAE4HAACXV/4zCgRVtwCsUEU7FAv/JMSWrCcGwm
SSlTveedlZ8sCR3UVzg8DLOf67gO4/BE/Qgzw10HPqSXT2sBFs+LgbeOYa493G/o
9dHtMbUu2yU=
=oZg0
-----END PGP SIGNATURE-----

--Sig_/kyB9mapQDoWD5Fs=gf3/FqQ--
