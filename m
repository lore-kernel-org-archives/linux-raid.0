From: Neil Brown <neilb@suse.de>
Subject: Re: auto-assembling arrays without a configuration file
Date: Fri, 14 Mar 2008 16:27:55 +1100
Message-ID: <18394.3291.753581.887869@notabene.brown>
References: <20080308004009.GA32251@rap.rap.dk>
	<18388.27742.907731.241140@notabene.brown>
	<20080310134828.GF9348@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday March 10, keld@dkuug.dk wrote:
> On Mon, Mar 10, 2008 at 10:01:50AM +1100, Neil Brown wrote:
> > On Saturday March 8, keld@dkuug.dk wrote:
> > > I want to assemble the root partition automatically, without havi=
ng=20
> > > a configuration file. Is that possible?=20
> > >=20
> > > mdadm -A --scan=20
> > >=20
> > > does seem to require a configuration file.
> > >=20
> > > On the other hand, I think all info needed is available in the su=
per
> > > blocks, and a traversal of the partitions present on the system (=
ala
> > > fdisk -l) could give consistent naming - there seems to be no /de=
v/md
> > > association available in the superblock.
> >=20
> > The information that is not present in the super blocks is which
> > array you want to assemble.
>=20
> Yse, that is evident.
>=20
> > This becomes particularly important if you move some drives from on=
e
> > machine to another.
>=20
> Moving a disk from one machine to another is not the common thing wit=
h
> raids. This is only done in special cases, and not prat of ordinary=20
> operations.

I absolutely agree.  However the time when you do it you are quite
possibly trying to get something that was broken working again.  And
so you don't want any surprises.

So I encourage configurations where moving devices around will not
cause unpleasant surprises.  Tagging all arrays with the host name
helps remove these surprises.

>=20
> > For that reason mdadm knows about a "homehost".  You can tag each
> > array with a hint about what host it expects to be assembled on.
> > If you run
> >=20
> >   mdadm -As --homehost=3D`hostname`
> >=20
> > then it will auto-assemble any arrays for the current host.
> > If you arrays haven't been tagged for at particular host, then
> >=20
> >   mdadm -As --homehost=3D`hostname` --auto-update-homehost
> >=20
> > will automatically tag everything that is found for the current hos=
t.
> > This is not something that should be done automatically, but it OK =
to
> > do one when you know you haven't done anything interesting with
> > devices.
>=20
> Hmm, I am still looking for a way to boot a lin=FAx raid as root.

Look at README.initramfs in the mdadm release.
It might not answer all your questions, but I describes in general how
it should work, and provides a simple sample you could build on.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
