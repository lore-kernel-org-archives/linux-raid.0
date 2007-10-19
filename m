From: Doug Ledford <dledford@redhat.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Fri, 19 Oct 2007 13:23:01 -0400
Message-ID: <1192814581.1666.87.camel@firewall.xsintricity.com>
References: <18200.49267.763509.924873@stoffel.org>
	 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
	 <18200.53593.687483.120827@stoffel.org>
	 <1192810534.1666.68.camel@firewall.xsintricity.com>
	 <18200.56684.14194.630264@stoffel.org>
	 <Pine.LNX.4.64.0710191239250.27246@p34.internal.lan>
	 <18200.57042.989520.666476@stoffel.org>
	 <Pine.LNX.4.64.0710191245230.7849@p34.internal.lan>
	 <1192813477.1666.74.camel@firewall.xsintricity.com>
	 <Pine.LNX.4.64.0710191305130.9497@p34.internal.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-P0zmd3K+YuN3+FkTJzSt"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0710191305130.9497@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-P0zmd3K+YuN3+FkTJzSt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-10-19 at 13:05 -0400, Justin Piszcz wrote:

> > I'm sure an internal bitmap would.  On RAID1 arrays, reads/writes are
> > never split up by a chunk size for stripes.  A 2mb read is a single
> > read, where as on a raid4/5/6 array, a 2mb read will end up hitting a
> > series of stripes across all disks.  That means that on raid1 arrays,
> > total disk seeks < total reads/writes, where as on a raid4/5/6, total
> > disk seeks is usually > total reads/writes.  That in turn implies that
> > in a raid1 setup, disk seek time is important to performance, but not
> > necessarily paramount.  For raid456, disk seek time is paramount becaus=
e
> > of how many more seeks that format uses.  When you then use an internal
> > bitmap, you are adding writes to every member of the raid456 array,
> > which adds more seeks.  The same is true for raid1, but since raid1
> > doesn't have the same level of dependency on seek rates that raid456
> > has, it doesn't show the same performance hit that raid456 does.

> Got it, so for RAID1 it would make sense if LILO supported it (the=20
> later versions of the md superblock)

Lilo doesn't know anything about the superblock format, however, lilo
expects the raid1 device to start at the beginning of the physical
partition.  In otherwords, format 1.0 would work with lilo.

>  (for those who use LILO) but for
> RAID4/5/6, keep the bitmaps away :)

I still use an internal bitmap regardless ;-)  To help mitigate the cost
of seeks on raid456, you can specify a huge chunk size (like 256k to 2MB
or somewhere in that range).  As long as you can get 90%+ of your
reads/writes to fall into the space of a single chunk, then you start
performing more like a raid1 device without the extra seek overhead.  Of
course, this comes at the expense of peak throughput on the device.
Let's say you were building a mondo movie server, where you were
streaming out digital movie files.  In that case, you very well may care
more about throughput than seek performance since I suspect you wouldn't
have many small, random reads.  Then I would use a small chunk size,
sacrifice the seek performance, and get the throughput bonus of parallel
reads from the same stripe on multiple disks.  On the other hand, if I
was setting up a mail server then I would go with a large chunk size
because the filesystem activities themselves are going to produce lots
of random seeks, and you don't want your raid setup to make that problem
worse.  Plus, most mail doesn't come in or go out at any sort of massive
streaming speed, so you don't need the paralllel reads from multiple
disks to perform well.  It all depends on your particular use scenario.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-P0zmd3K+YuN3+FkTJzSt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHGOf0TzP9PM7pjw8RAuNVAJ4pU5Tq9wa+vn4Q1bTV3n5NUxpqcgCfYtXm
PiQHpOhuXutIXM/XefnBO+o=
=O2zM
-----END PGP SIGNATURE-----

--=-P0zmd3K+YuN3+FkTJzSt--

