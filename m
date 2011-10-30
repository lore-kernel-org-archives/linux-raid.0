From: NeilBrown <neilb@suse.de>
Subject: Re: Question about mdadm commit
 d6508f0cfb60edf07b36f1532eae4d9cddf7178b "be more careful about add
 attempts"
Date: Mon, 31 Oct 2011 10:16:49 +1100
Message-ID: <20111031101649.657a1ab3@notabene.brown>
References: <CAGRgLy6Q9Qq8TeykEseXX45goi4kS8wOwrUOo1+tNZyxdyFHkw@mail.gmail.com>
	<20111027085125.747691a9@notabene.brown>
	<CAGRgLy7biNy4Tj9wXhBosjC4QNy7dXC2aoimu7ezGqdL82Axxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/p1_ENJ7YUaB0PbDE6e+2X4P"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy7biNy4Tj9wXhBosjC4QNy7dXC2aoimu7ezGqdL82Axxg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/p1_ENJ7YUaB0PbDE6e+2X4P
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Oct 2011 11:10:54 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hello Neil,
> it makes perfect sense not to turn a device into a spare inadvertently.
>=20
> However, with mdadm 3.1.4 under gdb, I tried the following:
> - I had a raid6 with 4 drives (sda/b/c/d), their "desc_nr" in the
> kernel were respectively (according to GET_DISK_INFO): 0,1,2,3.
> - I failed the two last drives (c & d) via mdadm and removed them from th=
e array
> - I wiped the superblock on drive d.
> - I added the drive d back to the array
> So now the array had the following setup:
> sda: disc_nr=3D0, raid_disk=3D0
> sdb: disc_nr=3D1, raid_disk=3D1
> sdd: disc_nr=3D4, raid_disk=3D2
> So sdd was added to the array into slot 2, and received disc_nr=3D4
>=20
> - Now I asked to re-add drive sdc back to array. In gdb I followed the
> re-add flow, to the place where it fills the mdu_disk_info_t structure
> from the superblock read from sdc. It put there the following content:
> disc.major =3D ...
> disc.minor =3D ...
> disc.number =3D 2
> disc.raid_disk =3D 2 (because previously this drive was in slot 2)
> disc.state =3D ...
>=20
> Now in gdb I changed disc.number to 4 (to match the desc_nr of sdd).
> And then issued ADD_NEW_DISK. It succeeded, and the sdc drive received
> disc_nr=3D2 (while it was asking for 4). Of course, it could not have
> received the same raid_disk, because this raid_disk was already
> occupied by sdd. So it was added as a spare.
>=20
> But you are saying:
> > If a device already exists with the same disk.number, a re-add cannot
> > succeed, so mdadm doesn't even try.
> while in my case it succeeded (while it actually did "add" and not "re-ad=
d").

We seem to be using word differently.
If I ask mdadm to do a "re-add" and it does an "add", then I consider that =
to
be "failure", however you seem to consider it to be a "success".

That seems to be the source of confusion.


>=20
> That's why I was thinking it makes more sense to check disc.raid_disk
> and not disc.number in this check. Since disc.number is not the
> drive's role within the array (right?), it is simply a position of the
> drive in the list of all drives.
> So if you check raid_disk, and see that this raid slot is already
> occupied, then, naturally, the drive will be converted to spare, which
> we want to avoid.

It may well be appropriate to check raid_disk as well, yes.  It isn't so ea=
sy
though which is maybe why I didn't.

With 0.90 metadata, the disc.number is the same as disc.raid_disk for active
devices.  That might be another reason for the code being the way that it i=
s.

Thanks,
NeilBrown



>=20
> And the enough_fd() check protects us from adding a spare to a failed
> array (like you mentioned to me previously).
>=20
> What am I missing?
>=20
> Thanks,
>   Alex.
>=20
>=20
>=20
>=20
>=20
>=20
>=20
> On Wed, Oct 26, 2011 at 11:51 PM, NeilBrown <neilb@suse.de> wrote:
> > On Wed, 26 Oct 2011 19:02:37 +0200 Alexander Lyakas <alex.bolshoy@gmail=
.com>
> > wrote:
> >
> >> Greetings everybody,
> >> I have a question about the following code in Manage.c:Manage_subdevs()
> >>
> >> disc.number =3D mdi.disk.number;
> >> if (ioctl(fd, GET_DISK_INFO, &disc) !=3D 0
> >> =A0 =A0 || disc.major !=3D 0 || disc.minor !=3D 0
> >> =A0 =A0 || !enough_fd(fd))
> >> =A0 =A0 goto skip_re_add;
> >>
> >> I do not underatand why the checks: disc.major !=3D 0 || disc.minor !=
=3D 0
> >> are required. This basically means that the kernel already has an
> >> rdev->desc_nr equal to disc.number. But why fail the re-add procedure?
> >>
> >> Let's say that enough_fd() returns true, and we go ahead an issue
> >> ioctl(ADD_NEW_DISK). In this case, according to the kernel code in
> >> add_new_disk(), it will not even look at info->number. It will
> >> initialize rdev->desc_nr to -1, and will allocate a free desc_nr for
> >> the rdev later.
> >>
> >> Doing this with mdadm 3.1.4, where this check is not present, actually
> >> succeeds. I understand that this code was added for cases when
> >> enough_fd() returns false, which sounds perfectly fine to protect
> >> from.
> >>
> >> I was thinking that this code should actually check something like:
> >> if (ioctl(fd, GET_DISK_INFO, &disc) !=3D 0
> >> =A0 =A0 || disk.raid_disk !=3D mdi.disk.raid_disk
> >> =A0 =A0 || !enough_fd(fd))
> >> =A0 =A0 goto skip_re_add;
> >>
> >> That is to check that the slot that was being occupied by the drive we
> >> are trying to add, is already occupied by a different drive (need also
> >> to cover cases of raid_disk <0, raid_disk >=3D raid_disks etc...) and
> >> not the desc_nr, which does not have any persistent meaning.
> >>
> >> Perhaps there are some compatibility issues with old kernels? Or
> >> special considerations for ... containers? non-persistent arrays?
> >
> > The point of this code is to make --re-add fail unless mdadm is certain=
 that
> > the kernel will accept the re-add, rather than turn the device into a s=
pare.
> >
> > If a device already exists with the same disk.number, a re-add cannot
> > succeed, so mdadm doesn't even try.
> >
> > When you say in 3.1.4 it "actually succeeds" - what succeeds? =A0Does i=
t re-add
> > the device to the array, or does it turn the device into a spare?
> > I particularly do not want --re-add to turn a device into a spare becau=
se
> > people sometimes use it in cases where it cannot work, their device gets
> > turned into a spare, and they lose information that could have been use=
d to
> > reconstruct the array.
> >
> > That that make sense?
> >
> > NeilBrown
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/p1_ENJ7YUaB0PbDE6e+2X4P
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTq3a4Tnsnt1WYoG5AQJpGg//bnoCglZP29kz1kMfsZD3iLFR2OYAtREq
Naqm6aa4y7KqQa6X0mOPOvK0+mv7JhflZH2/QCrCh13Hfy401L+g/ar/e9jAlBR1
XXbZcMjQ95qNhuzIgYkac8Ttt5+PrY+tD3lFpPtDT/r4xPJX3TjW3EjCbyAAsc20
7x/zz+eV7VICvis5ILYjOye2hZUddilf9F6bG9PJhiUokvIH9G4xbK9mhS5nBzVX
2h8+pRQspl1OAYK8OCyajmomT9Xu+dNVfFXBtS96s4+hU6TNYQjH6AoqpAExG0Hf
fQYV577pK4AInHGeGRct12uRseQ0yLvEk0jWi1nC++xJWQ/hGTZ/ACDmP6ERyxAW
7ooUze9WGdPzlgrTEhSaOxeCwKKHjotGWEUAs7BGFtm9DCjNSnNacyQOirpoAVBN
BDmmjvrEyZi0HP7RHe1WllaCEOTE2HJqvVPlqiGG7SVoMViB3FNzKc6ZH5iBR4JS
brDqE2UgMu8IBpjXINnVRAC+svPo1/pbUzGd7gnRS1xFk1qKYn93YBoOLeug5tTJ
RTo4n/pexzyQQ5wTS9OJwmbwImXZImzafrjprboeehYegQQ670qKzLeexjmzDE/u
fI4B1bstAFgOFNPIVPfh7CwGBdeF/ULo4zOIrTPWBnlcXF2jCMeGTWaC45nG4BDk
x22a3IbhEOA=
=0rA0
-----END PGP SIGNATURE-----

--Sig_/p1_ENJ7YUaB0PbDE6e+2X4P--
