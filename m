From: NeilBrown <neilb@suse.de>
Subject: Re: Can't start array and Negative "Used Dev Size"
Date: Wed, 29 Jun 2011 15:37:53 +1000
Message-ID: <20110629153753.5279c034@notabene.brown>
References: <BANLkTincbuZrS3PuPBOgjidsR8jdyTGBRw@mail.gmail.com>
	<20110629151825.56cb4499@notabene.brown>
	<BANLkTimonHoSn5eoX9AB8wLJYR4SFoBd-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimonHoSn5eoX9AB8wLJYR4SFoBd-w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Matthews <simon.d.matthews@gmail.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 28 Jun 2011 22:24:41 -0700 Simon Matthews
<simon.d.matthews@gmail.com> wrote:

> Neil,
>=20
>=20
>=20
> On Tue, Jun 28, 2011 at 10:18 PM, NeilBrown <neilb@suse.de> wrote:
> > =A0mdadm -S /dev/md5
> > =A0mdadm -C /dev/md5 --metadata 1.0 -l1 -n2 --assume-clean
>=20
> Will I lose data if I do this? Should I use metadata 1.2 ?

If you use 1.2 you will lose data.  If you use 1.0 you will not.

With 0.90 and 1.0 the data starts at the start of each device. so 1.0 w=
ill
see the same data as 0.90 would.

With 1.2 there is some metadata first and the start starts later, so if=
 you
use that the data will appear in the wrong place.

NeilBrown

>=20
> >
> > Then all should be happiness.
> >>
> >
> > =A0mdadm -S /dev/md4
> > =A0mdadm -A /dev/md4 /dev/sdc1 /dev/sdd1 --verbose
>=20
> That solved it. The array started.
>=20
> Thanks!
>=20
> Simon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
