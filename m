From: NeilBrown <neilb@suse.de>
Subject: Re: md metadata nightmare
Date: Thu, 24 Nov 2011 09:36:37 +1100
Message-ID: <20111124093637.0c3bb2eb@notabene.brown>
References: <CADzwnhXWvkVC13ZEJj8L0O6PLXLS6uhoBXqoLp67YwmeU60sQQ@mail.gmail.com>
	<20111123114743.1085889e@notabene.brown>
	<CADzwnhUJ7HbZH9yqa6x9sHFLo8Vg=1k_SyzvZyq2=iQ5YRLhZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/sf.ZHWqc80mGXnoxeRQuDY0"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADzwnhUJ7HbZH9yqa6x9sHFLo8Vg=1k_SyzvZyq2=iQ5YRLhZQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kenneth Emerson <kenneth.emerson@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/sf.ZHWqc80mGXnoxeRQuDY0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Nov 2011 16:17:52 -0600 Kenneth Emerson
<kenneth.emerson@gmail.com> wrote:

> On Tue, Nov 22, 2011 at 6:47 PM, NeilBrown <neilb@suse.de> wrote:
> > On Tue, 22 Nov 2011 18:05:21 -0600 Kenneth Emerson
> > <kenneth.emerson@gmail.com> wrote:
> >
> >> NOTE: I have set the linux-raid flag on all of the partitions in the
> >> GPT. I think I have read in the linux-raid archives that this is not
> >> recommended. Could this have had an affect on what transpired?
> >
> > Net recommended, but also totally ineffective.  The Linux-RAID partition
> type
> > is only recognised in MS-DOS partition tables.
> >
>=20
> I will remove these flags.
>=20
> >>
> >> So my question is:
> >>
> >> Is there a way, short of backing up the data, completely rebuilding
> >> the arrays, and restoring the data (a real PIA) to rewrite the
> >> metadata given the existing array configurations in the running
> >> system?  Also, is there an explanation as to why the metadata seems so
> >> screwed up that the arrays cannot be assembled automatically by the
> >> kernel?
> >
> > There appear to be two problems here.  Both could be resolved by
> converting to
> > v1.0 metadata.  But there are other approaches.  And converting to v1.0=
 is
> > not trivial (not enough developers to work on all the tasks!).
> >
>=20
> Here, I assume you mean providing a utility to upgrade the metatdata is
> daunting since
> below you give me instructions on how to do this with a brute-force metho=
d.

Yes.

"trivial" would mean you could:

  mdadm --stop /dev/md3
  mdadm --assemble /dev/md03 --update=3Dmetadata --metadata=3D1.0 /dev/sd[a=
bcd]4

and it would "get it right.
Writing the code in mdadm to do that isn't exactly "daunting", it just isn't
near the top of my list.
It would do almost exactly the same steps as I told you do to manually.



>=20
>=20
> > One problem is the final partition on at least some of your disks is at=
 a
> 64K
> > alignment.  This means that the superblock looks valid for both the who=
le
> > device and for the partition.
> > You can confirm this by running
> >  mdadm --examine /dev/sda
> >  mdadm --examine /dev/sda4
> >
> > (ditto for b,c,d,e,...)
> >
> > The "sdX4" should show a superblock.  The 'sdX' should not.
> > I think it will show exactly the same superblock.  It could show a
> different
> > superblock... that would be interesting.
> >
> I still have not re-installed the original sda drive, but the sde drive
> (which is now sdd)
> showed the similar problem where the kernel tried to build an array with
> the entire drive.
> When I look at the --examine on sdd and on sdd4 (and sdd1,2,3 as well),
> none are exactly
> the same (I assume that the output would be exactly the same if it were t=
he
> same superblock).
> I get different UUID's and time stamps as well as RAID types.

In that case you could probably just remove them with e.g.
  mdadm --zero /dev/sdd

That will write zeros over the superblock it finds which is another way you
can stop mdadm from being confused by it.


>=20
>=20
> > If I am correct here then you can "fix" this by changing mdadm.conf to
> read:
> >
> > DEVICES /dev/sda? /dev/sdb? /dev/sdc? /dev/sdd? /dev/sde?
> > or
> > DEVICES /dev/sd[abcde][1-4]
> >
> > or similar.  i.e. tell it to ignore the whole devices.
>=20
> I actually did this at one time, and it was better, but it still did not
> assemble the correct arrays.
> I will, however, change my current .conf file to ignore the whole drives.
>=20
> >
> > The other problem is that v0.90 metadata isn't good with very large
> devices.
> > It has 32bits to record kilobytes per device.
> > This show allow 4TB per device but due to a bug (relating to sign bits)=
 it
> > only works well with 2TB per device.  This bug was introduced in 2.6.29
> and
> > removed in 3.1.
> >
> > So if you can run a 3.1.2 kernel, that would be best.
> >
> OK. Now you have me worried.  Is this "bug" benign or is it a ticking time
> bomb?  If I do
> the conversion (below) to version 1.0 will that circumvent the problem?

Not sure what you mean by "time bomb".
The bug means that when you assemble an array with devices larger than 2TB,
the effective size has 2TB subtracted from it so you only see the beginning
of the array.

1.0 doesn't have this bug (it uses 64bit sizes) so after conversion the bug
will not affect you.


>=20
> > You could convert to v1.0 if you want.  You only need to do this for the
> last
> > partition (sdX4).
> >
> > Assuming nothing has changed since the "--detail" output you provided, =
you
> > should:
> >
> >  mdadm -S /dev/md3
> >  mdadm -C /dev/md3 --metadata=3D1.0 --chunk=3D64k --level=3D6 --raid-de=
vices=3D5 \
> >      missing /dev/sdb4 /dev/sdc4 /dev/sda4 /dev/sdd4 \
> >      --assume-clean
> >
> > The order of the disks is import.  You should compare it with the output
> > of "mdadm --detail" before you start to ensure that it is correct and I
> have
> > made any typos.  You should of course check the rest as well.
> > After doing this (and possibly before) you should 'fsck' to ensure the
> > transition was successful.  If anything goes wrong, ask before risking
> > further breakage.
> >
> I will do this conversion; but I will backup my data as best I can first,
> just in case.
> I still have the 5 1TB drives and my data should fit on there, just a PIA
> to do it.
> (Ahh, that's what weekends are for, right?)
> After the RAID6 is repaired and running OK, I believe I will rebuild the 2
> RAID1 arrays
> as that will be an easy project (since I have 5 copies of everything) whi=
ch
> will get rid of
> all vestiges of previous raid arrays.  Do I need to anything special other
> than zeroing
> the superblocks (--zero-superblock)?  Also, shouldn't I do that on the
> RAID6 array before
> doing the create or is that done automagically?

It is done automatically.  When you use "--create", mdadm will zero any
superblocks it finds of any format that it recognises, then write the new
metadata it wants.

>=20
> > Good luck.
> >
> Hopefully, luck has nothing to do with it, but I'll take it where I can g=
et
> it.  Lucky is
> better than good any day in my book.  ;-)
>=20
> Thank you very much for your insight and experience.  I'll let you know h=
ow
> it turns out.
>=20
> -- Ken Emerson
>=20
> > NeilBrown
> >
> >


:-)

NeilBrown

--Sig_/sf.ZHWqc80mGXnoxeRQuDY0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTs11ejnsnt1WYoG5AQIzkQ//bVZ8sA0vXHgjA+lt/eltR3J072bejarQ
wOuxBzFqg3kPKSRu67vvrOO+C+xe3hx9/8V5NuRj24JbeIyB8X8HjX7UAITr78KZ
Ig1y05SRt81wMlZnLH2b10yvL+XUZDd5CvGA8zaas/ysNrZ8XgA5mSxe9ytnrccB
gFLandkk5cplaRbaocu5npB0cQRZWUg7LUW1mrlMLuFenOVbYgQzSyU+Xu60iH1q
GvIklH5ssofQiUUZyHaJiNtRT/4ZWblgYFH3TWZeyZA2xfOkfK2IDwtrc7rz3fUR
OQLAisvheM+Px6xEG+r/p+RrdHtqPt5vMJHcBQlP4iH0frVIDdyYVKy8y2Gzrqji
tNWOZ+BiMJ84D3adk2VFBxJsASVU/V+z4nI8kWafnAGf5OusO6meTvtdBEzoVS7H
OWDE0Vsty2nhsHTpQE7ymmaXNujvI22b+T6J0tQo3gXi5fC42U1AS1XedFlbapiD
+Xoz7EMqyd4Gvr1GlZO76xYjUI/Aasl3uzKVKVnSgHnahYUyfycD+d48Vab+SxIy
gd9EXYayECwzHn6l9sGjCOsb6blz7CcoGAiMUI6LRWuTW/ucc7Bd2BPOvqBbgVX2
fp9SQ4qkKQQRLqeS64Rnbpin9qYmkgRmcOdTU7hCOSggaqLZRkLJ4WcZl5LcR2XS
E/fUfkSNWO0=
=6ehX
-----END PGP SIGNATURE-----

--Sig_/sf.ZHWqc80mGXnoxeRQuDY0--
