From: Doug Ledford <dledford@redhat.com>
Subject: Re: mounting component device of RAID1 with internal bitmap
Date: Thu, 01 Apr 2010 14:39:29 -0400
Message-ID: <4BB4E861.9020003@redhat.com>
References: <q2zf19d625d1004011047gf9d48094p696ac38e669fb5e4@mail.gmail.com>	 <4BB4E291.5090304@redhat.com> <s2nf19d625d1004011126p80d579b7oaba81484dcad92ce@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig35ED6FD4E64F5BDEB3B8E5C7"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <s2nf19d625d1004011126p80d579b7oaba81484dcad92ce@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig35ED6FD4E64F5BDEB3B8E5C7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/01/2010 02:26 PM, CoolCold wrote:
> On Thu, Apr 1, 2010 at 10:14 PM, Doug Ledford <dledford@redhat.com> wro=
te:
>> On 04/01/2010 01:47 PM, CoolCold wrote:
>>> Hello!
>>> For raid1 array with metadata 0.90 it is possible to mount component
>>> (let's say /dev/sda1) as usual FS, fix smth, /etc/fstab for example,
>>> unmount and then assamble arary.
>>
>> At which point you have just corrupted your array.
> I've did such operation several times and it worked fine..I'll do some
> checks and report later.

Because you got lucky.  When you do this, you make the different members
of the raid array disagree on the contents of whatever file you
modified.  Depending on which disk the kernel reads from, you will get
either the new or the old contents of the file.  Any time you mount a
component device and modify it, you *must* force a resync from that
component to all other components or you *will* have a corrupt array.
When that corruption will crop up to bite you in the ass is up to random
chance.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig35ED6FD4E64F5BDEB3B8E5C7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku06GEACgkQg6WylM+/8ZSNxwCcD7H35uEA+lC72WKWSWrT9Lz4
+AoAn1DKdWQ1T2etqYG8T2vCND6inmvA
=idB6
-----END PGP SIGNATURE-----

--------------enig35ED6FD4E64F5BDEB3B8E5C7--
