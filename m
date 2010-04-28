From: Doug Ledford <dledford@redhat.com>
Subject: Re: More Hot Unplug/Plug work
Date: Wed, 28 Apr 2010 17:05:58 -0400
Message-ID: <4BD8A336.7080309@redhat.com>
References: <4BD714A3.9020801@redhat.com> <905EDD02F158D948B186911EB64DB3D11C954788@irsmsx503.ger.corp.intel.com> <4BD874CB.5040803@redhat.com> <905EDD02F158D948B186911EB64DB3D11C95485F@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig20F18B557816BCE94C397384"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D11C95485F@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: Neil Brown <neilb@suse.de>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig20F18B557816BCE94C397384
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/28/2010 02:34 PM, Labun, Marcin wrote:
>>> Going further, thus causes that a new disk can be potentially grabbed=

>> by more than one container (because of shared path).
>>> For example:
>>> DOMAIN1: path=3Da path=3Db path=3Dc
>>> DOMAIN2: path=3Da path=3Dd
>>> DOMAIN3: path=3Dd path=3Dc
>>> In this example disks from path c can appear in DOMAIN 1 and DOMAIN
>> 3, but not in DOMAIN 2.
>>
>> What exactly is the use case for overlapping paths in different
>> domains?
>=20
> OK, makes sense.
> But if they are overlapped, will the config functions assign path are r=
equested by configuration file
> or treat it as misconfiguration?

For now it merely means that the first match found is the only one that
will ever get used.  I'm not entirely sure how feasible it is to detect
matching paths unless we are just talking about identical strings in the
path=3D statement.  But since the path=3D statement is passed to fnmatch(=
),
which treats it as a file glob, it would be possible to construct two
path statements that don't match but match the same set of files.  I
don't think we can reasonably detect this situation, so it may be that
the answer is "the first match found is used" and have that be the
official stance.

> So, do you plan to make changes similar to incremental in assembly to s=
erve DOMAIN?

I had not planned on it, no.  The reason being that assembly isn't used
for hotplug.  I guess I could see a use case for this though in that if
you called mdadm -As then maybe we should consult the DOMAIN entries to
see if there are free drives inside of a DOMAIN listed as spare or grow
and whether or not we have any degraded arrays while assembling that
could use the drives.  Dunno if we want to do that though.  However, I
think I would prefer to get the incremental side of things working
first, then go there.

> Should an array be split (not assembled) if a domain paths are dividing=
 array into two separate DOMAIN?

I don't think so.  Amongst other things, this would make it possible to
render a machine unbootable if you had a type in a domain path.  I think
I would prefer to allow established arrays to assemble regardless of
domain path entries.

>>  I'm happy to rework the code to support it if there's a valid use
>> case, but so far my design goal has been to have a path only appear in=

>> one domain, and to then perform the appropriate action based upon that=

>> domain.
> What is then the purpose of metadata keyword?

Mainly as a hint that a given domain uses a specific type of metadata.

> My initial plan was to create a default configuration for a specific me=
tadata, where user specifies actions=20
> but without paths letting metadata handler to use default ones.
> In your description, I can see that the path are required.

Yes.  We already have a default action for all paths: incremental.  This
is the same as how things work today without any new support.  And when
you combine incremental with the AUTO keyword in mdadm.conf, you can
control which devices are auto assembled on a metadata by metadata basis
without the use of DOMAINs.  The only purpose of a domain then is to
specify an action other than incremental for devices plugged into a
given domain.

>> add it to.  Only if there are no degraded arrays would we add it as a
>> spare to one of the arrays (non-deterministic which one).  If we add i=
t
>> as a spare to one of the arrays, then monitor mode can move that spare=

>> around as needed later based upon the spare-group settings.  Currently=
,
>> there is no correlation between spare-group and DOMAIN entries, but
>> that might change.
>=20
> A spare should go to any container controlled by mdmon, so any that con=
tains redundant volumes.

Yep.

>>
>>> So, in case of Monitor, sharing a spare device will be per path
>> basis.
>>
>> Currently, monitor mode still uses spare-group for controlling what
>> arrays can share spares.  It does not yet check any DOMAIN information=
=2E
>=20
> Yes, and I am now adding support for domains in monitor and for spare-g=
roups for external metadata.

Good to hear.

>>
>>> The same for new disks in hot-plug feature.
>>>
>>>
>>> In your repo domain_ent is a struct that contains domain paths.
>>> The function arrays_in_domain returns a list of mdstat entries that
>> are in the same domain as the constituent device name.
>>> (so it requires devname and domain as input parameter).
>>> In which case two containers will share the same DOMAIN?
>>
>> You get the list of containers, not just one.  See above about
>> searching the list for a degraded container and adding to it before a
>> healthy container.
> OK.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig20F18B557816BCE94C397384
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvYozYACgkQg6WylM+/8ZQMLQCfXF6CLoC0vfV2EQ9YS99+4QSm
Gi4AnjqhsvM+1e1B401/qhQWvzZ7fgxT
=ZNRR
-----END PGP SIGNATURE-----

--------------enig20F18B557816BCE94C397384--
