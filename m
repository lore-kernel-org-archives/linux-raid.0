From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 2/2] mdadm.c: fix compile error "switch condition has boolean value"
Date: Thu, 30 Mar 2017 08:38:35 +1100
Message-ID: <87lgrnu5k4.fsf@notabene.neil.brown.name>
References: <1490780434-8720-1-git-send-email-gi-oh.kim@profitbricks.com> <1490780434-8720-2-git-send-email-gi-oh.kim@profitbricks.com> <wrfjpoh0dqzz.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <wrfjpoh0dqzz.fsf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jes.sorensen@gmail.com, Gioh Kim <gi-oh.kim@profitbricks.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Wol <anthony@youngman.org.uk>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 30 2017, jes.sorensen@gmail.com wrote:

> Gioh Kim <gi-oh.kim@profitbricks.com> writes:
>> Remove a boolean expression in switch condition
>> to prevent compile error of some compilers.
>
> Please be specific, which compile is unable to handle this?
>
>> Signed-off-by: Gioh Kim <gi-oh.kim@profitbricks.com>
>> ---
>>  mdadm.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/mdadm.c b/mdadm.c
>> index 08ddcab..a98a051 100644
>> --- a/mdadm.c
>> +++ b/mdadm.c
>> @@ -1905,11 +1905,11 @@ static int misc_list(struct mddev_dev *devlist,
>>  			rv |=3D SetAction(dv->devname, c->action);
>>  			continue;
>>  		}
>> -		switch(dv->devname[0] =3D=3D '/') {
>> -			case 0:
>> +		switch(dv->devname[0]) {
>> +			default:
>>  				mdfd =3D open_dev(dv->devname);
>>  				if (mdfd >=3D 0) break;
>> -			case 1:
>> +			case '/':
>>  				mdfd =3D open_mddev(dv->devname, 1);=20=20
>>  		}
>>  		if (mdfd>=3D0) {
>
> While I agree the original code is ugly, I am not convinced your
> replacement is a lot prettier.
>

Maybe

		if (dv->devname[0] =3D=3D '/' ||
		    (mdfd =3D open_dev(dv->devname)) < 0)
				mdfd =3D open_mddev(dv->devname, 1);

??
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljcKVsACgkQOeye3VZi
gbnrAxAAkfq3s0JDQ8NZs2V7Nsbjt3G0YHYkJpu+9loE1GB9qBx7TvCWOmrKt8UX
z6R9g+Lus2AvFCZ6zojTAjoBs283bgt2/54sQUaebMtiHgjRYB//zvjV7XaVE2d1
qQLSQqHz6GUKySWfyuntZs/96QkuSRA0zYuNg6wjhpmPk/0dCPEg4To4gPXWfsFl
6tCa9K4hVKsPMECGfkSnhg8CN4FztuMzEiCpq4aPiSUDZHUeA+O3GWxZsQSd4zQ0
FUmxB+xMvGY5MKoZmmhGgAmI61IE6vYSwY09tmwa7zKP51X89grWVWOo313RX9Oz
MiUR4/wLRJa/8a3IDhg2Y+QhVBBUhV0/eR3SypKUBoaYNw2IhCITgpY8CeVeq3QJ
FsAoVjqtGoZ0b2krjjZ+3Y+AmclqRKzXkxt3jsUCNwFgiimMZJHD7GLGRnkiduP4
XedOUiH1K2vR8BsJ8bUfU+Z8ckwuJ+Zj/FPjyPPOwujnZwttGQsbea9E0pkLM4jm
2TNZidzdND/7Com2I6+9sATg9G3tfuMyxQweCj/R+tMc+E3h1JqSdjtuCxgoEKhu
z2BO2kvsiNH+ICr4069RXN611ulQOeNEMLam4HC4qG4eCqVvO2hW07wD4+HM9ZBZ
3/gxDVXktCKM4FUaBlLFJNO6B9F/EWmFsGf9c8tnqWObVM7C+8Y=
=GPQl
-----END PGP SIGNATURE-----
--=-=-=--
