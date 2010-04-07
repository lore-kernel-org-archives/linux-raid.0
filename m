From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch mdadm] Add hot-unplug support to mdadm
Date: Tue, 06 Apr 2010 22:24:21 -0400
Message-ID: <4BBBECD5.6010903@redhat.com>
References: <4BBA1289.4010705@redhat.com> <20100407113035.3ca437f2@notabene.brown> <4BBBE7D2.6090608@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB2B184E3969FFB66DF0E1EF5"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BBBE7D2.6090608@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB2B184E3969FFB66DF0E1EF5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/06/2010 10:02 PM, Doug Ledford wrote:
> On 04/06/2010 09:30 PM, Neil Brown wrote:
>> On Mon, 05 Apr 2010 12:40:41 -0400
>> Doug Ledford <dledford@redhat.com> wrote:
>>   would it help do you think to support e.g.
>>
>>     mdadm -If --devnum $major:$minor $name
>=20
> As I recall, on a remove event the major minor is already gone too (but=

> I could be wrong, the machine has since been blown away and reinstalled=

> and the file I had the whole env during a remove event stored off in is=

> gone with it).
>=20
> And I would be careful about using $env{DEVNAME}, in fact I'm removing
> usage of it in my local rules files right now because I've found it is
> inconsistent (part of the time it includes /dev/ and part of the time i=
t
> doesn't, where as $tempnode is consistent).

OK, so to expand on this a bit further.  $env{DEVNAME} sometimes refers
to devices via a full path (aka, /dev/sda1), and sometimes by just the
last part of the path (aka, md0).  I found this when creating a rule to
do incremental assembly on containers during late udev startup (I need
this because the initramfs created by dracut *only* starts necessary
arrays, and if you have a additional arrays in a container, then the
change event generated during udev startup can be used to trigger
incremental assembly of those additional arrays, but $env{DEVNAME} will
just be md0 or whatever, not a full path name).  So, I switched
everything to $tempnode as it always points to a device special file.
Except when doing removal events, in which case $tempnode doesn't exist
because there is no node to point to.  So, long story short, you're best
off to use $tempnode on any device add|change events, and $env{DEVNAME}
on remove events.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigB2B184E3969FFB66DF0E1EF5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku77NUACgkQg6WylM+/8ZSxBACcDmR2pvasTM2gsfMNas37uLfW
Dv0AnA+NEGdkZW2ZyGA8zJeTtk79prk3
=oNfV
-----END PGP SIGNATURE-----

--------------enigB2B184E3969FFB66DF0E1EF5--
