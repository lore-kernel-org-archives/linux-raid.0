From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH 01/18] md: disconnect device from personality before trying to remove it.
Date: Fri, 10 Jun 2016 16:40:44 +1000
Message-ID: <87twh1mtqr.fsf@notabene.neil.brown.name>
References: <20160602061319.2939.72280.stgit@noble> <20160602061952.2939.77544.stgit@noble> <20160603223130.GB1898@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160603223130.GB1898@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 04 2016, Shaohua Li wrote:

> On Thu, Jun 02, 2016 at 04:19:52PM +1000, Neil Brown wrote:
>> When the HOT_REMOVE_DISK ioctl is used to remove a device, we
>> call remove_and_add_spares() which will remove it from the personality
>> if possible.  This improves the chances that the removal will succeed.
>>=20
>> When writing "remove" to dev-XX/state, we don't.  So that can fail more =
easily.
>>=20
>> So add the remove_and_add_spares() into "remove" handling.
>>=20
>> Signed-off-by: NeilBrown <neilb@suse.com>
>> ---
>>  drivers/md/md.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>=20
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 866825f10b4c..2d26099e1160 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -2596,6 +2596,8 @@ state_store(struct md_rdev *rdev, const char *buf,=
 size_t len)
>>  		else
>>  			err =3D -EBUSY;
>>  	} else if (cmd_match(buf, "remove")) {
>> +		clear_bit(Blocked, &rdev->flags);
>> +		remove_and_add_spares(rdev->mddev, rdev);
>>  		if (rdev->raid_disk >=3D 0)
>>  			err =3D -EBUSY;
>>  		else {
>
> Do we need wakeup rdev->blocked_wait here? I noticed some times we do the
> wakeup but sometimes we not. This makes me worry about
> md_wait_for_blocked_rdev. Will timeout cause anything bad?

(sorry for delay)

Yes, we probably should but it isn't very important.  If any code is
waiting then the 'remove' will fail and whatever would normally unblock
the device will still unblock and wake up as it would have done.
It is import to wake blocked_rdev when we write out the bad block list
or other metadata which makes it safe to use the device.  If we clear
the flag at other time it doesn't really matter.

Adding a wakeup here might make it more likely for the "remove" to work
in some rare cases, but I think that is the most significant effect.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXWmDsAAoJEDnsnt1WYoG5VZYP/3z031RgLUx9WKYlcifwitdW
yZ+u4lsIdfg1MOSs4KXaKjNVt7y3E14C3bvNvXfE7lJT2XscWedt+odu1SQ7D0Ja
+UX2A95eBbyTQUmz0cm2NPUlZdYoMX9Qckx1rlWK2q1gDBzOljoWAd4DwJLNKkHK
oSOwzz5sTCYXtVzc9x+yVxTL25kQCBlm0l1M+YP4EljhL33moS5J3m3IgpAEmH4G
dqF6c3DhfdlTzpBbAHqnFTozwzw8YGU8p+O2eOI60k7MK0GiVgKhZWuypj/aqkN1
m6pICsYt4Sw41UeKADt1R6kBefEPLjUJCxOJSOLqGGQ//wlR4/FESXLnxQeXVpRZ
4+n6RsCUtQXWwYTHQmrffCy/1/FXlMOmTawImu76BYF0mMhGbjsi5Ra9TiIU/mif
Nai9/Bbbyc2TuSoOcicYg9jkNnZ/zSPLoOwMYCJFZt2dCnjOUm8f2CqrFbCui4R8
Cej6hA49hLhU0OP1iTraBT2OCgxazyJYyfoEG387KwAGHE2Jo9a0dvkYgKsiPZ5n
06tuJcTSIou3H2bEq3INla/AwGyJJgp2TlD8w5GKUKhWx/y8nPMOTfYP2o1q6mlt
i/qihJH4HoVxAjyk6VrNrk4k69rTpaja7/QPQDwdG4VOkiLY2jKaocwG56vpR6mo
KyuM7fbpIskp6YWSlq85
=k18d
-----END PGP SIGNATURE-----
--=-=-=--
