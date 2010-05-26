From: Doug Ledford <dledford@redhat.com>
Subject: Re: raid 5 mismatch_cnt errors
Date: Wed, 26 May 2010 11:49:52 -0400
Message-ID: <4BFD4320.6090606@redhat.com>
References: <4BF56B1F.9080205@locallinux.com>	<20100521071645.497cdcad@notabene.brown>	<4BF5B7D1.3070808@locallinux.com> <20100521083819.54680dfb@notabene.brown> <4BF5ECE7.7020907@redhat.com> <4BFD392E.3030906@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDF87B377FCCF121F6BC21B4E"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BFD392E.3030906@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Neil Brown <neilb@suse.de>, Trey Scarborough <treys@locallinux.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDF87B377FCCF121F6BC21B4E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/26/2010 11:07 AM, Bill Davidsen wrote:
> Doug Ledford wrote:
>> On 05/20/2010 06:38 PM, Neil Brown wrote:
>> =20
>>> On Thu, 20 May 2010 17:29:37 -0500
>>> Trey Scarborough <treys@locallinux.com> wrote:
>>>
>>>   =20
>>>> Neil Brown wrote:
>>>>     =20
>>>>> On Thu, 20 May 2010 12:02:23 -0500
>>>>> Trey Scarborough <treys@locallinux.com> wrote:
>>>>>
>>>>>         =20
>>>>>> I have a raid 5 array with 9 disks and I have a mismatch_cnt that
>>>>>> keeps growing. This is causing file corruption on the underlaying
>>>>>> file systems as well.  I can copy a group of 100 100mb files and
>>>>>> then do a md5sum on them and 1-3 will be corrupt. If this is a
>>>>>> drive that is bad is there anyway to run a report on the count per=

>>>>>> drive that these mismatches occur. I have run smarttools test and
>>>>>> do not see one drive that stands out to be causing errors. Could
>>>>>> something else be causing these errors?
>>>>>>              =20
>>
>> While a bad drive is certainly a possibility here, this is precisely t=
he
>> type of failure scenario that would make me suspect bad RAM,
>> motherboard, or CPU.  So I wouldn't rule those out as possibilities
>> either.
>>  =20
>=20
> I have the same thought, I would remove half the RAM from the system an=
d
> test again, then swap to the "other" half and repeat. Of course running=

> memtest first is a good idea, but I have seen failures which only happe=
n
> on disk access.

Indeed, I've seen lots of failures that only happen with disk access and
not with memory testers.  Hence why I have a shell script on my web page
in my sig that uses disk access to test memory.

> If the system is O/C obviously the first step is to cut the speed back.=
=2E.
>=20


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigDF87B377FCCF121F6BC21B4E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv9QyAACgkQg6WylM+/8ZTpNwCgqCGc6lVzsS6l0gpy5wpZwKs8
WeoAoKOyw5Sfs6fGGdSv13hHG9ATMUpl
=ig/k
-----END PGP SIGNATURE-----

--------------enigDF87B377FCCF121F6BC21B4E--
