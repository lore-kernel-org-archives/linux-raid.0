From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 1/2] imsm: delete subarray functionality
Date: Thu, 01 Apr 2010 12:31:37 -0400
Message-ID: <4BB4CA69.7060705@redhat.com>
References: <66C59AD0932712458090B447266D638CD3C7EAF4@irsmsx504.ger.corp.intel.com> <20100401060922.GA15461@maude.comedia.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB4FFA6EA9C42F8F824BEC6E1"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100401060922.GA15461@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Williams,
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB4FFA6EA9C42F8F824BEC6E1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/01/2010 02:09 AM, Luca Berra wrote:
> On Wed, Mar 31, 2010 at 09:50:40PM +0100, Hawrylewicz Czarnowski,
> Przemyslaw wrote:

>> int mdmon_pid(int devnum)
>> @@ -1502,7 +1523,11 @@ int mdmon_pid(int devnum)
>>        char pid[10];
>>        int fd;
>>        int n;
>> -       sprintf(path, "%s/%s.pid", pid_dir, devnum2devname(devnum));
>> +       char *devname =3D devnum2devname(devnum);
>> +
>> +       sprintf(path, "%s/%s.pid", pid_dir, devname);
>> +       free(devname);
>> +
>>        fd =3D open(path, O_RDONLY | O_NOATIME, 0);
>>
>>        if (fd < 0)
> why?

Looks like it leaks memory in the old implementation.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigB4FFA6EA9C42F8F824BEC6E1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku0ymoACgkQg6WylM+/8ZQNUQCgnKssZlA9saXzjBTq0tQ2C5TI
Fs0AnioIcRE00bYTuRRehSHZqisdDeZg
=UZuA
-----END PGP SIGNATURE-----

--------------enigB4FFA6EA9C42F8F824BEC6E1--
