From: NeilBrown <neilb@suse.de>
Subject: Re: Failed, but "md: cannot remove active disk..."
Date: Tue, 15 May 2012 13:38:56 +1000
Message-ID: <20120515133856.6e04d77b@notabene.brown>
References: <1336933308.2831.4.camel@localhost>
	<20120514202220.5a164eb0@notabene.brown>
	<1336992780.6722.18.camel@localhost>
	<20120514213623.3bc1bfa5@notabene.brown>
	<1336995865.6722.22.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9WaFM3.8RNhQ1rldR2vFp=Q"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1336995865.6722.22.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/9WaFM3.8RNhQ1rldR2vFp=Q
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 14 May 2012 13:44:25 +0200 Micha=C5=82 Sawicz <michal@sawicz.net> w=
rote:

> Dnia 2012-05-14, pon o godzinie 21:36 +1000, NeilBrown pisze:
> > Is the array still functioning?
> > Are there any interesting messages appearing in the kernel logs?
>=20
> Yes and no, the array is fine, working, nothing interesting in any logs
> I can see.
>=20
> > What does
> >   grep . /sys/block/md126/md/dev*/*
> > show?
>
//snip//


Thanks. No hints there - all normal.

If you can write to the array, then md_check_recovery must be getting run,
and the array is not read-only. So...

Is there a 'sync' thread still running?  It would be called
    md126_resync

That would stop things from progressing.
If there is, what does
    cat /proc/$PID/stack
show for the relevant PID ??

What about
    cat /sys/block/md126/md/sync_action
??
If that were 'frozen', that might explain it.

    cat /sys/block/md126/md/reshape_position

shows "none" I suspect?

I cannot think of anything else that could be getting in the way.

NeilBrown

--Sig_/9WaFM3.8RNhQ1rldR2vFp=Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7HP0Dnsnt1WYoG5AQKH4RAAn/kAuBiFSqmYmPIr/NMxqEe9OV8acQZV
nw67FlMRaFMMqEKw/KDa/PqFyozTkOnJY8k5uQoAov8P2gqXNvQEq3q8wxQQs55Z
3OamXGFEvn0YxPr9zaXN++TO+NsJ1S98QINrX+H8SklB3+t+cNTrO0g0/HT7oC5W
FMlx5eOzjYh3Vk0xcD5UQF8wxsoBQ+cxeYBN/eAPD1CaYSDwqJw85ANI2smkA2qF
P19ffQwzBoljbUq/IjrBrRQTkYXDpRE+9apCAr8spW2UHqQCnVpuNA039r+PmhZg
7itx4C51TpiQ0Ur3P0IMnJZXnQUdEQgXBnvq8jB6q/Y1dEGWwDH7qja/JfYvc1ou
uqleQ1U8IyQKlf6hszC8ronq6swbfMoxij3q0lIXxmJGhBzJrEzqyshqB221Muy9
4OiM+XCKfo99YlVofESw90thAMN/fuIZOYYHc9onN3+Bh0JwxpomYMNhpwnArYp9
4ec4f2Hz+UuaJN3JxLdZzGyyBOBMFssBw+IFt0ddIsBpM6nYYQBmJnh+9JlWfTra
RULthOrw63t6/IZeGi+0mJyGm2xEyiAmUYaWxzNUacfutDpx7VgWsHSmfcipRjx7
dsmgO9XZYH0NzWoXfXpLgKouCRWqacsqsAis/6E4VtVkRuejKWEEmV5STgznS4Dv
vpZSg4AN24Q=
=1Oth
-----END PGP SIGNATURE-----

--Sig_/9WaFM3.8RNhQ1rldR2vFp=Q--
