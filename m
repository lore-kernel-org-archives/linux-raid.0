From: NeilBrown <neilb@suse.de>
Subject: Re: disk order problem in a raid 10 array
Date: Sun, 20 Mar 2011 14:53:23 +1100
Message-ID: <20110320145323.4d949738@notabene.brown>
References: <201103181549.20835.xavier@alternatif.org>
	<201103190059.08093.xavier@alternatif.org>
	<20110319124247.41bac36a@notabene.brown>
	<201103191444.40489.xavier@alternatif.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201103191444.40489.xavier@alternatif.org>
Sender: linux-raid-owner@vger.kernel.org
To: Xavier Brochard <xavier@alternatif.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 19 Mar 2011 14:44:40 +0100 Xavier Brochard <xavier@alternatif.o=
rg>
wrote:

> Le samedi 19 mars 2011 02:42:47 NeilBrown, vous avez =E9crit :
> > I suggest you:
> >=20
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
> >=20
> > and let the  array rebuild the spare.
> > Then check the data and make sure it is all good.
> > Then add /dev/sdb1 back in as the spare
> >   mdadm /dev/md0 --add /dev/sdb1
> >=20
> > and everything should be fine - providing you don't hit any hardwar=
e errors
> > etc.
>=20
> It didnt work, until I've stopped the raid array:
> mdadm --zero /dev/sdg1
> mdadm: Couldn't open /dev/sdg1 for write - not zeroing
>=20
> is that normal, can I continue?
>

Yes, you are right.  You need to stop the array before you zero things.

So:
=20
   mdadm -S /dev/md0
   mdadm --zero /dev/the-device-which-thinks-most-of-the-other-devices-=
have-failed
   mdadm -As /dev/md0

That last command might need to be
   mdadm -As /dev/md0 /dev/sdc1 /dev/sdd1 ..... list of all member devi=
ces.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
