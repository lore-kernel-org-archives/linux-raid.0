From: Doug Ledford <dledford@redhat.com>
Subject: Re: safe segmenting of conflicting changes
Date: Mon, 26 Apr 2010 19:33:48 -0400
Message-ID: <4BD622DC.7030309@redhat.com>
References: <loom.20100423T152429-20@post.gmane.org> <4BD1B7E8.9020602@cfl.rr.com> <4BD1E491.3090603@cfl.rr.com> <4BD5C65B.7080707@redhat.com> <4BD5D20B.9020900@cfl.rr.com> <4BD5D5F7.208@redhat.com> <4BD5DEEE.7020208@cfl.rr.com> <4BD5E477.2010201@redhat.com> <4BD5EBC0.9030801@cfl.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig99870FCA016E28C502934B03"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BD5EBC0.9030801@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig99870FCA016E28C502934B03
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/26/2010 03:38 PM, Phillip Susi wrote:
> On 4/26/2010 3:07 PM, Doug Ledford wrote:
>> Then you need to remove the superblock from the device.
>=20
> Why?  It has been removed.  In English removed means it is no longer
> part of the array.

And in English raid means a hostile or predatory incursion, it has
nothing to do with disc drives.  And in English cat is an animal you
pet.  So technical jargon and regular English don't always agree, what's
your point?

>  Elements which are not part of the array should not
> be MADE part of the array just because they happen to be there.

Sorry, but that's just not going to happen, ever.  There any number of
valid reasons why someone might want to temporarily remove a drive from
an array and then readd it back later, and when they readd it back they
want it to come back, and they want it to know that it used to be part
of the array and only resync the necessary bits (if you have a write
intent bitmap, otherwise it resyncs the whole thing).

> Having to zero the superblock after failing and removing the drive is a=

> race condition with detecting the drive and automatically adding it bac=
k
> to the array.

No, it's not.  The udev rules that add the drive don't race with
manually removing it because they don't act on change events, only add
events.

>  To properly remove the disk from the array the superblock
> needs to be updated before the kernel releases the underlying device.

Not going to happen.  Doing what you request would undo a number of very
useful features in the raid stack.  So you might as well save your
breath, we aren't going to make a remove event equivalent to a zero
superblock event because then the entire --readd option would be
rendered useless.

>> The problem here seems to be an issue of expectations.  You think that=

>> "removed" is used as a flag to record intent, where as it actually is
>> nothing more than a matter of state.
>=20
> No, I don't think it has anything to do with intent.  I think that the
> state of being removed means it is no longer part of the array.  It
> sounds like your understanding of the state should be described in
> English as detached or disconnected, rather than removed.

Depends on context.  Removed makes perfect sense from the point of view
that the device has been removed from the list of devices currently held
with an exclusive open by the md raid stack.

>> Failed is also a matter of state.  It means the device has encountered=

>> some sort of error and we should no longer attempt to send any
>> read/write commands to the device.  It is not a statement of *why* it'=
s
>> in that state.  The removed state indicates that the device has been
>> removed from the array and is no longer a slave to the array.  Again, =
no
>> indication of intent or cause, purely an issue of state.
>=20
> Yes, it does not indicate why, nor do we care.  What we care about is
> that the drive failed or was removed, so we should not be using it.  Wh=
y
> bother recording that fact in the superblock if you're just going to
> ignore it the next time you start the array?

Because there are both transient and permanent failures.  Experience
caused us to switch from treating all failures as permanent to treating
failures as transient and picking up where we left off if at all
possible because too many people were having a single transient failure
render their array degraded, only to have a real issue come up sometime
later that then meant the array was no longer degraded, but entirely
dead.  The job of the raid stack is to survive as much failure as
possible before dying itself.  We can't do that if we allow a single,
transient event to cause us to stop using something entirely.

Besides, what you seem to be forgetting is that those events that make
us genuinely not want to use a device also make it so that at the next
reboot the device generally isn't available or seen by the OS
(controller failure, massive failure of the platter, etc).  Simply
failing and removing a device using mdadm mimics a transient failure.
If you fail, remove, then zero-superblock then you mimic a permanent
failure.  There you go, you have a choice.

If we were to do as you wish, then users would no longer have a choice,
they would be forced into mimicking a hard failure only.  I prefer to
give users a choice on how they want to do things.  So, just because you
happen to think that the only way it *should* be done is like a hard
failure doesn't mean we are going to change it to be that way.  Things
are the way they are for a reason, best to just learn to use
--zero-superblock if that's what you want.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig99870FCA016E28C502934B03
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvWItwACgkQg6WylM+/8ZTJDwCeJDbchjnxrFef825auA/3st5h
e7YAn0wycdkYbQvKBKsByOVlmwNxM9un
=osv/
-----END PGP SIGNATURE-----

--------------enig99870FCA016E28C502934B03--
