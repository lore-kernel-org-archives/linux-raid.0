From: Doug Ledford <dledford@redhat.com>
Subject: Re: safe segmenting of conflicting changes
Date: Tue, 27 Apr 2010 15:29:31 -0400
Message-ID: <4BD73B1B.8060204@redhat.com>
References: <loom.20100423T152429-20@post.gmane.org> <4BD1B7E8.9020602@cfl.rr.com> <4BD1E491.3090603@cfl.rr.com> <4BD5C65B.7080707@redhat.com> <4BD5D20B.9020900@cfl.rr.com> <4BD5D5F7.208@redhat.com> <4BD5DEEE.7020208@cfl.rr.com> <4BD5E477.2010201@redhat.com> <4BD5EBC0.9030801@cfl.rr.com> <4BD622DC.7030309@redhat.com> <4BD70ECE.3090200@cfl.rr.com> <4BD71E9D.1040206@redhat.com> <4BD7272D.3040500@cfl.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig57957A65CB0A58B532FE8A55"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BD7272D.3040500@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig57957A65CB0A58B532FE8A55
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/27/2010 02:04 PM, Phillip Susi wrote:
> On 4/27/2010 1:27 PM, Doug Ledford wrote:
>> And the state "removed" is labeled as such because the device has been=

>> removed from the list of slave devices that the kernel keeps.  Nothing=

>> more.  You are reading into it things that weren't intended.  What you=

>> are reading into it might even be a reasonable interpretation, but it'=
s
>> not the actual interpretation.
>=20
> Then it is a useless and non existent state.

Actually, that's more true than you realize.  Technically, there is no
"removed" state (at least not that's stored on the removed drive).
There are working, failed, and removed discs as far as the slot array
for the md device is concerned.  The usage of REMOVED in the device
states is limited to marking slots in the constituent device list that
have neither a working disc nor a failed disc associated with it.  It
has nothing to do with whether or not mdadm --remove was ever called.

>  Whether the kernel
> currently has the disk open or not is purely ephemeral; there is no
> reason to bother recording it in the superblock.

We do record it, but mainly in the form of our disk count.  We keep
track of active discs, failed discs, and spare discs.  Whether we have
the disc open and in our device list changes what our failed disc count
would be.  On removal, we decrement that failed disc count.  The slot
that the disc used to occupy gets changed from being failed to removed
simply to indicate there is no rdev associated with that slot.  That is
the information we record.

>  Why bother recording
> that bit in the superblock if you are just going to ignore it?  It is
> there, so it should not be ignored.

You are making assumptions about the use of that bit.  We don't ignore
it, we just don't use it the way you think we should.

>> mdadm /dev/md0 -f /dev/sdc1 -r /dev/sdc1; mdadm --zero-superblock /dev=
/sdc1
>>
>> and that should be sufficient to satisfy your needs.  If we race betwe=
en
>> the remove and the zero-superblock with something like a power failure=

>> then obviously so little will have changed that you can simply repeat
>> the procedure until you successfully complete it without a power failu=
re.
>=20
> Except that now I can't manually re-add the disk to the array.

Sure you can: mdadm /dev/md0 -a /dev/sdc1

>> This is intentional.  A remove event merely triggers a kernel error
>> cycle on the target device.  We don't differentiate between a user
>> initiated remove and one that's the result of catastrophic disc failur=
e.
>=20
> Why not?  Seems to be because of a broken definition of the removed sta=
te.

Not at all.  You make lots of assumptions, some of them rather silly.
We don't differentiate between the two because the best way to ensure
you don't have errors in your device failure code path is to actually
use it other than just when a device fails.  It was an intentional
design decision that when the set faulty and hot remove ioctl calls were
added to the raid stack, that they would actually call into the low
level command handling routines and activate the actual error paths that
would be followed if a command came back from a device with some sort of
error.  By doing that, we are actually testing the command failure path
every time we instigate a hot fail using mdadm.  That was intentional,
and it had nothing to do with the definition of removed state.

>>  However, trying to access a dead disc causes all sorts of bad behavio=
r
>> on a real running system with a real disc failure, so once we know a
>> disc is bad and we are kicking it from the array, we only try to write=

>> that data to the good discs so we aren't hosing the system.
>=20
> That is what failed is for.  Once failed, you can't write to the disk
> anymore.  If it isn't failed, you should be able to remove it, and the
> superblock should be updated prior to detaching.

That's all fine and dandy for the MD raid stack, version 2.  Feel free
to start writing said stack with your preferred semantic definitions in
place.

>> We are specifically going in the opposite direction here.  We *want* t=
o
>> automatically readd removed devices because we are implementing
>> automatic removal on hot unplug, which means we want automatic additio=
n
>> on hot plug.
>=20
> Again, this is because you are conflating removed, and failed.

No, because we only have one failed state: failed.  Removed as far as
mdadm is concerned is an action, and removed as far as the kernel is
concerned just means "I don't have any devices opened for this slot".
It's not a valid state for a device.

>  If you
> treat them separately then you don't have this problem.  Failed happens=

> automatically, so can be undone automatically, removed does not.
>=20
>> Again, we are back to the fact that you are interpreting removed to be=

>> something it isn't.  We can argue about this all day long, but that
>> option has had a specific meaning for long enough, and has been around=

>> long enough, that it can't be changed now without breaking all sorts o=
f
>> back compatibility.
>=20
> This may be true for the --remove switch, but as it stands right now,
> the removed flag in the superblock is utterly meaningless.  If you want=

> --remove to continue to behave the way it does, then you could add a
> --really-remove command to set the removed flag, though this seems a
> little silly.

I'm sure Neil will take patches.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig57957A65CB0A58B532FE8A55
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvXOxsACgkQg6WylM+/8ZQ/4gCgnJ56mH4xVMADgJnpbWctAN2+
fisAnRdfRZrKxJXCXCP0d2QahZdyOi+1
=kYm6
-----END PGP SIGNATURE-----

--------------enig57957A65CB0A58B532FE8A55--
