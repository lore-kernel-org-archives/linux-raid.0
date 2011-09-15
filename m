From: NeilBrown <neilb@suse.de>
Subject: Re: [TuxOnIce-users] Repeatable md OOPS on suspend,	2.6.39.4 and
 3.0.3
Date: Thu, 15 Sep 2011 05:31:39 +0200
Message-ID: <20110915053139.09dd6ae1@notabene.brown>
References: <CALxPEfw-XdcosHemovkxj9aOwaYxUaQ6dj=yMaKCmoy2vkkUkg@mail.gmail.com>
	<loom.20110901T032036-733@post.gmane.org>
	<CALxPEfwJ99bvmSXkqSKutAYbcD9OLcyMcKQQO6G+Yxi9RQ1DFA@mail.gmail.com>
	<CALxPEfyQrwWh1AWY-fwwCeMzDEeK390Eof9PwrsN6C11Wnt9=A@mail.gmail.com>
	<loom.20110906T201030-97@post.gmane.org>
	<87mxed7u3s.fsf_-_@spindle.srvr.nix>
	<4E71397A.9060708@tuxonice.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BpxcR5auxoFCudrNgmx.L2G"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E71397A.9060708@tuxonice.net>
Sender: linux-raid-owner@vger.kernel.org
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: TuxOnIce users' list <tuxonice-users@lists.tuxonice.net>, Nix <nix@esperi.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/BpxcR5auxoFCudrNgmx.L2G
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Sep 2011 09:32:10 +1000 Nigel Cunningham <nigel@tuxonice.net>
wrote:

> Hi.
>=20
> Please try/review the attached patch.
>=20
> The problem is that TuxOnIce adds a BUG_ON() to catch non-TuxOnIce I/O
> during hibernation, as a method of seeking to stop on-disk data getting
> corrupted by the writing of data that has potentially been overwritten
> by the atomic copy.
>=20
> Stopping the md devices from being marked readonly is the right thing to
> do - if we don't resume, we want recovery to be run. If we do resume,
> they should still be in the pre-hibernate state.
>=20
> Regards,
>=20
> Nigel

This doesn't feel like the right approach to me.

I think the 'md' device *should* be marked 'clean' when it is clean to
avoid unnecessary resyncs.

It would almost certainly make sense to have a way to tell md 'hibernate
wrote to your device so things might have changed - you should check'.
Then md could look at the metadata and refresh any in-memory information
such as device failures and event counts.
After all if a device fails while writing out the hibernation image, we want
the hibernation to succeed (I assume) and we want md to know that the device
is failed when it wakes back up, and currently it won't.  So we really need
that notification anyway.

??

Thanks,
NeilBrown

--Sig_/BpxcR5auxoFCudrNgmx.L2G
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iD8DBQFOcXGgG5fc6gV+Wb0RAud6AJ9xuIj3nwOMLRGcOaejxJTCUMOJSwCeN7Ql
4wFbY9Imd9vkPbulorviZDs=
=9xCT
-----END PGP SIGNATURE-----

--Sig_/BpxcR5auxoFCudrNgmx.L2G--
