From: NeilBrown <neilb@suse.com>
Subject: Re: RFC - Raid error detection and auto-recovery (was Fault tolerance with badblocks)
Date: Mon, 15 May 2017 13:43:44 +1000
Message-ID: <87lgpyn5sf.fsf@notabene.neil.brown.name>
References: <591314F4.2010702@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <591314F4.2010702@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid <linux-raid@vger.kernel.org>, Nix <nix@esperi.org.uk>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, May 10 2017, Wols Lists wrote:

> This discussion seems to have become a bit heated, but I think we have
> the following:

... much of which is throwing baseless accusations at the people who
provide you will an open operating system kernel without any charge.
This is not an approach that is likely to win you any friends.

Cutting most of that out...


>
> FURTHER FACTUAL TIDBITS:
>
> The usual response seems to be to push the problem somewhere else. For
> example "The user should keep backups". BUT HOW? I've investigated!
>
> Let's say I buy a spare drive for my backup. But I installed raid to
> avoid being at the mercy of a single drive. Now I am again because my
> backup is a single drive! BIG FAIL.

Not necessarily.  What is the chance that your backup device and your
main storage device both fail at the same time?  I accept that it is
non-zero, but so is the chance of being hit by a bus.  Backups don't
help there.

>
> Okay, I'll buy two drives, and have a backup raid. But what if my backup
> raid is reporting a mismatch count too? Now I have TWO copies where I
> can't vouch for their integrity. Double the trouble. BIG FAIL.

Creating a checksum of each file that you backup is not conceptually
hard - much easier that always having an accurate checksum of all files
that are currently 'live' on your system.  That would allow you to check
the integrity of your backups.

>
> Tape is cheap, you say? No bl***ding way!!! I've just done a quick
> investigation, and for the price of a tape drive I could probably turn
> my 2x3TB raid-1 into a 3x3TB raid-5, AND buy sufficient disks to
> implement a raid-based grandfather/father/son backup procedure, and
> STILL have some change left over. (I am using cheapie desktop drives,
> but I could probably afford cheap NAS drives with that money.)

I agree that tape backup is unlikely to be a good solution in lots of cases.

>
> PROPOSAL: Enable integrity checking.
>
> We need to create something like /sys/md/array/verify_data_on_read. If
> that's set to true and we can check integrity (ie not raid-0), rather
> than reading just the data disks, we read the entire stripe, check the
> mirror or parity, and then decide what to do. If we can return
> error-corrected data obviously we do. I think we should return an error
> if we can't, no?

Why "obviously"?  Unless you can explain the cause of an inconsistency,
you cannot justify one action over any other.  Probable cause is
sufficient.

Returning a read error when inconsistency is detected, is a valid response.

>
> We can't set this by default. The *potential* performance hit is too
> great. But now the sysadmin can choose between performance or integrity,
> rather than the present state where he has no choice. And in reality, I
> don't think a system like mine would even notice! Low read/write
> activity, and masses of spare ram. Chances are most of my disk activity
> is cached and doesn't go anywhere near the raid code.
>
> The kernel code size impact is minimal, I suspect. All the code required
> is probably there, it just needs a little "re-purposing".
>
> PROPOSAL: Enable automatic correction
>
> Likewise create /sys/md/array/correct_data_on_read. This won't work if
> verify_data_on_read is not set, and likewise it will not be set by
> default. IFF we need to reconstruct the data from a 3-or-more raid-1
> mirror or a raid-6, it will rewrite the corrected stripe.
>
> RATIONALE:
>
> NEVER THROW AWAY USER DATA IF YOU CAN RECONSTRUCT IT !!!
>
> This gives control to the sysadmin. At the end of the day, it should be
> *his* call, not the devs', as to whether verify-on-read is worth the
> performance hit. (Successful reconstructions should be logged ...)
>
> Likewise, while correct_data_on_read could mess up the array if the
> error isn't actually on the drive, that should be the sysadmin's call,
> not the devs'. And because we only rewrite if we think we have
> successfully recreated the data, the chances of it messing up are
> actually quite small. Because verify_data_on_read is set, that addresses
> Neil's concern of changing the data underneath an app - the app has been
> given the corrected data so we write the corrected data back to disk.
>
> NOTES:
>
> From Peter Anvin's paper it seems that the chance of wrongly identifying
> a single-disk error is low. And it's even lower if we look for the clues
> he mentions. Because we only correct those errors we are sure we've
> correctly identified, other sources of corruption shouldn't get fed back
> to the disk.
>
> This makes an error-correcting scrub easy :-) Run as an overnight script...
> cat 1 > /sys/md/root/verify_data_on_read
> cat 1 > /sys/md/root/correct_data_on_read
> tar -c / > /dev/null
> cat 0 > /sys/md/root/correct_data_on_read
> cat 0 > /sys/md/root/verify_data_on_read
>
>
> Coders and code welcome ... :-)

There is no shortage of people with ideas that they would like others to
implement.  While there is now law prohibiting more, it does seem unwise
to present one with such a negative tone.  You are unlikely to win
converts that way.


NeilBrown

>
> Cheers,
> Wol
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkZI/EACgkQOeye3VZi
gbldThAAnITc1OWvkPkdaTRfwkrD4r7VIPWoE+MEvG3ezqSJRFjnCzD1s4EGZMJt
22r+BTUuMIAd/Ojo2qghs6nvNQXjxHbiJZo3U7DsK0csIyICFBGc95TDxTjwqpGT
obbm1d49R86jB+FawsoYj8kX0ntXNreqgXV8SI7TdYQGFRYiC60Qbjf0KBnQx5/v
YfyJGdF3rwVbOZq627Mx378Fnf7GQMkWf5R+TpfRlU9eLydFHHL80FEji+Tabhon
cB2dSxYG92avwBKsHNPDyAR2pIMUhdFZtSkkreqUtAa9pkKl1ykSOua+XEdPxJbV
8iF+Hk7xzCllWt2WG+18mGT+SnfvNum8kjEU5dBNiSa3oVcmzJIivO6ImkP6JN0V
wxRBlv6Tm5WhfnBG06FndGRoMwH+y9yKzqupJu5AKQeEWJsGJrTTktIpqKIB0P9J
5HTJhPMPLljtLd5uMshj3yfNTvC6P9wKcyQ1F8KvlsqLEMEdPk4UEFYfonuJnli9
jL3mMnwfZY+AofrzQJtVxa/MTcfjoisbffz4xeeuVoj9hEtRwB6vflaHx8EKBYxD
SzoZWfL6Rma0dtH+rbpL8I53kKq73VsCKP0VQce7JCoKXxPlYVxFN3hNHHFbW7B+
PCPiK9MqQqpXVzQImJDzcsqpPYNiXhih+RiVsKrM2lZCFUfGG4s=
=Bry+
-----END PGP SIGNATURE-----
--=-=-=--
