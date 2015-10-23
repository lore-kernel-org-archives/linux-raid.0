From: Neil Brown <neilb@suse.de>
Subject: Re: Hung RAID5 array with discard
Date: Fri, 23 Oct 2015 16:51:59 +1100
Message-ID: <87vb9yxhc0.fsf@notabene.neil.brown.name>
References: <CANHB05vDxWqfST41hXgfApthHuxdSuyJYCKqS4jkOa7OZ0kpsA@mail.gmail.com> <CANHB05sb44ZD-31ceEWWSY0XdhWaU-Pq+NFRQSm-1qafHx1G2g@mail.gmail.com> <20150323135754.02afa72e@notabene.brown> <562909AC.7040003@kieser.ca> <87y4euxkj2.fsf@notabene.neil.brown.name> <5629BE44.8070205@kieser.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5629BE44.8070205@kieser.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Kieser <peter@kieser.ca>, Terry Hardie <thardie@instartlogic.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Peter Kieser <peter@kieser.ca> writes:

> On 2015-10-22 9:42 PM, Neil Brown wrote:
>> Peter Kieser <peter@kieser.ca> writes:
>>
>>> FYI I ran into this problem in 3.18.22 when forcing RAID5 TRIM support
>>> w/ raid456.devices_handle_discard_safely on Intel DC S3500 SSDs.
>> Can you please be precise about the problem you experienced.
>> Complete kernel messages are a minimum.
>> Anything interesting that might have been happening at the time might
>> help.
>>
>> Thanks,
>> NeilBrown
>
> Same behaviour as the original poster. Enabled the module knob, then ran=
=20
> mkfs.ext4, which starts to do "Discarding device blocks" and then the=20
> machine hard locked. No kernel messages.
>
Thanks.
The original poster reported a hung-task dump...
When you say "hard locked" - can you still access from another
window/login, or is it totally forzen?
If former, are then any processes in D start?  maybe mdXX-raid5?
Can you get /proc/$PID/stack of that process?

If totally frozen - do you have a console?  Can you alt-sysrq-W ??

Or have you since rebooted and the problem isn't repeatable?

Thanks,
NeilBrown




--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWKcr/AAoJEDnsnt1WYoG5fcQQAKKYyuNSpsm2UnGvEshos6r9
7Ni5VlaUBlmdB7QqySNW/+Oqi+17mt72hkR2oO41oRqw6mnA/tvhg5XI8PKryC1Q
BkDhGhP8INUqHNWoAzgKc21lwBpHJZiaJdx3g1b2UozHcS48CCjjBQ1Ok30NoxT3
q4wSukPzzIrbOcz8gTW8y+McgU5YQmxVflS7x11If2jqHiDl5ysrTW3ipVS6SHNH
D4VM2lGrYLj2icB8JpzyVw6xWt4HH7EuAr4i58g4OH9p3+OwRUBmGsAXiot9En4w
/TSgAw7TPRGZhwEhHkFyk5oVJtETZe7WPTHwqmNtqZRT7YsJ0eZQsY552mE6yzcV
sM1fQT+3Y3RTWt27GEbYhZnPAExLcz8zlU/SVpldo9dmmb+30u6NMI7jKlgSwx+Y
SaJsmNr/L5/j7C+vTsib1bEbgHB16slngGoruLkGEcjpyzvxCwNOqK4lJ70D0RcG
i/rYSMs7qy6r5ZCy0Qt02HCXGp/SFLcWRzdQXwRUeAUSST/rI1qxL6SF/LGjPdiZ
b+KO68oCMYAH41smE05OwGWTShEIhbHkepIGU379pkCVxtcS+vIMKoU10+nla7jC
lF4+SqhhkWIWtJErNxh5utCSYUbbev6Y6BfKBuIgteuVgYNo5E4JWEccJKCtO/6b
qtb1cJwtnYJIwNfA7lNT
=42ol
-----END PGP SIGNATURE-----
--=-=-=--
