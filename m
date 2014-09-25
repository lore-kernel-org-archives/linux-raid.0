From: NeilBrown <neilb@suse.de>
Subject: Re: Moving root to raid, weird raid behaviour
Date: Thu, 25 Sep 2014 10:05:21 +1000
Message-ID: <20140925100521.4740dc9f@notabene.brown>
References: <54206A9A.8010308@youngman.org.uk>
	<20140923103704.7116d112@notabene.brown>
	<542134C3.4090003@youngman.org.uk>
	<542325F0.9010306@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/dE+2XF.rZKF9GaoBxjj03ph"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <542325F0.9010306@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/dE+2XF.rZKF9GaoBxjj03ph
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 24 Sep 2014 21:13:36 +0100 Wols Lists <antlists@youngman.org.uk>
wrote:

> I've just had a flash of inspiration, and if I'm right it's a pretty
> nasty "feature", but surely it would have bitten people before me...
>=20
> What's the purpose of the array name? And what's going on with multiple
> arrays all sharing the same name? This system I'm working on, all three
> arrays are called "ashdown:0".

The name is just a name.  It can be used to identify arrays and it can be
used to create a symlink in /dev/md, but it is not assumed to be unique.

>=20
> And I've just thoroughly screwed up my dev system - I've lost /home ...
> all because I did a --wipe-superblock on a DIFFERENT partition on a
> DIFFERENT array!

Oops :-(

>=20
> (Oh, and I've got the boot sequence moaning that sdd and sdd4 have very
> similar superblocks - wtf? sdd DOESN'T HAVE a superblock as far as I know=
!)

"mdadm -E /dev/sdd" would tell you.
If you have a 0.90 superblock on sdd4, and sdd4 starts at a multiple for 64K
from the start of the device, then that superblock will appear to exist on
sdd as well.  This is one of the several reasons that we use 1.x metadata.

>=20
> But that thing about array names, what I've been doing is creating array
> 0 (or 1), and when I reboot, it gets changed to 127 or whatever, so the
> next array I create is 0 (or 1), etc etc. There seems to be precious
> little mention of names, what they do etc, they're treated as an
> afterthought. I didn't even realise arrays *had* names, until I noticed
> a reference to "mdhome" or something like that. Does that mean I can do
> "mdadm --create /dev/mdhome ..." ?

Sure can.  or "/dev/md/home"  or just "home".

If the array gets assembled at '127' despite being created as '1', then the=
re
is something different in the boot environment.  Presumably the array is
assembled before the host name is set, and the mdadm.conf in the initrd (I
think you said there wasn't one..) doesn't list the array with the correct
name.
Without one of those hints (the hostname is stored in the metadata so mdadm
knows if the array is "local" or "foreign" so it knows how much to trust the
name), mdadm will punt and use a number like 127.

NeilBrown


>=20
> Any light to shed?
>=20
> (At least I now grok grub2 enough to achieve what I want to, it's just
> that it's now making the raid mess worse as grub2 doesn't like it when
> arrays disappear under it!)
>=20
> Cheers,
> Wol
>=20
> On 23/09/14 09:52, Wols Lists wrote:
> > On 23/09/14 01:37, NeilBrown wrote:
> >> On Mon, 22 Sep 2014 19:29:46 +0100 Wols Lists
> >> <antlists@youngman.org.uk> wrote:
> >>
> >>> I'm not sure if this is weird raid, stupid grub2 or incompetent
> >>> newbie, but whatever ... and the system is my development/test
> >>> system so if it gets trashed it's no disaster, but I would like
> >>> to understand what is going on ...
> >>>
> >>> Old setup / =3D sdb2 /var =3D sdc2 /home =3D mdX (sdb3, sdc3), mirror
> >>>
> >>> I added sdd and made a new / =3D mdY (sdd3, missing) mirror and
> >>> added sdd4 to mdX /home =3D mdX (sdb3 sdc3 sdd4)
> >>>
> >>> Weirdo one - sdd4 mirrored and synced fine. Then I rebooted ...=20
> >>> mdX =3D (sdb3 sdc3 missing) mdZ =3D (sdd4 missing missing)
> >>
> >> You probably have something silly in your initrd which is making
> >> invalid assumptions. What does /etc/mdadm.conf in your
> >> initrd/initramfs contain?
> >=20
> > There shouldn't be anything there. I bombed into a grub2 shell, and
> > mdadm.conf appeared to be the empty default. I also used ark to peer
> > into the initramfs file and there didn't appear to be an mdadm.conf.
> >=20
> > But I've just had a bit of an uh-oh moment. Bear in mind I have two
> > /boot's (mdY/boot and sdb2/boot), and two grubs or more (sda, sdb,
> > sdd), I could be barking up a wrong tree. So that's my next step, try
> > and *make* *sure* which grub I'm working with! Too many variables...
> >>
> >>>
> >>> wtf?!?!? - oh and both of them share the same uuid. The obvious
> >>> (but it shouldn't make any difference?) possibility is that sdb
> >>> and sdc are 500Gb, partitioned identically. sdd is 1Tb, so sdd4
> >>> is twice the size of the other two.
> >>>
> >>> The other weirdo is I'm trying to migrate from grub/mbr to
> >>> grub2/gpt. Of course that's causing me fun, but I've managed to
> >>> get the system booting fine from mdY. Only snag is, when I list
> >>> /dev, mdY isn't there! mount shows it as mounted on / but that's
> >>> the only place I can find it!
> >>
> >> udev should create it.  'udevadm trigger' should cause udev to
> >> create device files for all devices.  That should  be done as part
> >> of the boot sequence. If you run "udevadm trigger" does /dev/mdX
> >> get created?
> >>
> > No errors, no messages, no disk ...
> >>
> >>>
> >>> mdadm v3.2.6 kernel 3.14.14-gentoo
> >>>
> >>> Any ideas what's going on? I've googled, but everything I find
> >>> looks out of date or not relevant.
> >>
> >> "out of date or not relevant"?? You must have been looking on the=20
> >> Internet ?!?! :-)
> >=20
> > :-)
> >=20
> > The search results were mostly ubuntu (I run gentoo, but so what),
> > grub1, I'm migrating to grub2, and any mention of root/boot got plenty
> > of results about not finding root and failing to boot, but absolutely
> > nothing about successfully booting off a root that wasn't there! Plus
> > they all seemed to be 2010 or earlier ...
> >>
> >> NeilBrown
> >>
> > Cheers,
> > Wol
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/dE+2XF.rZKF9GaoBxjj03ph
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCNcQTnsnt1WYoG5AQLDEBAAtLBGFDtdPjvilVzdAJmACwrXrKdnyT1L
+0t4XYwE4PFebZuBc5t7yfrtTQgYyHh0J/sOdAx3r009HWb5yUM7c0bWfScBOPEO
WpAKKT+a0l4ylo23zrPk/6a6nB4UsXzge3w/+YnvjREpV1rPBfYuvTPczFWXLHmB
wx/iAeurs2hpo5jPmtX7udwWCXqVVWPf5HsS9U7dlBffOIlowwDgfwXHpq5Fto/y
fZWDlsfjkMa8YkxunBUs6wLz3hCp+ePAERTvz84CbUQujjiUhXN4JbkzPGn6YZPK
fJ3oXSZUDECseFd+ynsE8UPEta6dftNDCy9KTBRZ6vUai+Ca3tjxicupjO9Tv4Ey
MFfJY0ZT2B7+dD6aEHuOhgFveIo9bZObKvv89k3tBdkBW9gfGKUz9YDbqDQCQXUG
zLxiVTV4ZCzgbnoRu4SsYwyoW0ruagSr1zxFqXUsVuv8DkGePXjmjsl8+l31HZQU
l97KIRgjf9VthNTqvGcKnrvU2c9Jg3Ub8Mbss9CsCgsq5Hp04Iz9u6b+NpdZit7A
xh+8T4i0H3w7VgFOI8qH0nfM40SCmne/EERsBmdBx/kDCoXAaOo4nizzL5sNefgD
mOfDMg/LmVX7BPbrX1vYD79Xv8ZgMsFu0XXyJ8fhRYYB2tn8InnSILEIji57WBEE
cPlwN3+Yybs=
=hoYs
-----END PGP SIGNATURE-----

--Sig_/dE+2XF.rZKF9GaoBxjj03ph--
