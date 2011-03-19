From: Xavier Brochard <xavier@alternatif.org>
Subject: Re: disk order problem in a raid 10 array
Date: Sat, 19 Mar 2011 16:14:09 +0100
Message-ID: <201103191614.09717.xavier@alternatif.org>
References: <201103181549.20835.xavier@alternatif.org> <20110319124247.41bac36a@notabene.brown> <201103191444.40489.xavier@alternatif.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201103191444.40489.xavier@alternatif.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Le samedi 19 mars 2011 14:44:40, Xavier Brochard =E9crivait :
> Le samedi 19 mars 2011 02:42:47 NeilBrown, vous avez =E9crit :
> > I suggest you:
> >   mdadm --zero /dev/sdb1
> >=20
> > having first double-checked that sdb1 is the devices with Events of=
 154,
> >=20
> > then
> >=20
> >  mdadm -S /dev/md0
> >  mdadm -As /dev/md0
> >=20
> > and let the  array rebuild the spare.
> > Then check the data and make sure it is all good.
> > Then add /dev/sdb1 back in as the spare
> >=20
> >   mdadm /dev/md0 --add /dev/sdb1
> >=20
> > and everything should be fine - providing you don't hit any hardwar=
e
> > errors etc.
>=20
> It didnt work, until I've stopped the raid array:
> mdadm --zero /dev/sdg1
> mdadm: Couldn't open /dev/sdg1 for write - not zeroing
>=20
> is that normal, can I continue?

so far I've done:
mdam -S /dev/md0
mdadm --zero /dev/sdg1
mdadm -As /dev/md0 --config=3D/path/to/config

mdadm: /dev/md0 has been started with 2 drives (out of 4) and 1 spare.

ot started to recover:
md0 : active raid10 sdc1[1] sdf1[4] sde1[3]
      976767872 blocks 64K chunks 2 near-copies [4/2] [_U_U]
      [>....................]  recovery =3D  0.3% (1468160/488383936)=20
finish=3D66.3min speed=3D122346K/sec

but why did it started md0 with 2 drives and not with 3 drives?

Xavier
xavier@alternatif.org - 09 54 06 16 26
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
