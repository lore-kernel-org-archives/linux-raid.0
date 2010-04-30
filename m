From: Doug Ledford <dledford@redhat.com>
Subject: Re: More Hot Unplug/Plug work
Date: Fri, 30 Apr 2010 12:26:05 -0400
Message-ID: <4BDB049D.3030604@redhat.com>
References: <4BD714A3.9020801@redhat.com> <r2ve9c3a7c21004291422q2144eaffsd16c8fe3c5ff8784@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig95578DF215E592F235589EE9"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <r2ve9c3a7c21004291422q2144eaffsd16c8fe3c5ff8784@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>, "Labun, Marcin" <Marcin.Labun@intel.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig95578DF215E592F235589EE9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/29/2010 05:22 PM, Dan Williams wrote:
> On Tue, Apr 27, 2010 at 9:45 AM, Doug Ledford <dledford@redhat.com> wro=
te:
>> So I pulled down Neil's git repo and started working from his hotunplu=
g
>> branch, which was his version of my hotunplug patch.  I had to do a
>> couple minor fixes to it to make it work.  I then simply continued on
>> from there.  I have a branch in my git repo that tracks his hotunplug
>> branch and is also called hotunplug.  That's where my current work is =
at.
>>
>> What I've done since then:
>>
>> 1) I've implemented a new config file line type: DOMAIN
>>   a) Each DOMAIN line must have at least one valid path=3D entry, but =
may
>>      have more than one path=3D entry.  path=3D entries are file globs=
 and
>>      must match something in /dev/disk/by-path
>>   b) Each DOMAIN line must have one and only one action=3D entry.  Val=
id
>>      action items are: ignore, incremental, spare, grow, partition.
>>      In addition, a word me be prefixed with force- to indicate that
>>      we should skip certain safety checks and use the device even if i=
t
>>      isn't clean.
>=20
> Just to clarify that we are on the same page with these actions:
> * incremental is the default action that "does the right thing" if the
> drive already has metadata.  I assume we need checks here to reject
> disks with ambiguous (multiple valid metadata records)
> * spare: implies incremental, but if it is a 'bare' device write a spar=
e record
> * grow: implies incremental but if it is a 'bare' device write a spare
> record, if there is a degraded array in the domain rebuild it
> otherwise grow an(y?) array in the domain
> * partition: if the device has a partition that matches the specified
> table then add the partitions incrementally

No, partition is an action, so a partition domain (which is limited to
being a whole disk device) causes us to write out a partition table on
the device.  This is only useful for native array types, not for imsm
arrays.

> A few comments:
> 1/ Does 'partition' need to be split to 'partition-spare' and
> 'partition-grow' to imply the action post partitioning?

No, because once you write the partition table out and cause the kernel
to reread the partition table, you will get separate incremental events
for the partitions themselves and they will match different domains (you
would have one domain line for the partition domain and as many domain
lines as you need for the actual partitions themselves).

> 2/ One of the safety checks for hot-inserting a spare is that it
> occurs on a port that was recently unplugged.  Should that be a
> default policy or do we need a different flavor spare action like
> 'spare-same-port'.

No, I canned this aspect.  The more I thought about it the more I
disliked it.  I suppose it could be added in for paranoia's sake, but
here's why I dropped it:

1) We don't know that the user will necessarily plug the new spare
device into the same port.  Maybe it was the port that went bad and not
the drive and they are using a new port as a result.
2) We specifically talked about this setup acting like a hardware raid
chassis and in that situation the hardware chassis grabs a new drive
regardless of whether it goes into the same slot as an old drive.
3) What happens if the technician removes the dead drive and then gets a
page they must answer before inserting the new drive and we time things
out.  Then the technician is left wondering why the drive didn't get
used like it should.
4) Maybe they have only one drive carrier and once they remove the old
drive they must unmount it from the carrier and mount the new drive to
the carrier before inserting the new drive and we time things out.
5) Maybe they are leaving the defunct drive in place and putting this
drive into an empty slot and want it to be used for rebuild regardless.

Really, the whole concept of a same-port action with a timeout is a nice
way to cover our ass and not much more.  But our asses are already
covered by the fact that we require a clean drive or the use of the
force- option on the action.  So I just didn't see much real benefit or
use for the same port stuff.

>>   c) Each DOMAIN line may have a metadata entry, and may have a
>>      spare-group entry.
>=20
> What is the purpose of the spare group?  I thought we were assuming
> that all DOMAIN members were automatically in the same spare group.
> Is this to augment the policy to allow spares to float between
> DOMAINs?  Something like the following where the different domains
> allow spares to cross boundaries?
> DOMAIN path=3DA spare-group=3DB action=3Dgrow
> DOMAIN path=3DB spare-group=3DA action=3Dspare

The above is possible, but also the use of different domains in the same
spare group with different priorities as outlined in a previous mail
would be useful too.

>>   d) For the partition action, a DOMAIN line must have a program=3D an=
d
>>      a table=3D entry.  Currently, the program=3D entry must be an ite=
m
>>      out of a list of known partition programs (I'm working on getting=

>>      sfdisk up and running, but for arches other than x86, other
>>      methods would be needed, and I'm planning on adding a method
>>      that allows us to call out to a user supplied script/program
>>      instead of a known internal method).  The table=3D entry points t=
o
>>      a file that contains a method specific table indicating the
>>      necessary partition layout.  As mentioned in previous mails, we
>>      only support identical partition tables at this point.  That
>>      may never change, who knows.
>>
>> 2) Created a new udev rules file that gets installed as
>> 05-md-early.rules.  This rule file, combined with our existing rules
>> file, is a key element to how this domain support works.  In particula=
r,
>> udev rules allow us to separate out devices that already have some sor=
t
>> of raid superblock from devices that don't.  We then add a new flag to=

>> our incremental mode to indicate that a device currently does not belo=
ng
>> to us, and we perform a series of checks to see if it should, and if s=
o,
>> we "grab" it (I would have preferred a better name, but the short
>> options for better names were already taken).  When called with the
>> "grab" flag, we follow a different code path where we check the domain=

>> of the device against our DOMAIN entries and if we have a match, we
>> perform the specified action.  There will need to be some additional
>> work to catch certain corner cases, such as the case where we have
>> force-partition and we insert a disk that currently has a raid
>> superblock on the bare drive.  We will currently miss that situation a=
nd
>> not grab the device.  So, this is a work in progress and not yet compl=
ete.
>>
>=20
> I notice this rules file grabs all events.  Did you see, or disagree,
> with the suggestion to have a mdadm --activate-domains command to
> generate udev rules for the paths we care about?

I saw it, and did it this way for the same list of reasons I listed
above in regards to same-port and timeouts.  In addition,
--activate-domains means that changes to the config file would not be
immediately active, and that would likely violate the principle of least
surprise.  However, I am actively working on trying to make the checks
we perform fast so that essentially the cost is a fork/exec of code most
likely already in page cache and if there is nothing to do we want to
exit quickly and with minimal touching of any physical media.
Considering that udev already touches the physical media to populate the
database for the device, our cost is incrementally negligible unless we
pass all of our simple checks and end up needing to go to media.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig95578DF215E592F235589EE9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvbBJ0ACgkQg6WylM+/8ZS+GgCfTXqK1gmnhlZTLEgpEmODHTUY
HpIAnRVhv4mJBtvXeZfhLiERGJRXJS3Q
=8kJE
-----END PGP SIGNATURE-----

--------------enig95578DF215E592F235589EE9--
