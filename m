From: NeilBrown <neilb@suse.de>
Subject: Re: question: no-bitmap RAID1 with off-site drive
Date: Tue, 27 Nov 2012 13:31:55 +1100
Message-ID: <20121127133155.2132a857@notabene.brown>
References: <6.2.5.6.2.20121111163935.05df8b18@binnacle.cx>
	<6.2.5.6.2.20121112122534.05dfec78@binnacle.cx>
	<6.2.5.6.2.20121118185613.05e63580@binnacle.cx>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ih7NEmp6OfIBi3E94TKAYwa"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6.2.5.6.2.20121118185613.05e63580@binnacle.cx>
Sender: linux-raid-owner@vger.kernel.org
To: starlight.2012q4@binnacle.cx
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ih7NEmp6OfIBi3E94TKAYwa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 18 Nov 2012 19:11:56 -0500 starlight.2012q4@binnacle.cx wrote:

> Started playing with the third drive
> and my invented approach may not
> be correct.  That, as recommended,
> using --grow to eliminate the offsite
> "removed" drive and put back the
> rotate-in drive is right.
>=20
> It looks like MD re-initializes the
> superblock (different UUID) when
> something like
>=20
>   mdadm --grow --add --raid-devices=3D3 /dev/md3 /dev/sde
>=20
> is run, even if /dev/sde has a previous
> superblock from the same array.  However
> I only tested it with a drive image that
> had not been fully synced and from the
> same (not different) array.  Running
>=20
>    mdadm --re-add /dev/md3 /dev/sde
>=20
> results 'mdadm' refusing the
> drive that had been from the
> same array (though not fully synced).
>=20
> Appears then that 'mdadm' may not
> check the superblock to see if the
> drive came from a different array
> and should not be overwritten, and
> instead prefers to just zap it.

Correct.  When you ask mdadm to --add device to an array, that is what it
will do.  If the metadata looks particularly good it might do a re-add for
you, but if not it will just erase it and write some more.

>=20
> Can anyone confirm or deny the
> possibility?  I can manually run
> an --examine and check the array
> name as a precaution when rotating
> drives if 'mdadm' doesn't perform
> the check.  Want to avoid inserting
> a offsite drive in the wrong array.
>=20

We might be able to make "mdadm -I" do what you want ... find out which arr=
ay
it "should" be a member of and auto-add it.
But that will currently fail for an out-of-date member with no bitmap.

If you applied
http://git.neil.brown.name/?p=3Dmdadm.git;a=3Dcommitdiff;h=3D75a410f6226d1e=
3ef441bbb8cd4f198d5de5cf5b

and put
  policy action=3Dforce-spare
in mdadm.conf, it might work.

NeilBrown


>=20
>=20
>=20
> At 12:26 PM 11/12/2012 -0500, starlight.2012q4@binnacle.cx wrote:
> >After some pondering, think I've figure it out.
> >
> >Best way to go is to set it up with
> >
> >  --create --level=3D1 --raid-devices=3D2
> >
> >for the initial pair of drives, then
> >
> >  --fail --remove
> >
> >the rotate-out drive, then
> >
> >  --add
> >
> >the alternate drive.  Now there will be
> >three drive slots with one "removed" and two
> >"active".
> >
> >To rotate a drive off-site
> >
> >   --fail --remove
> >
> >go to the off-site, swap the drives and on return
> >
> >   --re-add
> >
> >the rotate-in drive.
> >
> >This way the 'mdadm' UUID labels will stay on the
> >drives and 'mdadm' will warn against mistakes
> >such as trying to use the wrong drive for
> >a mirror pair.  Will always have one "removed"
> >drive.
> >
> >The
> >
> >   --grow --raid-devices=3D1 --force
> >
> >and
> >
> >   --grow --raid-devices=3D2 --add
> >
> >would be used only if a drive fails and needs to
> >be replaced.
> >
> >If anyone disagrees please advise.
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/ih7NEmp6OfIBi3E94TKAYwa
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBULQmGznsnt1WYoG5AQKv1Q//SQeYpxQ9wDt9auDs/yCtytX3H/Oz3ze5
RUXq4kNrQmURXJJ5GtefE2MrFDBeH+ZuEYl6TcnKMbyTUz8X8ST0TgoeqvoO2yXd
xnseLug2vJo3F/fuYXfzVEYZgfrEHWG0lAYFs1st2qxrVnsq4lK7tx3gFlPittxE
DXyHrUP2q16jtrmQ4LpfUS0y+562Pp3N03rpc9szf0rAQtyytHn5ml7kU33j1NMq
KOYTew0GfKBYvls2TBjbAkouxjCB/VqgVwskPclZ8tcqv2uFzDaZhQrtEC1mAhJV
QY+AJqFwHwb4CCtNuWGvTdG6cuviBAgql+xWB+AVFa8dHXzejbuOx9QMSuuRS3LL
ajxo6cLg+C8CdQTGP5kbY4sQleGaM4cQdFajO0eXhdDhpGthzMhOe09Vq4pcUjJg
maF8jyj9EvNunburUBY633J0IVF5gLEYOjCxqsU21O7aGgUBQyiIFg6accn5koE/
blAszX7x9ktw2IbtPdJPrVv3JgIXwI8vxqO67ETIncMiNDCrZCf8y8CgTTHlphQS
hdodJ6d5VcsChtRYyofesCrCNdJKYhMd10zmKEKioo+69zxJMiFgSL48czrnHXEc
jHWP+bUVN5WuVAwEfeWTJjES7QA9hgPxMzdV3qiDDPyRiGoGNDIGqfZpzk+jUULi
C/fQvdSM42c=
=S7wX
-----END PGP SIGNATURE-----

--Sig_/ih7NEmp6OfIBi3E94TKAYwa--
