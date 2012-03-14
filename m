From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 15/23] md/raid10 - support resizing some RAID10
 arrays.
Date: Wed, 14 Mar 2012 17:27:12 +1100
Message-ID: <20120314172712.3aa9310a@notabene.brown>
References: <20120314043555.7978.75486.stgit@notabene.brown>
	<20120314044040.7978.69754.stgit@notabene.brown>
	<20120314061746.GA28196@www5.open-std.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/vg3WQePJdTw+7cWllBiU/XM"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120314061746.GA28196@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: keld@keldix.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/vg3WQePJdTw+7cWllBiU/XM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Mar 2012 07:17:46 +0100 keld@keldix.com wrote:

> Hi Neil
>=20
> What is the problem with adding space to the 'far' layout?
>=20
> I would think you could just create the new array part 1 from the old arr=
ay part 2, and
> then sync the new array part 2 with the new array part 1. (in the case of=
 a far=3D2 array,
> for n>2 similar constructs would apply).

If I understand your proposal correctly, you would lose redundancy during t=
he
process, which is not acceptable.

If I don't understand properly - please explain in a bit more detail.

Thanks,
NeilBrown


--Sig_/vg3WQePJdTw+7cWllBiU/XM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT2A6QDnsnt1WYoG5AQKmqQ/9H/68lCrMxZuWzPVRjM/CL+zim5jFMYe6
nRxaacQbx/nGZpsU0llcsMxtG5jHv7I0bQwiMsnVLY/BURghfCC11Q0HAEWZrZY9
pTPwdtXwrHX6EDc4/UWRiOyuROUH9EtcxYhMdQG58n3kI26On/l3ZbVm4LEAjT9A
2BUWCnubh4YjgrlxEIAJpV5GIQgXw61IuyLXaRZ2Os9HZ80V83Wo8j22vrh30KI+
I4LaeCr3OhXhcC+1/6CQgA5Y+FK/KMJMlhxwx0LVPflCwnJlLBG5FKaG5NKkuI87
XOEVgIIkYnVyWYaJPgltekEQQBVbC+XEI49yu2WTAeO6gOC1DIJJXcOftqWsvyXY
kLT1m6APooE5ielPo1WvtoGvhA6KMFga3fAyMH6AV8i2dyfThBeM4zFZ6pcBmwST
HeX50Yi1GLOlJMmJ+fzjjYcV3Bs2bbm/s/8vjwxzGLssBW2rBO9FsI0LL9tShCoH
GIzXitRS0g+oji8nly6FbFFDYeGH8SIq0AiL8LGKuo7HoxgiDKetuVUEvT9iojo3
yN1A8GcOrNHAUvT6B4wlWQe9gQcohKy4bNqMSASsQ92XCnYVoxvY19pf0e5r9vHS
RrJitQqZSUPCQageuiygatUoyha1b8B3ivDR0gFDTlyX+zaNOQHfr/GTz2w36+wV
/ElP+4GLCe0=
=mhNL
-----END PGP SIGNATURE-----

--Sig_/vg3WQePJdTw+7cWllBiU/XM--
