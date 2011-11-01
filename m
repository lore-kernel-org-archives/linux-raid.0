From: NeilBrown <neilb@suse.de>
Subject: Re: Question about mdadm commit
 d6508f0cfb60edf07b36f1532eae4d9cddf7178b "be more careful about add
 attempts"
Date: Wed, 2 Nov 2011 09:52:04 +1100
Message-ID: <20111102095204.024dc6b2@notabene.brown>
References: <CAGRgLy6Q9Qq8TeykEseXX45goi4kS8wOwrUOo1+tNZyxdyFHkw@mail.gmail.com>
	<20111027085125.747691a9@notabene.brown>
	<CAGRgLy7biNy4Tj9wXhBosjC4QNy7dXC2aoimu7ezGqdL82Axxg@mail.gmail.com>
	<20111031101649.657a1ab3@notabene.brown>
	<CAGRgLy7G_M=FtdZ9mmDvxxN52+AF+L=0+OaEP=dK7Z+Z5YBYKw@mail.gmail.com>
	<20111031201933.314d130f@notabene.brown>
	<CAGRgLy5zkfy2bfrJnC_eKQ_-VAcdaKCyeSounjZ3FjBb83T0mQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/T_A5bKweYy.MSmc4j=SjPNd"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5zkfy2bfrJnC_eKQ_-VAcdaKCyeSounjZ3FjBb83T0mQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/T_A5bKweYy.MSmc4j=SjPNd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 1 Nov 2011 18:26:14 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> I hope you don't find my questions too pesky; I hope as time goes, I
> will be able to contribute as well, and not just ask for information.

Enquiring minds should always be encouraged!

>=20
> What you suggested works great, but only if the drive already has a
> valid superblock. This is according to md_import_device(), which calls
> super_1_load(). Although it calls it with NULL refdev, but it still
> performs basic validity checks of the superblock. So it is needed to
> have functionality of write_init_super() of mdadm (perhaps can be an
> mdadm operation, not sure how dangerous this is to expose such
> functionality).

Correct.  With v1.x metadata - and even more so with DDF and IMSM - the
kernel does not know everything about the metadata and cannot create new
superlocks.  At best it can edit what is there.

As for adding things to mdadm -  you just need a genuine use-case.
I can see it could be valid to add a '--role' option to --add so you can add
a device to a specific slot.  I doubt it would be used much, but if there w=
as
a concrete need I wouldn't object.


>=20
> Another question I was digging for, is to find a spot where kernel
> determines whether it is going to do a bitmap-based reconstruction or
> a full reconstruction. Can you verify that I found it correctly, or I
> am way off?
>=20
> In super_1_validate():
> 		if (ev1 < mddev->bitmap->events_cleared)
> 			return 0;
> This means that the array bitmap was cleared after the drive was
> detached, so we bail right out, and do not set rdev->raid_disk, and
> leave all flags off. In that case, eventually, we will need full
> reconstruction.
> Otherwise, after we decide that this drive is an active device (not
> failed or spare):
> if ((le32_to_cpu(sb->feature_map) &  MD_FEATURE_RECOVERY_OFFSET))
>     rdev->recovery_offset =3D le64_to_cpu(sb->recovery_offset);
> else
>     set_bit(In_sync, &rdev->flags);
> Here we might or might not set the In_sync flag.
>=20

Yes. 'In_sync' effectively means that recovery_offset =3D=3D MAX.


> Then in slot_store() and in add_new_disk(), we set the important flag
> for that matter:
> if (test_bit(In_sync, &rdev->flags))
>     rdev->saved_raid_disk =3D slot;
> else
>     rdev->saved_raid_disk =3D -1;
>=20
> And later, in hot_add_disk (like raid5_add_disk, raid1_add_disk), we
> check this flag and set/not set the fullsync flag. And in
> raid1_add_disk, like you said, the slot doesn't matter, any valid
> saved_raid_disk is good.
>=20
> Is this correct? If yes, then in the sequence you suggested, we will
> always do full reconstruction. Because new_dev_store() and
> slot_store() sequence do not call validate_super(), so In_sync is
> never set, so saved_raid_disk remains -1. This is perfectly fine.

Yes, this is all correct.
In the sequence I suggested you could add
   echo insync > dev-$DEVNAME/state
before
   echo $slot > dev-$DEVNAME/slot

and it would result in saved_raid_disk being set.

NeilBrown


--Sig_/T_A5bKweYy.MSmc4j=SjPNd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTrB4FDnsnt1WYoG5AQLACg//U/jAPDb4MqAIfTJmDyWyrhYKY0pLPcFV
jS/MbI12/XDrpYdweJ8KS2JLD9nWmY8ESF8ANKgJ44Shz7DNK2oVW4AgCuvJky+7
+dkkGHoAxO115epsucEJ+i6rjAaBjUUuSlkcPS9XuStzwTijRNlncImUYMsblgqD
VeIAwakD46nwfvGrApvog6F68jzGw7uqOGjR6xA2exnnFpzWgmn+aAZKWVmcctIx
WzgCBlxlPmwfSBCbaKDdoPG3bdYzQDMy7Xkq9PT3O/ukDUP3bEZR+FZw3O3mqGev
8uhY0/qTxHaEuq6mkr66ICcvUJAd2jS1LTm3wFqhd2m7N8vvECf2jTaimt4gvQks
2bVXCEN1rQf17PQVBbKabNd4ytOzwBzcS0GXosuDKCnjdPbVoPKT2R76okn6Yla+
eTbWIrzdNC+xp2Eevhem795ix/d45pYtL3MsQ0LGjPfuUkWW/IeTsOZz0cZ6Lgoi
0wDF5uvoIH13gBCA9DedgKCU5O/FxcCxaSyPP5gl6/HHkiiKvkaVUUHVHBUTIfx1
pBZFqU/WoJzLzMj6DmH0wEPrq+r5JaYPDUPY+GZUhoZhJ2xCrVsImZVfafDEtEjp
r/Ys5Sa1hv02+5Gr38psIb/eTMl8RQSNa6utq0JWjCHVjXkuiB0e56xjtTaEzzqu
FCJvaQyHyVw=
=X2BE
-----END PGP SIGNATURE-----

--Sig_/T_A5bKweYy.MSmc4j=SjPNd--
