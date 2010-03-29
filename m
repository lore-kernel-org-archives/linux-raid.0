From: Doug Ledford <dledford@redhat.com>
Subject: Re: Auto Rebuild on hot-plug
Date: Mon, 29 Mar 2010 14:10:27 -0400
Message-ID: <4BB0ED13.6020507@redhat.com>
References: <20100325113543.0e2124c5@notabene.brown>	 <905EDD02F158D948B186911EB64DB3D11C510278@irsmsx503.ger.corp.intel.com> <e9c3a7c21003261737k1e753b08xc6f8eb45d0320be9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3EE4F419B2F4B0CC90DEB798"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c21003261737k1e753b08xc6f8eb45d0320be9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Labun, Marcin" <Marcin.Labun@intel.com>, Neil Brown <neilb@suse.de>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3EE4F419B2F4B0CC90DEB798
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/26/2010 08:37 PM, Dan Williams wrote:
> On Thu, Mar 25, 2010 at 8:04 AM, Labun, Marcin <Marcin.Labun@intel.com>=
 wrote:
>> I think that metadata keyword can be used to identify scope of devices=
 to which the DOMAIN line applies.
>> For instance we could have:
>> DOMAIN path=3Dglob-pattern metadata=3Dimsm hotplug=3Dmode1  spare-grou=
p=3Dname1
>> DOMAIN path=3Dglob-pattern metadata=3D0.90 hotplug=3Dmode2  spare-grou=
p=3Dname2
>>
>> Keywords:
>> Path, metadata and spare-group shall define to which arrays the hotplu=
g definition (or other definition of action) applies. User could define a=
ny subset of it.
>> For instance to define that all imsm arrays shall use hotplug mode2 us=
er shall define:
>> DOMAIN metadata=3Dimsm hotplug=3Dmode2
>>
>> In above example user need not define spare-group in his/her configura=
tion file for each array.
>>
>> I also assume that each metadata handler can additionally sets its own=
 rules of accepting the spare in the container. Rules can be derived from=
 platform dependencies or metadata. Notice that user can disable platform=
 specific constrains by defining IMSM_NO_PLATFORM environment variable.
>>
>=20
> For the 'platform' case we could automate some decisions, but I think
> I would rather extend the --detail-platform option to dump the
> recommended/compatible DOMAIN entries for the platform, perhaps via
> the --brief modifier.  This mirrors what can be done with --examine
> --brief to generate an initial configuration file that can be modified
> to taste.

So, a few things that I think can be said about the DOMAIN line type
(I'm assuming for now that this is what we'll use, mainly because I'm
implementing it right now):

There is an assumed, default DOMAIN line that is the equivalent of:

DOMAIN path=3D* metadata=3D* action=3Dincremental spare-group=3D<none>

This is what you get simply by normal udev incremental assembly rules
(notice I used action instead of hotplug, action makes more sense to me
as all the words we use to define hotplug mode are in fact actions to
take on hotplug).  We will treat this as a given.  Anything else
requires an explicit DOMAIN line in mdadm.conf.

The second thing I'm having a hard time with is the spare-group.  To be
honest, if I follow what I think I should, and make it a hard
requirement that any action other than none and incremental must use a
non-global path glob (aka, path=3D MUST be present and can not be *), the=
n
spare-group looses all meaning.  I say this because if a disk matches
the path glob is it in a specific spare group already (the one that this
DOMAIN represents) and ditto if arrays are on disks in this DOMAIN, then
they are automatically part of the same spare-group.  In other words, I
think spare-group becomes entirely redundant once we have a DOMAIN keywor=
d.

I'm also having a hard time justifying the existence of the metadata
keyword.  The reason is that the metadata is already determined for us
by the path glob.  Specifically, if we assume that an array's members
can not cross domain boundaries (a reasonable requirement in my opinion,
we can't make an array where we can guarantee to the user that hot
plugging a replacement disk will do what they expect if some of the
array's members are inside the domain and some are outside the domain),
then we should only ever need the metadata keyword if we are mixing
metadata types within this domain.  Well, we can always narrow down the
domain if we are doing something like the first three sata disks on an
Intel Matrix RAID controller as imsm and the last three as jbod with
version 1.x metadata by putting the first half in one domain and the
second half in another.  And this would be the right thing to do versus
trying to cover both in one domain.  That means that only if we ever
mixed imsm/ddf and md native raid types on a single disk would we be
unable to narrow down the domain properly, and I'm not sure we care to
support this.  So, that leaves us back to not really needing the
metadata keyword as the disks present in the path spec glob should be
uniform in the metadata type and we should be able to simply use the
right metadata from that.

>>>   hotplug modes are:
>>>     none  - ignore any hotplugged device
>>>     incr  - normal incremental assembly (the default).  If the device=
 has
>>>          metadata that matches an array, try to add it to the array
>>>     replace - If above fails and a device was recently removed from t=
his
>>>          same path, add this device to the same array(s) that the old=

>>> devices
>>>          was part of
>>>     include - If the above fails and the device has not recognisable
>>> metadata
>>>          add it to any array/container that uses devices in this doma=
in,
>>>          partitioning first if necessary.
>>>     force - as above but ignore any pre-existing metadata
>>>
>>>
>>>   I'm not sure that all those are needed, or are the best names.  Nam=
es
>>> like
>>>     ignore, reattach, rebuild, rebuild_spare
>>>   have also been suggested.
>>
>> Please consider:
>>      spare_add - add any spare device that matches the metadata contai=
ner/volume in case of native metadata regardless of array state, so later=
 such a spare can be used in rebuild process.
>=20
> This is the same as 'incr' above.  If the device has metadata and
> hotplug is enabled, auto-incorporate the device.

So my preferred and suggest words for the action item are as follows
(Note: there are two classes of actions, things we do when presented
with a disk and we have a degraded array, and things we do when
presented with a disk and all arrays in domain are fully up to date,
which implies this is a new disk in the domain and not replacing a
faulty disk in the domain, which implies the domain wasn't previously
full up...it might be worth having two keywords in the DOMAIN line to
separate these two items, but I'm going to argue a bit later that we
really don't care about the second option and so maybe not):

none
incremental - what we have now, and the default
readd - if incremental didn't work but the device is supposed to be part
of the array, then attempt the --re-add option of mdadm, this would
allow a sysadmin to unplug and replug a device from an array if it got
kicked for some reason and the system would attempt to reinsert it into
the array with minimal rebuild, but it would not attempt to use any
device that was hot plugged that didn't previously belong to the array
safe_use - if the new drive is currently bare and we have a degraded
array, assume this drive is intended to repair the degraded array and
use the device
force_use - as above but don't require the drive be empty

All of the above actions are related to domains that are degraded.  But
what to do if the array isn't degraded?  We could add the device as a
spare, but if the array isn't degraded, adding a new hot spare doesn't
really *do* anything.  No rebuild will start, nothing immediate happens,
it just goes in and sits there.  And now that we have all these fancy
grow options, it's not entirely clear that a user would want that
anyway.  So, I would argue that if the array isn't degraded, then there
is no sense of emergency in our actions, and there exists multiple
options for what to do with the device, some include being a hot spare
while others include using the device to grow the array, and the
possibilities and answers to what to do here are not at all clear.  Even
if the user had previously configured us to treat the device as a spare,
they may change their mind and want to grow things.  Given that there's
no immediate need to do anything as there aren't any degraded arrays, I
say let the user do whatever they want and don't try to do anything
automatically as it seems likely to me that the user's wants in this
area are likely to change from time to time based on circumstances and
having them update the config file prior to inserting the device is more
klunky than just telling them to do whatever they want themselves after
inserting the device.


>> Can we assume for all external metadata that spares added any containe=
r can be potentially moved between all container the same metadata?
>=20
> Yes, that can be the default action, and the spare-group keyword can
> be specified to override.

Or as I mentioned earlier, two domains with different path globs gets
you this without having to use the spare-group keyword.  For instead,
you can put the sata ports on one domain path and the sas ports on
another domain path as the bios won't allow containers to cross that
boundary and that is sufficient to make us handle hot plugged drives
properly when both are in use.  I really don't see the use of the
spare-group keyword, the path glob should be sufficient.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig3EE4F419B2F4B0CC90DEB798
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuw7RMACgkQg6WylM+/8ZTVqACfZkd8RERxq1ARUQnlwEV2UFiG
Ed0AoK+nNapOtyB3No4fUGcZAIIZ2vCv
=4k5T
-----END PGP SIGNATURE-----

--------------enig3EE4F419B2F4B0CC90DEB798--
