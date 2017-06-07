From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: fix deadlock between mddev_suspend() and md_write_start()
Date: Wed, 07 Jun 2017 11:45:24 +1000
Message-ID: <874lvsd0zv.fsf@notabene.neil.brown.name>
References: <87lgppz221.fsf@esperi.org.uk> <87a865jf9a.fsf@notabene.neil.brown.name> <87fufwy3lr.fsf@esperi.org.uk> <87poezhwsa.fsf@notabene.neil.brown.name> <20170524225735.555dpfe24mi6yxrb@kernel.org> <871sr8h8qx.fsf@notabene.neil.brown.name> <20170530174133.qdj2qsopwug2opp6@kernel.org> <87wp8rc4jg.fsf@notabene.neil.brown.name> <20170606000115.jijxe6xvkclm4tsb@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170606000115.jijxe6xvkclm4tsb@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Nix <nix@esperi.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 05 2017, Shaohua Li wrote:

> On Mon, Jun 05, 2017 at 04:49:39PM +1000, Neil Brown wrote:
>>=20
>> If mddev_suspend() races with md_write_start() we can deadlock
>> with mddev_suspend() waiting for the request that is currently
>> in md_write_start() to complete the ->make_request() call,
>> and md_write_start() waiting for the metadata to be updated
>> to mark the array as 'dirty'.
>> As metadata updates done by md_check_recovery() only happen then
>> the mddev_lock() can be claimed, and as mddev_suspend() is often
>> called with the lock held, these threads wait indefinitely for each
>> other.
>>=20
>> We fix this by having md_write_start() abort if mddev_suspend()
>> is happening, and ->make_request() aborts if md_write_start()
>> aborted.
>> md_make_request() can detect this abort, decrease the ->active_io
>> count, and wait for mddev_suspend().
>
> Applied the two patches, thanks! For this one, I added md_start_write sym=
bol back. Will
> push these to Linus in the 4.12 cycle.
>


Thanks for fixing the md_start_write export!  At one stage in
development I made it "static", but then forgot the export when I put it
back :-(

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlk3WrYACgkQOeye3VZi
gbkHLQ/9G9xSN9v+LE5rr87AWpqjL8XQRuLaCBH2qVQV+OvZm4Fl+Vk0TNxpw2Ew
AUg+DH4pnwrVpdVihn+kyZRFecJyzgKNCLsSA27MJvarZ+/sov5NjuBdcFXjR+fp
YFF0mYbsT5sRLU1JKiPjszKomlJ4Y4c646jk2ftz2LaWaJ0tgd+WvvpVE2AxdGr9
SZAxt/z7j/mopusrDNcc9zR5dxMCHe9CGy0lruKZz9U2YzYvc9PRorSF9qgPfs4B
AIGnwbgkPl+av4WGJxPTR5EDvR6b2CZKtTGy9ZG45w79CorXW5oLRM/1L52rTseZ
Jlp8iQvXFqHTTo3cuP80U+FWxNcJb+zgpcgI14S0/W64BUb817ih9cO6KYSSmgq0
qa7FEii5CmvvwrJsS4IuAS+/5RajDrfkedMz9CqA8KD5QVHOZFW4esgLEj5l8ppg
x+4NSA7aLvyjeVUHG/Fz0A4IG1Ke+FZLBcWCVQH0UrbZZvb7He2Ha0PM0nRsfOFy
i0wzZsezqcGPtt51E3yHzlvCcnm7Sp3KNF3iVhSWTavK0F6ttbkvIPomCvnjzAm6
Gx3Oofj396GeCl8Z8Vt6uhZHCQWHgPgSM98A9Gyl16GAu9lvBiFUWQlFg5ixSGcR
517RpIt/GkAfxF1ymg4W5HFtHXOZlWbYuelk3lbdm5aX5fWeR6s=
=30h6
-----END PGP SIGNATURE-----
--=-=-=--
