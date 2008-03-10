From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: auto-assembling arrays without a configuration file
Date: Mon, 10 Mar 2008 14:48:28 +0100
Message-ID: <20080310134828.GF9348@rap.rap.dk>
References: <20080308004009.GA32251@rap.rap.dk> <18388.27742.907731.241140@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18388.27742.907731.241140@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 10, 2008 at 10:01:50AM +1100, Neil Brown wrote:
> On Saturday March 8, keld@dkuug.dk wrote:
> > I want to assemble the root partition automatically, without having=
=20
> > a configuration file. Is that possible?=20
> >=20
> > mdadm -A --scan=20
> >=20
> > does seem to require a configuration file.
> >=20
> > On the other hand, I think all info needed is available in the supe=
r
> > blocks, and a traversal of the partitions present on the system (al=
a
> > fdisk -l) could give consistent naming - there seems to be no /dev/=
md
> > association available in the superblock.
>=20
> The information that is not present in the super blocks is which
> array you want to assemble.

Yse, that is evident.

> This becomes particularly important if you move some drives from one
> machine to another.

Moving a disk from one machine to another is not the common thing with
raids. This is only done in special cases, and not prat of ordinary=20
operations.

> If the target machine and a "/dev/md0" and the drives that are moved
> are from a "/dev/md0" on the source machine, then any auto-assembly o=
n
> the target machine has not obvious way to know which set of "/dev/md0=
"
> devices to assemble.

Moving a disk from one machine to another should be a special case,=20
and done by hand.

> For that reason mdadm knows about a "homehost".  You can tag each
> array with a hint about what host it expects to be assembled on.
> If you run
>=20
>   mdadm -As --homehost=3D`hostname`
>=20
> then it will auto-assemble any arrays for the current host.
> If you arrays haven't been tagged for at particular host, then
>=20
>   mdadm -As --homehost=3D`hostname` --auto-update-homehost
>=20
> will automatically tag everything that is found for the current host.
> This is not something that should be done automatically, but it OK to
> do one when you know you haven't done anything interesting with
> devices.

Hmm, I am still looking for a way to boot a lin=FAx raid as root.

mkinitrd does not seem to handle linux raids at all. Only hardware raid=
s
(doen by a controller).

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
