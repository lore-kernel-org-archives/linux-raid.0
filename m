From: Xavier Brochard <xavier@alternatif.org>
Subject: Re: disk order problem in a raid 10 array
Date: Sun, 20 Mar 2011 11:40:20 +0100
Message-ID: <201103201140.21279.xavier@alternatif.org>
References: <201103181549.20835.xavier@alternatif.org> <201103191444.40489.xavier@alternatif.org> <20110320145323.4d949738@notabene.brown>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110320145323.4d949738@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Le dimanche 20 mars 2011 04:53:23 NeilBrown, vous avez =E9crit :
> On Sat, 19 Mar 2011 14:44:40 +0100 Xavier Brochard <xavier@alternatif=
=2Eorg>
>=20
> wrote:
> > Le samedi 19 mars 2011 02:42:47 NeilBrown, vous avez =E9crit :
> > > I suggest you:
> > >   mdadm --zero /dev/sdb1
> > >=20
> > > having first double-checked that sdb1 is the devices with Events =
of
> > > 154,
> > >=20
> > > then
> > >=20
> > >  mdadm -S /dev/md0
> > >  mdadm -As /dev/md0
> > >=20
> > > and let the  array rebuild the spare.
> > > Then check the data and make sure it is all good.
> > > Then add /dev/sdb1 back in as the spare
> > >=20
> > >   mdadm /dev/md0 --add /dev/sdb1
> > >=20
> > > and everything should be fine - providing you don't hit any hardw=
are
> > > errors etc.
> >=20
> > It didnt work, until I've stopped the raid array:
> > mdadm --zero /dev/sdg1
> > mdadm: Couldn't open /dev/sdg1 for write - not zeroing
> >=20
> > is that normal, can I continue?
>=20
> Yes, you are right.  You need to stop the array before you zero thing=
s.
>=20
> So:
>=20
>    mdadm -S /dev/md0
>    mdadm --zero
> /dev/the-device-which-thinks-most-of-the-other-devices-have-failed md=
adm
> -As /dev/md0
>=20
> That last command might need to be
>    mdadm -As /dev/md0 /dev/sdc1 /dev/sdd1 ..... list of all member de=
vices.

I would like to thank you very much for you help.
You helped me to understand mdadm message and to keep only relevant par=
t of=20
the various errors I could see in the logs. Your explanation and instru=
ctions=20
were a great help to repair .

Everything is working now.
Thanks again.

Xavier
xavier@alternatif.org=20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
