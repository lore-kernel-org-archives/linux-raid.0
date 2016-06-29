From: Zygo Blaxell <u0oo5pgu@umail.furryterror.org>
Subject: Re: URE, link resets, user hostile defaults
Date: Wed, 29 Jun 2016 08:17:51 -0400
Message-ID: <20160629121751.GT15597@hungrycats.org>
References: <CAJCQCtT1qi1yLjE3Lor3ScVJx7aX4A_S_iM_=VhDtDCD_C9uqw@mail.gmail.com>
 <57721A47.8070203@suse.de>
 <CAJCQCtQ=DXWg6qK1+9bwQxrzpKUsRvaiaAnatYR-dupg7JOVzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uCozLMBrA/OCc/kF"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJCQCtQ=DXWg6qK1+9bwQxrzpKUsRvaiaAnatYR-dupg7JOVzQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--uCozLMBrA/OCc/kF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 28, 2016 at 11:33:36AM -0600, Chris Murphy wrote:
> On Tue, Jun 28, 2016 at 12:33 AM, Hannes Reinecke <hare@suse.de> wrote:
> > Can you post a message log detailing this problem?
>
> Just over the weekend Phil Turmel posted an email with a bunch of back
> reading on the subject of timeout mismatches for someone to read. I've
> lost track of how many user emails he's replied to, discovering this
> common misconfiguration, and get it straightened out and more often
> than not helping the user recover data that otherwise would have been
> lost *because* of hard link resetting instead of explicit read errors.

OK, but the two links you provided are not examples of these.

> http://www.spinics.net/lists/raid/msg50289.html

This one is basically a software or pilot-error problem that lead to a
partition table being destroyed (with a dash of terrible advice along
the way, like "pull two disks out of the machine and see if the array
recovers").  The one SATA link reset in the logs took all of 9ms to
report a drive error about 4 seconds after boot.  Nothing about this
would be affected by changing the 30-second SATA timeout.

> http://www.spinics.net/lists/raid/msg52789.html

This one is a RAID5 array that was in degraded mode for a *year* before
it was finally taken out by a second disk failure.  Data loss is the
expected outcome given those conditions--you don't get to keep your
data if you ignore drive failures for a year!  Changing the timeout
to expose latent UREs could not have helped in that case--errors were
already detected, but the admin ignored their monitoring responsibility
and just left the array to die.

> He isn't the only list regular who helps educate users tirelessly with
> this very repetitive work around

He repeats it a lot, to be sure, and he's not wrong--but it doesn't seem
to be relevant in those specific examples.  Timeout mismatch mitigation
is presented before any causal analysis of the reported failure.

There's a use case for the long timeout in situations where the system
is no longer healthy and ddrescue/myrescue-style tools are in play.

In redundant setups that are still healthy, the time to error detection
should be as short as possible so repair can start sooner, while still
long enough to avoid crazy numbers of false positives.  Unfortunately
that's not what seems to happen if the Linux-side timeout is shortened.

> for a very old misconfiguration that
> as far as I can tell only exists on Linux. And it's the default
> behavior.
[...]
> Usually recoveries don't take minutes. But they can take minutes. And
> that's where the problem comes in. I don't see why the user should be
> the one punished by the kernel, which is in effect what a 30 second
> default command timer is doing.

Long timeouts don't really serve anyone, even in single-disk cases.

I was once presented a machine with an obvious disk failure--painfully
slow multi-minute application startup times, and the disk was making loud
clicking/rattling noises--but the drive was never reporting any problems
to the OS (Windows, as it happened).  The machine's owners would not
believe that its disk had failed due to the lack of reported errors, and
would not authorize a test build with a new disk restored from backups
(an expensive proposition since there weren't any, and making a copy
of this broken disk would have taken days if it was successful at all).
The owners were convinced it was some sort of software problem.  Finally I
told the users to run a drive self-test over a weekend and--after about
40 hours and only 4% of the disk tested--it finally found a bad sector
it couldn't read, and generated an error code that would get the drive
replaced.  Apparently the machine's users had been living with this
for three months before I got there, and the machine was unusable the
whole time.  A much shorter error timeout would at least have provided
evidence of a hardware problem, even if it was the wrong one.

--uCozLMBrA/OCc/kF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAldzvG8ACgkQgfmLGlazG5zkRgCdEypBT8B2Hyhju+dVWbyjZGU4
dJQAoOq6zq4KjLsht/qFlCXANV//kcR3
=qsxc
-----END PGP SIGNATURE-----

--uCozLMBrA/OCc/kF--
