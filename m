From: Doug Ledford <dledford@redhat.com>
Subject: Re: safe segmenting of conflicting changes
Date: Mon, 26 Apr 2010 15:07:35 -0400
Message-ID: <4BD5E477.2010201@redhat.com>
References: <loom.20100423T152429-20@post.gmane.org> <4BD1B7E8.9020602@cfl.rr.com> <4BD1E491.3090603@cfl.rr.com> <4BD5C65B.7080707@redhat.com> <4BD5D20B.9020900@cfl.rr.com> <4BD5D5F7.208@redhat.com> <4BD5DEEE.7020208@cfl.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig89461C8E1B82A2AE389B7E91"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BD5DEEE.7020208@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig89461C8E1B82A2AE389B7E91
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/26/2010 02:43 PM, Phillip Susi wrote:
> On 4/26/2010 2:05 PM, Doug Ledford wrote:
>> So, the point of raid is to be as reliable as possible, if the disk th=
at
>> was once gone is now back, we want to use it if possible.
>=20
> No, we don't.  I explicitly removed that disk from the array because I
> have no wish for it to be there any more.

Then you need to remove the superblock from the device.

>  Maybe I plan on using it in
> another array, or maybe I plan on shreding its contents.  Whatever I'm
> planning for that disk, it does not involve it being used in a raid
> array any more.

The problem here seems to be an issue of expectations.  You think that
"removed" is used as a flag to record intent, where as it actually is
nothing more than a matter of state.

>> The problem is the cause of this thread, and it's a bug that should be=

>> fixed, it should not cause us to require things to have an explicit
>> --add --force to use a previously failed drive.  This is a case of
>=20
> Then when the drive fails it should only be marked as failed, not also
> removed.  If I manually remove it, then it should stay removed until I
> decide to do something else with it.

As above, removed is a matter of state and simply means that the device
is no longer being held open by the raid device (aka, the device is no
longer a slave to the raid array).

>> The md raid stack makes no distinction between explicit removal or a
>> device that disappeared because of a glitch in a USB cable or some suc=
h.
>>  In both cases the drive is failed and removed.  So the fact that you
>=20
> Then that's the problem.  If it fails, it should be marked as failed.
> If it is removed, it should be marked as removed.  They are two
> different actions, that should have different results.  Why on earth th=
e
> two flags seem to always be used together is beyond me.

Failed is also a matter of state.  It means the device has encountered
some sort of error and we should no longer attempt to send any
read/write commands to the device.  It is not a statement of *why* it's
in that state.  The removed state indicates that the device has been
removed from the array and is no longer a slave to the array.  Again, no
indication of intent or cause, purely an issue of state.

And there in is the reason that you must go through both states in order
to remove a drive.  The first state, Failed, is what stops commands from
going to the drive, and the second state, Removed, is what actually
removes the dead drive from the array.  We don't allow you to remove a
live drive from the array.

Now, as those are both states, and not causes or intents, it is the
removing of the superblock that signifies intent that a drive should no
longer be part of the array.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig89461C8E1B82A2AE389B7E91
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvV5HcACgkQg6WylM+/8ZSx/QCfYTwHreb5RMZ9ZlZTc7yyf4jE
IyIAoLbeEzcKi3IAzQmalG9KAl5YT4Bd
=pkAN
-----END PGP SIGNATURE-----

--------------enig89461C8E1B82A2AE389B7E91--
