From: Doug Ledford <dledford@redhat.com>
Subject: Re: raid 5 mismatch_cnt errors
Date: Fri, 21 May 2010 16:57:29 -0400
Message-ID: <4BF6F3B9.5020405@redhat.com>
References: <4BF56B1F.9080205@locallinux.com> <20100521071645.497cdcad@notabene.brown> <4BF5B7D1.3070808@locallinux.com> <20100521083819.54680dfb@notabene.brown> <4BF5ECE7.7020907@redhat.com> <4BF6B782.3060408@shiftmail.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig501CD30DB138E0F5F5A796AA"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BF6B782.3060408@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: MRK <mrk@shiftmail.org>
Cc: Neil Brown <neilb@suse.de>, Trey Scarborough <treys@locallinux.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig501CD30DB138E0F5F5A796AA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/21/2010 12:40 PM, MRK wrote:
> On 05/21/2010 04:16 AM, Doug Ledford wrote:
>> On 05/20/2010 06:38 PM, Neil Brown wrote:
>>  =20
>>> On Thu, 20 May 2010 17:29:37 -0500
>>> Trey Scarborough<treys@locallinux.com>  wrote:
>>>
>>>    =20
>>>> Neil Brown wrote:
>>>>      =20
>>>>> On Thu, 20 May 2010 12:02:23 -0500
>>>>> Trey Scarborough<treys@locallinux.com>  wrote:
>>>>>
>>>>>
>>>>>        =20
>>>>>> I have a raid 5 array with 9 disks and I have a mismatch_cnt that
>>>>>> keeps
>>>>>> growing. This is causing file corruption on the underlaying file
>>>>>> systems
>>>>>> as well.  I can copy a group of 100 100mb files and then do a
>>>>>> md5sum on
>>>>>> them and 1-3 will be corrupt. If this is a drive that is bad is th=
ere
>>>>>> anyway to run a report on the count per drive that these mismatche=
s
>>>>>> occur. I have run smarttools test and do not see one drive that
>>>>>> stands
>>>>>> out to be causing errors. Could something else be causing these
>>>>>> errors?
>>>>>>
>>>>>>           =20
>> While a bad drive is certainly a possibility here, this is precisely t=
he
>> type of failure scenario that would make me suspect bad RAM,
>> motherboard, or CPU.  So I wouldn't rule those out as possibilities
>> either.
>>   =20
>=20
> Could the cabling to the drive be causing this? (maybe failing or maybe=

> it's partly disconnected)
> I don't remember at what point Linux is at implementing the checksums
> between the controller and the drive.

I don't know.  I'm not up on the SATA signaling details so I don't know
if it uses CRC on the signal, but I suspect it does and a bad cable
would cause failed requests.  But I wouldn't bet my house on it, so I
would ask some SATA gurus.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig501CD30DB138E0F5F5A796AA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv287kACgkQg6WylM+/8ZQmywCgg1zPfO0693Df+fK06SqtCg1X
qLIAn23vV6ivCqwli4qibbiFqVNWb7Ge
=JB4e
-----END PGP SIGNATURE-----

--------------enig501CD30DB138E0F5F5A796AA--
