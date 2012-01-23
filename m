From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v2 0/4] add --preboot argument to mdadm/mdmon
Date: Mon, 23 Jan 2012 11:24:25 -0500
Message-ID: <4F1D89B9.9080802@redhat.com>
References: <1327317505-14782-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC8113CD05C241BFCFB67149E"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1327317505-14782-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: neilb@suse.de, linux-raid@vger.kernel.org, kay@redhat.com, harald@redhat.com, lpoetter@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC8113CD05C241BFCFB67149E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/23/2012 06:18 AM, Jes.Sorensen@redhat.com wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> Hi,
>=20
> Here is v2 of the systemd/dracut fixes for preboot handling in
> mdadm/mdmon. I have changed the argument over from --initrd to
> --preboot as Neil suggested, as well as fixed up the minor code nits
> and added documentation to the man pages.
>=20
> It shows up that I didn't need to add a separate enum for the command
> line arguments in mdmon since mdadm.h gets pulled in so we can reuse
> those. If we find that to be an issue, we can always create a separate
> one later.

I'm not sure I like --preboot.  I understand the difficulty in finding
just the right option name, but to me, preboot sounds like an option you
would use if you are doing pre-processing of something for a later
invokation to use.  And that isn't the case here, so the gut level
understanding won't match up with the man page/help output understanding
and I try to avoid that as much as possible.  Since the distinct element
is that we want to keep running both before and after the normal root
filesystem is mounted and we want all files we open to be off of the
root filesystem namespace, maybe --offroot (which is odd enough by
itself to forestall any gut reactions and prompt a trip to the help/man
pages as opposed to guessing what the option means)?

> Cheers,
> Jes
>=20
> Jes Sorensen (4):
>   mdmon: Use getopt_long() to parse command line options
>   Add --preboot argument to mdadm
>   Add --preboot argument to mdmon
>   Spawn mdmon with --preboot if mdadm was launched with --preboot
>=20
>  ReadMe.c   |    5 +++++
>  mdadm.8.in |   12 ++++++++++++
>  mdadm.c    |   10 ++++++++++
>  mdadm.h    |    3 +++
>  mdmon.8    |   12 +++++++++++-
>  mdmon.c    |   60 +++++++++++++++++++++++++++++++++++++++++++++++++---=
--------
>  util.c     |   17 +++++++++++++----
>  7 files changed, 103 insertions(+), 16 deletions(-)
>=20


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford



--------------enigC8113CD05C241BFCFB67149E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPHYm5AAoJELgmozMOVy/dfCYP/0OrPY3XFGZk6TMO8hIpu9oe
p6cZdxPrZdgBYLmUb/mmI9kQaLIYt9k20Z1GB9UcPB4HtJWmBYBz4gSl57R0wxZ6
wG6nMCguFPO/VgJP4kgLeuTx8FCNZ5gdj+POk34q0weBEX4VdxomjdeLMHGI2PNU
GqKDQp1MqkGsOwZScaOyNuGVBJ3o8dR6/1Q4dSdVga45HTNHEMb6hn5UMEeCKMrx
50tMDf7ZLSl9DWVHoGGE7PTtizNcML/nxy+7mUJV0fLwRWgBNzhkSPo4+r0DJx3k
FkR/rLRrjUrZIf59U3JtvGwc2EaKeMCzuzzFEfFRgMCLfV1e95x6tmnddYHgGKLz
RixtZOHk5Qd4c+uaG6tqWGrtgsI7Iw/uuWfemf3NOh6Pyu28071Kiz5DMMuH5ObN
6eJH01t2Z+x73fXrasV3qUpSMyNRPWeE15yCYONx8WQTE6qaruOkZ+stbrx/YiJ/
Yrg3vZzRCVjvoBFXRtA0YAka6v8hBnV1IfASrJPHnbh37Jjrp94qqxzxESPqQsdi
dIMd1YZsDrFfsXm0mrOlO2oljJ6PG/97DYEXihH+ABrk5Mo7kRoyQ5sJPKpIMna/
3dNO6uQikwJ5leGoe3FWJE5O9e89Z6bfEEmauOFz1XmYIepvAApzokj0+OO1pcM2
dCTf/6gkrVUHzdEwstnm
=iVN+
-----END PGP SIGNATURE-----

--------------enigC8113CD05C241BFCFB67149E--
