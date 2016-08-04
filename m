From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/3] MD: hold mddev lock for .quiesce in md_do_sync
Date: Thu, 04 Aug 2016 13:16:49 +1000
Message-ID: <87y44dnrz2.fsf@notabene.neil.brown.name>
References: <515fa68e5c4784b08f2ce99c082c923f6b02a3c9.1469922791.git.shli@fb.com> <87y44epwb5.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87y44epwb5.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org, linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Aug 03 2016, NeilBrown wrote:

> [ Unknown signature status ]
> On Sun, Jul 31 2016, shli@kernel.org wrote:
>
>> From: Shaohua Li <shli@fb.com>
>>
>> .quiesce is called with mddev lock hold at most places. There are few
>> exceptions. Calling .quesce without the lock hold could create races. For
>> example, the .quesce of raid1 can't be recursively. The purpose of the patches
>> is to fix a race in raid5-cache. The raid5-cache .quesce will write md
>> superblock and should be called with mddev lock hold.
>>
>> Cc: NeilBrown <neilb@suse.com>
>> Signed-off-by: Shaohua Li <shli@fb.com>
>
> Acked-by: NeilBrown <neilb@suse.com>
>
> This should be safe but I'm not sure I really like it.
> The raid1 quiesce could be changed so that it can be called recursively.
> The raid5-cache situation would be harder to get right and maybe this is
> the best solution... It's just that 'quiesce' should be a fairly
> light-weight operation, just waiting for pending requests to flush.  It
> shouldn't really *need* a lock.

Actually, the more I think about this, the less I like it.

I would much rather make .quiesce lighter weight so that no locking was
needed.

For r5l_quiesce, that probable means removed the "r5l_do_reclaim()".
Stopping and restarting the reclaim thread seems reasonable, but calling
r5l_do_reclaim() should not be needed.  It should be done periodically
by the thread, and at 'stop' time, but otherwise isn't needed.
You would need to hold some mutex while calling md_register_thread, but
that could be probably be log->io_mutex, or maybe even some other new
mutex

Could you explore following that path instead?

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXorOhAAoJEDnsnt1WYoG53D0P/RhtXYI4WdT71yrQuer0dOcm
bc2JSBBuyWQ69Yf3oaGdcv+XfV5+pof3YalWNMjGbKhmcwkg9obmvfuuT7WdM1rh
jtXyxmA1Go3dkDUOCmtmD/NjtCdonJcn5Sc7dFSBjkkn6ssMdQxvOQhZqFwVjfYO
y6pMBg1B6aalWZf4JvK8QnU08eO0eaxxuaa6VBmmy4r3ni9emHuOEruelEpcfQUz
HnNxUwYh6pUERvdRJHFomhcOemRyd9h50H5HQYuEUciA6rkyQ/TVk5G8cVo8ei5U
ZoNNz5njFcqa6fyTlglJr1DXcBiL7U4nbjIO9t9JNTUPy0dBHT/qCENDt+JR4Dv7
l+IcnBNwLulnZg7W7h2g3qZ/3qe7CjDxPEN36Wk/mgzm8Z/HZuLH3Gb6G9K5fn7z
Oqd+sIfh6vMWW3yzkHgW7HQqbf+T/Adi23FWnlWkcDqlTm4gkNF43Y74SXCXbzf3
EIcjjc4TwfXv+Hs5H17cQFhB61WLwSnTRUxKMVPgEiXijjkqg/eBrU9tyH4+1B0F
B+l9funeQU1G2j2RJaLn/a0tQT4TFA+fyX6a0zwBl4hWXUhKAWa3PaqoTpvUhOk6
JcGttF0H4Rb1TJIZpPnMPNzeEEq7MzhVpjLRMG6cM5HRlUuq2RIHBaEKwuhputFX
iqcmlsstlBk+p75uZ2pc
=pyE/
-----END PGP SIGNATURE-----
--=-=-=--
