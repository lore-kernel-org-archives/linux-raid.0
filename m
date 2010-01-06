From: Lapohos Tibor <tibor.lapohos@rogers.com>
Subject: Re: embedding area is unusually small... (GRUB2 on software RAID1)
Date: Wed, 6 Jan 2010 13:40:46 -0800 (PST)
Message-ID: <932657.98441.qm@web88207.mail.re2.yahoo.com>
References: <1262825627.g6ATheBPQY@rnqqfki.eternal-september.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1262825627.g6ATheBPQY@rnqqfki.eternal-september.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you Antonio!

--- On Wed, 1/6/10, Antonio Perez <ap23563m@gmx.com> wrote:

> However, you did repartition md0, while still expecting to
> boot from md0.
>=20
> That is "odd" to me. Just make a FS in md0 and use it as>
> /boot (and root).

I've been, and still am, puzzled by the efficiency of the calculations =
involved in setting up RAID, one way or the other. And what I refer to,=
 goes down to number of clocks needed to perform the writing. As I was =
wondering down this path, I figured that the way I set it up would be t=
he most efficient. Of course, I do not know enough about the actual ker=
nel/raid code to be able to tell for sure. My intuition dictated it thi=
s way.

> > should I create all the partitions first and build
> > them into so many /dev/md[01234] devices separately maybe?
>
> I could tell you what seems to be a reasonable setup IMO:
> =A0=A0=A0 200Mb --> {sda1,sdb1} --> md1 --> RAID1 --> use as /boot
> =A0=A0=A0 5Gb=A0=A0=A0--> {sda2,sdb2} --> md2 --> RAID1 --> use as /
> =A0=A0=A0 ...

=2E...and that's exactly what is also on my list, and your suggestion e=
nforces my thoughts, thanks. Nevertheless, it still does not explain to=
 me whether multiple md devices with more underlying disk partitions or=
 more md partitions with fewer underlying disk partitions are the way t=
o go. To be absolutely clear, is the

/dev/sd[ab]1 =3D> /dev/md0 =3D> /dev/md0p[123...] [RAID1]
/dev/sd[ab]2 =3D> /dev/md1 =3D> /dev/md1p[123...] [RAID0]

or the

/dev/sd[ab][123...] =3D> /dev/md[012...] [RAID1,RAID0]

setup the most stable, efficient and robust solution? The way I see it,=
 there shall be a difference somewhere, somehow, right? About the first=
 one, thanks to Michael E. pointing it out, we already know that one ha=
s to take care about choosing the patritions.

=46urthermore, I think that the gain in speed of RAID0 would start vani=
shing if disk access is required on the RAID1 side all at the same time=
=2E In fact, the whole system's efficiency would degrade. The only way =
out would be to use 4 disks as

/dev/sd[ab]1 =3D> /dev/md0 =3D> /dev/md0p[123...] [RAID1]
/dev/sd[cd]1 =3D> /dev/md1 =3D> /dev/md1p[123...] [RAID0]

Right? Keep in mind that I am not after what RAID10 can offer. I can af=
ford giving up the data safety on the RAID0 side in exchange for speed.

> Having only two disks means to use only RAID1. RAID0 is too
> risky IMO as any disk failure means a complete loss of data.

I will be developing a numerical electromagnetics code, that will do qu=
ite some number crunching and dumping with 4xTesla C1060 GPUs. I will n=
eed the RAID0 for that purpose, for a scratch space, if you will. So it=
 is a must have for me.

> I am a common user which is trying to help you.

Thanks, it's highly appreciated.

> But, in this list alone, there are three post from you with exactly t=
he
> same content and question.=20

That's really odd. I would never do that intentionally. As I wrote earl=
ier, I did submit it to 3 lists, help-grub, grub-devel and linux-raid, =
but not to the same one 3 times. The subject is related to both RAID an=
d GRUB, which is why I sent it 3 ways. My apologies again to all those =
who got it in 3 copies, whether by being subscribed to all 3 lists, or =
by a misterious triple submission of mine.=20

> If you are not getting any feedback, perhaps you should re-think=20
> of a different way to make your questions. And, please,
> allow more time for an answer.

I am a patient man, so not getting answers would not drive me to re-pos=
t the same message again.

> Thanks for your cooperation.

Absolutely. And I thank to all for your help.

All the best,
Tibor

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
