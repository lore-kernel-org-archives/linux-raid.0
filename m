From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm raid6 recovery status
Date: Sat, 31 Mar 2012 09:51:00 +1100
Message-ID: <20120331095100.5c6db4c0@notabene.brown>
References: <B2B36B3006DB4C47A56D6BA19443F5D12DCEB542@IU-MSSG-MBX110.ads.iu.edu>
	<20120328151148.035bd737@notabene.brown>
	<B2B36B3006DB4C47A56D6BA19443F5D12DCEB63D@IU-MSSG-MBX110.ads.iu.edu>
	<20120329102704.14b08f2a@notabene.brown>
	<B2B36B3006DB4C47A56D6BA19443F5D12DCEBA2E@IU-MSSG-MBX110.ads.iu.edu>
	<B2B36B3006DB4C47A56D6BA19443F5D12DCEBAA4@IU-MSSG-MBX110.ads.iu.edu>
	<20120330064145.6747fff0@notabene.brown>
	<B2B36B3006DB4C47A56D6BA19443F5D12DCEBDDD@IU-MSSG-MBX110.ads.iu.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4fnAwAfe_+38cXajIHe5N5s"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B2B36B3006DB4C47A56D6BA19443F5D12DCEBDDD@IU-MSSG-MBX110.ads.iu.edu>
Sender: linux-raid-owner@vger.kernel.org
To: "Paramasivam, Meenakshisundaram" <mparamas@iupui.edu>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/4fnAwAfe_+38cXajIHe5N5s
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Mar 2012 21:22:34 +0000 "Paramasivam, Meenakshisundaram"
<mparamas@iupui.edu> wrote:

>=20
> Thanks. Is it safe to fsck -n (and then fsck -y) on /dev/md2 when sdg is =
just added to md2 and is in "spare rebulding" status and recovery is only a=
t 4% completed? BTW, we got all of the data backed up.

It is certainly safe to "fsck -n" while there is a spare rebuilding.  Each
process will slow down the other but that shouldn't be a problem.
I would never say that "fsck -y" is safe without seeing the output for "fsck
-n" however the rebuilding the spare should affect the safety of "fsck -y".

And it is always nice to hear that people have their data safe -  thanks.

NeilBrown


>=20
> Background:
> When we assembled md2 we forced rest of the drives and did not include th=
is drive. After 24 hrs, when I tried to assemble all of the drives into md2=
, I got "md: kicking non-fresh sdg from array!" message through dmesg, and =
was removed from md2 (through mdadm --detail). I just did:
> # mdadm /dev/md2 --add /dev/sdg
> mdadm: re-added /dev/sdg
>=20
> Sundar
>=20
> ________________________________________
> From: NeilBrown [neilb@suse.de]
> Sent: Thursday, March 29, 2012 3:41 PM
> To: Paramasivam, Meenakshisundaram
> Cc: linux-raid@vger.kernel.org
> Subject: Re: mdadm raid6 recovery status
>=20
> On Thu, 29 Mar 2012 18:47:14 +0000 "Paramasivam, Meenakshisundaram"
> <mparamas@iupui.edu> wrote:
>=20
> >
> > Clarification:
> > >>should I do new array creation
> > I meant running newfs on assembled 12 TB array, and restore data from b=
ackup, to resolve "df" reporting problem.
>=20
> I would suggest asking on
>     linux-ext4@vger.kernel.org
>=20
> be sure to give lots of details - kernel version etc.
> It would be worth running
>    fsck -n /dev/md2
> first and see if it reports anything strange.
> Maybe  just a fsck will fix it.
>=20
> NeilBrown
>=20
>=20
> >
> > ________________________________________
> > From: Paramasivam, Meenakshisundaram
> > Sent: Thursday, March 29, 2012 1:33 PM
> > To: NeilBrown
> > Cc: linux-raid@vger.kernel.org
> > Subject: RE: mdadm raid6 recovery status
> >
> > Good news: Got ALL of our data back. [Actually it was 4.96TB not 7TB].
> >                      mdadm is a good one.
> >
> > Bad news: "df" is reporting wrong, while "du" is showing full size.
> > # df -kl /myarray
> > Filesystem           1K-blocks      Used Available Use% Mounted on
> > /dev/md2             11537161976    162432 10950945196   1% /myarray
> > # du -sk /myarray
> > 5326133556      /myarray
> > #
> >
> > I never looked into du or looked in depth of the files & folders and si=
mply got mislead by reported "df" usage; data was there all along. We defin=
itely want "df" for the array's filesystem (ext3) to report right.
> >
> > Now that we are backing up all of the data (at 400 Mbps) over network, =
I want to know if "df" reporting can be fixed easily or should I do new arr=
ay creation and restore data from backup.
> >
> > We are ordering a new RAID card, just to be on safer side.
> >
> > Sundar
> >
> > ________________________________________
> > From: NeilBrown [neilb@suse.de]
> > Sent: Wednesday, March 28, 2012 7:27 PM
> > To: Paramasivam, Meenakshisundaram
> > Cc: linux-raid@vger.kernel.org
> > Subject: Re: mdadm raid6 recovery status
> >
> > On Wed, 28 Mar 2012 12:49:18 +0000 "Paramasivam, Meenakshisundaram"
> > <mparamas@iupui.edu> wrote:
> >
> > > [root@in-rady-neuro9 ~]# df -kl /myarray
> > > Filesystem           1K-blocks      Used Available Use% Mounted on
> > > /dev/md2             11537161976    162432 10950945196   1% /myarray
> > > Should be 7TB of used space.
> >
> > This is bad.  Something has happened to your filesystem.
> > It is almost as though someone ran "mkfs" on the array.
> > I don't know much about recovery after such an action, but I doubt you
> > will get much back.
> >
> > >
> > > [root@in-rady-neuro9 ~]# cat /proc/partitions
> > > major minor  #blocks  name
> > >
> > >    8        0  438960128 sda
> > >    8        1     512000 sda1
> > >    8        2   51200000 sda2
> > >    8        3  387247104 sda3
> > >    8       16 1953514584 sdb
> > >    8       32 1953514584 sdc
> > >    8       48 1953514584 sdd
> > >    8       64 1953514584 sde
> > >    8       80 1953514584 sdf
> > >    8       96 1953514584 sdg
> > >    8      112 1953514584 sdh
> > >    8      128 1953514584 sdi
> > >  253        0  346226688 dm-0
> > >  253        1   40992768 dm-1
> >
> > No md2 ???
> >
> > >
> > > sd[b-i] are raid devices
> > >
> > > [root@in-rady-neuro9 ~]# mdadm --detail /dev/md2
> > > /dev/md2:
> > >         Version : 0.90
> > >   Creation Time : Fri Dec 16 17:56:14 2011
> > >      Raid Level : raid6
> > >      Array Size : 11721086976 (11178.10 GiB 12002.39 GB)
> > >   Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)  <<<=3D=3D=3D=
=3D=3D=3D Wrong! Should be 7TB of used array space.
> >
> > "Used Dev Size" isn't "how much of the array is used by the filesystem"=
 -
> > mdadm doesn't know anything about filesystems.
> > It is "How much of each individual device is used by the array", which =
is
> > usually a little less than the size of the smallest device.
> > So 2TB is correct here.
> >
> >
> > NeilBrown
> >
> >
>=20


--Sig_/4fnAwAfe_+38cXajIHe5N5s
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3Y41Dnsnt1WYoG5AQLXRhAAt/8M6s3akcovIyi/KoptBH/ha4/UPLJp
jJyGohIPJAR5OxV7OZzpAXaLCpy16nOYvR4YMlV+NZhAEacdHoU4tfb1kbGraqq8
w4b1bhHcyOeLau2vfM2hSZpFDvjtOONvgAUQZxyp0ylQNQuvKj2jt9UaBR2awzPA
AC/zmhbz2JyRPG0LjVXC6j+LB31yx1AU9qIVbZ+77XYUg+R4Z8YISWudpGdb10P/
pE7HVZBysVs62pvsTVROjtS+V37NS49x4KsVRnHRMLavYS5x2RcIIpoD8/d767dg
WU/F7Cdta7EKBprJXr1Wd727uFZQAyMwSl1XjS81ORQ+tIa2dNo98FFkx/xUslMr
kdIP5jhbwcSUAoLfN6g6tI7I5oIMS9hr7SmwkVFTttMHaEp1yx6u8vIVgggppHQc
CC4LyukICr9TJlDHP7BBEmNNHqwjJPvAhJJeXfHxEuVY7PZKQt/t6cGq4+5b1nND
xSPa5GUFyKNetUfuiSc56M4Pm25foDWYmBHgbXKm/9xO1SdjNGJs/0Z7/SgbeCab
IcHP+udT7Rmr6maTrK73gYl89NC8k95Lo4JLvEwf83folBM+5utnMC6SPW+xzKFO
2JOj9FVtZdeBhlEzmoj0LN3fsS8kD0C3kpbYROYMETNKzxxWg37BzGeljxiADiwX
FnHxMz64o5c=
=wcGP
-----END PGP SIGNATURE-----

--Sig_/4fnAwAfe_+38cXajIHe5N5s--
