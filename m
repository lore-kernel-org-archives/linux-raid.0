From: Doug Ledford <dledford@redhat.com>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
 support handoff after pivotroot
Date: Thu, 04 Feb 2010 10:48:28 -0500
Message-ID: <4B6AEC4C.9060705@redhat.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com> <4B686CC0.4030103@redhat.com> <201002041450.14139.bernd.schubert@fastmail.fm> <201002041603.37619.bernd.schubert@fastmail.fm>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDDA754E0A31E65607DFFA071"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201002041603.37619.bernd.schubert@fastmail.fm>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Bill Davidsen <davidsen@tmr.com>, Michael Evans <mjevans1983@gmail.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDDA754E0A31E65607DFFA071
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 02/04/2010 10:03 AM, Bernd Schubert wrote:
> On Thursday 04 February 2010, Bernd Schubert wrote:
>> On Tuesday 02 February 2010, Doug Ledford wrote:
>>> On 02/02/2010 10:42 AM, Bill Davidsen wrote:
>>>> Michael Evans wrote:
>>>> It seems as if a lot of work
>>>> and overhead is being generated for the applications, just to save a=

>>>> tiny bit of work for the people implementing a new boot procedure.
>>>>
>>>> (cd /dev .run && find . -depth | cpio -pdm /var/run; cd -; rmdir
>>>> /dev/.run)
>>
>> What about to use "mount --move" from /var/run of the initrams to fina=
l
>> /var/run before the chroot command?
>=20
> Oops, I meant pivot_root.

Static files in /var/run would be lost that way.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigDDA754E0A31E65607DFFA071
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktq7EwACgkQg6WylM+/8ZQLagCglmJnmSwDcn4kWl2Xe2AWdqOb
2OUAnjCbejVuKaNNZPohk0e6I0FyC4h7
=eYDh
-----END PGP SIGNATURE-----

--------------enigDDA754E0A31E65607DFFA071--
