From: NeilBrown <neilb@suse.de>
Subject: Re: Recovery of failed RAID 6 and LVM
Date: Wed, 28 Sep 2011 09:13:35 +1000
Message-ID: <20110928091335.1df35f8e@notabene.brown>
References: <4E7EDE58.3000804@yazzy.org>
	<20110926074002.6399de56@notabene.brown>
	<4E7FA3E8.5010603@yazzy.org>
	<20110926081853.2819622b@notabene.brown>
	<4E804062.3020700@yazzy.org>
	<20110926193130.6377f5b9@notabene.brown>
	<4E82203A.60507@yazzy.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kxTjlraYe+XxiVmE4qI9Fci"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E82203A.60507@yazzy.org>
Sender: linux-raid-owner@vger.kernel.org
To: lists@yazzy.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/kxTjlraYe+XxiVmE4qI9Fci
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Sep 2011 21:12:58 +0200 "Marcin M. Jessa" <lists@yazzy.org> wrot=
e:

> On 9/26/11 11:31 AM, NeilBrown wrote:
> > On Mon, 26 Sep 2011 11:05:38 +0200 "Marcin M. Jessa"<lists@yazzy.org>  =
wrote:
> >
> >> On 9/26/11 12:18 AM, NeilBrown wrote:
> >>
> >>> Do you remember what filesystem you had on 'storage'?  Was it ext3 or=
 ext4 or
> >>> xfs or something else?
> >>
> >> You're giving me some hope here and then silence :)
> >> Why did you ask about the file system? Should I run fsck on the LV ?
> >>
> >>
> >>
> >
> > You already did run fsck on the LV.  It basically said that it didn't
> > recognise the filesystem at all.
> > I asked in case maybe it was XFS in which case a different tool would be
> > required.
>=20
> Looks like I didn't remember correctly. I ran testdisk and it reported=20
> the file system to be XFS. What would you suggest now Neil?
>=20
>=20

Presumably
   xfs_check /dev/fridge/storage

and then maybe
   xfs_repair /dev/fridge/storage

but I have no experience with XFS - I'm just reading man pages.

NeilBrown


--Sig_/kxTjlraYe+XxiVmE4qI9Fci
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOglifG5fc6gV+Wb0RAtc+AKC90q667dcXREefcHQSc3b3f/UDEACfX+pK
vfj8fmXwiUIZ0rizvSc9zwQ=
=Wltc
-----END PGP SIGNATURE-----

--Sig_/kxTjlraYe+XxiVmE4qI9Fci--
