From: Xavier Brochard <xavier@alternatif.org>
Subject: Re: disk order problem in a raid 10 array
Date: Sat, 19 Mar 2011 00:06:30 +0100
Message-ID: <201103190006.31231.xavier@alternatif.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Le vendredi 18 mars 2011 23:14:05, NeilBrown  =E9crivait :
> On Fri, 18 Mar 2011 15:49:20 +0100 Xavier Brochard <xavier@alternatif=
=2Eorg>
> > trying to solve my problem with a unusable raid10 array, I discover=
ed
> > that disk order is mixed between each boot - even with live-cd.
> > Here's an extract from dmesg:
> > [   12.5]  sda:
> > [   12.5]  sdc:
> > [   12.5]  sdd:
> > [   12.5]  sde: sdd1
> > [   12.5]  sdf: sdc1
> > [   12.5]  sda1 sda2
> > [   12.5]  sdg: sde1
> > [   12.5]  sdf1
> >=20
> > is that normal?
>=20
> You are saying that something changes between each boot, but only giv=
ing
> one example so that we cannot see the change.  That is not particular=
ly
> helpful.

sorry, I didn't want to send too long email
as each dmesg show diffent but similar output


> The output above is a bit odd, but I think it is simply that the devi=
ces
> are all being examined in parallel so the per-device messages are bei=
ng
> mingled together.
> Certainly 'sdd1' is on 'sdd', not no 'sde' as the message seems to sh=
ow.

ok thanks


Xavier
xavier@alternatif.org - 09 54 06 16 26
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
