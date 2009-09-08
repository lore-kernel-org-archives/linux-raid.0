From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: Adaptec 1430SA
Date: Tue, 8 Sep 2009 22:24:53 +0000
Message-ID: <73e903670909081524j3e676e98pf0921e79ac3daf93@mail.gmail.com>
References: <769530.6689.qm@web51307.mail.re2.yahoo.com>
	 <4AA67ACF.2080506@anonymous.org.uk>
	 <70ed7c3e0909081513h5affac5at2ce313d02bb01eba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909081513h5affac5at2ce313d02bb01eba@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: John Robinson <john.robinson@anonymous.org.uk>, Jon@ehardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Sep 8, 2009 at 10:13 PM, Majed B. <majedb@gmail.com> wrote:
>
> Check this link out:
> http://blog.backblaze.com/2009/09/01/petabytes-on-a-budget-how-to-bui=
ld-cheap-cloud-storage/
>
> AT the end, they have a list of components, cheap ones. One is a
> 2-port sata card and another is a 4-port sata card. You might find
> them appealing to your usage.
>
> On Tue, Sep 8, 2009 at 6:39 PM, John
> Robinson<john.robinson@anonymous.org.uk> wrote:
> > On 08/09/2009 15:34, Jon Hardcastle wrote:
> >>
> >> --- On Tue, 8/9/09, Majed B. <majedb@gmail.com> wrote:
> >>>
> >>> Jon, According to this link (
> >>>
> >>> http://groups.google.com/group/linux.debian.ports.x86-64/browse_t=
hread/thread/12f2084ceace4c08?pli=3D1
> >>> ) that card uses fake raid
> >
> > [...]
> >>
> >> Hi, thanks for the link! I was planning on just using it as a mean=
s to get
> >> more ports - and then use mdadm to actually to the raid part.
> >
> > Been doing a spot of Googling around this myself. Looks like there'=
s open
> > source code available to support seeing the discs, either with sata=
_mv or
> > Adaptec's own aar81xx drivers, which will get you going for what yo=
u say
> > above. However, if you did want to use HostRAID (Adaptec's name for
> > fakeraid) you either have to build Adaptec's driver linking in thei=
r
> > closed-source binary HostRAID code or use the open source dmraid.
> >
> > I'm a bit mystified at the idea of Adaptec using Marvell chips, tho=
ugh. I
> > wonder what that's all about?
> >
> > Cheers,
> >
> > John.
> >
>
> --
> =A0 =A0 =A0 Majed B.


Hi all,

I've used a Supermicro 8-port Marvell PCI-X card in Linux that works
really well. There's driver support in the kernel for it and it's
great. The type is AOC-SAT2-MV8:
http://www.supermicro.com/products/accessories/addon/AOC-SAT2-MV8.cfm

I've also used a PCI-Express card from Supermicro, the AOC-SASLP-MV8,
that did NOT work as well. I only managed to get it running on the
Linux 2.6.31 release candidates, and even then, it loses disks under
heavy load such as when building an array. There is work ongoing in
the relevant subsystems of the Linux kernel, so I predict that it will
work fine in kernel 2.6.31 final, but I wouldn't count on it just yet.
The card is well built and looks good, it's just that driver support
isn't solid yet.

So, Supermicro multiport SATA cards: PCI-X good, PCI-Express not so
great. Both cards are quite cheap as far as I can tell, and solidly
designed. Supermicro using them is also a vote of confidence in my
book.

Hope this helps someone!

-- Kristleifur
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
