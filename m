From: Doug Ledford <dledford@redhat.com>
Subject: Re: Auto Rebuild on hot-plug
Date: Mon, 29 Mar 2010 19:30:56 -0400
Message-ID: <4BB13830.8070709@redhat.com>
References: <20100325113543.0e2124c5@notabene.brown>	 <905EDD02F158D948B186911EB64DB3D11C510278@irsmsx503.ger.corp.intel.com>	 <e9c3a7c21003261737k1e753b08xc6f8eb45d0320be9@mail.gmail.com>	 <4BB0ED13.6020507@redhat.com> <e9c3a7c21003291436lb898278i21f988fd5f76bd53@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3A9CC43A12F99755DA83F588"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c21003291436lb898278i21f988fd5f76bd53@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Labun, Marcin" <Marcin.Labun@intel.com>, Neil Brown <neilb@suse.de>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3A9CC43A12F99755DA83F588
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/29/2010 05:36 PM, Dan Williams wrote:
> On Mon, Mar 29, 2010 at 11:10 AM, Doug Ledford <dledford@redhat.com> wr=
ote:
>> The second thing I'm having a hard time with is the spare-group.  To b=
e
>> honest, if I follow what I think I should, and make it a hard
>> requirement that any action other than none and incremental must use a=

>> non-global path glob (aka, path=3D MUST be present and can not be *), =
then
>> spare-group looses all meaning.  I say this because if a disk matches
>> the path glob is it in a specific spare group already (the one that th=
is
>> DOMAIN represents) and ditto if arrays are on disks in this DOMAIN, th=
en
>> they are automatically part of the same spare-group.  In other words, =
I
>> think spare-group becomes entirely redundant once we have a DOMAIN key=
word.
>=20
> I agree once you have a DOMAIN you implicitly have a spare-group.  So
> DOMAIN would supersede the existing spare-group identifier in the
> ARRAY line and cause mdadm --monitor to auto-migrate spares between
> 0.90 and 1.x metadata arrays in the same DOMAIN.  For the imsm case
> the expectation is that spares migrate between containers regardless
> of the DOMAIN line as that is what the implementation expects.

Give me some clearer explanation here because I think you and I are
using terms differently and so I want to make sure I have things right.
 My understanding of imsm raid containers is that all the drives that
belong to a single option rom, as long as they aren't listed as jbod in
the option rom setup, belong to the same container.  That container is
then split up into various chunks and that's where you get logical
volumes.  I know there are odd rules for logical volumes inside a
container, but I think those are mostly irrelevant to this discussion.
So, when I think of a domain for imsm, I think of all the sata ports or
sas ports under a single option rom.  From that perspective, spares can
*not* move between domains as a spare on a sas port can't be added to a
sata option rom container array.  I was under the impression that if you
had, say, a 6 port sata controller option rom, you couldn't have the
first three ports be one container and the next three ports be another
container.  Is that impression wrong?  If so, that would explain our
confusion over domains.

However, that just means (to me anyway) that I would treat all of the
sata ports as one domain with multiple container arrays in that domain
just like we can have multiple native md arrays in a domain.  If a disk
dies and we hot plug a new one, then mdadm would look for the degraded
container present in the domain and add the spare to it.  It would then
be up to mdmon to determine what logical volumes are currently degraded
and slice up the new drive to work as spares for those degraded logical
volumes.  Does this sound correct to you, and can mdmon do that already
or will this need to be added?

> However this is where we get into questions of DOMAIN conflicting with
> 'platform' expectations, under what conditions, if any, should DOMAIN
> be allowed to conflict/override the platform constraint?  Currently
> there is an environment variable IMSM_NO_PLATFORM, do we also need a
> configuration op

I'm not sure I would ever allow breaking valid platform limitations.  I
think if you want to break platform limitations, then you need to use
native md raid arrays and not imsm/ddf.  It seems to me that if you
allow the creation of an imsm/ddf array that the BIOS can't work with
then you've potentially opened an entire can of worms we don't want to
open about expectations that the BIOS will be able to work with things
but can't.  If you force native arrays as the only type that can break
platform limitations, then you are at least perfectly clear with the
user that the BIOS can't do what the user wants.

>> I'm also having a hard time justifying the existence of the metadata
>> keyword.  The reason is that the metadata is already determined for us=

>> by the path glob.  Specifically, if we assume that an array's members
>> can not cross domain boundaries (a reasonable requirement in my opinio=
n,
>> we can't make an array where we can guarantee to the user that hot
>> plugging a replacement disk will do what they expect if some of the
>> array's members are inside the domain and some are outside the domain)=
,
>> then we should only ever need the metadata keyword if we are mixing
>> metadata types within this domain.  Well, we can always narrow down th=
e
>> domain if we are doing something like the first three sata disks on an=

>> Intel Matrix RAID controller as imsm and the last three as jbod with
>> version 1.x metadata by putting the first half in one domain and the
>> second half in another.  And this would be the right thing to do versu=
s
>> trying to cover both in one domain.  That means that only if we ever
>> mixed imsm/ddf and md native raid types on a single disk would we be
>> unable to narrow down the domain properly, and I'm not sure we care to=

>> support this.  So, that leaves us back to not really needing the
>> metadata keyword as the disks present in the path spec glob should be
>> uniform in the metadata type and we should be able to simply use the
>> right metadata from that.
>=20
> ...but this assumes we already have an array assembled in the domain
> before the first hot plug event.  The 'metadata' keyword would be
> helpful at assembly time for ensuring only arrays of a certain type
> are brought up in the domain.

OK, I can see this.  Especially if someone if not using ARRAY lines and
instead has enabled the AUTO keyword to just auto assemble arrays.  If
we had a hard requirement that all arrays are listed in the file then we
could deduce the metadata of a domain from the arrays present in it, but
we don't.

> We also need some consideration for reporting and enforcing 'platform'
> boundaries if the user requests it.  By default mdadm will block
> attempts to create/assemble configurations that the option-rom does
> not support (i.e. disk attached to third-party controller).  For the
> hotplug case if the  DOMAIN is configured incorrectly I can see cases
> where a user would like to specify "enforce platform constraints even
> if my domain says otherwise", and the inverse "yes, I know the
> option-rom does not support this configuration, but I know what I am
> doing".

I can think of a perfect example of when I would want to break platform
rules here.  I have a machine that's imsm capable with motherboard sata
ports, but if a drive went out I wouldn't want to open up the case, put
a new drive in, and cable it all up with the machine live.  On the other
hand, that same machine has an external 4 drive hot plug chassis
attached and I could put a drive into it, add it to the imsm array, and
have everything rebuild before ever shutting the machine down.  But, the
expectation here is that things wouldn't work unless I moved that drive
out of the external chassis and into the machine proper before
rebooting, otherwise the BIOS will consider the array degraded.  So
while this is a perfectly valid scenario, I don't think it's one that we
should be catering to in any automated actions.  Quite simply, I think
our support for automated actions should be limited to what we *know* is
right, and that we'll get right, and not try to be esoteric lest we end
up screwing the pooch so to speak.  At least not for initial
implementations.

> So I see a couple options:
> 1/ path=3Dplatform: auto-determine/enforce the domain(s) for all
> platform raid controllers in the system

I think for imsm/ddf metadata, this should be automatic.

> 2/ Allow the user to manually enter a DOMAIN that is compatible but
> different than the default platform constraints like your 3-ahci ports
> for imsm-RAID remainder reserved for 1.x arrays example above

I agree.  More restrictive than platform is OK.

> 3/ Allow the user to turn off platform constraints and define 'exotic'
> domains (mixed controller configurations).

Only for native metadata formats IMO.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig3A9CC43A12F99755DA83F588
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuxODAACgkQg6WylM+/8ZRYyQCbBaKzanJ0qDYgAbfHKaV0ZUjo
N4oAnAzjGsR7kMCCPjiWMCxtXwmcONlS
=VN69
-----END PGP SIGNATURE-----

--------------enig3A9CC43A12F99755DA83F588--
