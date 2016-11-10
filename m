From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH 2/3] md: remove md_super_wait() call after bitmap_flush()
Date: Thu, 10 Nov 2016 11:57:35 +1100
Message-ID: <87bmxom9s0.fsf@notabene.neil.brown.name>
References: <147864718560.1076.2148299631932240330.stgit@noble> <147864729285.1076.27654779060287129.stgit@noble> <20161109205120.kodctkb5xn5x55rd@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161109205120.kodctkb5xn5x55rd@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 10 2016, Shaohua Li wrote:

> On Wed, Nov 09, 2016 at 10:21:32AM +1100, Neil Brown wrote:
>> bitmap_flush() finishes with bitmap_update_sb(), and that finishes
>> with write_page(..., 1), so write_page() will wait for all writes
>> to complete.  So there is no point calling md_super_wait()
>> immediately afterwards.
>>=20
>> Signed-off-by: NeilBrown <neilb@suse.com>
>> ---
>>  drivers/md/md.c |    1 -
>>  1 file changed, 1 deletion(-)
>>=20
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index f389d8abe137..1f1c7f007b68 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -5472,7 +5472,6 @@ static void __md_stop_writes(struct mddev *mddev)
>>  	del_timer_sync(&mddev->safemode_timer);
>>=20=20
>>  	bitmap_flush(mddev);
>> -	md_super_wait(mddev);
>
> bitmap_flush() could be null if there is no bitmap, is this safe?

Good question.
If there is no bitmap, then all metadata updates (both superblock
and bad-block-list) are synchronous in md_update_sb(), which is always
called under ->reconfig_mutex and so which cannot race with this code.

So yes, it is safe.  That md_super_wait() was only ever intended to wait
for things that bitmap_flush() might have flushed, so it should have
been inside that function.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYI8X/AAoJEDnsnt1WYoG52aMP/3vUtgR8ThLou/Z1Lm3v3Zsp
hx5Y+WUB6DoHD0XBlnK8WQvkhJVJ63b7Nm6S0B69dCPwZ6CsMuR5fMSI2b+j32qU
uHFHzziPUFafmzYv4MQdyrMRl3mIeInXCnja0ztZfi1DeexUFcINt1rtjeytfsw8
2vU1qtGbsMRiGbKw7H4LfJL/kj0wKUiLOI8mq4DnIo3Ix5bYM33kdNllHMR7h4VH
U5p/DzRTPH0fth7ALNo3p7KUByhAbsy0ckB86tQ4WgzPcEIfZYT09Pq0sEejZ0B5
WTLRaY3QFkZF1si7o43nDSxoeBcDFGfMhPuCBE0dayXQAl/r0vojB2qpuhk6062G
YamBpxEaUsDcG7o2v1V/cZfXl77Ju+NIIHnQ8r5/nsGZhz8y0tETgt0q97Yox9B/
RUSpnz+yXvvkYqZ8Sctpp+dxOWcNW87Bf6EsiUovUNHyr8zMenKbAoCiWBHZTsAU
XOGYl6ObnbDg/wPKIiOcy6+6gWn4UA0dFZnAyBEn0C+nPP+ofrOGAFxry1yFLEYP
ylpcSFVXWVlJUAGlgB898KzAJuop3UWagra2XzY/vOjrlyfxbhEaIOcnmLn3X865
Rf1tPe/VpoRwKKskQLbGlmI8atAwXpXBhUfauV0DgTXfbHfihdf9v099P2vocKh0
CuHQHcpbbNtUcoUUn2SL
=oFsP
-----END PGP SIGNATURE-----
--=-=-=--
