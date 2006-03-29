From: Technomage <technomage-hawke@cox.net>
Subject: recovering data on a failed raid-0 installation
Date: Tue, 28 Mar 2006 22:08:46 -0700
Message-ID: <200603282208.47214.technomage-hawke@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

ok,
here's the situation in a nutshell.

one of the 2 HD's in a linux raid-0 installation has failed.

=46ortunately, or otherwise, it was NOT the primary HD.

problem is, I need to recover data from the first drive but appear to b=
e=20
unable to do so because the raid is not complete. the second drive only=
 had=20
193 MB written to it and I am fairly certain that the data I would like=
 to=20
recover is NOT on that drive.

can anyone offer any solutions to this?

the second HD is not usable (heat related failure issues).=20

The filesystem used on the md0 partition (under mdadm) was xfs. now I h=
ave=20
tried the xfs_check and xfs_repair tools and they are not helpful at th=
is=20
point.

The developer (of mdadm) suggested I use the following commands in an a=
ttempt=20
to recover:

  mdadm -C /dev/md0 -l0 -n2 /dev/......
  fsck -n /dev/md0

However, the second one was a no go.

I am stumped as to how to proceed here. I need the data off the first d=
rive,=20
but do not appear to have any way (other than using cat to see it) to g=
et at=20
it.

some help would be greatly appreciated.

technomage

p. here is the original response sent back to me from the developer of =
mdadm:
***************************
Re: should have been more explicit here -> Re: need some help <URGENT!>
=46rom: Neil Brown <neilb@suse.de>
To: Technomage <technomage-hawke@cox.net>
Date: Sunday 22:01:45
On Sunday March 26, technomage-hawke@cox.net wrote:
> ok,
>=20
> you gave me more info than some local to that mentioned e-mail list.
>=20
> ok, the vast majority of the data I need to recover is on /dev/hda=20
> and /dev/hdb only has 193 MB and is probably irrelevant.
>=20
> can you help me with this?
> can you baby me through this. I really need to recover this data (if =
at all=20
> possible).=20

Not really, and certainly not now (I have to go out).
I have already make 2 suggestions
=A0 mail linux-raid@vger.kernel.org
and
=A0 mdadm -C /dev/md0 -l0 -n2 /dev/......
=A0 fsck -n /dev/md0

try one of those.

NeilBrown

>=20
> the friend of mine that this actually happened to is on the phone, be=
gging=20
me=20
> and grovelling before the gods of linux in order to have this fixed. =
I have=20
> setup an identical test situation here.
>=20
> the important data is on drive 1 and drive 2 is mostly irrelevant.
> is there any way to convince raid-0 to truncate to the end of drive 1=
 and=20
> allow me to get whatever data I can off. btw, the filesystem that was=
=20
> formatted was xfs (for linux) on md0.
>=20
> if you have questions, please do not hesitate to ask.
>=20
> thank you.
>=20
> p. real name here is Eric.
>=20
>=20
> On Sunday 26 March 2006 21:33, you wrote:
> > On Sunday March 26, technomage-hawke@cox.net wrote:
> >
> > With a name like "Technomage" and a vague subject "need some help
> > <URGENT>", I very really discarded your email assuming it was spam!
> >
> > Questions like this are best sent to linux-raid@vger.kernel.org.
> >
> > If one drive in a raid0 has failed non-recoverably, then half your
> > data is gone, so you are out of luck.
> >
> > Your best bet would be to recreate the raid0 in exactly the same
> > configuration as before, and see if you can find the data there.
> > e.g.
> > =A0 =A0mdadm -C /dev/md0 -l0 -n2 /dev/hda2 /dev/hdb2
> > =A0 fsck -n /dev/md0
> >
> > or something like that.
> >
> > NeilBrown
> >
> > > I recently ran into a problem after an install using mdadm. the s=
oftware
> > > raid-0 environment suffered a failure after a HD in the system fa=
iled=20
due
> > > to thermal run-away.
> > >
> > > the setup goes like this:
> > >
> > > /dev/hda has:
> > > /dev/hda1 -> boot (512 MN)
> > > /dev/hda2 -> partition 1 (linux raid autodetect)
> > >
> > > /dev/hdb has:
> > > /dev/hdb1 -> swap (512 MB)
> > > /dev/hdb2 -> partition 2 (linux raid autodetect)
> > >
> > > /dev/hdb is the drive that failed. according to a drive imager, o=
nly 129
> > > MB of data was actually written to the second raid partition (in=20
serial).
> > > unfortunately, without it, I cannot recover any data off of the f=
irst HD
> > > and I would like very much to do so. Some of this data is for my =
work as
> > > a forensics examiner.
> > >
> > > I am fairly certain that the data I need to recover is on /dev/hd=
a but=20
so
> > > far, I have been unable to read the data in any meaningful way (e=
xcept
> > > the use of cat piped through less to see if the data is, in fact,
> > > readable).
> > >
> > > can you help?
> > >
> > > thank you.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
