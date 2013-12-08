From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm rebuild
Date: Mon, 9 Dec 2013 10:17:52 +1100
Message-ID: <20131209101752.33deb603@notabene.brown>
References: <B49ACD0F-BAD8-4D61-B87C-A06295B58A56@gmail.com>
	<20131209085554.262006d5@notabene.brown>
	<CAJ1=nZfUBQ0_T1s3deG+HOU7BQeayibWcW8y5h5bEjFt2tvhnA@mail.gmail.com>
	<20131209095328.0d39e6ad@notabene.brown>
	<CA74C8FD-DBDC-428B-9645-E2DD2300EE9D@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/mxH85Tr01UCD96wkNhPuuUo"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA74C8FD-DBDC-428B-9645-E2DD2300EE9D@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hai Wu <haiwu.us@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/mxH85Tr01UCD96wkNhPuuUo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 8 Dec 2013 17:03:22 -0600 Hai Wu <haiwu.us@gmail.com> wrote:

> This is something I am not aware of, thanks!=20
>=20
> In this case, do I have to worry about cases where the new drive might no=
t be able to boot (this is raid1 with 2 drives, and both drives need to be =
able to boot up the server by themselves in case the other drive fails late=
r)? I remember I had to do the following before for the new drive:
>=20
> grub> root (hd0,0)
>=20
> Is that still the case here if marking it as 'spare'?

If you want the new drive to boot and the boot sector is not covered by any
md array, then you have to update the boot sector yourself.

You can presumably get udev to run some command which will write a boot
sector out.  However I'm not an expert on boot sector management so cannot
really advise you.

NeilBrown


>=20
> On Dec 8, 2013, at 4:53 PM, NeilBrown <neilb@suse.de> wrote:
>=20
> > On Sun, 8 Dec 2013 16:45:08 -0600 hai wu <haiwu.us@gmail.com> wrote:
> >=20
> >> Thanks Neil. I am not sure if I understand mdadm 'spare' correctly. If
> >> doing as you mentioned above, the new driver will show up in output of
> >> "mdadm --detail /dev/md0" as 'spare' status, while I would like the new
> >> drive to automatically show up as "acitve, sync", and it will automati=
cally
> >> be synced up with the one remaining good drive upon running the udev r=
ule.
> >> I don't see an option like "force-include" in this case. Please let me=
 know
> >> if I miss something.
> >=20
> > Whenever md notices that an array has a spare device and a missing devi=
ce it
> > will start rebuilding the spare and will then make it an active device.
> >=20
> > So if a new device is added to the system, you really do want to give i=
t to
> > md as a 'spare'.  md will do the rest - it always has done.
> >=20
> > NeilBrown
> >=20
> >=20
> >>=20
> >>=20
> >> On Sun, Dec 8, 2013 at 3:55 PM, NeilBrown <neilb@suse.de> wrote:
> >>=20
> >>> On Sun, 8 Dec 2013 11:53:00 -0600 Hai Wu <haiwu.us@gmail.com> wrote:
> >>>=20
> >>>> I am wondering whether it is possible for mdadm to auto-rebuild a fa=
iled
> >>>> raid1 driver upon its replacement with a new drive? The following li=
nes
> >>>> from some RedHat website URL seems to indicate vaguely that it might=
 be
> >>> possible:
> >>>>=20
> >>>=20
> >>> Yes and no.
> >>> "yes" because it is certainly possible to arrange this,
> >>> "no" because it isn't just mdadm which does it.
> >>>=20
> >>> When a drive is plugged in, udev notices and can run various commands=
 to do
> >>> things with that device.  You need to get udev to run "mdadm -I $devn=
ame"
> >>> when a new device is plugged in.
> >>> The udev scripts which come with mdadm will only do that for new driv=
es
> >>> which
> >>> appear to be part of an array already.  You presumably want it to do =
that
> >>> for
> >>> any new drive.  The change should be quite easy.
> >>>=20
> >>> Secondly, you need to tell mdadm that it is OK to add a new device as=
 a
> >>> spare
> >>> to an array.  To see how to do this you need to read the documentatio=
n for
> >>> the "POLICY" command in mdadm.conf.5.
> >>>=20
> >>> A line like:
> >>>    POLICY action=3Dforce-spare
> >>> tells mdadm that any device passed to "mdadm -I" can be added to any =
array
> >>> as
> >>> a spare.  You might not want that, but you can restrict it in various=
 ways.
> >>>=20
> >>>    POLICY path=3Dpci-0000:00:1f.2-scsi* action=3Dspare
> >>>=20
> >>> says that any device attached to a particular controller can be added=
 to
> >>> any
> >>> array as long as it is already a member of the array, or appears to be
> >>> blank.
> >>>=20
> >>> There are various other directives which should allow you to describe
> >>> whatever you want.
> >>>=20
> >>> NeilBrown
> >>>=20
> >>>=20
> >>>> Previously, mdadm was not able to rebuild newly-connected drives
> >>>> automatically. This update adds the array auto-rebuild feature and
> >>> allows a
> >>>> RAID stack to automatically rebuild newly-connected drives.
> >>>>=20
> >>>> The goal is to get mdadm software raid1 to behave the same as hardwa=
re
> >>>> raid1, when replacing failed hard drive. It should automatically det=
ect
> >>> new
> >>>> drive and rebuild the new drive into part of raid1 ..--
> >>>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
> >>>> the body of a message to majordomo@vger.kernel.org
> >>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>=20
> >>>=20
> >=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/mxH85Tr01UCD96wkNhPuuUo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUqT+IDnsnt1WYoG5AQLN+RAAuv9MfYnuMJfMkbhi9+sGbKxPUzhj4PU3
Y5KO8gqV4FF6le9F7jOF1SyNRHGBasDmr1JChvcY3nbHg65IUYp3qFXPUcjSlB/W
tdZ3isDnwwXeswA1iK77Td64QUck1RaZJ+TnbB8fth/1bGN9wkxWRLHlgJBDWznX
pe1CwEBuBz7vxExOPxvO9IdyhT7hZXjeL3bZoaUFP1ylGfbBvsz42/cNsZ/cE1nF
JPwS5otpzyPcAyjnrNVlGK5zkV/3yk6y37qfU8zV+LJWORfNasz76S/Xjxk50JPm
1fo1g3Y3NYBdQkJEON2QaKafJ8vKIxBhU2Si2VCv2nZm/53yfeA4+keW4hJM/KJW
0xilSaG7mnvlNyGpAgmX/aHeFWP0VZxMSflBiE943kO0Knp1HTAngAF1FhLXxC9V
+7fGmZLNo+wqV4qBFbAo4XAfCEBECABBp7QvtfkvGSZBO94zg3ChoFTq209151iI
EcacvpMNps8eEDABZ7gQ+y+ht+S97DndfKsHiSMuKHxnoXjG4cmzD55efKiBm3tb
gct7KcUts39bqharFWRQA9cqVmWpgP8W9KGk4+/B+QsouBQojD6/PYbFlelao/xK
6SuLoCAUbzrXhm07A4jbDmbeWt3lkmueaZGfAnefwAdOHYTBSUMkuxNEpmpzaXSv
2Qn7IW25xzo=
=HjUY
-----END PGP SIGNATURE-----

--Sig_/mxH85Tr01UCD96wkNhPuuUo--
