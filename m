From: NeilBrown <neilb@suse.de>
Subject: Re: Recovering failed array
Date: Fri, 23 Sep 2011 14:15:12 +1000
Message-ID: <20110923141512.7c48f667@notabene.brown>
References: <CAB1R3sirkfauftgvNN5Sz9_ZGFaHC7_jZUD5cyRrhfARue08TQ@mail.gmail.com>
	<4E7BAE1E.9020704@turmel.org>
	<CAB1R3sgywmhCxmcVf8CmRt=KMRz7L=QJnkzXLyaPfrgnXmDXwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/NVvDc/eddB0SVGXPtxWcHQA"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB1R3sgywmhCxmcVf8CmRt=KMRz7L=QJnkzXLyaPfrgnXmDXwQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex <mysqlstudent@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/NVvDc/eddB0SVGXPtxWcHQA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 22 Sep 2011 18:39:10 -0400 Alex <mysqlstudent@gmail.com> wrote:

> Hi,
>=20
> >> Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] [line=
ar]
> >> md1 : inactive sda2[0] sdd2[4](S) sdb2[1]
> >> =A0 =A0 =A0 205820928 blocks super 1.1
> >>
> >> md0 : active raid1 sda1[0] sdd1[3] sdc1[2] sdb1[1]
> >> =A0 =A0 =A0 255988 blocks super 1.0 [4/4] [UUUU]
> >>
> >>
> >> # mdadm --add /dev/md1 /dev/sdd2
> >> mdadm: Cannot open /dev/sdd2: Device or resource busy
> >>
> >> # mdadm --run /dev/md1
> >> mdadm: failed to run array /dev/md1: Input/output error
> >>
> >> I've tried "--assemble --scan" and it also provides an IO error.
> >>
> >> mdadm.conf:
> >> # mdadm.conf written out by anaconda
> >> MAILADDR root
> >> AUTO +imsm +1.x -all
> >> ARRAY /dev/md0 level=3Draid1 num-devices=3D4
> >> UUID=3D9406b71d:8024a882:f17932f6:98d4df18
> >> ARRAY /dev/md1 level=3Draid5 num-devices=3D4
> >> UUID=3Df5bb8db9:85f66b43:32a8282a:fb664152
> >
> > Please show the output of "lsdrv" [1] and then "mdadm -D /dev/md[01]", =
and also "mdadm -E /dev/sd[abcd][12]"
> >
> > (From within your rescue environment.) =A0Some errors are likely, but g=
et what you can.
>=20
> Great, thanks for your offer to help. Great program you've written.
> I've included the output here:
>=20
> # mdadm -E /dev/sd[abcd][12]
> http://pastebin.com/3JcBjiV6
>=20
> # When I booted into the rescue CD again, it mounted md0 as md127
> http://pastebin.com/yXnzzL6K
>=20

Hmmm ... looks like a bit of a mess.  Two devices that should be active
arrays appear to be spares. I suspect you tried to --add them when you
shouldn't have.  Newer version of mdadm stop you from doing that but older
version don't.  You only --add a device that you want to be a spare, not a
device that you think is part of the array.

All of the devices think that device 2 (the third in the array) should  exi=
st
and  be working, but no device claims to be it.  Presumably it is /dev/sdc2.


You will need to recreate the array.
i.e.

 mdadm -S /dev/md1
or=20
 mdadm -S /dev/md125 /dev/md126

or whatever md arrays claim to be holding any of the 4 devices according
to /proc/mdstat.

Then

 mdadm -C /dev/md1 -e 1.1 --level 5 -n 4  --chunk 512 --assume-clean \
    /dev/sda2 /dev/sdb2 /dev/sdc2 missing

This will just re-write the metadata and assemble the array.  It won't chan=
ge
the data.
Then "fsck -n /dev/md1" and make sure it looks good.
If it does: good.
If not, try again with sdd2 in place of sdc2.

Once you are happy that you can see your data, you can add the other device
as a spare and it will rebuild.

You don't really need the --assume-clean above because a degraded RAID5 is
always assumed to be clean, but it is good practice to use --assume-clean
whenever re-creating an array which has real data on it.

Good luck,
NeilBrown

--Sig_/NVvDc/eddB0SVGXPtxWcHQA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOfAfQG5fc6gV+Wb0RAqBIAJ4vVLeHTRjESVMURiAdjDVh+rzj3QCfQB87
S+Xp16ym7Jq3Vlyz/m3lMvg=
=I3a/
-----END PGP SIGNATURE-----

--Sig_/NVvDc/eddB0SVGXPtxWcHQA--
