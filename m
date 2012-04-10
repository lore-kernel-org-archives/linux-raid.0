From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 0/1] Make failure message on re-add more explcit
Date: Tue, 10 Apr 2012 19:44:26 -0400
Message-ID: <4F84C5DA.2040501@redhat.com>
References: <1329930000-20679-1-git-send-email-Jes.Sorensen@redhat.com> <20120223090412.2b14fb7f@notabene.brown> <4F7DEB91.4060306@redhat.com> <20120410094130.283195dc@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4B2A38F82F9BD2A9DF7E88A7"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120410094130.283195dc@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jes.Sorensen@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4B2A38F82F9BD2A9DF7E88A7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 4/9/2012 7:41 PM, NeilBrown wrote:
> On Thu, 05 Apr 2012 14:59:29 -0400 Doug Ledford <dledford@redhat.com> w=
rote:
>=20
>> On 02/22/2012 05:04 PM, NeilBrown wrote:
>>> On Wed, 22 Feb 2012 17:59:59 +0100 Jes.Sorensen@redhat.com wrote:
>>>
>>>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>>>
>>>> Hi,
>>>>
>>>> I have seen this come up on the list a couple of times, and also had=

>>>> bugs filed over it, since this used to 'work'. Making the printed
>>>> error message a little more explicit should hopefully make it cleare=
r
>>>> why this is being rejected.
>>>>
>>>> Thoughts?
>>
>> My apologies for coming into this late.  However, this change is causi=
ng
>> support isses, so I looked up the old thread so that I could put my
>> comments into context.
>>
>>> While I'm always happy to make the error messages more helpful, I don=
't think
>>> this one does :-(
>>>
>>> The reason for the change was that people seemed to often use "--add"=
 when
>>> what they really wanted was "--re-add".
>>
>> This is not an assumption you can make (that people meant re-add inste=
ad
>> of add when they specifically used add).
>=20
> I don't assume that they "do" but that they "might" - and I assume this=

> because observation confirms it.

I don't doubt that some do, I do on a regular basis.  But as of this
change, I can no longer specify add in many instances and get a
reasonable result because it assumes re-add, fails, then quits.  So
while the assumption that they "might" is fine and should be a good
reason to try re-add, on failure of re-add the error is a hard error
that stops anything else from happening and so is not treated as a
"might" but as a "must have really meant".

>>> --add will try --re-add first,
>>
>> Generally speaking this is fine, but there are instances where re-add
>> will never work (such as a device with no bitmap) and mdadm upgrades a=
ll
>> add attempts to re-add attempts without regard for this fact.
>=20
> Minor nit: --re-add can work on a device with no bitmap.  If you assemb=
le 4
> of the 5 devices in a 5-device RAID5, then re-add the missing device be=
fore
> any writes, it *should* re-add successfully (I haven't tested lately, b=
ut I
> think it works).

That's not really a re-add, that's no different than incremental
assembly where you go to auto read-only and then add the last device
before the first write.  To my knowledge, there is no condition where
the array has a different event counter than the device to be re-added
and where the array does not have a bitmap where a re-add works.

>>
>>> but it if that doesn't succeed it would do the
>>> plain add and destroy the metadata.
>>
>> Yes.  So?  The user actually passed add in this instance.  If the user=

>> passes re-add and it fails, we should not automatically attempt to do =
an
>> add.  If the user passes in add, and we attempt a re-add instead and i=
t
>> works, then great.  But if the user passes in add, we attempt a re-add=

>> and fail, then we can't turn around and not even attempt to add or els=
e
>> we have essentially just thrown add out the window.  It would no longe=
r
>> have any meaning at all.  And that is in fact the case now.  Add is de=
ad
>> all except for superblockless devices, for any devices with a superblo=
ck
>> only re-add does anything useful, and it only works with devices that
>> have a bitmap.
>=20
> While there is some validity in your case you are over-stating it here =
which
> is not a good thing.
> --add has not become meaningless (or neutered as you say below).  The o=
nly
> case where it doesn't work is when we attempted --re-add, and we don't
> always do that.   In cases where we don't try --re-add, --add is just a=
s good
> as it was before.  There may well be a problem, but it doesn't help to
> over-state it.

In all of my use cases it seems to be effected.  If the event counters
don't match and there is no bitmap (which is the common transient
failure followed by re-add case), it is neutered.  For the case like you
describe above, it may still work.

>>> So I introduced the requirement that if you want to destroy metadata,=
 you
>>> need to do it explicitly (and I know that won't stop people, but hope=
fully it
>>> will slow them down).
>>
>> Yes you did.  You totally neutered add in the process.
>>
>>> Also, this is not at all specific to raid1 - it applies equally to
>>> raid4/5/6/10.
>>
>> I have a user issue already opened because of this change, and I have =
to
>> say I agree with the user completely.  In their case, they set up
>> machines that go out to remote locations.  The users at those location=
s
>> are not highly skilled technical people.  This admin does not *ever*
>> want those users to run zero-superblock, he's afraid they will zero th=
e
>> wrong one.  And he's right.  Before, with the old behavior of add, we =
at
>> least had some sanity checks in place: did this device used to belong =
to
>> this array or no array at all, is it just out of date, does it have a
>> higher event counter than the array, etc.  When you used add, mdadm
>> could at least perform a few of these sanity checks to make sure thing=
s
>> are cool and alert the user if they aren't.  But with a workflow of
>> zero-superblock/add, there is absolutely no double checks we can perfo=
rm
>> for the user, no ability to do any sanity checking at all, because we
>> don't know what the user will be doing with the device next.
>=20
> Did "--add" perform those sanity checks? or do anything with them?

At least one of them, yes.  It would warn you if the device didn't
appear to belong to the array you were adding it to.

> I don't think so.  It would just do a --re-add if it could and a --add =
if it
> couldn't, and --add would replace the metadata (except the device uuid,=
 but
> I don't think anyone cares about that).

Maybe we need to split our discussion into raid1 (and maybe raid10)
arrays and raid4/5/6 arrays.  It would appear from your earlier comments
and also you later comments that this change was initiated because of
issues with raid4/5/6 arrays where being converted to a spare and then
rebuilding a new slot position onto a disk really does destroy the
current state, where as with a raid1 array this is not the case (and not
with a raid10 depending on layout).

The discussion also appears to hinge on the issue of the event counter.
 A re-add only works under two conditions: the event counters match and
the device can be re-added because it isn't really out of date or there
is a bitmap and we can re-add and re-sync only the out of date parts.
If there is no bitmap, and the event counters don't match, then the
device must be re-synced.  The support issues I'm seeing are this last
case, and they are legitimate.

> --add doesn't do all the same checks that --create does so it really is=

> (was) a lot like --zero-superblock in its ability to make a mess.
> =20
>>
>> Neil, this was a *huge* step backwards.  I think you let the idea that=

>> an add destroys metadata cause a problem here.  Add doesn't destroy
>> metadata, it rewrites it.  But in the process it at least has the chan=
ce
>> to sanity check things.  The zero-superblock/add workflow really *does=
*
>> destroy metadata, and in a much more real way than the old add behavio=
r.
>>  I will definitely be reverting this change, and I suggest you do the =
same.
>=20
> Also a step forwards I believe.
>=20
>=20
> The real problem I was trying to protect against (I think) was when som=
eone
> ends up with a failed RAID5 or RAID6 array and they try to --remove fai=
led
> devices and  --add them back in.

Fair enough.  This scenario warrants attention as people can totally
hose their data doing this.  But I don't think your solution was
correct.  First, it didn't solve anything.  If a re-add fails, then what
corrective action can a user take to make it succeed?  Nothing according
to the message other than zero-superblock.  The add used to do that for
them, then add the device.  The new work flow makes them zero the
superblock manually and do the same thing.  Has anything changed?  No.
They still have no option.  Since a re-add won't work, there is
*nothing* they can do but fall back to zero superblock and add.  We
haven't presented an alternative.  So, while this makes the fact that
they are blowing away their device's current state and data and totally
rebuilding it obvious, it provides no means to proceed down any other
path, no alternative, and so makes no positive impact what so ever.

I would note here that I suspect that the failure case you are really
concerned about is those times where a device is assembled with too few
drives to continue, or where we degrade to a state that we fail due to a
transient error, and the user tries to fix the problem by failing and
adding a drive.  This is a real and legitimate issue, but it is not
solved by your solution.  If any parity based array gets to the point of
non-functional because of too many failed devices, there there is
currently only one way to save the data: remake the array using
--assume-clean.  Stopping someone from re-adding a device to avoid
blowing away the metadata needed to enable that reconstruction effort
has the right intent in mind, but not the right solution.  You would
need to stop them at the remove/fail stage, not at the add stage, and
need to give them advice on how to try and recover, not advice on how to
make the changes unrecoverable.  So detecting a situation where too many
devices have failed, you could print out something like:

You have too few devices in a running state to start this array.  In a
last ditch effort to restore the array, you could recreate the array
with the devices that last failed added back in so that the array is in
a runnable state again (hoping not to have file corruption) by calling
mdadm with the following command line: (print out what they would need,
we should be able to detect what drives have what even counters and see
what the last removed drives where, what their slots in the array where,
what the necessary options to mdadm to recreate the array parameters
where, and print that out).

>  This cannot work so the devices get marked
> as spares which is bad.
> So I probably want to restrict the failure to only happen when the arra=
y is
> failed.  I have a half-memory that I did that but cannot find the code,=
 so
> maybe I only thought of doing it.
> RAID1 and RAID10 cannot be failed (we never fail the 'last' device) so =
it is
> probably safe to always allow --add on these arrays.
>=20
> Could you say more about the sanity checks that you think mdadm did or =
could
> or should do on --add.  Maybe I misunderstood, or maybe there are some =
useful
> improvements we can make there.

1) That the device is not part of an array, or that it was previously
part of this array and the array thinks this device is failed.
2) That the event counter is less than that of the array (this isn't
totally foolproof, raid1 and certain layouts of raid10 arrays could fool
this, I posted a possible solution in the bugzilla I have for this issue
at: https://bugzilla.redhat.com/show_bug.cgi?id=3D808776 however please
ignore the fact I was still a bit annoyed at this issue when I wrote the
bug so my language is not as calm as it should have been, my apologies).



--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig4B2A38F82F9BD2A9DF7E88A7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPhMXaAAoJELgmozMOVy/dSFAQAMFC3krsF5En3xjx/juWLFNd
Z5+mAoToUl2m/IhQixzkc+sWy2tt1POc3G0aXx6NpT0p6HOkoaa6H5fQfB8yOz8A
Yj/jIWXyOmI/5mg4mDdexWt5zbMEQ/WUBtj2Fg9Yz3mRIKEac7KIC+924CEynByE
yKjvCRCH1lYqurIgw1O/+SXAxQZWyn+zLPX2PwuoScoUm6ivjXsp4BNKtxXjI8mr
2kazbyrO6X107PWHfFuYrS3bjRczDezcvYSoXpwOOkvuNTui29dopo5FzP3Piafw
aCz2pvCRpmxVdI/N9qX9jcvE8yJbciqSS0GEz0fF5CeLCXUpeUHnK6EH2XRhaUcX
MLh5UKaZqy8X8crsVzdYEvRm3h/BWrXZ9Qc/0BR2VBidKCz16Anpq3R1Hw6SM3VD
s+NpUl3meBdeCVkjEL/rGacn2e7MX2DjcbfVvrcSUeBs9FXBPMLQyAoTGcEgxu9l
DKvk3Foa7EyiiBA/Z8szdKaB1bkVG93faDo6WIQoeDcHuvv6dX1foeBP5Y4oLqLH
ksGSVQmyTQgt36a8rgZzFOFEcSbmFZ43Al0wmoWTB5EE1J2DzrAmutIIVHUd+yMF
XYlQxMDdjfcvWCb8yO1+4N7eVkRoCL2KOLj8Y9mpaRDpPrJux8uA8sDyUt8G5XcI
H5G5kLOOihgZxr0yyEVT
=BZxT
-----END PGP SIGNATURE-----

--------------enig4B2A38F82F9BD2A9DF7E88A7--
