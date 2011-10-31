From: NeilBrown <neilb@suse.de>
Subject: Re: Question about mdadm commit
 d6508f0cfb60edf07b36f1532eae4d9cddf7178b "be more careful about add
 attempts"
Date: Mon, 31 Oct 2011 20:19:33 +1100
Message-ID: <20111031201933.314d130f@notabene.brown>
References: <CAGRgLy6Q9Qq8TeykEseXX45goi4kS8wOwrUOo1+tNZyxdyFHkw@mail.gmail.com>
	<20111027085125.747691a9@notabene.brown>
	<CAGRgLy7biNy4Tj9wXhBosjC4QNy7dXC2aoimu7ezGqdL82Axxg@mail.gmail.com>
	<20111031101649.657a1ab3@notabene.brown>
	<CAGRgLy7G_M=FtdZ9mmDvxxN52+AF+L=0+OaEP=dK7Z+Z5YBYKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/gMXi9pQKEoVVtR.eAd2W5og"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy7G_M=FtdZ9mmDvxxN52+AF+L=0+OaEP=dK7Z+Z5YBYKw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/gMXi9pQKEoVVtR.eAd2W5og
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 31 Oct 2011 10:57:25 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Thank you for the clarification, Neil!
>=20
> I was looking at raid_disk, because I am trying to see whether it is
> possible to control into which raid slot a disk is being added (not
> re-added).
>=20
> Let's say we had raid6 with 4 drives (a,b,c,d), and drives c and d
> failed.Now let's say, that it is decided to replace drive d with a new
> drive e (--add for drive e). Then it's possible that drive e will take
> the raid slot of drive c. So later, if we want to bring back drive c
> into the array, it will have to go into a different slot, resulting in
> a full reconstruction, not bitmap-based reconstruction. While if we
> would have re-added drive c first, it would have done a bitmap-based
> reconstruction, so only the e drive would have required a full
> reconstruction.
>=20
> So do you think it makes sense to somehow (perhaps through
> disc.raid_disk) instruct the kernel into which slot to add a new
> drive?

You should be able to do that via sysfs.
echo frozen > sync_action
echo $major:$minor > new_dev
echo $slot > dev-$DEVNAME/slot
echo idle > sync_action

something like that.

Seems and odd sort of scenario though.

Note that with RAID1 this is not an issue.  A re-added drive can take any
position in a RAID1 array - it doesn't have to be the same one.

NeilBrown



>=20
> Thanks,
>   Alex.
>=20
>=20
>=20
>=20
>=20
> On Mon, Oct 31, 2011 at 1:16 AM, NeilBrown <neilb@suse.de> wrote:
> > On Thu, 27 Oct 2011 11:10:54 +0200 Alexander Lyakas <alex.bolshoy@gmail=
.com>
> > wrote:
> >
> >> Hello Neil,
> >> it makes perfect sense not to turn a device into a spare inadvertently.
> >>
> >> However, with mdadm 3.1.4 under gdb, I tried the following:
> >> - I had a raid6 with 4 drives (sda/b/c/d), their "desc_nr" in the
> >> kernel were respectively (according to GET_DISK_INFO): 0,1,2,3.
> >> - I failed the two last drives (c & d) via mdadm and removed them from=
 the array
> >> - I wiped the superblock on drive d.
> >> - I added the drive d back to the array
> >> So now the array had the following setup:
> >> sda: disc_nr=3D0, raid_disk=3D0
> >> sdb: disc_nr=3D1, raid_disk=3D1
> >> sdd: disc_nr=3D4, raid_disk=3D2
> >> So sdd was added to the array into slot 2, and received disc_nr=3D4
> >>
> >> - Now I asked to re-add drive sdc back to array. In gdb I followed the
> >> re-add flow, to the place where it fills the mdu_disk_info_t structure
> >> from the superblock read from sdc. It put there the following content:
> >> disc.major =3D ...
> >> disc.minor =3D ...
> >> disc.number =3D 2
> >> disc.raid_disk =3D 2 (because previously this drive was in slot 2)
> >> disc.state =3D ...
> >>
> >> Now in gdb I changed disc.number to 4 (to match the desc_nr of sdd).
> >> And then issued ADD_NEW_DISK. It succeeded, and the sdc drive received
> >> disc_nr=3D2 (while it was asking for 4). Of course, it could not have
> >> received the same raid_disk, because this raid_disk was already
> >> occupied by sdd. So it was added as a spare.
> >>
> >> But you are saying:
> >> > If a device already exists with the same disk.number, a re-add cannot
> >> > succeed, so mdadm doesn't even try.
> >> while in my case it succeeded (while it actually did "add" and not "re=
-add").
> >
> > We seem to be using word differently.
> > If I ask mdadm to do a "re-add" and it does an "add", then I consider t=
hat to
> > be "failure", however you seem to consider it to be a "success".
> >
> > That seems to be the source of confusion.
> >
> >
> >>
> >> That's why I was thinking it makes more sense to check disc.raid_disk
> >> and not disc.number in this check. Since disc.number is not the
> >> drive's role within the array (right?), it is simply a position of the
> >> drive in the list of all drives.
> >> So if you check raid_disk, and see that this raid slot is already
> >> occupied, then, naturally, the drive will be converted to spare, which
> >> we want to avoid.
> >
> > It may well be appropriate to check raid_disk as well, yes. =A0It isn't=
 so easy
> > though which is maybe why I didn't.
> >
> > With 0.90 metadata, the disc.number is the same as disc.raid_disk for a=
ctive
> > devices. =A0That might be another reason for the code being the way tha=
t it is.
> >
> > Thanks,
> > NeilBrown
> >
> >
> >
> >>
> >> And the enough_fd() check protects us from adding a spare to a failed
> >> array (like you mentioned to me previously).
> >>
> >> What am I missing?
> >>
> >> Thanks,
> >> =A0 Alex.
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >> On Wed, Oct 26, 2011 at 11:51 PM, NeilBrown <neilb@suse.de> wrote:
> >> > On Wed, 26 Oct 2011 19:02:37 +0200 Alexander Lyakas <alex.bolshoy@gm=
ail.com>
> >> > wrote:
> >> >
> >> >> Greetings everybody,
> >> >> I have a question about the following code in Manage.c:Manage_subde=
vs()
> >> >>
> >> >> disc.number =3D mdi.disk.number;
> >> >> if (ioctl(fd, GET_DISK_INFO, &disc) !=3D 0
> >> >> =A0 =A0 || disc.major !=3D 0 || disc.minor !=3D 0
> >> >> =A0 =A0 || !enough_fd(fd))
> >> >> =A0 =A0 goto skip_re_add;
> >> >>
> >> >> I do not underatand why the checks: disc.major !=3D 0 || disc.minor=
 !=3D 0
> >> >> are required. This basically means that the kernel already has an
> >> >> rdev->desc_nr equal to disc.number. But why fail the re-add procedu=
re?
> >> >>
> >> >> Let's say that enough_fd() returns true, and we go ahead an issue
> >> >> ioctl(ADD_NEW_DISK). In this case, according to the kernel code in
> >> >> add_new_disk(), it will not even look at info->number. It will
> >> >> initialize rdev->desc_nr to -1, and will allocate a free desc_nr for
> >> >> the rdev later.
> >> >>
> >> >> Doing this with mdadm 3.1.4, where this check is not present, actua=
lly
> >> >> succeeds. I understand that this code was added for cases when
> >> >> enough_fd() returns false, which sounds perfectly fine to protect
> >> >> from.
> >> >>
> >> >> I was thinking that this code should actually check something like:
> >> >> if (ioctl(fd, GET_DISK_INFO, &disc) !=3D 0
> >> >> =A0 =A0 || disk.raid_disk !=3D mdi.disk.raid_disk
> >> >> =A0 =A0 || !enough_fd(fd))
> >> >> =A0 =A0 goto skip_re_add;
> >> >>
> >> >> That is to check that the slot that was being occupied by the drive=
 we
> >> >> are trying to add, is already occupied by a different drive (need a=
lso
> >> >> to cover cases of raid_disk <0, raid_disk >=3D raid_disks etc...) a=
nd
> >> >> not the desc_nr, which does not have any persistent meaning.
> >> >>
> >> >> Perhaps there are some compatibility issues with old kernels? Or
> >> >> special considerations for ... containers? non-persistent arrays?
> >> >
> >> > The point of this code is to make --re-add fail unless mdadm is cert=
ain that
> >> > the kernel will accept the re-add, rather than turn the device into =
a spare.
> >> >
> >> > If a device already exists with the same disk.number, a re-add cannot
> >> > succeed, so mdadm doesn't even try.
> >> >
> >> > When you say in 3.1.4 it "actually succeeds" - what succeeds? =A0Doe=
s it re-add
> >> > the device to the array, or does it turn the device into a spare?
> >> > I particularly do not want --re-add to turn a device into a spare be=
cause
> >> > people sometimes use it in cases where it cannot work, their device =
gets
> >> > turned into a spare, and they lose information that could have been =
used to
> >> > reconstruct the array.
> >> >
> >> > That that make sense?
> >> >
> >> > NeilBrown
> >> >
> >> >
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


--Sig_/gMXi9pQKEoVVtR.eAd2W5og
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTq5oJTnsnt1WYoG5AQLyDA//UPcsAqvNc5G0hNYmg2FNsRw9WCsCA3eq
TrTtXb+/7N6JkH7127fLH+//iaFDTWXE7qHaZqQnzIFzcgYAgBjklQoRuYX3WHyW
5P1m8VbtrCClmGzc0+25uJpys7BaL/lHmBTI+KJzSg9voZWZUbz89YSk1kyV3vmX
fK5DXIoHE0XEMu6oHg0T6aiDEzwKaIClEsaPoKieX2WwoUqxvnb+WEsRVp42jfw/
t90895yYajMutWJoN2r0iywEWyP7N87LiOZk6KZrKo0WPiTXwQMLkxZm9ac2A8x7
4TsAcA70vxrCwv5v+H5/PvO+QHvqwAOyam9mHA0O64cAkGIlHkzYJlpeIzSxW5g/
jzvFqKLNAFXcNGZ5STp+lkQSrs123R4y3+gGwEmi9YshjIJn7H/uqZypAO/h431A
nu7VokKBmqkICU8CmHfRLqRDCgzzVG6Qsj+yO3VkvikWfwVfeXbWlePQKwBzc6zs
x3FBYZrJ4gnjnMOOXODtzZlJjoOp0DU1COfOfbxFKGLzHXypZoZ2s9ETEpXpuJsD
aDa8U94l3jIyQrnrzF0uhdrALfPUrQXByGXkvYPUfUAwyEetvcc5ov5rFtIljNvG
AZiNBzwejt68spNVMMnT88kU6AWsVy0ge5QsS36gIXXcWPDXWeNQMdoJPhWSPTFK
qZ9sI1w4/nU=
=t2yr
-----END PGP SIGNATURE-----

--Sig_/gMXi9pQKEoVVtR.eAd2W5og--
