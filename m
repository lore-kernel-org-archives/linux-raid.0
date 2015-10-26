From: Simon Guinot <simon.guinot@sequanux.org>
Subject: Re: Remove inactive array created by open
Date: Mon, 26 Oct 2015 22:12:52 +0100
Message-ID: <20151026211252.GC4665@kw.sim.vm.gnt>
References: <20151022162445.GA11904@kw.sim.vm.gnt>
 <87vb9yzjfp.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vEao7xgI/oilGqZ+"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87vb9yzjfp.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, Remi Reroller <remi.rerolle@seagate.com>, Vincent Donnefort <vdonnefort@gmail.com>, Yoann Sculo <yoann@printk.fr>
List-Id: linux-raid.ids


--vEao7xgI/oilGqZ+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 23, 2015 at 08:23:38AM +1100, Neil Brown wrote:
> Simon Guinot <simon.guinot@sequanux.org> writes:
>=20
> > Hi Neil,
> >
> > I'd like to have your advice about destroying an array created by open
> > at close time if not configured, rather than waiting for a ioctl or a
> > sysfs configuration. This would allow to get rid of the inactive md
> > devices created by an "accidental" open.
> >
> > On the Linux distribution embedded in LaCie NAS, we are able to
> > observe the following scenario:
> >
> > 1. A RAID array is stopped with a command such as mdadm --stop /dev/mdx.
> > 2. The node /dev/mdx is still available because not removed by mdadm at
> >    stop.
> > 3. /dev/mdx is opened by a process such as udev or mdadm --monitor.
> > 4. An inactive RAID array mdx is created and a "add" uevent is
> >    broadcasted to userland. It is let to userland to understand that
> >    this event must be discarded.
> >
> > You have to admit that this behaviour is at best awkward :)
>=20
> No argument there.
>=20
>=20
> >
> > I read the commit d3374825ce57
> > "md: make devices disappear when they are no longer needed" in which
> > you express some concerns about an infinite loop due to udev always
> > opening newly created devices. Is that still actual ?
> >
> > In your opinion, how could we get rid of an inactive RAID array created
> > by open ? Maybe we could switch the hold_active flag from UNTIL_IOCTL to
> > 0 after some delay (enough to prevent udev from looping) ? In addition,
> > maybe we could remove the device node from mdadm --stop ? Or maybe
> > something else :)
> >
> > If you are interested by any of this solutions or one of yours, I'll
> > be happy to work on it.
>=20
> By far the best solution here is to used named md devices.  These are
> relatively recent and I wouldn't be surprised if you weren't aware of
> them.
>=20
> md devices 9,0 to 9,511 (those are major,minor numbers) are "numeric" md
> devices.  They have in-kernel names md%d which appear in /proc/mdstat
> and /sys/block/
>=20
> If you create a block-special-device node with these numbers, that will
> create the md device if it doesn't already exist.
>=20
> md devices 9,512 to 9,$BIGNUM are "named" md devices.  These have
> in-kernel names like md_whatever-you-like.
> If you create a block-special-device with device number 9,512 and try to
> open it you will get -ENODEV.
> To create these you
>    echo whatever-you-like >  /sys/module/md_mod/parameters/new_array
>=20
> A number 512 or greater will be allocated as the minor number.
>=20
> These arrays behave as you would want them to.  They are only created
> when explicitly requested and they disappear when stopped.
>=20
> mdadm will create this sort of array if you add
>  CREATE names=3Dyes
> to mdadm.conf and don't use numeric device names.
> i.e. if you ask for /dev/md0, you will still get 9,0.
> But if you ask for /dev/md/home, you will get 9,512 where as
> with names=3Dno (the default) you would probably get 9,127.

Thanks for describing the usage of the named md devices. We will look
to convert our userland from numeric to named md devices.

>=20
> A timeout for dropping idle numeric md devices might make sense but it
> would need to be several seconds at least as udev can sometimes get very
> backlogged and would wouldn't want to add to that.  Would 5 minutes be
> soon enough to meet your need?

No unfortunately, this will not. In our case, I think we need to
remove the inactive numeric md device at close or quickly after.

Considering that for a numeric md device we need to add the gendisk at
probe and that we can't destroy it at close if inactive (due to the udev
issue), then I don't think there is a solution to our problem. But I was
kind of hoping you had an idea :)

Thanks.

Simon

--vEao7xgI/oilGqZ+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlYul1QACgkQgtp0PDeOcDqkqQCgnrb2kzmRusdEq7FdaF/3+Dnd
QyMAn1B0r5yjbxXzn1z1WRCLrTTgYn5V
=XbUY
-----END PGP SIGNATURE-----

--vEao7xgI/oilGqZ+--
