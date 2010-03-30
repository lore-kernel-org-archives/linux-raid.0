From: Doug Ledford <dledford@redhat.com>
Subject: Re: Auto Rebuild on hot-plug
Date: Tue, 30 Mar 2010 11:23:08 -0400
Message-ID: <4BB2175C.7070201@redhat.com>
References: <20100325113543.0e2124c5@notabene.brown>	 <905EDD02F158D948B186911EB64DB3D11C510278@irsmsx503.ger.corp.intel.com>	 <e9c3a7c21003261737k1e753b08xc6f8eb45d0320be9@mail.gmail.com>	 <4BB0ED13.6020507@redhat.com>	 <e9c3a7c21003291436lb898278i21f988fd5f76bd53@mail.gmail.com>	 <4BB13830.8070709@redhat.com> <e9c3a7c21003291746o49191295r876c7fef50fe63a5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEB9E72EC022B34A9583376F7"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c21003291746o49191295r876c7fef50fe63a5@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Labun, Marcin" <Marcin.Labun@intel.com>, Neil Brown <neilb@suse.de>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEB9E72EC022B34A9583376F7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/29/2010 08:46 PM, Dan Williams wrote:
> I think the disconnect in the imsm case is that the container to
> DOMAIN relationship is N:1, not 1:1.  The mdadm notion of an
> imsm-container correlates directly with a 'family' in the imsm
> metadata.  The rules of a family are:
>=20
> 1/ All family members must be a member of all defined volumes.  For
> example with a 4-drive container you could not simultaneously have a
> 4-drive (sd[abcd]) raid10 and a 2-drive (sd[ab]) raid1 volume because
> any volume would need to incorporate all 4 disks.  Also, per the rules
> if you create two raid1 volumes sd[ab] and sd[cd] those would show up
> as two containers.
>=20
> 2/ A spare drive does not belong to any particular family
> ('family_number' is undefined for a spare).  The Windows driver will
> automatically use a spare to fix any degraded family in the system.
> In the mdadm/mdmon case since we break families into containers we
> need a mechanism to migrate spare devices between containers because
> they are equally valid hot spare candidate for any imsm container in
> the system.

This explains the weird behavior I got when trying to create arrays on
my IMSM box via the BIOS.  Thanks for the clear explanation of family
delineation.

> This begs the question, why not change the definition of an imsm
> container to incorporate anything with imsm metadata?  This definitely
> would make spare management easier.  This was an early design decision
> and had the nice side effect that it lined up naturally with the
> failure and rebuild boundaries of a family.  I could give it more
> thought, but right now I believe there is a lot riding on this 1:1
> container-to-family relationship, and I would rather not go there.

I'm fine with the container being family based and not domain based.  I
just didn't realize that distinction existed.  It's all cleared up now ;-=
)

>> However, that just means (to me anyway) that I would treat all of the
>> sata ports as one domain with multiple container arrays in that domain=

>> just like we can have multiple native md arrays in a domain.  If a dis=
k
>> dies and we hot plug a new one, then mdadm would look for the degraded=

>> container present in the domain and add the spare to it.  It would the=
n
>> be up to mdmon to determine what logical volumes are currently degrade=
d
>> and slice up the new drive to work as spares for those degraded logica=
l
>> volumes.  Does this sound correct to you, and can mdmon do that alread=
y
>> or will this need to be added?
>=20
> This sounds correct, and no mdmon cannot do this today.  The current
> discussions we (Marcin and I) had with Neil offlist was extending
> mdadm --monitor to handle spare migration for containers since it
> already handles spare migration for native md arrays.  It will need
> some mdmon coordination since mdmon is the only agent that can
> disambiguate a spare from a stale device at any given point in time.

So we'll need to coordinate on this aspect of things then.  I'll keep
you updated as I get started implementing this if you want to think
about how you would like to handle this interaction between mdadm/mdmon.

As far as I can tell, we've reached a fairly decent consensus on things.
 But, just to be clear, I'll reiterate that concensus here:

Add a new linetype: DOMAIN with options path=3D (must be specified at
least once for any domain action other than none and incremental and
must be something other than a global match for any action other than
none and incremental) and metadata=3D (specifies the metadata type
possible for this domain as one of imsm/ddf/md, and where for imsm or
ddf types, we will verify that the path portions of the domain do not
violate possible platform limitations) and action=3D (where action is
none, incremental, readd, safe_use, force_use where action is specific
to a hotplug when a degraded array in the domain exists and can possibly
have slightly different meanings depending on whether the path specifies
a whole disk device or specific partitions on a range of devices, and
where there is the possibility of adding more options or a new option
name for the case of adding a hotplug drive to a domain where no arrays
are degraded, in which case issues such as boot sectors, partition
tables, hot spare versus grow, etc. must be addressed).

Modify udev rules files to cover the following scenarios (it's
unfortunate that we have to split things up like this, but in order to
deal with either bare drives or drives that have things like lvm data
and we are using force_use, we must trigger on *all* drive hotplug
events, we must trigger early, and we must override other subsystem's
possible hotplug actions, otherwise the force_use option will be a noop):=


1) plugging in a device that already has md raid metadata present
   a) if the device has metadata corresponding to one of our arrays,
attempt to do normal incremental add
   b) if the device has metadata corresponding to one of our arrays, and
the normal add failed and the options readd, safe_use, or force_use are
present in the mdadm.conf file, reattempt to add using readd
   c) if the device has metadata corresponding to one of our arrays, and
the readd failed, and the options safe_use or force_use are present,
then do a regular add of the device to the array (possibly with doing a
preemptive zero-superblock on the device we are adding).  This should
never fail.
   d) if the device has metadata that does not correspond to any array
in the system, and there is a degraded array, and the option force_use
is present, then quite possibly repartition the device to make the
partitions match the degraded devices, zero any superblocks, and add the
device to the arrays.  BIG FAT WARNING: the force_use option will cause
you to loose data if you plug in an array disk for another machine while
this machine has degraded arrays.

2) plugging in a device that doesn't already have md raid metadata
present but is part of an md domain
   a) if the device is bare and the option safe_use is present and we
have degraded arrays, partition the device (if needed) and then add
partitions to degraded arrays
   b) if the device is not bare, and the option force_use is present and
we have degraded arrays, (re)partition the device (if needed) and then
add partitions to degraded arrays.  BIG FAT WARNING: if you enable this
mode, and you hotplug say an LVM volume into your domain when you have a
degraded array, kiss your LVM volume goodbye.

Modify udev rules files to deal with device removal.  Specifically, we
need to watch for removal of devices that are part of raid arrays and if
they weren't failed when they were removed, fail them, and then remove
them from the array.  This is necessary for readd to work.  It also
releases our hold on the scsi device so it can be fully released and the
new device can be added back using the same device name.

Modify mdadm -I mode to read the mdadm.conf file for the DOMAIN lines on
hotplug events and then modify the -I behavior to suit the situation.
The majority of the hotplug changes mentioned above will actually be
implemented as part of mdadm -I, we will simply add a few rules to call
mdadm -I in a few new situations, then allow mdadm -I (which has
unlimited smarts, where as udev rules get very convoluted very quickly
if you try to make them smart) to actually make the decisions and do the
right thing.  This means that effectively, we might just end up calling
mdadm -I on every disk hot plug event whether there is md metadata or
not, but only doing special things when the various conditions above are
met.

Modify mdadm and the spare-group concept of ARRAY lines to coordinate
spare-group assignments and DOMAIN assignments.  We need to know what to
do in the event of a conflict between the two.  My guess is that this is
unlikely, but in the end, I think we need to phase out spare-group
entirely in favor of domain.  Since we can't have a conflict without
someone adding domain lines to the config file, I would suggest that the
domain assignments override spare-group assignments and we complain
about the conflict.  That way, even though the user obviously intended
something specific with spare-group, he also must have intended
something specific with domain assignments, and as the domain keyword is
the newest and latest thing, honor the latest wishes and warn about it
in case they misentered something.

Modify mdadm/mdmon to enable spare migration between imsm containers in
a domain.  Retain mdadm ability to move hot spares between native
arrays, but make it based on domain now instead of spare-group, and in
the config settings if someone has spare-group assignments and no domain
assignments, then create internal domain entries that mimic the
spare-group layout so that we can modify the core spare movement code to
only be concerned with domain entries.

I think that covers it.  Do we have a consensus on the general work?
Your thoughts Neil?

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigEB9E72EC022B34A9583376F7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuyF1wACgkQg6WylM+/8ZQd6gCffMTjrwiJ8M0xGZgv7/uEKtXs
vgUAn2MQwz3iFrXNsQQipdqmqKNHvqnq
=oN9K
-----END PGP SIGNATURE-----

--------------enigEB9E72EC022B34A9583376F7--
