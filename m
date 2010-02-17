From: Bryan Mesich <bryan.mesich@ndsu.edu>
Subject: Re: Why does one get mismatches?
Date: Tue, 16 Feb 2010 21:19:03 -0600
Message-ID: <20100217031903.GA26028@atlantis.cc.ndsu.nodak.edu>
References: <869541.92104.qm@web51304.mail.re2.yahoo.com> <4B67451F.8040206@tmr.com> <20100202093738.44b4fece@notabene.brown> <4B684087.50001@tmr.com> <20100211161444.7a0ea7bb@notabene.brown> <20100211175133.GA30187@atlantis.cc.ndsu.nodak.edu> <4B7B0D45.7040801@tmr.com> <6db64f7872286165ac1fd3436e9d6476@localhost>
Reply-To: Bryan Mesich <bryan.mesich@ndsu.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6db64f7872286165ac1fd3436e9d6476@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Haigh <netwiz@crc.id.au>
Cc: Bill Davidsen <davidsen@tmr.com>, Neil Brown <neilb@suse.de>, Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 17, 2010 at 08:38:11AM +1100, Steven Haigh wrote:
> On Tue, 16 Feb 2010 16:25:25 -0500, Bill Davidsen <davidsen@tmr.com> wrot=
e:
> > The issue lies with data changing between write to multiple drives. In=
=20
> > hardware raid the data traverses the memory bus once, only once, and=20
> > goes into cache in the controller, from which it is written to all=20
> > mirrored drives. With software raid an individual write is done to each=
=20
> > drive, and if the data in the buffer changes between writes to one drive
> > or the other you get different values. Neil may be convinced that the OS
> > somehow "knows" which of the mirror copies is correct, ie. most recent,=
=20
> > and never uses the stale data, but if that information was really=20
> > available reads would always return the latest value and it wouldn't be=
=20
> > possible to read the same file multiple times and get different MD5sums.

[snip...]

> I agree Bill, there is an issue with the software RAID1 when it comes down
> to some hardware. I have one machine where the ONLY way to stop the root
> filesystem going readonly due to journal issues is to remove RAID. Having
> RAID1 enabled gives silent corruption of both data and the journal at
> seemingly random times.

Maybe I missed something earlier in this thread...and if so I apologize.
However, I was not aware of anyone reporting FS corruption due do software
RAID 1.  Needless to say, a serious problem if occurring.

At work, we use software RAID 1 on the majority of our production servers
and have never seen problems as you describe.  I'm not trying to
discredit you...just that we have had not seen similar results.=20

> I can see the data corruption from running a verify between RPM and data
> on the drive. Reinstalling these packages fixes things - until something
> random things get corrupted next time.

For curiosity sake, what kind of files did RPM report as being corrupt
after running the verify?  The reason I ask as that I would expect user
data to be corrupt before system files as they are typically written to
disk at install/update  and never written to again.  Or maybe there is a
reason...correct me if I'm wrong ;)

In my last post, I asked Neil if he had a patch that would indicate where
the mis-matches exist on disk.  Have you found a way to correlate the
mis-matches with your FS corruption? =20

Bryan

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkt7YCcACgkQlSl3SAlkhEezUgCeMbFVgQAt+PRJamq+/WOWKcpA
f78AnA0P1mdNVFGcqmh2kqGxn/L1CL+3
=NXjJ
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
