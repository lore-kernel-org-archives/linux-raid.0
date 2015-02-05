From: Xiao Ni <xni@redhat.com>
Subject: Re: Can't reshape raid0 to raid10
Date: Thu, 5 Feb 2015 03:44:10 -0500 (EST)
Message-ID: <724950041.5158431.1423125850171.JavaMail.zimbra@redhat.com>
References: <1718053393.1731733.1419906625563.JavaMail.zimbra@redhat.com> <484995116.1735572.1419909221275.JavaMail.zimbra@redhat.com> <20150204173921.23df9d79@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150204173921.23df9d79@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



----- Original Message -----
> From: "NeilBrown" <neilb@suse.de>
> To: "Xiao Ni" <xni@redhat.com>
> Cc: linux-raid@vger.kernel.org
> Sent: Wednesday, February 4, 2015 2:39:21 PM
> Subject: Re: Can't reshape raid0 to raid10
>=20
> On Mon, 29 Dec 2014 22:13:41 -0500 (EST) Xiao Ni <xni@redhat.com> wro=
te:
>=20
> > Hi Neil
> >=20
> >    When I try to reshape a raid0 to raid10, it'll fail like this:
> >=20
> > [root@dhcp-12-133 mdadm-3.3.2]# lsblk
> > NAME                    MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
> > sda                       8:0    0 111.8G  0 disk
> > =E2=94=9C=E2=94=80sda1                    8:1    0  1000M  0 part /=
boot
> > =E2=94=9C=E2=94=80sda2                    8:2    0  29.3G  0 part /
> > =E2=94=9C=E2=94=80sda3                    8:3    0   512M  0 part [=
SWAP]
> > =E2=94=9C=E2=94=80sda4                    8:4    0     1K  0 part
> > =E2=94=9C=E2=94=80sda5                    8:5    0   102M  0 part
> > =E2=94=94=E2=94=80sda6                    8:6    0  10.1G  0 part
> >   =E2=94=94=E2=94=80VolGroup00-LogVol00 254:0    0   9.9G  0 lvm
> > sdb                       8:16   0 111.8G  0 disk
> > =E2=94=9C=E2=94=80sdb1                    8:17   0     2G  0 part
> > =E2=94=94=E2=94=80sdb2                    8:18   0    10G  0 part
> > sdc                       8:32   0 186.3G  0 disk
> > =E2=94=9C=E2=94=80sdc1                    8:33   0     2G  0 part
> > =E2=94=94=E2=94=80sdc2                    8:34   0    10G  0 part
> > sdd                       8:48   0 111.8G  0 disk
> > =E2=94=9C=E2=94=80sdd1                    8:49   0     2G  0 part
> > =E2=94=94=E2=94=80sdd2                    8:50   0    10G  0 part
> > [root@dhcp-12-133 mdadm-3.3.2]# mdadm -CR /dev/md0 -l0 -n3 /dev/sdb=
1
> > /dev/sdc1 /dev/sdd1
> > mdadm: Defaulting to version 1.2 metadata
> > mdadm: array /dev/md0 started.
> > [root@dhcp-12-133 mdadm-3.3.2]# mdadm --grow /dev/md0 -l10 -a /dev/=
sdb2
> > /dev/sdc2 /dev/sdd2
> > mdadm: level of /dev/md0 changed to raid10
> > mdadm: add new device failed for /dev/sdb2 as 6: No space left on d=
evice
> >=20
> >   =20
> >    But if I reshape the raid0 to raid5, reshape raid5 to raid0, the=
n
> >    reshape raid0 to raid10 use
> > the same command it'll succeed.
> >=20
> > [root@dhcp-12-133 mdadm-3.3.2]# mdadm -CR /dev/md0 -l0 -n3 /dev/sdb=
1
> > /dev/sdc1 /dev/sdd1
> > [root@dhcp-12-133 mdadm-3.3.2]# mdadm --grow /dev/md0 -l5
> > [root@dhcp-12-133 mdadm-3.3.2]# cat /proc/mdstat
> > Personalities : [raid6] [raid5] [raid4] [raid0] [raid10]
> > md0 : active raid5 sdd1[2] sdc1[1] sdb1[0]
> >       6285312 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/=
3]
> >       [UUU_]
> >      =20
> > unused devices: <none>
> >=20
> > [root@dhcp-12-133 mdadm-3.3.2]# mdadm --grow /dev/md0 -l0
> > [root@dhcp-12-133 mdadm-3.3.2]# cat /proc/mdstat
> > Personalities : [raid6] [raid5] [raid4] [raid0] [raid10]
> > md0 : active raid0 sdd1[2] sdc1[1] sdb1[0]
> >       6285312 blocks super 1.2 512k chunks
> >      =20
> > unused devices: <none>
> > [root@dhcp-12-133 mdadm-3.3.2]# mdadm --grow /dev/md0 -l10 -a /dev/=
sdb2
> > /dev/sdc2 /dev/sdd2
> > mdadm: level of /dev/md0 changed to raid10
> > mdadm: added /dev/sdb2
> > mdadm: added /dev/sdc2
> > mdadm: added /dev/sdd2
> >=20
> >     So I guess it's the problem add the disk to raid10 after the re=
shaping.
> >     In the function
> > super_1_validate, it'll set the  mddev->dev_sectors using the super=
block
> > read from disks.
> > If it's raid0, the le64_to_cpu(sb-size) is 0. So when add disk to r=
aid10
> > bind_rdev_to_array
> > return -ENOSPC.
> >=20
> >     When create raid0, it doesn't write give the value to s->size. =
So the
> >     sb-size is 0.
> > I modify the code about Create.c. I'm not sure whether it's right t=
o do so.
> > But it can resolve
> > the problem.
>=20
> Thanks for the report.
>=20
> I think this need to be fixing in the md driver, when the reshape hap=
pens.
>=20
> Something like the following.
>=20
> NeilBrown
>=20
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index d1203cddb024..b8d76b1fba64 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -3872,7 +3872,7 @@ static int raid10_resize(struct mddev *mddev, s=
ector_t
> sectors)
>  	return 0;
>  }
> =20
> -static void *raid10_takeover_raid0(struct mddev *mddev)
> +static void *raid10_takeover_raid0(struct mddev *mddev, sector_t siz=
e, int
> devs)
>  {
>  	struct md_rdev *rdev;
>  	struct r10conf *conf;
> @@ -3882,6 +3882,7 @@ static void *raid10_takeover_raid0(struct mddev=
 *mddev)
>  		       mdname(mddev));
>  		return ERR_PTR(-EINVAL);
>  	}
> +	sector_div(size, devs);
> =20
>  	/* Set new parameters */
>  	mddev->new_level =3D 10;
> @@ -3892,12 +3893,15 @@ static void *raid10_takeover_raid0(struct mdd=
ev
> *mddev)
>  	mddev->raid_disks *=3D 2;
>  	/* make sure it will be not marked as dirty */
>  	mddev->recovery_cp =3D MaxSector;
> +	mddev->dev_sectors =3D size;
> =20
>  	conf =3D setup_conf(mddev);
>  	if (!IS_ERR(conf)) {
>  		rdev_for_each(rdev, mddev)
> -			if (rdev->raid_disk >=3D 0)
> +			if (rdev->raid_disk >=3D 0) {
>  				rdev->new_raid_disk =3D rdev->raid_disk * 2;
> +				rdev->sectors =3D size;
> +			}
>  		conf->barrier =3D 1;
>  	}
> =20
> @@ -3920,7 +3924,9 @@ static void *raid10_takeover(struct mddev *mdde=
v)
>  			       mdname(mddev));
>  			return ERR_PTR(-EINVAL);
>  		}
> -		return raid10_takeover_raid0(mddev);
> +		return raid10_takeover_raid0(mddev,
> +			raid0_conf->strip_zone->zone_end,
> +			raid0_conf->strip_zone->nb_dev);
>  	}
>  	return ERR_PTR(-EINVAL);
>  }
>=20

   Thanks, the problem is fixed.

Best Regards
Xiao
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
