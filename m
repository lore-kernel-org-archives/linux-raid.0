From: Doug Ledford <dledford@redhat.com>
Subject: Re: safe segmenting of conflicting changes
Date: Tue, 27 Apr 2010 13:27:57 -0400
Message-ID: <4BD71E9D.1040206@redhat.com>
References: <loom.20100423T152429-20@post.gmane.org> <4BD1B7E8.9020602@cfl.rr.com> <4BD1E491.3090603@cfl.rr.com> <4BD5C65B.7080707@redhat.com> <4BD5D20B.9020900@cfl.rr.com> <4BD5D5F7.208@redhat.com> <4BD5DEEE.7020208@cfl.rr.com> <4BD5E477.2010201@redhat.com> <4BD5EBC0.9030801@cfl.rr.com> <4BD622DC.7030309@redhat.com> <4BD70ECE.3090200@cfl.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2A8444AD523E668B1008F6EB"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BD70ECE.3090200@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2A8444AD523E668B1008F6EB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/27/2010 12:20 PM, Phillip Susi wrote:
> RAID is an acronym that just happens to also spell an English word.
> Removed and Failed are not, and your cat example is a complete non
> sequitur.  My point is that when naming technical things you should do
> so sanely.  You wouldn't label the state a disk goes into when it keeps=

> failing IO requests as "Iceland" would you?  Of course not.  The state
> is named failed because the disk has failed.

And the state "removed" is labeled as such because the device has been
removed from the list of slave devices that the kernel keeps.  Nothing
more.  You are reading into it things that weren't intended.  What you
are reading into it might even be a reasonable interpretation, but it's
not the actual interpretation.

> I didn't say never allow it to be added back, I said don't go doing it
> automatically.  An explicit add should, of course, work as it does now,=

> but it should not be added just because udev decided it has appeared an=
d
> called mdadm --incremental on it.

This is, in fact, completely contrary to where we are heading with
things.  We in fact *do* want udev invoked incremental rules to readd
the device after it has been removed.  The entire hotunplug/hotplug
support I'm working on does *exactly* that.  On device removal is does
both a fail and remove action, an on device insertion is does a readd or
add as needed.

So, as I said, you are reading more into "removed" than we intend, and
we *will* be automatically removing devices when they go away, so it's
entirely appropriate that if we automatically remove them then we don't
consider "removed" to be a manual intervention only state, it is a valid
automatic state and recovery from it should be equally automatic.

>> No, it's not.  The udev rules that add the drive don't race with
>> manually removing it because they don't act on change events, only add=

>> events.
>=20
> And who is to say that you won't get one of those?  A power failure
> after --remove and when the system comes back up, viola, the disk gets
> put back into the array.  Or maybe your hotplug environment has a loose=

> cable that slips out and you put it back.  This clearly violates the
> principal of least surprise.

No, it doesn't.  This is exactly what people expect in a hotplug
environment.  A device shows up, you use it.  If you don't want the
device to be used, then remove the superblock.  This whole argument
centers around the fact that, to you, --remove means "don't use this
device again".  That's a very reasonable thing to think, but it's not
actually what it means.  It simply means "remove this device from the
slaves held by this array".  Only under certain circumstances will it
get readded back into the array automatically (you reboot the machine,
power failure, cable unplug/plug, etc.)  This is because of the
interaction between hotplug discovery and the fact that we merely
removed the drive from the list of slaves to the array, we did not mark
the drive as "not to be used".  That's what zero-superblock is for.  And
this whole argument that the drive being readded is a big deal is bogus
too.  You can always just re-remove the device if it got added.  If you
were wanting to preserve the data on the drive (say you were splitting a
raid1 array and wanting it to remain as it was for possible revert
capability) then you could issue this command:

mdadm /dev/md0 -f /dev/sdc1 -r /dev/sdc1; mdadm --zero-superblock /dev/sd=
c1

and that should be sufficient to satisfy your needs.  If we race between
the remove and the zero-superblock with something like a power failure
then obviously so little will have changed that you can simply repeat
the procedure until you successfully complete it without a power failure.=


>> Not going to happen.  Doing what you request would undo a number of ve=
ry
>> useful features in the raid stack.  So you might as well save your
>> breath, we aren't going to make a remove event equivalent to a zero
>> superblock event because then the entire --readd option would be
>> rendered useless.
>=20
> I didn't say that.  I said that a remove event 1) should actually bothe=
r
> recording the removed state on the disk being removed ( right now it
> only records it on the other disks ),

This is intentional.  A remove event merely triggers a kernel error
cycle on the target device.  We don't differentiate between a user
initiated remove and one that's the result of catastrophic disc failure.
 However, trying to access a dead disc causes all sorts of bad behavior
on a real running system with a real disc failure, so once we know a
disc is bad and we are kicking it from the array, we only try to write
that data to the good discs so we aren't hosing the system.

> and 2) the fact that the disk is
> in the removed state should prevent --incremental from automatically
> re-adding it.

We are specifically going in the opposite direction here.  We *want* to
automatically readd removed devices because we are implementing
automatic removal on hot unplug, which means we want automatic addition
on hot plug.

>> Because there are both transient and permanent failures.  Experience
>> caused us to switch from treating all failures as permanent to treatin=
g
>> failures as transient and picking up where we left off if at all
>> possible because too many people were having a single transient failur=
e
>> render their array degraded, only to have a real issue come up sometim=
e
>> later that then meant the array was no longer degraded, but entirely
>> dead.  The job of the raid stack is to survive as much failure as
>> possible before dying itself.  We can't do that if we allow a single,
>> transient event to cause us to stop using something entirely.
>=20
> That's a good thing and is why it is fine for --incremental to activate=

> a disk in the failed state if it appears to have returned to being
> operational and it is safe to do so ( meaning hasn't also been activate=
d
> degraded ).  It should not do this for the removed state however.

Again, we are back to the fact that you are interpreting removed to be
something it isn't.  We can argue about this all day long, but that
option has had a specific meaning for long enough, and has been around
long enough, that it can't be changed now without breaking all sorts of
back compatibility.

>> Besides, what you seem to be forgetting is that those events that make=

>> us genuinely not want to use a device also make it so that at the next=

>> reboot the device generally isn't available or seen by the OS
>> (controller failure, massive failure of the platter, etc).  Simply
>> failing and removing a device using mdadm mimics a transient failure.
>> If you fail, remove, then zero-superblock then you mimic a permanent
>> failure.  There you go, you have a choice.
>=20
> Failed and removed are two different states; they should have different=

> behaviors.  Failed =3D temporary, removed =3D more permanent.

There is *no* such distinction between failed and removed.  Only *you*
are inferring that distinction.  The real distinction is failed =3D=3D no=

longer allowed to process read/write requests from the block layer but
still present as a slave to the array, removed =3D=3D no longer present a=
s a
slave to the array.

> zero-superblock is completely permanent.  Removed should be a good
> middle ground where you still CAN re-add the device, but it should not
> be done automatically.

A semantic change such as this would require huge amounts of pain in
terms of fixing up scripts to do as you expect.  It would be far easier
on the entire mdadm using world to add a new option that implements what
you want instead of changing existing behavior.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig2A8444AD523E668B1008F6EB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvXHp0ACgkQg6WylM+/8ZRucACdHcEalFio9RZpbBDtCh7WiHad
6joAoJLQme10d9DM9rEiuFAhsArsItbK
=1UNT
-----END PGP SIGNATURE-----

--------------enig2A8444AD523E668B1008F6EB--
