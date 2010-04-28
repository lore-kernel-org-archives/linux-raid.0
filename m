From: Doug Ledford <dledford@redhat.com>
Subject: Re: More Hot Unplug/Plug work
Date: Wed, 28 Apr 2010 13:47:55 -0400
Message-ID: <4BD874CB.5040803@redhat.com>
References: <4BD714A3.9020801@redhat.com> <905EDD02F158D948B186911EB64DB3D11C954788@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCEA147EEFFBEA0151C77A868"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D11C954788@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: Neil Brown <neilb@suse.de>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCEA147EEFFBEA0151C77A868
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/28/2010 12:08 PM, Labun, Marcin wrote:
>=20
>=20
>> -----Original Message-----
>> From: Doug Ledford [mailto:dledford@redhat.com]
>> Sent: Tuesday, April 27, 2010 6:45 PM
>> To: Linux RAID Mailing List; Neil Brown; Labun, Marcin; Williams, Dan =
J
>> Subject: More Hot Unplug/Plug work
>>
>> So I pulled down Neil's git repo and started working from his hotunplu=
g
>> branch, which was his version of my hotunplug patch.  I had to do a
>> couple minor fixes to it to make it work.  I then simply continued on
>> from there.  I have a branch in my git repo that tracks his hotunplug
>> branch and is also called hotunplug.  That's where my current work is
>> at.
>>
>> What I've done since then:
>>
>> 1) I've implemented a new config file line type: DOMAIN
>>    a) Each DOMAIN line must have at least one valid path=3D entry, but=

>> may
>>       have more than one path=3D entry.  path=3D entries are file glob=
s and
>>       must match something in /dev/disk/by-path
>=20
> DOMAIN is defined per container or raid volume for native metadata.

No, a DOMAIN can encompass more than a single volume, array, or container=
=2E

> Each DOMAIN can have more than one path, so actually list of path defin=
e if a given disk belongs to domain or not.=20

Correct.

> Do you plan to allow for the same path to be assigned to different cont=
ainers (so path is shared between domains)?

I had planned that a single DOMAIN can encompass multiple containers.
So I didn't planned on it a single path being in multiple DOMAINs, but I
did plan that a single domain could allow a device to be placed in
multiple different containers based upon need.  I don't have checks in
place to make sure the same path isn't listed in more than one domain,
although that would be a next step.

> If so the domains will have some or all paths overlapped, and some cont=
ainers will share some paths.
> Going further, thus causes that a new disk can be potentially grabbed b=
y more than one container (because of shared path).
> For example:
> DOMAIN1: path=3Da path=3Db path=3Dc
> DOMAIN2: path=3Da path=3Dd
> DOMAIN3: path=3Dd path=3Dc
> In this example disks from path c can appear in DOMAIN 1 and DOMAIN 3, =
but not in DOMAIN 2.

What exactly is the use case for overlapping paths in different domains?
 I'm happy to rework the code to support it if there's a valid use case,
but so far my design goal has been to have a path only appear in one
domain, and to then perform the appropriate action based upon that
domain.  So if more than one container array was present in a single
DOMAIN entry (lets assume that the domain entry path encompassed all 6
sata ports on a motherboard and therefore covered the entire platform
capability of the imsm motherboard bios), then we would add the new
drive as a spare to one of the imsm arrays.  It's not currently
deterministic which one we would add it to, but that would change as the
code matures and we would search for a degraded array that we could add
it to.  Only if there are no degraded arrays would we add it as a spare
to one of the arrays (non-deterministic which one).  If we add it as a
spare to one of the arrays, then monitor mode can move that spare around
as needed later based upon the spare-group settings.  Currently, there
is no correlation between spare-group and DOMAIN entries, but that might
change.

> So, in case of Monitor, sharing a spare device will be per path basis.

Currently, monitor mode still uses spare-group for controlling what
arrays can share spares.  It does not yet check any DOMAIN information.

> The same for new disks in hot-plug feature.
>=20
>=20
> In your repo domain_ent is a struct that contains domain paths.
> The function arrays_in_domain returns a list of mdstat entries that are=
 in the same domain as the constituent device name.
> (so it requires devname and domain as input parameter).
> In which case two containers will share the same DOMAIN?

You get the list of containers, not just one.  See above about searching
the list for a degraded container and adding to it before a healthy
container.

> It seems that this function shall return a list of mdstat entries that =
share a path to which a devname device belongs.
> So, a given new device is tried to be grabbed by a list of a containers=
 (or native volumes).

Yes.  There can be more than one array/container that this device might
go to.

> Can you send a config file example?

The first two entries are good, the third is a known bad line that I
just leave in there to make sure I don't partition the wrong thing.

DOMAIN path=3Dpci-0000:00:1f.2-scsi-[2345]:0:0:0 action=3Dpartition
	table=3D/etc/mdadm.table program=3Dsfdisk
DOMAIN path=3Dpci-0000:00:1f.2-scsi-[2345]:0:0:0-part? action=3Dspare
DOMAIN path=3Dpci-0000:00:1f.2-scsi-[2345]:0:0:0*
	path=3Dpci-0000:00:1f.2-scsi-[2345]:0:0:0-part* action=3Dpartition


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigCEA147EEFFBEA0151C77A868
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvYdMsACgkQg6WylM+/8ZTYTQCeK2v0PqMS4qhT9rO/i0/U8j7O
jyYAnA+MmtAYzB1rTfRUTwzowKhDb/23
=jOaO
-----END PGP SIGNATURE-----

--------------enigCEA147EEFFBEA0151C77A868--
