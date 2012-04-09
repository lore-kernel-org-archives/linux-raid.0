From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/1] Make failure message on re-add more explcit
Date: Tue, 10 Apr 2012 09:41:30 +1000
Message-ID: <20120410094130.283195dc@notabene.brown>
References: <1329930000-20679-1-git-send-email-Jes.Sorensen@redhat.com>
	<20120223090412.2b14fb7f@notabene.brown>
	<4F7DEB91.4060306@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/m/Q6qA_bUKVTNiE6N4nc22="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F7DEB91.4060306@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Jes.Sorensen@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/m/Q6qA_bUKVTNiE6N4nc22=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 05 Apr 2012 14:59:29 -0400 Doug Ledford <dledford@redhat.com> wrote:

> On 02/22/2012 05:04 PM, NeilBrown wrote:
> > On Wed, 22 Feb 2012 17:59:59 +0100 Jes.Sorensen@redhat.com wrote:
> >=20
> >> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> >>
> >> Hi,
> >>
> >> I have seen this come up on the list a couple of times, and also had
> >> bugs filed over it, since this used to 'work'. Making the printed
> >> error message a little more explicit should hopefully make it clearer
> >> why this is being rejected.
> >>
> >> Thoughts?
>=20
> My apologies for coming into this late.  However, this change is causing
> support isses, so I looked up the old thread so that I could put my
> comments into context.
>=20
> > While I'm always happy to make the error messages more helpful, I don't=
 think
> > this one does :-(
> >=20
> > The reason for the change was that people seemed to often use "--add" w=
hen
> > what they really wanted was "--re-add".
>=20
> This is not an assumption you can make (that people meant re-add instead
> of add when they specifically used add).

I don't assume that they "do" but that they "might" - and I assume this
because observation confirms it.

>=20
> > --add will try --re-add first,
>=20
> Generally speaking this is fine, but there are instances where re-add
> will never work (such as a device with no bitmap) and mdadm upgrades all
> add attempts to re-add attempts without regard for this fact.

Minor nit: --re-add can work on a device with no bitmap.  If you assemble 4
of the 5 devices in a 5-device RAID5, then re-add the missing device before
any writes, it *should* re-add successfully (I haven't tested lately, but I
think it works).

>=20
> > but it if that doesn't succeed it would do the
> > plain add and destroy the metadata.
>=20
> Yes.  So?  The user actually passed add in this instance.  If the user
> passes re-add and it fails, we should not automatically attempt to do an
> add.  If the user passes in add, and we attempt a re-add instead and it
> works, then great.  But if the user passes in add, we attempt a re-add
> and fail, then we can't turn around and not even attempt to add or else
> we have essentially just thrown add out the window.  It would no longer
> have any meaning at all.  And that is in fact the case now.  Add is dead
> all except for superblockless devices, for any devices with a superblock
> only re-add does anything useful, and it only works with devices that
> have a bitmap.

While there is some validity in your case you are over-stating it here which
is not a good thing.
--add has not become meaningless (or neutered as you say below).  The only
case where it doesn't work is when we attempted --re-add, and we don't
always do that.   In cases where we don't try --re-add, --add is just as go=
od
as it was before.  There may well be a problem, but it doesn't help to
over-state it.

>=20
> > So I introduced the requirement that if you want to destroy metadata, y=
ou
> > need to do it explicitly (and I know that won't stop people, but hopefu=
lly it
> > will slow them down).
>=20
> Yes you did.  You totally neutered add in the process.
>=20
> > Also, this is not at all specific to raid1 - it applies equally to
> > raid4/5/6/10.
>=20
> I have a user issue already opened because of this change, and I have to
> say I agree with the user completely.  In their case, they set up
> machines that go out to remote locations.  The users at those locations
> are not highly skilled technical people.  This admin does not *ever*
> want those users to run zero-superblock, he's afraid they will zero the
> wrong one.  And he's right.  Before, with the old behavior of add, we at
> least had some sanity checks in place: did this device used to belong to
> this array or no array at all, is it just out of date, does it have a
> higher event counter than the array, etc.  When you used add, mdadm
> could at least perform a few of these sanity checks to make sure things
> are cool and alert the user if they aren't.  But with a workflow of
> zero-superblock/add, there is absolutely no double checks we can perform
> for the user, no ability to do any sanity checking at all, because we
> don't know what the user will be doing with the device next.

Did "--add" perform those sanity checks? or do anything with them?
I don't think so.  It would just do a --re-add if it could and a --add if it
couldn't, and --add would replace the metadata (except the device uuid, but
I don't think anyone cares about that).

--add doesn't do all the same checks that --create does so it really is
(was) a lot like --zero-superblock in its ability to make a mess.
=20
>=20
> Neil, this was a *huge* step backwards.  I think you let the idea that
> an add destroys metadata cause a problem here.  Add doesn't destroy
> metadata, it rewrites it.  But in the process it at least has the chance
> to sanity check things.  The zero-superblock/add workflow really *does*
> destroy metadata, and in a much more real way than the old add behavior.
>  I will definitely be reverting this change, and I suggest you do the sam=
e.

Also a step forwards I believe.


The real problem I was trying to protect against (I think) was when someone
ends up with a failed RAID5 or RAID6 array and they try to --remove failed
devices and  --add them back in.  This cannot work so the devices get marked
as spares which is bad.
So I probably want to restrict the failure to only happen when the array is
failed.  I have a half-memory that I did that but cannot find the code, so
maybe I only thought of doing it.
RAID1 and RAID10 cannot be failed (we never fail the 'last' device) so it is
probably safe to always allow --add on these arrays.

Could you say more about the sanity checks that you think mdadm did or could
or should do on --add.  Maybe I misunderstood, or maybe there are some usef=
ul
improvements we can make there.

Thanks,
NeilBrown


--Sig_/m/Q6qA_bUKVTNiE6N4nc22=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4Nzqjnsnt1WYoG5AQJ5KxAAnntHjkfOm7WrpbE4uiNY6wNQHHeYGDkm
FMYVTSoqL20H1S/6gJd34F8S8iCose71++YD14BFjTScoMLdm8J4MwN1Be+7Qjya
snoYjWe4je4pDXDzCzatQiIzsyDUGQykOcqQSv4HIgNB35SPuU9YCNXvSqmZ89ma
F8TXtZtYtnVeMkJ72oaXeBP3ke9CxeB0sSsZF4wxyKzQNEoDLsdFBR7QRrae7yqx
GKz1TR7PJ9Ai6a3BEat86nKmJPFUkzSbo/48mHM20XiKbVhnit/8bYeflZTplByF
72YqhOOQW0kJxaYtykMHskRcJBzJvGf1UvdnmfNJKNy4vjvv88Bk933CZsHtEsfE
dgU4jb0qLXYTc9C6+1pl85WD2hsIzz3rruYQHZbUHDzyRdY5EDuLektINt9Eu+Wg
R8avT/JnILpPC+V9PsqJzTor5jwhdOBLa7D/ye10BnMZ//n0Gymhy9NZ7fCSIUvA
HpM01uWg83I5TEANT+S0uXAhc7XpRZwQfYYJLDTUdkimvrKOryqR3nBF1vVANhj/
+CzfhbHtLUHNbwfFDqFXWsk1C7CKXAmnbPtepEycFmKozCDM5zae5X0fI328j5R+
cQ4qRamxh+2/X+HV4O/nr9gwQve/Z6E8OUY1ddCdAEPqdX647tHWQrqD6evSIFqr
XSEo4jU3PEI=
=9qP1
-----END PGP SIGNATURE-----

--Sig_/m/Q6qA_bUKVTNiE6N4nc22=--
