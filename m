From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID Configuration For New Home Server
Date: Sun, 6 Jun 2010 06:23:05 -0500
Message-ID: <BA.E9.03181.F158B0C4@cdptpa-omtalb.mail.rr.com>
References: <3A.AD.03181.3FF2B0C4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3A.AD.03181.3FF2B0C4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mark Knecht' <markknecht@gmail.com>
Cc: 'Mdadm' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> > >> problem. This method does require that I update the two backups =
by
> > >> hand once in awhile. That's OK by me.
> > >
> > > =A0 =A0 =A0 =A0Define, "once in awhile [sic]".
> >
> > Every 2-3 months I make sure each drive is up to date.
>=20
> 	I was having to update one server or the other every week or so,
> sometimes more than once a week.  I could have written scripts to do =
it,
> or
> used rsync, I suppose, but I opted for RAID1.
>=20
> > > It's certainly possible to do it,
> > > but the very reason I went with boot arrays rather than boot
> partitions
> > was
> > > it was getting to be a pain to update the backup drives all the t=
ime.
> >
> > All the time vs once every 2-3 months.
> >
> > Even an out-of-date boot drive will allow me to boot the machine an=
d
> > get things fixed.
> >
> > > Almost every time a package is added or deleted, /etc gets update=
d.
> > =A0Keeping
> > > different copies of the configuration files in /etc in the initrd=
 and
> > the
> > > root partition is not the best of ideas, although if course it ca=
n be
> > done.
> >
> > As I said I don't using an initrd. I've never learned how to build =
one
> > and didn't need it if I didn't use RAID on /boot.
>=20
> 	Most distros these days employ an initrd.  One re-builds it by
> running whatever application is included with the distro for that pur=
pose.
> In the case of Debian and Debian derivatives, it is currently
> `update-initramfs`.  It's built the first time by installing a Linux
> distro.
> It's not that difficult to do by hand, however.  Most are built using=
 cpio
> and gzip.  Once one has the directory structure one wishes, one simpl=
y
> creates a compressed tarball (cpioball?) from the structure.  It incl=
udes
> a
> copy of /etc, with some special scripts to allow the system to work p=
rior
> to
> the existence of the "real" /.
>=20
> > I don't understand your comments about /etc as it's not kept in /bo=
ot.
> > /etc, /, /home, and all other directories are on RAID. Only /boot
> > isn't, so it needs only a kernel and grub.
>=20
> 	The initrd has a copy of /etc - especially the boot configuration
> files such as mdadm.conf, fstab, etc.

	Oh, I almost forgot.  It may be of notable mention an array with a
1.0 superblock can be read as if it were an ordinary partition.  This m=
eans
one can build a 1.0 superblock array containing a file system (ext2 may=
 be
the best choice in this case), but boot from the partition just as if i=
t
were not an array.  Once the system is booted, the array can be assembl=
ed
and then /boot can be mounted.  This is because:

1.  The 1.0 superblock is at the *END* of the array.

2.  The file system when created only uses up the front part of the
partition, leaving the superblock intact.

3.  GRUB does not require the file system to be mounted in order to rea=
d the
kernel and the initrd.  (Actually, it could be made to work even if it =
did
mount the partition, but since it does not, it makes it much easier.)

	Indeed, this is the only way of which I know to boot to an array
using GRUB legacy.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
