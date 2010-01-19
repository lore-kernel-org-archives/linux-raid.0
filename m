From: Doug Ledford <dledford@redhat.com>
Subject: Re: [[Patch mdadm] 1/5] Make the IMSM_DEVNAME_AS_SERIAL option work
 	when creating containers. This allows a person to testing using loopback
 	devices that don't support serial number queries.
Date: Mon, 18 Jan 2010 20:55:59 -0500
Message-ID: <4B55112F.4090403@redhat.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>	 <1263242294-5353-2-git-send-email-dledford@redhat.com> <e9c3a7c21001181413p60e0322byd97844d3f30a0715@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF4825D5C368ABDA60A28345A"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c21001181413p60e0322byd97844d3f30a0715@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF4825D5C368ABDA60A28345A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/18/2010 05:13 PM, Dan Williams wrote:
> Hi Doug,
>=20
> On Mon, Jan 11, 2010 at 1:38 PM, Doug Ledford <dledford@redhat.com> wro=
te:
>> Signed-off-by: Doug Ledford <dledford@redhat.com>
>> ---
>>  super-intel.c |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/super-intel.c b/super-intel.c
>> index d6951cc..fcf438c 100644
>> --- a/super-intel.c
>> +++ b/super-intel.c
>> @@ -3208,7 +3208,10 @@ static int add_to_super_imsm(struct supertype *=
st, mdu_disk_info_t *dk,
>>        dd->fd =3D fd;
>>        dd->e =3D NULL;
>>        rv =3D imsm_read_serial(fd, devname, dd->serial);
>> -       if (rv) {
>> +       if (rv && check_env("IMSM_DEVNAME_AS_SERIAL")) {
>> +               memset(dd->serial, 0, MAX_RAID_SERIAL_LEN);
>> +               fd2devname(fd, (char *) dd->serial);
>> +       } else if (rv) {
>=20
> This just duplicates the check already inside imsm_read_serial().
> Containers on loopback devices worked before this patch, so I'll send
> a revert.
>=20
> --
> Dan

Me thinks you didn't try it, because this does not duplicate the code in
imsm_read_serial().  That code is needed to assemble an IMSM array that
already exists on loopback devices.  This is needed to *create* an imsm
container on fresh loopback devices.  I'm assuming your imsm container
superblocks already existed or some such.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigF4825D5C368ABDA60A28345A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktVES8ACgkQg6WylM+/8ZSiXgCfeEoK7Db/iOHW4jkm/qY0OvUh
TOwAnjLwQI04eZ93Zq4WgptZRBCL5cMB
=jdrr
-----END PGP SIGNATURE-----

--------------enigF4825D5C368ABDA60A28345A--
