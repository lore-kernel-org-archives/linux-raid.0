From: Doug Ledford <dledford@redhat.com>
Subject: Re: More Hot Unplug/Plug work
Date: Fri, 30 Apr 2010 12:13:59 -0400
Message-ID: <4BDB01C7.2000308@redhat.com>
References: <4BD714A3.9020801@redhat.com>	<905EDD02F158D948B186911EB64DB3D11C954788@irsmsx503.ger.corp.intel.com>	<4BD874CB.5040803@redhat.com>	<905EDD02F158D948B186911EB64DB3D11C95485F@irsmsx503.ger.corp.intel.com>	<4BD8A336.7080309@redhat.com>	<20100429110153.7148bb9b@notabene.brown>	<4BD8DEB1.40801@intel.com> <20100429123717.2144a341@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig62925A70BABA91E82846815C"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100429123717.2144a341@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig62925A70BABA91E82846815C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/28/2010 10:37 PM, Neil Brown wrote:
> On Wed, 28 Apr 2010 18:19:45 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>=20
>> Neil Brown wrote:
>>> I'm not sure how this fits with imposing platform constraints.
>>> As platform constraints are closely tied to metadata types, it might =
be OK
>>> to have a metadata-specific tags (imsm=3D???) and leave to details to=
 the
>>> metadata handler???
>>>
>>> Dan: help me understand these platform constraints: what is the most =
complex
>>>   constraint that you can think of that you might want to impose?
>>
>> At this point we really only need one constraint: prevent controller=20
>> spanning.  If for example I take an existing imsm member off of ahci a=
nd=20
>> reattach it via a usb-to-sata enclosure mdadm needs a policy to preven=
t=20
>> associating that drive with anything on ahci.
>>
>> In a pinch this policy can be disabled, but you wouldn't want to rebui=
ld=20
>> across usb or any other controller because the option-rom only talks=20
>> ahci and will mark the drive missing.
>>
>> So something like DOMAIN spanning=3Dimsm, to tell mdadm to follow imsm=
=20
>> rules for this domain.  Where 'spanning' is policy tag??
>>
>=20
> Thanks.
>=20
> So we have two different ideas here.
>=20
> 1/ A given set of devices (paths) are all attached to the one controlle=
r.
> 2/ A given array is not allowed to span controllers
>=20
> The first statement is somewhat similar to a statement about sparegroup=
s.
> It groups devices together is some way.
>=20
> The second is a policy statement, and is metadata specific to some exte=
nt.
> If I create a native-metadata array using the controller, then adding o=
ther
> devices from a different controller is a non-issue.  It is only when an=

> IMSM array is created that it is an issue (and then - only if the array=
 is to
> be used for boot for for multi-boot).
>=20
> So the ARRAY line could have "exclusive-group=3Dfoo" where 'foo' is a g=
roup
> name similar to those used for 'spare-group=3D'
> But that isn't much fun for auto-detect and auto-assembly.
>=20
> Maybe we want to extend the 'auto' line.  It gives policy on a per-meta=
data
> basis. Maybe:
>=20
>   POLICY auto-assemble  +1.x -all
>   POLICY same-group  imsm
>=20
> where 'same-group' means that all the devices in an array must be in th=
e
> same spare-group.  The 'domain' lines assign spare-groups to devices.
>=20
> Maybe "same-group" could be "same-$tag" so we could have different tags=

> for different metadatas....
>=20
> Is this working for anyone else, or have I lost the plot??
>=20
> NeilBrown

I keep going back to the idea of just implement the no-spanning policy
for imsm/ddf as the default with a force-override flag and don't bother
putting it into the config anywhere, it simply is.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig62925A70BABA91E82846815C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvbAccACgkQg6WylM+/8ZTUJACgtkJfh3niTapHIXnz7ySA+NuN
KXQAnjaMrs3Uji/9aO5UHHR3/c0jOlSb
=zskW
-----END PGP SIGNATURE-----

--------------enig62925A70BABA91E82846815C--
