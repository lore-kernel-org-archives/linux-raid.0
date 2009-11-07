From: Doug Ledford <dledford@redhat.com>
Subject: Re: mismatch_cnt again
Date: Sat, 07 Nov 2009 09:58:40 -0500
Message-ID: <4AF58B20.3000409@redhat.com>
References: <4AF4C247.6050303@eyal.emu.id.au> <4AF4D323.6020108@panix.com>	<4AF5268D.60900@eyal.emu.id.au>	<4877c76c0911070008m789507f8h799d419287740ca5@mail.gmail.com> <87tyx6tpcb.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig19562E7E27D3B4CAFA48C2BC"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87tyx6tpcb.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Michael Evans <mjevans1983@gmail.com>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig19562E7E27D3B4CAFA48C2BC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/07/2009 08:51 AM, Goswin von Brederlow wrote:
> Michael Evans <mjevans1983@gmail.com> writes:
>=20
>> Your dmesg and/or the syslog stream of the same kernel warnings/info
>> should show you when and where these errors occurred.
>=20
> I believe mismatch count doesn't show up in the kernel. The mismatch
> count shows where data can be read clearly from the disks but the
> computed parity does not match the read parity (or the mirrors
> disagree). If the drive reports an actual error then the block is
> recomputed and not left as mismatch.
>=20
> So this would be caused by a bit flipping in ram (cpu, controler or
> disk) before being written to the platter, flipping in the cable or
> flipping on the platter. Or software.
>=20
> I currently only have mismatches on raid1. In both cases on a device
> containing swap on lvm, which I think is the culprit. Lucky me.

I'm very quickly starting to become dubious of the current mismatch_cnt
implementation.  I think a kernel patch is in order and I may just work
on that today.  Here's the deal: a non-0 mismatch count is worthless if
you don't also tell people *where* the mismatch is so they can
investigate it and correct it.

And Goswin is correct, once a mismatch exists, reading the mismatch
would not normally produce any kernel messages because the data is being
read just fine, it's simply inconsistent (bad parity or disagreeing
copies in raid1/10).  Whatever *caused* it to be inconsistent might show
up in your logs (system crash, drive reset) or it might not (sectors
went bad on a disk and were reallocated by the disk's firmware so they
now read all zeros or just random junk instead of your data).

And actually, with 1TB drives, your most likely culprit for this is the
last item I just listed: reallocated drive sectors.  Here's the deal.
If the drive detects the bad sectors during a write, it reallocates and
redoes the write to the new sectors, data saved.  If, on the other hand,
the sectors go bad after the write, then whether or not your data gets
saved depends on a number of factors.  For instance, if the sectors were
going bad slowly and you also read those sectors on a regular basis so
the drive firmware would have reason to know that they are going bad (it
would start gettings reads with errors that it had to ECC correct before
it went totally bad), then some drives will reallocate the sectors and
move the data before it's totally lost.  But, if they go bad suddenly,
or if they went bad without having frequent enough intervening reads to
pick it up that it was on its way to going bad, then the data is just
lost.  But, that's what RAID is for, so we can get it back.  Anyway,
that's my guess for the culprit of your situation.  And, unfortunately,
without getting in and looking at the mismatch to identify the correct
data, a repair operation is just as likely (50-50 chance) to corrupt
things as opposed to correct things.

With Fedora 11 there should be the palimpsest program installed.  Run it
and it will allow you to see the SMART details on each drive.  Take a
look and see if you have any showing reallocated sectors.  I happen to
have 4 of 6 drives in my array that show reallocated sectors.  I also
happen to be lucky in that none of my weekly raid-checks have turned up
a mismatch count on any devices, so the bad sectors must have been
caught in time (or there was a read error sometime for the sectors and
the raid subsystem corrected it, but if that happened I missed it in the
kernel logs).

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig19562E7E27D3B4CAFA48C2BC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr1iyUACgkQg6WylM+/8ZQD0gCfQVj0yJnmR8B+/c3QW395brkO
OCoAn3WoYnXr2vvPLYvHhMOOYBDBr6GI
=7y5X
-----END PGP SIGNATURE-----

--------------enig19562E7E27D3B4CAFA48C2BC--
