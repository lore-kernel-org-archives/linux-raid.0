From: NeilBrown <neilb@suse.de>
Subject: Re: stoppind md from kicking out "bad' drives
Date: Mon, 25 Nov 2013 10:00:03 +1100
Message-ID: <20131125100003.5114a9f4@notabene.brown>
References: <5280870E.6080703@msgid.tls.msk.ru>
	<5291269C.5080209@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZKgVXWtGr9egWCd5UCkBVJr"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5291269C.5080209@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/ZKgVXWtGr9egWCd5UCkBVJr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 24 Nov 2013 02:05:16 +0400 Michael Tokarev <mjt@tls.msk.ru> wrote:

> Neil, I'm sorry for the repost, -- can you comment please?
>=20
> I think this is important enough to deserve your comments... ;)

Sorry.  I had meant to reply.  I even thought about what the reply would be.
Unfortunately my telepath-to-SMTP gateway is a bit flakely and must have
dropped the connection.


>=20
> Meanwhile, in order to fix the mentioned broken raid5, I had
> to resort to a small perl script which reads each stripe (all
> parts which can be read), re-constructs missing stuff from
> available data when possible, and writes result to external
> file, displaying areas which can't be reconstructed.  Repeating
> procedure for the missing areas using another set of drives...
> So in the end we were able to completely restore all data
> from the array in question.

Well that is good news.  Well done!  Obviously we don't want everyone to ha=
ve
to do that though.

>=20
> Thanks,
>=20
> /mjt
>=20
> 11.11.2013 11:28, Michael Tokarev wrote:
> > Hello.
> >=20
> > Yesterday we've hit a classical issue of two drives
> > failure in raid5 configuration.
> >=20
> > The scenario was like this:
> >=20
> >  - one disk failed (atually just stopped responding, but
> >    started working again after bus reset, but that was much
> >    later than needed)
> >=20
> >  - the failed disk has been kicked out of the array
> >=20
> >  - md started syncronizing a hot-spare drive
> >=20
> >  - during resync, another drive developed a bad (unreadable)
> >    sector
> >=20
> >  - another drive has been kicked out of the array
> >=20
> >  - boom
> >=20
> > Now it is obvious that almost all data on the second drive
> > is intact, except of the area where the bad sector resides
> > (which is, btw, at the very end of the drive, where most
> > likely there's no useful data at all).  The hot-spare is
> > almost ready too (up to amost the end of it).  But the array
> > is non-functional and all filesystems are switched to read-
> > only mode...
> >=20
> > The question is: what's missing currently to prevent kicking
> > drives from md arrays at all?  And I really mean preventing
> > _both_ first failed drive (before start of resync) and second
> > failed drive?

For the first drive failure, the alternatives are:
 - kick the drive from the array.  Easiest, but you don't like that.
 - block all writes which affect that drive until either the drive
   starts responding again, or an administrative decision (whether manual or
   based on some high-level policy and longer timeouts) allows the drive to
   be kicked out. (After all we must be able to handle cases where
   the drive really is completely and totally dead)
 - continue permitting writes and recording a bad-block-list for the
   failed drive on every other drive.
   When an access to some other drive also fails, you then need to decide
   whether to fail the request, or try just that block on the
   first-fail-drive, and in the second case, whether to block or fail if two
   drives cannot respond.

There is a lot of non-trivial policy here, and non-trivial implementation
details.

I might feel comfortable with a configurable policy to block all writes when
a whole-drive appears to have disappeared, but I wouldn't want that to be t=
he
default, and I doubt many people would turn it on, even if they knew about =
it.

For the second drive failure the answer is the per-device bad-block list.  =
One
of the key design goals for that functionality was to survive single bad
blocks when recovering to a spare.
It's very new though and I don't remember if it is enabled by default with
mdadm-3.3 or not.

> >=20
> > Can write-intent bitmap be used in this case, to mark areas
> > changed in array which are failed to be written to one or
> > another component device, for example?  Md can mark a drive
> > as "semi-failed" and still try to use it in some situations.

I don't think the granularity of the bitmap is nearly fine enough.  You
really want a bad-block-list.  That will of course be limited in size.


> >=20
> > This "semi" state can be different - f.e., one is where md
> > tries all normal operations on the drive and redirects failed
> > reads to other drives (with continued attempts to re-write
> > bad data) and continues writing normally, marking all failed
> > writes in the bitmap.  Let's say it is "semi-working" state.
> > Another is when no regular I/O is happening to it except of
> > the critical situations when _another_ drive becomes unreadable
> > in some place - so md will try to reconstruct that data based
> > on this semi-failed drive in a hope that those places will
> > be read successfully.  And other variations of the same theme...
> >=20
> > At the very least, maybe we should prevent md from kicking
> > the last component device which makes the array unusable, like
> > failed second drive on raid5 config - even if it has a bad
> > sector, the array was 99.9% fine before md kicked it out,
> > but after kicking it, the array is 100% dead...  This does
> > not look right to me.
> >=20
> > Also, what's the way to assemble this array now?  We've almost
> > resynced hot spare, a failed-at-the-end drive (the second
> > failed one), and a non-fresh first failed drive which is in
> > good condition, just outdated.  Can mdadm be forced to assemble
> > the array from good drives plus second-failed drive?, maybe in
> > read-only mode (this will let us to copy data which is still
> > readable to another place)?
> >=20
> > I'd try to re-write the bad places on second-failed drive based
> > on the information on good drives plus data from first-failed
> > drive, -- it is obvious that those places still can be reconstructed,
> > because even when the filesystem were in use during (attempt to)
> > resync, no changes were made to the problematic areas, so there,
> > first-failed drive still can be used.  But this - at this stage -
> > is rather tricky, i'll need to write a program to help me, and
> > made it bug-free to be useful.
> >=20
> > All in all, it still looks like md has very good potential for
> > improvements wrt reliability... ;)

The bad-block-log should help reliability in some of these cases.
It would probably make sense to provide a utility which will access the
bad-block-list for a device and recover the blocks from some other device -
in you case the blocks that could not be recovered to the spare could then =
be
recovered from the original device.

Also, regular scrubbing should significantly reduce the chance of hitting a
bad read during a recovery.

> >=20
> > (The system in question belongs to one of a very well-known
> > organisations in free software, and it is (or was) the main
> > software repository)

so they naturally had backups :-)

NeilBrown

--Sig_/ZKgVXWtGr9egWCd5UCkBVJr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUpKE8znsnt1WYoG5AQKnbQ/+JwLV4MuhrZ0VJNx7Y1ytjgy2e7zuLsrm
XTfyBPXSUVR8M1RSw0LXP6xMD1uvAHFgUaP9Y5thQleCQPDDrJWN+P48tW7HItMe
EaB6sXO/Xm+YxTNrklgXPkjFw6IIVCIMzP9gZ1C3mwwsPo3qwJZHxTpXdLxSEvpB
i28VOMz7uptIC6vZQkZwjlBP7nKW1fxmsH1wtGWimy6CzoZSQM6vk+D8691GUNDU
OBe6krUm4QgImLOnNHYbWOVSSlnoND7FbgC2aha+VVevLWPQSJ43lCb6aJIkz1ke
xRhUfzWqRLpQRM6LfwQ+OUEdu5iE/7jhMR8kgOJ7KHOh5OaLpfyf5+WhqT5bj6aQ
jr+3s9whdKK8+heh5K8FlwxHMRNj9nJRV5kIQXWpwIyyo841lTnQ5Mdm67TTEQ70
NhpBQdyaNKNIsSkgn5M0mLCNCcYXyb/lbQZO/wYH1zlSHZiF4/YOzmovidhcIGIY
TXvkHGsDIpSBb4f0Cz7qUNibO1uCXUqEG1PBRL+fS9WUjW0mbfYtZi8RZq8j1xVS
9+Ao1TqzhsihgB5qGNvlELdUM1EtTbvp/eVMPDkD87m+Kjycq1eOdTRpRhb4X2dy
6+JTzZKvs3MsRYIpzX8C9xD5Cg9NPYAmLxXSNDn03660HWT9nh7FBdQ2dPOslipR
sOT8mychF+s=
=hPZ9
-----END PGP SIGNATURE-----

--Sig_/ZKgVXWtGr9egWCd5UCkBVJr--
