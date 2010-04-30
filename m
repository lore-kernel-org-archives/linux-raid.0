From: Doug Ledford <dledford@redhat.com>
Subject: Re: More Hot Unplug/Plug work
Date: Fri, 30 Apr 2010 11:52:46 -0400
Message-ID: <4BDAFCCE.1060708@redhat.com>
References: <4BD714A3.9020801@redhat.com>	<905EDD02F158D948B186911EB64DB3D11C954788@irsmsx503.ger.corp.intel.com>	<4BD874CB.5040803@redhat.com>	<905EDD02F158D948B186911EB64DB3D11C95485F@irsmsx503.ger.corp.intel.com>	<4BD8A336.7080309@redhat.com> <20100429110153.7148bb9b@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE3C165E6E7513208322A5A0C"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100429110153.7148bb9b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Labun, Marcin" <Marcin.Labun@intel.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE3C165E6E7513208322A5A0C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/28/2010 09:01 PM, Neil Brown wrote:
> On Wed, 28 Apr 2010 17:05:58 -0400
> Doug Ledford <dledford@redhat.com> wrote:
>=20
>> On 04/28/2010 02:34 PM, Labun, Marcin wrote:
>>>>> Going further, thus causes that a new disk can be potentially grabb=
ed
>>>> by more than one container (because of shared path).
>>>>> For example:
>>>>> DOMAIN1: path=3Da path=3Db path=3Dc
>>>>> DOMAIN2: path=3Da path=3Dd
>>>>> DOMAIN3: path=3Dd path=3Dc
>>>>> In this example disks from path c can appear in DOMAIN 1 and DOMAIN=

>>>> 3, but not in DOMAIN 2.
>>>>
>>>> What exactly is the use case for overlapping paths in different
>>>> domains?
>>>
>>> OK, makes sense.
>>> But if they are overlapped, will the config functions assign path are=
 requested by configuration file
>>> or treat it as misconfiguration?
>>
>> For now it merely means that the first match found is the only one tha=
t
>> will ever get used.  I'm not entirely sure how feasible it is to detec=
t
>> matching paths unless we are just talking about identical strings in t=
he
>> path=3D statement.  But since the path=3D statement is passed to fnmat=
ch(),
>> which treats it as a file glob, it would be possible to construct two
>> path statements that don't match but match the same set of files.  I
>> don't think we can reasonably detect this situation, so it may be that=

>> the answer is "the first match found is used" and have that be the
>> official stance.
>=20
> I think we do need an "official stance" here.
> glob is good for lots of things, but it is hard to say "everything exce=
pt".
> The best way to do that is to have a clear ordering with more general g=
lobs
> later in the order.
>    path=3Dabcd  action=3Dfoo
>    path=3Dabc*  action=3Dbar
>    path=3D*     action=3Dbaz
>=20
> So the last line doesn't really mean "do baz on everything" but rather
> "do baz on everything else".
>=20
> You could impose ordering explicitly with a priority number or a
> "this domain takes precedence over that domain" tag, but I suspect
> simple ordering in the config file is easiest and so best.
>=20
> An important question to ask here though is whether people will want to=

> generate the "domain" lines automatically and if so, how we can make it=
 hard
> for people to get that wrong.
> Inserting a line in the middle of a file is probably more of a challeng=
e than
> inserting a line with a specific priority or depends-on tag.
>=20
> So before we get too much further down this path, I think it would be g=
ood to
> have some concrete scenarios about how this functionality will actually=
 be
> put into effect.  I'd love to just expect people to always edit mdadm.c=
onf to
> meet their specific needs, but experience shows that is naive - people =
will
> write scripts based on imperfect understanding, then share those script=
s
> with others....

OK, so here's some scenarios that I've been working from that display
how I envision this being used:

1) IMSM arrays: a single domain entry with a path=3D that specifies all
(or some) ports on the controller in question and encompasses all the
containers on that controller.  The action would be spare or grow and
what container we add any new drives to would depend on the various
container's conditions and types.

2) IMSM arrays + native arrays: similar to above but split the ports
between IMSM use and native use.  No overlapping paths, some paths to
one, some paths to other.

3) native arrays: one or more domains, no overlapping paths, actions
dependent on domain.  As an example of this type of setup, let me detail
how I commonly configure my machines when I have multiple drives I want
in multiple arrays.  Let's assume a machine with 6 drives (like the one
I'm using right now).  I use a raid5 for my / partition, so I can
tolerate at most 1 drive failure on my machine before it's unusable.
So, my standard partitioning method is to create a 1gig partition on sda
and sdb and make those into a raid1 /boot partition.  Then I do 1gig on
all remaining drives and make that into a raid5 swap partition.  Then I
do the remaining space on all drives as a raid5 root partition.  I don't
do any more than two drives in the raid1 /boot partition because if I
ever loose two drives and can't use the machine anyway, so more than
that in the /boot partition is a waste.  So, in my machine's case, here
are the domain entries I would create:

DOMAIN path=3Dblah[123456] action=3Dforce-partition table=3D/etc/mdadm.ta=
ble
	program=3Dsfdisk
DOMAIN path=3Dblah[12]-part1 action=3Dforce-spare
DOMAIN path=3Dblah[3456]-part1 action=3Dforce-grow
DOMAIN path=3Dblah*-part2 action=3Dforce-grow

Assuming that blah in the above is the path to my PCI sata controller,
the first entry would tell mdadm that if a bare disk is inserted into
slots 1 through 6, then force the disk to have the correct partition
table for my usage (Dan, I think this should clear up the confusion
about the partition action you had in another email, but I'll address it
there to...partition is really only for native array types, IMSM will
never use it).  The second entry says if it's sda or sdb and it's the
first partition (so sda1 or sdb1), then force it to be added as a spare
to any arrays in the domain.  Because of how the arrays_in_domain
function works, this will only ever match the raid1 /boot array, so we
know for a fact that it will always get added to the raid1 /boot array.
 And because that array only exists on sda1 and sdb1 anyway, we know
that if we ever plug a drive into either of those slots, then the array
will already be degraded, and this spare will be used to bring the array
back into good condition.  The third domain says on the remaining ports
to take the first partition and grow (if possible, spare if the array is
degraded) any existing array.  This means that my raid5 swap partition
will either get repaired, or grown, depending on the situation.  The
final entry makes it so that the second partition on any disk inserted
is used to grow (or spare if degraded) the / partition.

One of the things that the current code relies upon is something that we
talked about earlier.  For native array types, we only allow identical
partition tables.  We don't try to do things like add /dev/sdd4 to an
array comprised of entries such as /dev/sdc3.  Finding a suitable
partition when partition tables are not identical is beyond the initial
version of this code.  Because of this requirement, the arrays_in_domain
function makes use of this to narrow down arrays that might match a
domain based upon partition number.  So if the current pathname include
part? in its path, the function only returns arrays with the same part
in their path.  That considerably eases the matching process.

>=20
>>
>>> So, do you plan to make changes similar to incremental in assembly to=
 serve DOMAIN?
>>
>> I had not planned on it, no.  The reason being that assembly isn't use=
d
>> for hotplug.  I guess I could see a use case for this though in that i=
f
>> you called mdadm -As then maybe we should consult the DOMAIN entries t=
o
>> see if there are free drives inside of a DOMAIN listed as spare or gro=
w
>> and whether or not we have any degraded arrays while assembling that
>> could use the drives.  Dunno if we want to do that though.  However, I=

>> think I would prefer to get the incremental side of things working
>> first, then go there.
>>
>>> Should an array be split (not assembled) if a domain paths are dividi=
ng array into two separate DOMAIN?
>>
>> I don't think so.  Amongst other things, this would make it possible t=
o
>> render a machine unbootable if you had a type in a domain path.  I thi=
nk
>> I would prefer to allow established arrays to assemble regardless of
>> domain path entries.
>>
>>>>  I'm happy to rework the code to support it if there's a valid use
>>>> case, but so far my design goal has been to have a path only appear =
in
>>>> one domain, and to then perform the appropriate action based upon th=
at
>>>> domain.
>>> What is then the purpose of metadata keyword?
>>
>> Mainly as a hint that a given domain uses a specific type of metadata.=


I want to address this in a bit more detail.  One of the conceptual
problems I've been wrestling with in my mind if not on paper yet is the
problem of telling a drive that is intended to be wiped out and reused
from a drive that is part of your desired working set.  Let's think
about my above example for native arrays, where there are three arrays,
a /boot, a swap, and a / array.  Much of this talk has centered around
"what do we do when we get a hotplug event for a drive and array <blah>
is degraded".  That's the easy case.  The hard case is "what do we do if
array <blah> is degraded and the user shuts the machine down, puts in a
new-to-this-machine drive (possibly with existing md raid superblocks),
and then boots the machine back up and expects us to do the right
thing".  For anyone that doesn't have true hotplug hardware, this is
going to be the common case.  If the drive is installed in the last
place in the system and it's the last drive we detect, then we have a
chance of doing the right thing.  But if it's installed to replace
/dev/sda, we are *screwed*.  It will be the first drive we detect.  And
we won't know *what* to do with it.  And if it has a superblock on it,
we won't even know that it's not supposed to be here.  We will happily
attempt incremental assembly on this drive, possibly starting arrays
that have never existed on this machine before.  So, I'm actually
finding the metadata keyword less useful than possibly adding a UUID
keyword and allowing a domain to be restricted to one or more UUIDs.
Then if we find an errant UUID in the domain, we know not to assemble it
and in fact if the force-spare or force-grow keywords are present we
know to wipe it out and use it for our own purposes.  However, that
doesn't solve the whole problem that if it's /dev/sda then we won't have
any other arrays assembled yet, so the second thing we are going to have
to do is defer our use of the drive until a later time.  Specifically
I'm thinking we might have to write a map entry for the drive into the
mapfile, then when we run mdadm -IRs (because all distros do this after
scsi_wait_scan has completed...right?) we can revisit what to do with
the drive.  The other option is to add the drive to the mapfile, then
when mdadm --monitor mode is started have it process the drive because
all of our arrays should be up and running by the time we start the
monitor process.  Those are the only two solutions I have to this issue
at the moment.  Thoughts welcome.

>>> My initial plan was to create a default configuration for a specific =
metadata, where user specifies actions=20
>>> but without paths letting metadata handler to use default ones.
>>> In your description, I can see that the path are required.
>>
>> Yes.  We already have a default action for all paths: incremental.  Th=
is
>> is the same as how things work today without any new support.  And whe=
n
>> you combine incremental with the AUTO keyword in mdadm.conf, you can
>> control which devices are auto assembled on a metadata by metadata bas=
is
>> without the use of DOMAINs.=20
>=20
>=20
>>                               The only purpose of a domain then is to
>> specify an action other than incremental for devices plugged into a
>> given domain.
>=20
> I like this statement.  It is simple and to the point and seems to capt=
ure
> the key ideas.
>=20
> The question is:  is it true? :-)

Well, for the initial implementation I would say it's true ;-)
Certainly all the other things you bring up here make my brain hurt.

> It is suggested that 'domain' also involved in spare-groups and could b=
e used
> to warn against, or disable, a 'create' or 'add' which violated policy.=

>=20
> So maybe:
>   The purpose of a domain is to guide:
>    - 'incremental' by specifying actions for hot-plug devices other tha=
n the
>      default

Yes.

>    - 'create' and 'add' by identifying configurations that breach polic=
y

We don't really need domains for this.  The only things that have hard
policy requirements are BIOS based arrays, and that's metadata/platform
specific.  We could simply test for and warn on create/add operations
that violate platform capability without regard to domains.

>    - 'monitor' by providing an alternate way of specifying spare-groups=


Although this can be done, it need not be done.  I'm still not entirely
convinced of the value of the spare-group tag on domain lines.

> It is a lot more wordy, but still seems useful.
>=20
> While 'incremental' would not benefit from overlapping domains (as each=

> hotplugged device only wants one action), the other two might.
>=20
> Suppose I want to configure array A to use only a certain set of drives=
,
> and array B that can use any drive at all.  Then if we disallow overlap=
ping
> domains, there is no domain that describes the drives that B can be mad=
e from.
>=20
> Does that matter?  Is it too hypothetical a situation?

Let's see if we can construct such a situation.  Let's assume that we
are talking about IMSM based arrays.  Let's assume we have a SAS
controller and we have more than 6 ports available (may or may not be
possible, I don't know, but for the sake of argument we need it).  Let's
next assume we have a 3 disk raid5 on ports 0, 1, and 2.  And let's
assume we have a 3 disk raid5 on ports 4, 5, and 6.  Let's then assume
we only want the first raid5 to be allowed to use ports 0 through 4, and
that the second raid5 is allowed to use ports 0 through 7.  To create
that config, we create the two following DOMAIN lines:

DOMAIN path=3Dblah[01234] action=3Dgrow
DOMAIN path=3Dblah[01234567] action=3Dgrow

Now let's assume that we plug a disk into port 3.  What happens?

Currently, conf_get_domain() will return one, and only one, domain for a
given device.  And it doesn't search for best match (which would be very
difficult to do as we use fnmatch to test the glob match, which means
that really the path=3D statement is more or less opaque to us, we don't
process it ourselves and don't evaluate it ourselves, we just pass it
off to fnmatch and let it tell us if things matched), it just finds the
first match and returns it.  So, right now anyway, we will match the
first domain and the first domain only.  That means we will then return
that domain, then later when we call arrays_in_domain we will pass in
our device path plus our matched domain and as a result we will search
mdstat and we will find both raid5 arrays in our requested domain (the
current search returns any array with at least one member in the domain,
maybe that should be any array where all members are in the domain).

Now, at this point, if one or the other array is degraded, then what to
do is obvious.  However, if both arrays are degraded or neither array is
degraded, then our choice is not obvious.  I'm having a hard time coming
up with a good answer to that issue.  It's not clear which array we
should grow if both are clean, nor which one takes priority if both are
degraded.  We would have to add a new tag, maybe priority=3D, to the ARRA=
Y
lines in order to make this decision obvious.  Short of that, the proper
course of action is probably to do nothing and let the user sort it out.

Now let's assume that we plug a disk into port 7.  We search and find
the second domain.  Then we call arrays_in_domain() and we get both
raid5 arrays again because both of them have members in the domain.
Regardless of anything else, it's clear that this situation did *not* do
what you wanted.  It did not specify that array 1 can only be on the
first 5 ports, and it did not specify that array 2 can use all 8 ports.
 If we changed the second domain path to be blah[567] then it would
work, but I don't think that this combination of domains and the
resulting actions is all that clear to understand from a user's
perspective.  I think right now trying to do what you are suggesting is
confusing from a domain line.  Maybe we need to add something to array
lines for this.  Maybe the array line needs an allowed_path entry that
could be used to limit what paths an array will accept devices from.
But this then assumes we will create an array line for all arrays (or
for ones where we want to limit their paths) and I'm not sure people
will do (or want to do) that.

So, while I can see a possible scenario that matches your hypothetical,
I'm finding that the domain construct is a very clunky way to try and
implement the constraints of your hypothetical.

> Here is another interesting question.  Suppose I have two drive chassis=
, each
> connected to the host by a fibre.  When I create arrays from all these =
drives,
> I want them to be balanced across the two chassis, both for performance=

> reasons and for redundancy reasons.
> Is there any way we can tell mdadm about this, possible through 'domain=
s'.

This is actually the first thing that makes me see the use of
spare-group on a domain line.  We could construct two different domains,
one for each chassis, but with the same spare-group tag.  This would
imply that both domains are available as spares to the same arrays, but
allows us to then add a policy to mdadm for how to select spares from
domains.  We could add a priority tag to the domain lines.  If two
domains share the same spare-group tag, and the domains have the same
priority, then we could round-robin allocate from domains (what you are
asking about), but if they have different priorities then we could
allocate solely from the higher (or lower, implementation defined)
priority domain until there is nothing left to allocate from it and then
switch to the other domain.  I could actually also see adding a
write_mostly flag to an entire domain in case the chassis that domain
represents is remote via wan.

> This could be an issue when building a RAID10 (alternate across the cha=
ssis
> is best) or when finding a spare for a RAID1 (choosing from the 'other'=

> chassis is best).
>=20
> I don't really want to solve this now, but I do want to be sure that ou=
r
> concept of 'domain' is big enough that we will be able to fit that sort=
 of
> thing into it one day.
>=20
> Maybe a 'domain' is simply a mechanism to add tags to devices, and poss=
ibly
> by implication to arrays that contain those devices.
> The mechanism for resolving when multiple domains add conflicting tags =
to
> the one device would be dependant on the tag.  Maybe first-wins.  Maybe=

> all are combined.
>=20
> So we add an 'action' tag for --incremental, and the first wins (maybe)=

> We add a 'sparegroup' tag for --monitor
> We add some other tag for balancing (share=3D1/2, share=3D2/2 ???)
>=20
> I'm not sure how this fits with imposing platform constraints.
> As platform constraints are closely tied to metadata types, it might be=
 OK
> to have a metadata-specific tags (imsm=3D???) and leave to details to t=
he
> metadata handler???

I'm more and more of the mind that we need to leave platform constraints
out of the domain issue and instead just implement proper platform
constraint checks and overrides in the various parts of mdadm that need
it regardless of domains.

> Dan: help me understand these platform constraints: what is the most co=
mplex
>   constraint that you can think of that you might want to impose?
>=20
> NeilBrown


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigE3C165E6E7513208322A5A0C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkva/M4ACgkQg6WylM+/8ZRUaACffQSA3+fkgRILncpMaG60enCK
WYcAn1Ko6oflF6rLsRKEXsNuPzwCVnry
=S1A/
-----END PGP SIGNATURE-----

--------------enigE3C165E6E7513208322A5A0C--
