From: NeilBrown <neilb@suse.de>
Subject: Re: MD devnode still present after 'remove' udev event, and mdadm
 reports 'does not appear to be active'
Date: Wed, 21 Sep 2011 15:03:23 +1000
Message-ID: <20110921150323.0ef402c9@notabene.brown>
References: <CAGRgLy4K-sFpeHhu_f+7-F8Fa_L1OP7ki0X-_9858BbBQrnWOA@mail.gmail.com>
	<20110830072557.428fab35@notabene.brown>
	<CAGRgLy5D+yZJArP9Y=x6N5NnozckQnyF7eaLFo8hgbBxPwzn4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/pBTLdAJz+fbWKqxW_DW6v5R"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5D+yZJArP9Y=x6N5NnozckQnyF7eaLFo8hgbBxPwzn4w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/pBTLdAJz+fbWKqxW_DW6v5R
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 13 Sep 2011 11:49:12 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hello Neil,
> I am sorry for opening this again, but I am convinced now that I don't
> understand what's going on:)
>=20
> Basically, I see that GET_ARRAY_INFO can also return ENODEV in case
> the device in the kernel exists, but "we are not initialized yet":
> /* if we are not initialised yet, only ADD_NEW_DISK, STOP_ARRAY,
>  * RUN_ARRAY, and GET_ and SET_BITMAP_FILE are allowed */
> if ((!mddev->raid_disks && !mddev->external)
>     && cmd !=3D ADD_NEW_DISK && cmd !=3D STOP_ARRAY
>     && cmd !=3D RUN_ARRAY && cmd !=3D SET_BITMAP_FILE
>     && cmd !=3D GET_BITMAP_FILE) {
> 	err =3D -ENODEV;
> 	goto abort_unlock;
>=20
> I thought that ENODEV means that the device in the kernel does not
> exist, although I am not this familiar with the kernel sources (yet)
> to verify that.
>=20
> Basically, I just wanted to know whether there is a reliable way to
> determine whether the kernel MD device exists or no. (Obviously,
> success to open a devnode from user space is not enough).
>=20
> Thanks,
>   Alex.

What exactly do you mean by "the kernel MD device exists" ??

When you open a device-special-file for an md device (major =3D=3D 9) it
automatically creates an inactive array.  You can then fill in the details
and activate it, or explicitly deactivate it.  If you do that it will
disappear.

Opening the devnode is enough to check that the device exists, because it
creates the device and then you know that it exists.
If you want to know if it already exists - whether inactive or not - look
in /proc/mdstat or /sys/block/md*.
If you want to know if it already exists and is active, look in /proc/mdsta=
t,
or open the device and use GET_ARRAY_INFO, or look in /sys/block/md*
and look at the device size. or maybe /sys/block/mdXX/md/raid_disks.

It depends on why you are asking.

NeilBrown



>=20
>=20
>=20
>=20
>=20
>=20
>=20
> On Tue, Aug 30, 2011 at 12:25 AM, NeilBrown <neilb@suse.de> wrote:
> > On Mon, 29 Aug 2011 20:17:34 +0300 Alexander Lyakas <alex.bolshoy@gmail=
.com>
> > wrote:
> >
> >> Greetings everybody,
> >>
> >> I issue
> >> mdadm --stop /dev/md0
> >> and I want to reliably determine that the MD devnode (/dev/md0) is gon=
e.
> >> So I look for the udev 'remove' event for that devnode.
> >> However, in some cases even after I see the udev event, I issue
> >> mdadm --detail /dev/md0
> >> and I get:
> >> mdadm: md device /dev/md0 does not appear to be active
> >>
> >> According to Detail.c, this means that mdadm can successfully do
> >> open("/dev/md0") and receive a valid fd.
> >> But later, when issuing ioctl(fd, GET_ARRAY_INFO) it receives ENODEV
> >> from the kernel.
> >>
> >> Can somebody suggest an explanation for this behavior? Is there a
> >> reliable way to know when a MD devnode is gone?
> >
> > run "udevadm settle" after stopping /dev/md0 =A0is most likely to work.
> >
> > I suspect that udev removes the node *after* you see the 'remove' event.
> > Sometimes so soon after that you don't see the lag - sometimes a bit la=
ter.
> >
> > NeilBrown
> >
> >>
> >> Thanks,
> >> =A0 Alex.
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/pBTLdAJz+fbWKqxW_DW6v5R
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOeXAbG5fc6gV+Wb0RAlk5AJ9MIzhfZeYoACvopdjXUzI96InD5gCgtbOi
sLCU7BkZTDlx54b5sbWM8a8=
=uiWF
-----END PGP SIGNATURE-----

--Sig_/pBTLdAJz+fbWKqxW_DW6v5R--
