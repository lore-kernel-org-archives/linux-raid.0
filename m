From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID Configuration For New Home Server
Date: Sun, 6 Jun 2010 00:19:42 -0500
Message-ID: <3A.AD.03181.3FF2B0C4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTil0Y-mXuoibzPUWtxKML8K0iRaz9mCxL3_40XSB@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTil0Y-mXuoibzPUWtxKML8K0iRaz9mCxL3_40XSB@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mark Knecht' <markknecht@gmail.com>
Cc: 'Mdadm' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> >> problem. This method does require that I update the two backups by
> >> hand once in awhile. That's OK by me.
> >
> > =A0 =A0 =A0 =A0Define, "once in awhile [sic]".
>=20
> Every 2-3 months I make sure each drive is up to date.

	I was having to update one server or the other every week or so,
sometimes more than once a week.  I could have written scripts to do it=
, or
used rsync, I suppose, but I opted for RAID1.

> > It's certainly possible to do it,
> > but the very reason I went with boot arrays rather than boot partit=
ions
> was
> > it was getting to be a pain to update the backup drives all the tim=
e.
>=20
> All the time vs once every 2-3 months.
>=20
> Even an out-of-date boot drive will allow me to boot the machine and
> get things fixed.
>=20
> > Almost every time a package is added or deleted, /etc gets updated.
> =A0Keeping
> > different copies of the configuration files in /etc in the initrd a=
nd
> the
> > root partition is not the best of ideas, although if course it can =
be
> done.
>=20
> As I said I don't using an initrd. I've never learned how to build on=
e
> and didn't need it if I didn't use RAID on /boot.

	Most distros these days employ an initrd.  One re-builds it by
running whatever application is included with the distro for that purpo=
se.
In the case of Debian and Debian derivatives, it is currently
`update-initramfs`.  It's built the first time by installing a Linux di=
stro.
It's not that difficult to do by hand, however.  Most are built using c=
pio
and gzip.  Once one has the directory structure one wishes, one simply
creates a compressed tarball (cpioball?) from the structure.  It includ=
es a
copy of /etc, with some special scripts to allow the system to work pri=
or to
the existence of the "real" /.

> I don't understand your comments about /etc as it's not kept in /boot=
=2E
> /etc, /, /home, and all other directories are on RAID. Only /boot
> isn't, so it needs only a kernel and grub.

	The initrd has a copy of /etc - especially the boot configuration
files such as mdadm.conf, fstab, etc.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
