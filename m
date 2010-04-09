From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch mdadm] Add hot-unplug support to mdadm
Date: Fri, 09 Apr 2010 16:02:30 -0400
Message-ID: <4BBF87D6.1050307@redhat.com>
References: <4BBA1289.4010705@redhat.com>	<20100407113035.3ca437f2@notabene.brown>	<4BBBE7D2.6090608@redhat.com>	<20100409093153.690ea963@notabene.brown> <20100409103330.37d9dff5@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig753CCA3E8743E9E91573A8D2"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100409103330.37d9dff5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig753CCA3E8743E9E91573A8D2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/08/2010 08:33 PM, Neil Brown wrote:
> On Fri, 9 Apr 2010 09:31:53 +1000
> Neil Brown <neilb@suse.de> wrote:
>=20
>> On Tue, 06 Apr 2010 22:02:58 -0400
>> Doug Ledford <dledford@redhat.com> wrote:
>>
>>> Let me know if you want me to redo/resend any of it.
>>>
>>
>> not necessary, but some remove would be appreciated.
>>
> I suspect you cope graciously with most of my typos, but this one is
> ridiculous!
>=20
>    s/remove/review/
>=20
> :-(

Yeah, that's when it transitions from typo to thinko.

> NeilBrown
>=20
> P.S.  When could the word "remove" be used in that context?  The only e=
xcuse
> I can think of is that a "remove" is a palette cleanser at a banquet.
> So "some remove" would be "some crystallized fruit or ginger bread" - a=
lways
> appreciated :-)

Not sure how well that would travel across the pond unless it was
airmail ;-)

Initial review looks fine to me.  I think I would suggest a few more
tweaks to the default udev rules file, but I'll forward those
separately.  Later tonight I'll do actual unit testing of your patch to
make sure it doesn't regress any functionality and if it needs any
fixes, forward those on to you as well.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig753CCA3E8743E9E91573A8D2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku/h9YACgkQg6WylM+/8ZQO+gCfWF8GQBD9mOgmrowyM1+vDqgr
YeIAn0ZJ07na7a7tHtQO1t+sMPm5KdxQ
=aUKy
-----END PGP SIGNATURE-----

--------------enig753CCA3E8743E9E91573A8D2--
