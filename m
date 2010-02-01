From: Doug Ledford <dledford@redhat.com>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
 support handoff after pivotroot
Date: Mon, 01 Feb 2010 16:32:16 -0500
Message-ID: <4B674860.7080604@redhat.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>	<1263242294-5353-3-git-send-email-dledford@redhat.com> <20100119110930.107ca42e@notabene> <4B55F138.7060008@redhat.com> <4B673A5D.2010901@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE553705043FDD58B692EE945"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B673A5D.2010901@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE553705043FDD58B692EE945
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/01/2010 03:32 PM, Bill Davidsen wrote:
> Doug Ledford wrote:
>> On 01/18/2010 05:09 PM, Neil Brown wrote:
>> =20
>>> I understand there is a problem here, but I don't like this approach
>>> to a
>>> solution.  I'll give it more though when I get home from LCA2010 and =
see
>>> what I can come up with.
>>>    =20
>>
>> Feel free to come up with something different.  But, if your solution
>> involves maintaining an additional read/write mount area in deference =
to
>> a long dead unix tradition, I'm just going to shake my head and patch
>> your solution away to something sane.
>>
>>  =20
> I don't understand you argument here. Not the one where you say you're
> going to ignore Neil and do what you want because you can, I understand=

> that, but the "additional read/write mount area" part, isn't /var/run
> r/w on all systems now? Could you clarify why this is "additional" here=
?
>=20

It's not necessarily read/write in the initrd time frame, and putting
the mdadm files there means it would have to be.  We didn't make these
changes because we wanted to, we made them because using mdadm raid
arrays for the root filesystem combined with incremental assembly or
with imsm raid devices was broken otherwise.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigE553705043FDD58B692EE945
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktnSGUACgkQg6WylM+/8ZTBKACgpp5a8veNX67pTgxtv81WQks+
V4wAnjqHZgL5IJ2kyclXe1Kl+ydBoQWw
=7SqX
-----END PGP SIGNATURE-----

--------------enigE553705043FDD58B692EE945--
