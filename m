From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 0/1] Make failure message on re-add more explcit
Date: Thu, 05 Apr 2012 14:59:29 -0400
Message-ID: <4F7DEB91.4060306@redhat.com>
References: <1329930000-20679-1-git-send-email-Jes.Sorensen@redhat.com> <20120223090412.2b14fb7f@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD7966E573781518FF08A0CF0"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120223090412.2b14fb7f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jes.Sorensen@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD7966E573781518FF08A0CF0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/22/2012 05:04 PM, NeilBrown wrote:
> On Wed, 22 Feb 2012 17:59:59 +0100 Jes.Sorensen@redhat.com wrote:
>=20
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> Hi,
>>
>> I have seen this come up on the list a couple of times, and also had
>> bugs filed over it, since this used to 'work'. Making the printed
>> error message a little more explicit should hopefully make it clearer
>> why this is being rejected.
>>
>> Thoughts?

My apologies for coming into this late.  However, this change is causing
support isses, so I looked up the old thread so that I could put my
comments into context.

> While I'm always happy to make the error messages more helpful, I don't=
 think
> this one does :-(
>=20
> The reason for the change was that people seemed to often use "--add" w=
hen
> what they really wanted was "--re-add".

This is not an assumption you can make (that people meant re-add instead
of add when they specifically used add).

> --add will try --re-add first,

Generally speaking this is fine, but there are instances where re-add
will never work (such as a device with no bitmap) and mdadm upgrades all
add attempts to re-add attempts without regard for this fact.

> but it if that doesn't succeed it would do the
> plain add and destroy the metadata.

Yes.  So?  The user actually passed add in this instance.  If the user
passes re-add and it fails, we should not automatically attempt to do an
add.  If the user passes in add, and we attempt a re-add instead and it
works, then great.  But if the user passes in add, we attempt a re-add
and fail, then we can't turn around and not even attempt to add or else
we have essentially just thrown add out the window.  It would no longer
have any meaning at all.  And that is in fact the case now.  Add is dead
all except for superblockless devices, for any devices with a superblock
only re-add does anything useful, and it only works with devices that
have a bitmap.

> So I introduced the requirement that if you want to destroy metadata, y=
ou
> need to do it explicitly (and I know that won't stop people, but hopefu=
lly it
> will slow them down).

Yes you did.  You totally neutered add in the process.

> Also, this is not at all specific to raid1 - it applies equally to
> raid4/5/6/10.

I have a user issue already opened because of this change, and I have to
say I agree with the user completely.  In their case, they set up
machines that go out to remote locations.  The users at those locations
are not highly skilled technical people.  This admin does not *ever*
want those users to run zero-superblock, he's afraid they will zero the
wrong one.  And he's right.  Before, with the old behavior of add, we at
least had some sanity checks in place: did this device used to belong to
this array or no array at all, is it just out of date, does it have a
higher event counter than the array, etc.  When you used add, mdadm
could at least perform a few of these sanity checks to make sure things
are cool and alert the user if they aren't.  But with a workflow of
zero-superblock/add, there is absolutely no double checks we can perform
for the user, no ability to do any sanity checking at all, because we
don't know what the user will be doing with the device next.

Neil, this was a *huge* step backwards.  I think you let the idea that
an add destroys metadata cause a problem here.  Add doesn't destroy
metadata, it rewrites it.  But in the process it at least has the chance
to sanity check things.  The zero-superblock/add workflow really *does*
destroy metadata, and in a much more real way than the old add behavior.
 I will definitely be reverting this change, and I suggest you do the sam=
e.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford



--------------enigD7966E573781518FF08A0CF0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPfeuRAAoJELgmozMOVy/di3UP/32hSX4xmpgfNNBX8zfUadl7
S1W3qNG/W+Avcf7PYavQ6On/84XiHj4wnMCcBdotO6l6ppNNKzl4ooCWnsJtU40Z
l9vE/oNH8Cm6KfrjNSnoVjhuc2tTZg7xHVjxvZoVB3a98vmhJEOS5Z+56+blAl2F
W74AK+sRCn2BvvSXJf2m5rHiYmcr1FeTJOwurS0v1OZxwiCbbS9Lb/KMeKzsQtuM
ygQ8ydOammkezY4byYy6PXd37CwHwfLjGfRVCARLmCzUfe0MGJ1Ll/agrtYhhPcy
d+L0e7SF9DYB6D8VQY1XA1c8FqHI1keiJnKV+g1U1q4CDLB12euA+kvr8aHGhjGU
QggI/dSuTds5fLuxS94dLJz5ltQU5vjuJC3I7+XvMvQJaLIj1R4DLnnXqiGaGDZq
Y+je3IHdmkR6Fkk53WeDwL5W9pXnsJb5jVo2J8USOvFOmEAnB+VcOMerQ5eWlQQ4
zqNupQuaHMM5hq0Whh5I9nLqa8mmM+BxDJByNRbkWh4mmQPpkfZ9IXsE3lUrbEDH
iUrwJA7ACt5voN69qEB20rJhZPbHaDnDYotmFk2SMAdTA5TpmikgB9GfO/GqZ3vK
o0+GIID1qNfSpWMCZUKqyrpv4Yk3rOWmHVDfg/40n8SXbyLJT/1T/GnffnNqvBHl
GcGAthYLQr0G4RlE7XkL
=xW9U
-----END PGP SIGNATURE-----

--------------enigD7966E573781518FF08A0CF0--
