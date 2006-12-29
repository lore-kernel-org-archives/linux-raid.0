From: Michael Schmitt <mschmitt@unixkiste.org>
Subject: Re: confusion about partitionable md arrays
Date: Fri, 29 Dec 2006 09:31:45 +0100
Message-ID: <1167381105.12758.57.camel@localhost.localdomain>
References: <1167161228.3918.41.camel@localhost.localdomain>
	 <4594897A.4080903@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4594897A.4080903@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Bill,

this `thing=C2=B4 works in another computer and as I moved it to anothe=
r one,
I could not get it working. So the problem is... somewhere in between :=
)
As I had other non md-related problems in this computer (power supply
insufficient, system could not boot from hda anymore when sata disks
were connected to the pci-controller so I needed to unplug the sata
cables until grub has loaded, BIOS upgrade did not help), I moved the
array back in the original one, and it worked without a change.

But I noticed there a different behavior "Generating udev events for MD
arrays" showed up during boot, listing the partitions md0_d0p1 to
md0_d0p4 and of course /dev/md0_d0pN showed up. Then I cogitated about
all that a bit and came to some possible conclusions. Maybe the nameing
scheme for the arrays need to reflect somehow if it is a partibionable
array or not, if there are partitions and if udev needs to add the
appropriate devices... or not. Then I remembered some of the strange
things which happend when I did set up the array in the first place. I
tried to name the array "md0" but /dev/md_0" was generated too. /dev/md=
0
was somehow "dead" and my array was accessible as /dev/md0_d0. A bit
later as I tried to build an array with IDE discs in the "troublesome"
computer, I noticed similar effects. I tried to name the array
simple /dev/array1 but /dev/md127_d0 (iirc) was generated
too. /dev/array1 was dead and the raid was accessible at /dev/md127_d0.
So, whats all that? Even if I had read somehwere the name of the device
can be anything, it may be that that's not really true.

So the question remains the same, the confusion is persistent as the
superblocks in my arrays :) Any input is appreciated.

I already did read some mails in this list but did not get the point an=
d
no real explanation to my question. I will read on, maybe I get
enlightenment.

greetings
Michael

Am Donnerstag, den 28.12.2006, 22:20 -0500 schrieb Bill Davidsen:
> Michael Schmitt wrote:
> > Hi list,
> >
> > since recent releases obviously it is possible to build an array an=
d
> > partition that instead of building an array out of partitions. This=
 was
> > somehow confusing but it worked in the first place. Now I moved the
> > array from one machine to another and... now it gets somehow strang=
e. I
> > have nothing in /dev/md/ but /dev/md0. If I do fdisk -l it lists th=
e
> > partitions /dev/md0p1 to /dev/md0p4, set to type 83 but there are n=
o
> > devices under /dev/ or in /proc/partitions for them. I've read the
> > archives and googled around but there was no real solution just
> > different meanings on how it should be and how such things come. I'=
d
> > really appreciate a definite answer how that should work with
> > partitionable arrays and in best cases, what my problem may be here=
 :)
> >
> > At the end of this mail are the mdstat and mdadm outputs for refere=
nce
> >
> >  =20
> I'm not sure you have a problem, if this whole thing works correctly.=
=20
> However, there has been discussion about the implications of using wh=
ole=20
> drives instead of partitions to build your array. Having avoided that=
=20
> particular path I'm not going to rehash something I marginally=20
> understand, but some reading of post in the last few months may shed=20
> understanding.
>=20

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
