From: Xavier Brochard <xavier@alternatif.org>
Subject: Re: disk order problem in a raid 10 array
Date: Sat, 19 Mar 2011 14:44:40 +0100
Message-ID: <201103191444.40489.xavier@alternatif.org>
References: <201103181549.20835.xavier@alternatif.org> <201103190059.08093.xavier@alternatif.org> <20110319124247.41bac36a@notabene.brown>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110319124247.41bac36a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Le samedi 19 mars 2011 02:42:47 NeilBrown, vous avez =E9crit :
> I suggest you:
>=20
>   mdadm --zero /dev/sdb1
>=20
> having first double-checked that sdb1 is the devices with Events of 1=
54,
>=20
> then
>=20
>  mdadm -S /dev/md0
>  mdadm -As /dev/md0
>=20
>=20
> and let the  array rebuild the spare.
> Then check the data and make sure it is all good.
> Then add /dev/sdb1 back in as the spare
>   mdadm /dev/md0 --add /dev/sdb1
>=20
> and everything should be fine - providing you don't hit any hardware =
errors
> etc.

It didnt work, until I've stopped the raid array:
mdadm --zero /dev/sdg1
mdadm: Couldn't open /dev/sdg1 for write - not zeroing

is that normal, can I continue?

Xavier
xavier@alternatif.org
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
