From: Doug Ledford <dledford@redhat.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Sat, 20 Oct 2007 09:11:57 -0400
Message-ID: <1192885917.1666.112.camel@firewall.xsintricity.com>
References: <18200.49267.763509.924873@stoffel.org>
	 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
	 <18200.53593.687483.120827@stoffel.org>
	 <1192810534.1666.68.camel@firewall.xsintricity.com>
	 <18200.56684.14194.630264@stoffel.org>
	 <1192813877.1666.79.camel@firewall.xsintricity.com>
	 <18200.63987.514073.184865@stoffel.org>
	 <20071019212303.GB2013@teal.hq.k1024.org>
	 <1192830129.1666.103.camel@firewall.xsintricity.com>
	 <20071020075349.GA17431@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-m5ASuyfL9NwMverolq6N"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071020075349.GA17431@teal.hq.k1024.org>
Sender: linux-raid-owner@vger.kernel.org
To: Iustin Pop <iusty@k1024.org>
Cc: John Stoffel <john@stoffel.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-m5ASuyfL9NwMverolq6N
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-10-20 at 09:53 +0200, Iustin Pop wrote:

> Honestly, I don't see how a properly configured system would start
> looking at the physical device by mistake. I suppose it's possible, but
> I didn't have this issue.

Mount by label support scans all devices in /proc/partitions looking for
the filesystem superblock that has the label you are trying to mount.
LVM (unless told not to) scans all devices in /proc/partitions looking
for valid LVM superblocks.  In fact, you can't build a linux system that
is resilient to device name changes without doing that.

> It's not only about the activation of the array. I'm mostly talking
> about RAID1, but the fact that migrating between RAID1 and plain disk is
> just a few hundred K at the end increases the flexibility very much.

Flexibility, no.  Convenience, yes.  You can do all the things with
superblock at the front that you can with it at the end, it just takes a
little more effort.

> Also, sometime you want to recover as much as possible from a not intact
> copy of the data...

And you can with superblock at the front.  You can create a new single
disk raid1 over the existing superblock or you can munge the partition
table to have it point at the start of your data.  There are options,
they just require manual intervention.  But if you are trying to rescue
data off of a seriously broken device, you are already doing manual
intervention anyway.

> Of course, different people have different priorities, but as I said, I
> like that this conversion is possible, and I never had the case of a
> tool saying "hmm, /dev/md<something> is not there, let's look at
> /dev/sdc instead".

mount, pvscan.

> thanks,
> iustin
--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-m5ASuyfL9NwMverolq6N
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHGf6dTzP9PM7pjw8RAtq5AJ0eszaJPZYDAYUr2ka3vcTxHwdMGgCfU858
T2rppCCVl5EuNEY0JMkjl1Y=
=LuXg
-----END PGP SIGNATURE-----

--=-m5ASuyfL9NwMverolq6N--

