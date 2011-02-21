From: NeilBrown <neilb@suse.de>
Subject: Re: Likely forced assemby with wrong disk during raid5 grow.
 Recoverable?
Date: Mon, 21 Feb 2011 11:53:03 +1100
Message-ID: <20110221115303.4862e093@notabene.brown>
References: <AANLkTikhOAXQ6JAG1fK3x9V3icki8cjn0_ggyQwkGmnt@mail.gmail.com>
	<AANLkTi=5UZcMRKHTiXC3w8joh-qyi50gtTYwRf_scksW@mail.gmail.com>
	<20110220162509.2eb85a03@notabene.brown>
	<AANLkTi=-guMf-8YJDMvq9ybyY9Fppi+W0pqhH2Of=mKd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=-guMf-8YJDMvq9ybyY9Fppi+W0pqhH2Of=mKd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Claude Nobs <claudenobs@blunet.cc>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 20 Feb 2011 15:44:35 +0100 Claude Nobs <claudenobs@blunet.cc> w=
rote:

> > They are the 'Number' column in the --detail output below. =A0This =
is /dev/md1
> > - I can tell from the --examine outputs, but it is a bit confusing.=
 =A0Newer
> > versions of mdadm make this a little less confusing. =A0If you look=
 for
> > patterns of U and u =A0in the 'Array State' line, the U is 'this de=
vice', the
> > 'u' is some other devices.
>=20
> Actually this is running a stock Ubunutu 10.10 server kernel. But as
> it is from my memory it could very well have been :
>=20
>        2930281920 blocks super 1.2 level 5, 64k chunk, algorithm 2 [4=
/5] [U_UUU]
>=20

I'm quite sure it would have been '[U_UUU]' as you say.

When I say "Newer versions" I mean of mdadm, not the kernel.

What does
   mdadm -V

show?  Version 3.0 or later gives less confusing output for "mdadm --ex=
amine"
on 1.x metadata.

> > Just to go through some of the numbers...
> >
> > Chunk size is 64K. =A0Reshape was 4->5, so 3 -> 4 data disks.
> > So old stripes have 192K, new stripes have 256K.
> >
> > The 'good' disks think reshape has reached 502815488K which is
> > 1964123 new stripes. (2618830.66 old stripes)
> > md1 thinks reshape has only reached 489510400K which is 1912150
> > new stripes (2549533.33 old stripes).
>=20
> i think you mixed up sdd1 with md1 here? (the numbers above for md1
> are for sdd1. md1 would be :  reshape has reached 502809856K which
> would be 1964101 new stripes. so the difference between the good disk=
s
> and md1 would be 22 stripes.)

Yes, I got them mixed up.  But the net result is the same - the 'new' s=
tripes
numbers haven't got close to overwriting the 'old' stripe numbers.

>=20
> >
> > So of the 51973 stripes that have been reshaped since the last meta=
data
> > update on sdd1, some will have been done on sdd1, but some not, and=
 we don't
> > really know how many. =A0But it is perfectly safe to repeat those s=
tripes
> > as all writes to that region will have been suspended (and you prob=
ably
> > weren't writing anyway).
>=20
> jep there was nothing writing to the array. so now i am a little
> confused, if you meant sdd1 (which failed first is 51973 stripes
> behind) this would imply that at least so many stripes of data are
> kept of the old (3 data disks) configuration as well as the new one?
> if continuing from there is possible then the array would no longer b=
e
> degraded right? so i think you meant md1 (22 stripes behind), as
> keeping 5.5M of data from the old and new config seems more
> reasonable. however this is just a guess :-)

Yes, it probably is possible to re-assemble the array to include sdd1 a=
nd not
have a degraded array, and still have all your data safe - providing yo=
u are
sure that nothing at all changed on the array (e.g. maybe it was unmoun=
ted?).

I'm not sure I'd recommend it though....  I cannot see anything that wo=
uld go
wrong, but it is somewhat unknown territory.
Up to you...

If you:

% git clone git://neil.brown.name/mdadm master
% cd mdadm
% make
% sudo bash
# ./mdadm -S /dev/md2
# ./mdadm -Afvv /dev/md2 /dev/sda1 /dev/md0 /dev/md1 /dev/sdc1

It should restart your array - degraded - and repeat the last stages of
reshape just in case.

Alternately, before you run 'make' you could edit Assemble.c, find:
	while (force && !enough(content->array.level, content->array.raid_disk=
s,
				content->array.layout, 1,
				avail, okcnt)) {

around line 818, and change the '1,' to '0,', then run make, mdadm -S, =
and
then
# ./mdadm -Afvv /dev/md2 /dev/sda1 /dev/md0 /dev/md1 /dev/sdc1 /dev/sdd=
1

it should assemble the array non-degraded and repeat all of the reshape=
 since
sdd1 fell out of the array.

As you have a backup, this is probably safe because even if to goes bad=
 you
can restore from backups - not that I expect it to go bad but ....

> >
> > Thanks for the excellent problem report.
> >
> > NeilBrown
>=20
> Well i thank you for providing such an elaborate and friendly answer!
> this is actually my first mailing list post and considering how many
> questions get ignored (don't know about this list though) i just hope=
d
> someone would at least answer with a one liner... i never expected
> this. so thanks again.

All part of the service... :-)

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
