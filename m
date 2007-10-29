From: Doug Ledford <dledford@redhat.com>
Subject: Re: Raid-10 mount at startup always has problem
Date: Mon, 29 Oct 2007 13:08:12 -0400
Message-ID: <1193677692.10336.475.camel@firewall.xsintricity.com>
References: <46D3147D.2040201@amfes.com> <46D49F1A.7030409@tmr.com>
	 <46E4A39C.8040509@amfes.com> <46E4A5F0.9090407@sauce.co.nz>
	 <46E4A7C3.1040902@amfes.com> <471F5542.3020504@amfes.com>
	 <471FA485.6010705@tmr.com>  <47202D17.3040000@amfes.com>
	 <1193294406.10336.76.camel@firewall.xsintricity.com>
	 <472576A5.3030603@amfes.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PxLA9TVOMBG1qpCLG5DP"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <472576A5.3030603@amfes.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Daniel L. Miller" <dmiller@amfes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-PxLA9TVOMBG1qpCLG5DP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-10-28 at 22:59 -0700, Daniel L. Miller wrote:
> Doug Ledford wrote:
> > Anyway, I happen to *like* the idea of using full disk devices, but the
> > reality is that the md subsystem doesn't have exclusive ownership of th=
e
> > disks at all times, and without that it really needs to stake a claim o=
n
> > the space instead of leaving things to chance IMO.
> >  =20
> I've been re-reading this post numerous times - trying to ignore the=20
> burgeoning flame war :) - and this last sentence finally clicked with me.
>=20
> As I'm a novice Linux user - and not involved in development at all -=20
> bear with me if I'm stating something obvious.  And if I'm wrong -=20
> please be gentle!
>=20
> 1.  md devices are not "native" to the kernel - they are=20
> created/assembled/activated/whatever by a userspace program.

My real point was that md doesn't own the disks, meaning that during
startup, and at other points in time, software other than the md stack
can attempt to use the disk directly.  That software may be the linux
file system code, linux lvm code, or in some case entirely different OS
software.  Given that these situations can arise, using a partition
table to mark the space as in use by linux is what I meant by staking a
claim.  It doesn't keep the linux kernel from using it because it thinks
it owns it, but it does stop other software from attempting to use it.

> 2.  Because md devices are "non-native" devices, and are composed of=20
> "native" devices, the kernel may try to use those components directly=20
> without going through md.

In the case of superblocks at the end, yes.  The kernel may see the
underlying file system or lvm disk label even if the md device is not
started.

> 3.  Creating a partition table somehow (I'm still not clear how/why)=20
> reduces the chance the kernel will access the drive directly without md.

The partition table is more to tell other software that linux owns the
space and to avoid mistakes where someone runs fdisk on a disk
accidentally and wipes out your array because they added a partition
table on what they thought was a new disk (more likely when you have
large arrays of disks attached via fiber channel or such than in a
single system).  Putting the superblock at the beginning of the md
device is the main thing that guarantees the kernel will never try to
use what's inside the md device without the md device running.

> These concepts suddenly have me terrified over my data integrity.  Is=20
> the md system so delicate that BOOT sequence can corrupt it?

If you have your superblocks at the end of the devices, then there are
certain failure modes that can cause data inconsistencies.  Generally
speaking they won't harm the array itself, it's just that the different
disks in a raid1 array might contain different data.  If you don't use
partitions, then the majority of failure scenarios involve things like
accidental use of fdisk on the unpartitioned device, access of the
device by other OSes, that sort of thing.

>   How is it=20
> more reliable AFTER the completed boot sequence?

Once the array is up and running, the constituent disks are marked as
busy in the operating system, which prevents other portions of the linux
kernel and other software in general from getting at the md owned disks.

> Nothing in the documentation (that I read - granted I don't always read=20
> everything) stated that partitioning prior to md creation was necessary=20
> - in fact references were provided on how to use complete disks.  Is=20
> there an "official" position on, "To Partition, or Not To Partition"? =20
> Particularly for my application - dedicated Linux server, RAID-10=20
> configuration, identical drives.
>=20
> And if partitioning is the answer - what do I need to do with my live=20
> dataset?  Drop one drive, partition, then add the partition as a new=20
> drive to the set - and repeat for each drive after the rebuild finishes?

You *probably*, and I emphasize probably, don't need to do anything.  I
emphasize it because I don't know enough about your situation to say so
with 100% certainty.  If I'm wrong, it's not my fault.

Now, that said, here's the gist of the situation.  There are specific
failure cases that can corrupt data in an md raid1 array mainly related
to superblocks at the end of devices.  There are specific failure cases
where an unpartitioned device can be accidentally partitioned or where a
partitioned md array in combination with superblocks at the end and
using a whole disk device can be misrecognized as a partitioned normal
drive.  There are, on the other hand, cases where it's perfectly safe to
use unpartitioned devices, or superblocks at the end of devices.  My
recommendation when someone asks what to do is to use partitions, and to
use superblocks at the beginning of the devices (except for /boot since
that isn't supported at the moment).  The reason I give that advice is
that I assume if a person knows enough to know when it's safe to use
unpartitioned devices, like Luca, then they wouldn't be asking me for
advice.  So since they *are* asking my advice, and since a lot of the
failure cases have as much to do with human error as they do with
software error, and since human error always seems to find new ways to
err, it's therefore impossible to list all the error cases, and so it's
best just to give the known safe advice.

Just because you heard the advice after creating your arrays is no
reason to panic though.  Since the disks are local to your linux server
and not attached via a fiber channel network or something similar, about
2/3rds of the failure cases drop away immediately.  And given that you
are using raid10 instead of raid1, the possible silent inconsistency
issue drops away.  All in all, your pretty safe.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-PxLA9TVOMBG1qpCLG5DP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHJhN8TzP9PM7pjw8RAnXnAJ0YIYVklqyOIfSeXHuRMDMV60T/5ACfQMD4
Ccs/wM8XEkW23Kp+6jbZW0U=
=GAGy
-----END PGP SIGNATURE-----

--=-PxLA9TVOMBG1qpCLG5DP--

