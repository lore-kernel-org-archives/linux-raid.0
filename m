From: Ralph =?iso-8859-1?q?Pa=DFgang?= <ralph@debianbase.de>
Subject: Re: Which raid card to buy for Sarge
Date: Wed, 31 Mar 2004 20:03:41 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200403312003.41762.ralph@debianbase.de>
References: <008f01c41737$8b57be40$6405a8c0@a30> <002501c4173f$3cfda1d0$6405a8c0@a30> <yw1xekr9uf6a.fsf@kth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yw1xekr9uf6a.fsf@kth.se>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Mittwoch, 31. M=E4rz 2004 18:58 schrieben Sie:
> <me@heyjay.com> writes:
> > Seems like 3ware is the card of choice.  I'll probably pick one up =
at
> > cdw, unless anyone knows where I can get them on the cheap.
> >
> > Speaking of cheap, anyone ever have any luck with the Highpoint
> > RocketRaid cards on Sarge?
>
> I don't use debian, but my rocketraid is doing well with recent kerne=
ls.
>
> > They're roughly 80% the price of 3ware (maybe you get what you pay
> > for)
>
> 80%?  You must mean 20%.  The Highpoint cards are software raid cards=
,
> meaning that they are just regular ATA cards with a "RAID" label
> slapped on the box.

If would not use the "raid" feature of the Highpoint cards, because it =
is only=20
software raid and not so performant as a hardware raid. If you don't ne=
ed a=20
high-end system, then you can make a software raid with linux standard =
tools=20
like: mdadm. If you need performance, then you should think about a scs=
i raid=20
setup and a good adapter, maybe adaptec or 3ware or something like that=
=2E

If software raid, then I would prefer a linux software raid (with mdadm=
 for=20
example) and would not use not good supported third-party software raid=
=20
"drivers". For mdadm you will find more support and you can migrate the=
 disks=20
in another linux box and it will read the raid... With the Highpoint ra=
id=20
function you are forced to continue using the highpoint card.

And just for your information, you don't have to look after a card that=
 is=20
specially supported by Debian. Debian uses a normal linux kernel (+ som=
e=20
patches, but nothing revolutionary) so it can handle each raid adapter =
that=20
is supported by the linux kernel... It's the same for SuSE and RedHat,=20
because they support each adapter supported by the standard linux kerne=
l plus=20
maybe some patched-in drivers). But even when the adapter is not suppor=
ted in=20
the vanilla kernel you can patch a kernel-source by yourself... But it =
is=20
always a good decision to only use hardware that is supported in a stoc=
k=20
kernel.

So better look after general linux support. I think there is not one pi=
ece of=20
hardware that is declared as: "ready for debian sarge" :))
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
