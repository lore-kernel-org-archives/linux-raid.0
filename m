From: NeilBrown <neilb@suse.de>
Subject: Re: MD devnode still present after 'remove' udev event, and mdadm
 reports 'does not appear to be active'
Date: Sun, 25 Sep 2011 20:15:10 +1000
Message-ID: <20110925201510.24e0f468@notabene.brown>
References: <CAGRgLy4K-sFpeHhu_f+7-F8Fa_L1OP7ki0X-_9858BbBQrnWOA@mail.gmail.com>
	<20110830072557.428fab35@notabene.brown>
	<CAGRgLy5D+yZJArP9Y=x6N5NnozckQnyF7eaLFo8hgbBxPwzn4w@mail.gmail.com>
	<20110921150323.0ef402c9@notabene.brown>
	<CAGRgLy7fKegKw6j-36o0uchTF35F4hT8NvujW4ghb5av-onCGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/yhhRG7Xiw4qEMEtuGv5vhy4"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy7fKegKw6j-36o0uchTF35F4hT8NvujW4ghb5av-onCGQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/yhhRG7Xiw4qEMEtuGv5vhy4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, 23 Sep 2011 22:24:08 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Thank you, Neil, for answering.
> I'm not sure that understand all of this, because my knowledge of
> Linux user-kernel interaction is, unfortunately, not sufficient. In
> the future, I hope to know more.
> For example, I don't understand, how opening a "/dev/mdXX" can create
> a device in the kernel, if the devnode "/dev/mdXX" does not exist. In
> that case, I actually fail to open it with ENOENT.

/dev/mdXX is a "device special file".  It is not the device itself.
You can think of it like a symbolic link.
The "real" name for the device is something like "block device with major 9
and minor X"  That thing can exist quite independently of whether
the /dev/mdXX thing exists.  Just like a file may or may not exist
independently of whether some sym-link to it exists.

When the device (block,9,XX) appears, udev is told and it should create
things in /dev.  when the device disappears, udev is told and it should
remove the /dev entry.  But there can be races, and other things might
sometimes add or remove /dev entries (though they shouldn't).  So the
existence of something in /dev isn't a guarantee that it really exists.


>=20
> But what I did is actually similar to what you advised:
> - if I fail to open the devnode with ENOENT, I know (?) that the
> device does not exist
> - otherwise, I do GET_ARRAY_INFO
> - if it returns ok, then I go ahead and do GET_DISK_INFOs to get the
> disks information
> - otherwise if it returns ENODEV, I close the fd and then I read /proc/md=
stat
> - if the md is there, then I know it's inactive array (and I have to
> --stop it and reassemble or do incremental assembly)
> - if the md is not there, then I know that it really does not exist
> (this is the case when md deletion happened but the devnode did not
> disappear yet)
>=20
> Does it sound right? It passes stress testing pretty well.

Yes, that sounds right.

>=20
> By the way, I understand that /proc/mdstat can be only of 4K size...so
> if I have many arrays, I should probably switch to look at
> /sys/block....

Correct.

NeilBrown


>=20
> Thanks,
>   Alex.
>=20
>=20
>=20
>=20
>=20
>=20
> On Wed, Sep 21, 2011 at 8:03 AM, NeilBrown <neilb@suse.de> wrote:
> >
> > On Tue, 13 Sep 2011 11:49:12 +0300 Alexander Lyakas <alex.bolshoy@gmail=
.com>
> > wrote:
> >
> > > Hello Neil,
> > > I am sorry for opening this again, but I am convinced now that I don't
> > > understand what's going on:)
> > >
> > > Basically, I see that GET_ARRAY_INFO can also return ENODEV in case
> > > the device in the kernel exists, but "we are not initialized yet":
> > > /* if we are not initialised yet, only ADD_NEW_DISK, STOP_ARRAY,
> > > =A0* RUN_ARRAY, and GET_ and SET_BITMAP_FILE are allowed */
> > > if ((!mddev->raid_disks && !mddev->external)
> > > =A0 =A0 && cmd !=3D ADD_NEW_DISK && cmd !=3D STOP_ARRAY
> > > =A0 =A0 && cmd !=3D RUN_ARRAY && cmd !=3D SET_BITMAP_FILE
> > > =A0 =A0 && cmd !=3D GET_BITMAP_FILE) {
> > > =A0 =A0 =A0 err =3D -ENODEV;
> > > =A0 =A0 =A0 goto abort_unlock;
> > >
> > > I thought that ENODEV means that the device in the kernel does not
> > > exist, although I am not this familiar with the kernel sources (yet)
> > > to verify that.
> > >
> > > Basically, I just wanted to know whether there is a reliable way to
> > > determine whether the kernel MD device exists or no. (Obviously,
> > > success to open a devnode from user space is not enough).
> > >
> > > Thanks,
> > > =A0 Alex.
> >
> > What exactly do you mean by "the kernel MD device exists" ??
> >
> > When you open a device-special-file for an md device (major =3D=3D 9) it
> > automatically creates an inactive array. =A0You can then fill in the de=
tails
> > and activate it, or explicitly deactivate it. =A0If you do that it will
> > disappear.
> >
> > Opening the devnode is enough to check that the device exists, because =
it
> > creates the device and then you know that it exists.
> > If you want to know if it already exists - whether inactive or not - lo=
ok
> > in /proc/mdstat or /sys/block/md*.
> > If you want to know if it already exists and is active, look in /proc/m=
dstat,
> > or open the device and use GET_ARRAY_INFO, or look in /sys/block/md*
> > and look at the device size. or maybe /sys/block/mdXX/md/raid_disks.
> >
> > It depends on why you are asking.
> >
> > NeilBrown
> >
> >
> >
> > >
> > >
> > >
> > >
> > >
> > >
> > >
> > > On Tue, Aug 30, 2011 at 12:25 AM, NeilBrown <neilb@suse.de> wrote:
> > > > On Mon, 29 Aug 2011 20:17:34 +0300 Alexander Lyakas <alex.bolshoy@g=
mail.com>
> > > > wrote:
> > > >
> > > >> Greetings everybody,
> > > >>
> > > >> I issue
> > > >> mdadm --stop /dev/md0
> > > >> and I want to reliably determine that the MD devnode (/dev/md0) is=
 gone.
> > > >> So I look for the udev 'remove' event for that devnode.
> > > >> However, in some cases even after I see the udev event, I issue
> > > >> mdadm --detail /dev/md0
> > > >> and I get:
> > > >> mdadm: md device /dev/md0 does not appear to be active
> > > >>
> > > >> According to Detail.c, this means that mdadm can successfully do
> > > >> open("/dev/md0") and receive a valid fd.
> > > >> But later, when issuing ioctl(fd, GET_ARRAY_INFO) it receives ENOD=
EV
> > > >> from the kernel.
> > > >>
> > > >> Can somebody suggest an explanation for this behavior? Is there a
> > > >> reliable way to know when a MD devnode is gone?
> > > >
> > > > run "udevadm settle" after stopping /dev/md0 =A0is most likely to w=
ork.
> > > >
> > > > I suspect that udev removes the node *after* you see the 'remove' e=
vent.
> > > > Sometimes so soon after that you don't see the lag - sometimes a bi=
t later.
> > > >
> > > > NeilBrown
> > > >
> > > >>
> > > >> Thanks,
> > > >> =A0 Alex.
> > > >> --
> > > >> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
> > > >> the body of a message to majordomo@vger.kernel.org
> > > >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
> > > >
> > > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> >


--Sig_/yhhRG7Xiw4qEMEtuGv5vhy4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOfv8uG5fc6gV+Wb0RAlJdAJ9mjR7leOsodxWYV71vwrxHQCgmRQCggBlm
km8GGvboD6ywOcgqgPcMr14=
=ddqj
-----END PGP SIGNATURE-----

--Sig_/yhhRG7Xiw4qEMEtuGv5vhy4--
