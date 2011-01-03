From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: [Slightly OT] Cheap 4-port PCI-E SATA card?
Date: Mon, 03 Jan 2011 16:00:59 +0000
Message-ID: <4D21F2BB.3020905@anonymous.org.uk>
References: <4D20E9F7.2080800@anonymous.org.uk> <4D216FA1.5010502@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D216FA1.5010502@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/01/2011 06:41, Stan Hoeppner wrote:
[...]
> Go with one or two of these SATA II port multipliers with 1 host
> interface and 5 drive interfaces--perfect for a 10 drive setup with t=
wo
> 5 drive cages.
>
> http://www.addonics.com/products/host_controller/ad5sapm.asp
>
> http://www.buy.com/prod/addonics-ad5sapm-serial-ata-controller-5-x-7-=
pin-serial-ata-300-serial/q/loc/101/213272437.html
>
> http://www.siliconimage.com/products/product.aspx?pid=3D32
>
> If your mobo SATA ports support FIS based switching, this PMP will gi=
ve
> you 5 SATA II drive ports.  It doesn't use a PCI slot of any kind.  N=
o
> additional software required.  No kernel driver issues.  300MB/s is
> sufficient for 5 drives in an mdraid setup isn't it?

=46or a backup array, yes, but I'm not sure it is for online storage.=20
300MB/s is an absolute max and there's protocol overhead etc, but even=20
if it's minimal we're still looking at no better than 50MB/s per drive,=
=20
while the drives can manage 125MB/s these days.

I doubt my motherboard supports FIS PMPs. It's an Asus P5Q Pro, Intel=20
P45+ICH10R, and I'm pretty sure the ICH10R doesn't support PMPs even if=
=20
the original spec said it would.

There is a Marvell 88SE6121 SATA+IDE chip on there but it's currently i=
n=20
IDE-only mode for the DVD drive and even if I switched over to SATA mod=
e=20
and a SATA DVD drive that'd only give me one more SATA port. But it=20
might work with a FIS PMP, I suppose.

> When I use these I remove the slot bracket and mount the PCB directly=
 to
> my server chassis side wall using mobo type standoffs.  You may need =
to
> drill a couple of holes in the chassis depending on where you decide =
to
> mount it.  If you're not a mechanically inclined DIY type person, jus=
t
> use the supplied mounting bracket.  This may deny access to an
> underlying PCI slot though.  I prefer the more solid mount and having
> all slots available.

I'd do that too - no problems doing case mods here. I suppose it's=20
possible the mounting holes might be able to be made to line up with=20
some of the mounting holes on the side of the hot-swap chassis. On the=20
other hand I might cheat and use the little plastic mounts with=20
double-sided tape on their feet.

[...]
>   The driver for the Marvell chip is present in kernel
> 2.6.19 and later.  Considering that 2.6.19 is like 6 years old, I'd h=
ope
> your kernel is newer.

It's kernel-2.6.18-194.26.1.el5 so it's stuffed full of backports and=20
security updates, it's less than two months old. Yes, I have sata_mv,=20
but several people have reported data corruption issues with some=20
Marvell controllers - a bad interaction with SMART I think.

> It may be a little more money than you were planning on spending, but
> for little more than the cost of one hard drive

In this case I'm using consumer-level drives so they're about =C2=A340 =
($60),=20
so $165 is a bit rich for me, especially since it's potentially limited=
=20
for throughput.

Nevertheless, thank you very much for taking the time for such a=20
considered reply.

Cheers,

John.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
