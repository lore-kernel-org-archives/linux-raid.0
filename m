From: NeilBrown <neilb@suse.com>
Subject: Re: linux raid wiki - backup files
Date: Tue, 22 Nov 2016 09:45:40 +1100
Message-ID: <87vavgcuzv.fsf@notabene.neil.brown.name>
References: <583077D0.5070804@youngman.org.uk> <ffb47575-b655-924d-8626-07b9e48a6371@turmel.org> <5831B7B9.8090008@youngman.org.uk> <4febebb6-0442-cc5e-45d5-e041e21e2d95@turmel.org> <c3d16a30-b36e-3d26-f30a-441b236f7107@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c3d16a30-b36e-3d26-f30a-441b236f7107@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 22 2016, Anthony Youngman wrote:

> On 21/11/16 14:07, Phil Turmel wrote:
>> On 11/20/2016 09:48 AM, Wols Lists wrote:
>>> On 20/11/16 00:27, Phil Turmel wrote:
>>>> Yes.  But the new stripes lay on top of the old stripes, unless you mo=
ve
>>>> the data offset.  Which is why a backup file holds the old stripe just
>>>> in case.  If you can move the offset, you use the lower offset for the
>>>> lower addresses in the array, and the higher offset for the higher
>>>> addresses, on either side of the reshape position.
>>>
>>> Okay, understood. So v0.9 and v1.0 always need a backup for a reshape.
>
> Having looked at the man page, this now seems obvious - the superblock=20
> is at the end, so the data offset is 0. But for a 1.0 array, could we=20
> create a data offset?

Yes.  But usually the purpose for using 1.0 is to have data_offset =3D=3D 0,
so you might not want to.

>
> (So, if we created a data offset, we could then move the superblock and=20
> convert a 1.0 to 1.1 or 1.2? Okay, it can't do it now, but it looks to=20
> me like it shouldn't be that hard ... ?)

It would be quite easy to extend "--update=3Dmetadata" to change the
version once the data_offset had been changed.

>>>
>>> But if we have a data offset with v1.2, a reshape will use that space if
>>> it can rather than needing a backup file?
>>
> I'm guessing that 1.0 and 1.1 defaulted to no data offset to speak of?=20
> And if we (can) create a decent data offset, we can then use that in=20
> exactly the same way as with v1.2?

1.0 defaults to no data_offset.
1.1 uses the safe choice function as 1.2.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYM3kUAAoJEDnsnt1WYoG5v64P/3zrXwyqdbCydYW/KbobCPne
xjv/WnKKsvssiVqoO8cHETMM7EV5cfYok+i4A7c/xEvgN+yQMaVNkD2fMCn3uE+B
EJL96tHVVOjFdb4pi4Fb4ugFzvkPN445n2O8fynpsL6t7SILUlteCYWV01hfPUHg
3sNv/rbjSKuvFmVPUAYHWfwzO9BQeylI3kWi/gh0DeWzcybwj6fykcupjeHIyEy2
NawUiyhu/6FIE7Gbk8ljhxjMA1l80COUNuPQZNeGs2dFhcZkXXtB/h74jUhH0wKe
/tc7xKcLponKo1xoQChxlGhCxOwx9wVn1g0QIB87wwmhH9C4CP+lx/L6gxuMtJIV
a5rHlL9C1RtYQRBd6N0VIg9KVEGZKuTda4ZOnQxbQqsIb6inLHWzBQnc3XJMJ/1X
woAa9f4W0Z3RdoZagzS0/3zpcciGl11AkyM1ZsAdtiYcZVIr9fj8EvtvTbznz+5A
LlRuM0a4RVwBbfLuWR+BLy8RY/v7gBsreoMdLWcTueJStjffXB0ZUStDvQ1xxAnp
x7Crg06HBHfJrs0n+7D5VdSY8pJThCkcliC7T3UhYJfdWhv8dHPQIxAY5grr6Pfa
25ty9ML1TZJhL3KWoBOQOIfXn/tHO4XThB7HHpjT9DOcGmlJijumyn0L8XKvvSy7
/JVngvyc/Zq5HXag0Ob0
=jXOm
-----END PGP SIGNATURE-----
--=-=-=--
