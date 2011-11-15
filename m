From: NeilBrown <neilb@suse.de>
Subject: Re: Reshape 3-drive RAID1 into 3-drive RAID-5
Date: Wed, 16 Nov 2011 10:40:45 +1100
Message-ID: <20111116104045.74041bdf@notabene.brown>
References: <CAK2H+ed1M=_N5rW5Y72Cm0_74ii=-9dCMsB7xJR4FGMST4rCjA@mail.gmail.com>
	<4EC2D58F.3070508@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/QsOKOuMnftcm2c.5xdBsHu8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EC2D58F.3070508@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Mark Knecht <markknecht@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/QsOKOuMnftcm2c.5xdBsHu8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 15 Nov 2011 16:11:43 -0500 Phil Turmel <philip@turmel.org> wrote:

> Hi Mark,
>=20
> On 11/15/2011 10:13 AM, Mark Knecht wrote:
> > Hi all,
> >    I have an existing 3-drive RAID-1 (md6) that I use as a short term
> > backup device for a 5-drive RAID-6 (md7) on this machine. The _only_
> > purpose of this internal backup RAID-1 is to protect against a
> > fat-finger 'oops' event when using VMWare or Virtualbox VMs on md7.
> > Real data backups happen over the network to other machines but that's
> > slow and only gets done about once a week. With this local storage I
> > can do it in just a few minutes every day.
> >=20
> >    I recently reshaped the RAID-6 from a 5-drive RAID-1and now it's
> > larger than this local backup so I can't get everything backed up any
> > more. I.e. - I need /dev/md6 large enough to back up /dev/md7. With 3
> > existing 235GB partitions I believe the RAID-5 will be about 470GB
> > when complete and therefore large enough to hold my 400GB RAID-6 data.
> >=20
> >    I would like to verify that the right commands to do this would be:
> >=20
> > umount /dev/md6
> > mdadm --stop /dev/md6
> > mdadm --create /dev/md6 --level=3D5 --raid-devices=3D3 /dev/sda6 /dev/s=
db6 /dev/sdc6
>=20
> This will blow away the contents, but will otherwise work.  After the
> --create, MD will spend time generating parity for the third disk from
> the other two.
>=20
> >    If these commands are wrong or anyone thinks there are other things
> > I should be doing at this time please speak up as I'm interested.
> >=20
> >    The data that's currently on the backup is not terribly important
> > but if possible I'd like to keep it through this process unless doing
> > so makes things more difficult. The time it takes to do this reshape
> > is not terribly important to me.
>=20
> In your case, the data can be retained, and even remain in use, as follow=
s:
>=20
> 1) Drop the third device and wipe its superblock.
>=20
> mdadm /dev/md6 --fail /dev/sdc6 --remove /dev/sdc6
> mdadm --zero-superblock /dev/sdc6

1a/ Convert the 2-drive RAID1 to a 2-drive RAID1:
  mdadm --grow /dev/md6 --raid-devices=3D2

>=20
> 2) Convert 2-drive raid1 to 2-drive raid5.  Due to a quirk of the parity =
math, the second drive contains the same data as the first, and Neil has op=
timized this conversion to be instant.  (I don't know what version that bec=
ame true, but I believe it has been a while.)
When RAID1->RAID5 conversion was first implemented it was instant - 2.6.30.

>=20
> mdadm /dev/md6 --grow --level=3D5
>=20
> 3) Add third drive as a spare:
>=20
> mdadm /dev/md6 --add /dev/sdc6
>=20
> 4) Reshape/grow to use the new space.  MD will re-arrange the blocks and =
compute parity as it goes, without disturbing the running filesystem.  You =
probably need a backup-file option as well...  mdadm will tell you if it ne=
eds it.

You won't.  Backups is only needed for the first 6 stripes, and the spare c=
an
be used for that.

>=20
> mdadm /dev/md6 --grow --raid-devices=3D3
>=20
> 5) Resize your filesystem to use the additional space.
>=20
> .... (varies, some FS can do it on the run.)
>=20
> >=20
> > Thanks,
> > Mark
>=20
> HTH,
>=20
> Phil

NeilBrown

--Sig_/QsOKOuMnftcm2c.5xdBsHu8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTsL4hznsnt1WYoG5AQKbbQ//VmccsOIVVb/aWHCoT8O6yNcdg3WwS+UZ
XSjAyogwZhb0siOInTj1jiH7o2562mlky85zGApGEGN48XkfjEmO3GM4GsuMdhzi
sf55Bd0pF4JuSLp6zVKxzC2Ueuu+JN/CFCTl0d1JA6UDosT3Q3QXDA746BEmIaBb
YXqY6/704Khe0yl9l5iRM9gh74fkmylZLaS68a2RHwDnHV1PcFp9g7UTrkkwuDUU
xmP7ffgVcpAdBCPCdzMCmg6Dy2g0Y1oEA8hx6qhSkLVanOBdsus0XrBslZ4e1x2I
9RBegIDMJ2AaKk1oZvBrOFsEWcve/3Zp0DI7ibUi20ho3dMo/UkoEGBFontSPxXk
zZY9K5SLUs22EoYuNiWI/B8QbdB/VUiTSfZ5c3mSjDDf0ykztmXrfLB15AFTv9vA
UWoHQhwUz3MILLt6/2L7lGl28uSwRaC6sHv8WKePplnVjLLFXvtWVX3goD6iWKHZ
CJQeANIaodNUVGqQZpx5+ObrWckplMH/sNX5SMrEU8myveSwEucphR+hJzMFTWoZ
SRDIUA6Rokz8hKfNjX67cNEkcGJMTE13Qb1doOWZx6HT0E20NT9RiJVx+X/6lkJn
ffUTAEjIXwAB9CsNFXqFzCdeMWY9v8VnyvKY0+i8sHV8EhIrFvC7GnZe+s8Z//0P
sKJ2xsVJhYM=
=mc/X
-----END PGP SIGNATURE-----

--Sig_/QsOKOuMnftcm2c.5xdBsHu8--
