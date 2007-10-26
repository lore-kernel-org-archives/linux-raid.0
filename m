From: Doug Ledford <dledford@redhat.com>
Subject: Re: Raid-10 mount at startup always has problem
Date: Fri, 26 Oct 2007 15:26:33 -0400
Message-ID: <1193426793.10336.302.camel@firewall.xsintricity.com>
References: <46D3147D.2040201@amfes.com> <46D49F1A.7030409@tmr.com>
	 <46E4A39C.8040509@amfes.com> <46E4A5F0.9090407@sauce.co.nz>
	 <46E4A7C3.1040902@amfes.com> <471F5542.3020504@amfes.com>
	 <471FA485.6010705@tmr.com> <47202D17.3040000@amfes.com>
	 <1193294406.10336.76.camel@firewall.xsintricity.com>
	 <20071026091513.GB32550@percy.comedia.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-faXgCSqh6/7NZ2i4McWB"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071026091513.GB32550@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-faXgCSqh6/7NZ2i4McWB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-10-26 at 11:15 +0200, Luca Berra wrote:
> On Thu, Oct 25, 2007 at 02:40:06AM -0400, Doug Ledford wrote:
> >The partition table is the single, (mostly) universally recognized
> >arbiter of what possible data might be on the disk.  Having a partition
> >table may not make mdadm recognize the md superblock any better, but it
> >keeps all that other stuff from even trying to access data that it
> >doesn't have a need to access and prevents random luck from turning your
> >day bad.
> on a pc maybe, but that is 20 years old design.

So?  Unix is 35+ year old design, I suppose you want to switch to Vista
then?

> partition table design is limited because it is still based on C/H/S,
> which do not exist anymore.
> Put a partition table on a big storage, say a DMX, and enjoy a 20%
> performance decrease.

Because you didn't stripe align the partition, your bad.

> >Oh, and let's not go into what can happen if you're talking about a dual
> >boot machine and what Windows might do to the disk if it doesn't think
> >the disk space is already spoken for by a linux partition.
> Why the hell should the existance of windows limit the possibility of
> linux working properly.

Linux works properly with a partition table, so this is a specious
statement.

> If i have a pc that dualboots windows i will take care of using the
> common denominator of a partition table, if it is my big server i will
> probably not. since it won't boot anything else than Linux.

Doesn't really gain you anything, but your choice.  Besides, the
question wasn't "why shouldn't Luca Berra use whole disk devices", it
was why I don't recommend using whole disk devices, and my
recommendation wasn't based in the least bit upon a single person's use
scenario.

> >And, in particular with mdadm, I once created a full disk md raid array
> >on a couple disks, then couldn't get things arranged like I wanted, so I
> >just partitioned the disks and then created new arrays in the partitions
> >(without first manually zeroing the superblock for the whole disk
> >array).  Since I used a version 1.0 superblock on the whole disk array,
> >and then used version 1.1 superblocks in the partitions, the net result
> >was that when I ran mdadm -Eb, mdadm would find both the 1.1 and 1.0
> >superblocks in the last partition on the disk.  Confused both myself and
> >mdadm for a while.
> yes, this is fun
> On the opposite, i once inserted an mmc memory card, which had been
> initialized on my mobile phone, into the mmc slot of my laptop, and was
> faced with a load of error about mmcblk0 having an invalid partition
> table.

So?  The messages are just informative, feel free to ignore them.

>  Obviously it had none, it was a plain fat filesystem.
> Is the solution partitioning it? I don't think the phone would
> agree.

The phone dictates the format, only a moron would say otherwise.  But,
then again, the phone doesn't care about interoperability and many other
issues on memory cards that it thinks it owns, so only a moron would
argue that because a phone doesn't use a partition table that nothing
else in the computer realm needs to either.

> >Anyway, I happen to *like* the idea of using full disk devices, but the
> >reality is that the md subsystem doesn't have exclusive ownership of the
> >disks at all times, and without that it really needs to stake a claim on
> >the space instead of leaving things to chance IMO.
> Start removing the partition detection code from the blasted kernel and
> move it to userspace, which is already in place, but it is not the
> default.

Which just moves where the work is done, not what work needs to be done.
It's a change for no benefit and a waste of time.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-faXgCSqh6/7NZ2i4McWB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHIj9pTzP9PM7pjw8RAqYpAJ9fvIzo6X5hTPrc1vEdhSFGB3V3wQCfXlYV
vJTs2V84VWIb58JqJfqSRHE=
=7gHU
-----END PGP SIGNATURE-----

--=-faXgCSqh6/7NZ2i4McWB--

