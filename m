From: NeilBrown <neilb@suse.de>
Subject: Re: RAID5 -> RAID6 conversion, please help
Date: Wed, 11 May 2011 10:47:30 +1000
Message-ID: <20110511104730.175372fe@notabene.brown>
References: <002a01cc0f68$1c851180$558f3480$@priv.hu>
	<20110511093155.5b1a203e@notabene.brown>
	<4DC9CCAF.9010709@crc.id.au>
	<20110511102116.494bf0fd@notabene.brown>
	<BANLkTimwg94Bz22q5J7FJTcuFvX4BpRECg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimwg94Bz22q5J7FJTcuFvX4BpRECg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dylan Distasio <interzone@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 10 May 2011 20:38:11 -0400 Dylan Distasio <interzone@gmail.com>=
 wrote:

> Hi Neil-
>=20
> Just out of curiosity, how does mdadm decide which layout to use on a
> reshape from RAID5->6.=A0 I converted two of my RAID5s on different
> boxes running the same OS awhile ago, and was not aware of the
> different possibilities.=A0=A0 When I check now, one of them was conv=
erted
> with the Q block all on the last disk, and the other appears
> normalized.=A0 I'm relatively confident I ran exactly the same comman=
d
> on both to reshape them within a short time of one another.

mdadm first converts the RAID5 to RAID6 in an instant atomic operation =
which
results in the "-6" layout.  It then starts a restriping process which
converts the layout.

If you end up with a -6 layout then something when wrong starting the
restriping process.

Maybe you used different version of mdadm?  There have probably been bu=
gs in
some versions..

NeilBrown



>=20
> Here are the current details of the two arrays:
>=20
> dylan@terrordome:~$ sudo mdadm -D /dev/md0
> /dev/md0:
> =A0=A0=A0=A0=A0=A0=A0 Version : 0.90
> =A0 Creation Time : Tue Mar=A0 3 23:41:24 2009
> =A0=A0=A0=A0 Raid Level : raid6
> =A0=A0=A0=A0 Array Size : 5860559616 (5589.07 GiB 6001.21 GB)
> =A0 Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
> =A0=A0 Raid Devices : 8
> =A0 Total Devices : 8
> Preferred Minor : 0
> =A0=A0=A0 Persistence : Superblock is persistent
>=20
> =A0 Intent Bitmap : Internal
>=20
> =A0=A0=A0 Update Time : Tue May 10 20:06:42 2011
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 State : active
> =A0Active Devices : 8
> Working Devices : 8
> =A0Failed Devices : 0
> =A0 Spare Devices : 0
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric-6
> =A0=A0=A0=A0 Chunk Size : 64K
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : 4891e7c1:5d7ec244:a9bd8edb:
> d35467d0 (local to host terrordome)
> =A0=A0=A0=A0=A0=A0=A0=A0 Events : 0.743956
>=20
> =A0=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
> =A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 33=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdc1
> =A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 49=A0=A0=A0=
=A0=A0=A0=A0 1=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdd1
> =A0=A0=A0=A0=A0=A0 2=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 97=A0=A0=A0=
=A0=A0=A0=A0 2=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdg1
> =A0=A0=A0=A0=A0=A0 3=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 113=A0=A0=A0=A0=
=A0=A0=A0 3=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdh1
> =A0=A0=A0=A0=A0=A0 4=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 17=A0=A0=A0=
=A0=A0=A0=A0 4=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdb1
> =A0=A0=A0=A0=A0=A0 5=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 65=A0=A0=A0=
=A0=A0=A0=A0 5=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sde1
> =A0=A0=A0=A0=A0=A0 6=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 241=A0=A0=A0=A0=
=A0=A0=A0 6=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdp1
> =A0=A0=A0=A0=A0=A0 7=A0=A0=A0=A0=A0 65=A0=A0=A0=A0=A0=A0 17=A0=A0=A0=A0=
=A0=A0=A0 7=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdr1
> dylan@terrordome:~$ lsb_release -a
> No LSB modules are available.
> Distributor ID: Ubuntu
> Description:=A0=A0=A0 Ubuntu 10.04.1 LTS
> Release:=A0=A0=A0=A0=A0=A0=A0 10.04
> Codename:=A0=A0=A0=A0=A0=A0 lucid
>=20
>=20
> dylan@rapture:~$ sudo mdadm -D /dev/md0
>=20
> /dev/md0:
> =A0=A0=A0=A0=A0=A0=A0 Version : 0.90
> =A0 Creation Time : Sat Jun=A0 7 02:54:05 2008
> =A0=A0=A0=A0 Raid Level : raid6
> =A0=A0=A0=A0 Array Size : 2194342080 (2092.69 GiB 2247.01 GB)
> =A0 Used Dev Size : 731447360 (697.56 GiB 749.00 GB)
> =A0=A0 Raid Devices : 5
> =A0 Total Devices : 5
> Preferred Minor : 0
> =A0=A0=A0 Persistence : Superblock is persistent
>=20
> =A0=A0=A0 Update Time : Tue May 10 20:19:13 2011
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
> =A0Active Devices : 5
> Working Devices : 5
> =A0Failed Devices : 0
> =A0 Spare Devices : 0
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
> =A0=A0=A0=A0 Chunk Size : 64K
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : 83b4a7df:1d05f5fd:e368bf24:bd0f=
ce41
> =A0=A0=A0=A0=A0=A0=A0=A0 Events : 0.723556
>=20
> =A0=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
> =A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 18=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdb2
> =A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 34=A0=A0=A0=
=A0=A0=A0=A0 1=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdc2
> =A0=A0=A0=A0=A0=A0 2=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0=A0 2=A0=A0=
=A0=A0=A0=A0=A0 2=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sda2
> =A0=A0=A0=A0=A0=A0 3=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 66=A0=A0=A0=
=A0=A0=A0=A0 3=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sde2
> =A0=A0=A0=A0=A0=A0 4=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 82=A0=A0=A0=
=A0=A0=A0=A0 4=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdf2
>=20
> dylan@rapture:~$ lsb_release -a
> No LSB modules are available.
> Distributor ID: Ubuntu
> Description:=A0=A0=A0 Ubuntu 10.04.1 LTS
> Release:=A0=A0=A0=A0=A0=A0=A0 10.04
> Codename:=A0=A0=A0=A0=A0=A0 lucid
>=20
> On Tue, May 10, 2011 at 8:21 PM, NeilBrown <neilb@suse.de> wrote:
> >
> > On Wed, 11 May 2011 09:39:27 +1000 Steven Haigh <netwiz@crc.id.au> =
wrote:
> >
> > > On 11/05/2011 9:31 AM, NeilBrown wrote:
> > > > When it finished you will have a perfectly functional RAID6 arr=
ay with full
> > > > redundancy. =A0It might perform slightly differently to a stand=
ard layout -
> > > > I've never performed any measurements to see how differently.
> > > >
> > > > If you want to (after the recovery completes) you could convert=
 to a regular
> > > > RAID6 with
> > > > =A0 =A0mdadm -G /dev/md0 --layout=3Dnormalise =A0 --backup=3D/s=
ome/file/on/a/different/device
> > > >
> > > > but you probably don't have to.
> > > >
> > >
> > > This makes me wonder. How can one tell if the layout is 'normal' =
or with
> > > Q blocks on a single device?
> > >
> > > I recently changed my array from RAID5->6. Mine created a backup =
file
> > > and took just under 40 hours for 4 x 1Tb devices. I assume that t=
his
> > > means that data was reorganised to the standard RAID6 style? The
> > > conversion was done at about 4-6Mb/sec.
> >
> > Probably.
> >
> > What is the 'layout' reported by "mdadm -D"?
> > If it ends -6, then it is a RAID5 layout with the Q block all on th=
e last
> > disk.
> > If not, then it is already normalised.
> >
> > >
> > > Is there any effect on doing a --layout=3Dnormalise if the above =
happened?
> > >
> > Probably not.
> >
> > NeilBrown
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
