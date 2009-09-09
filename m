From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: Adaptec 1430SA
Date: Wed, 9 Sep 2009 00:44:09 -0700 (PDT)
Message-ID: <332340.55866.qm@web51306.mail.re2.yahoo.com>
References: <70ed7c3e0909081513h5affac5at2ce313d02bb01eba@mail.gmail.com>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909081513h5affac5at2ce313d02bb01eba@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>, "Majed B." <majedb@gmail.com>
Cc: Jon@ehardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Tue, 8/9/09, Majed B. <majedb@gmail.com> wrote:

> From: Majed B. <majedb@gmail.com>
> Subject: Re: Adaptec 1430SA
> To: "John Robinson" <john.robinson@anonymous.org.uk>
> Cc: Jon@ehardcastle.com, linux-raid@vger.kernel.org
> Date: Tuesday, 8 September, 2009, 11:13 PM
> Check this link out:
> http://blog.backblaze.com/2009/09/01/petabytes-on-a-budget-how-to-bui=
ld-cheap-cloud-storage/
>=20
> AT the end, they have a list of components, cheap ones. One
> is a
> 2-port sata card and another is a 4-port sata card. You
> might find
> them appealing to your usage.
>=20
> On Tue, Sep 8, 2009 at 6:39 PM, John
> Robinson<john.robinson@anonymous.org.uk>
> wrote:
> > On 08/09/2009 15:34, Jon Hardcastle wrote:
> >>
> >> --- On Tue, 8/9/09, Majed B. <majedb@gmail.com>
> wrote:
> >>>
> >>> Jon, According to this link (
> >>>
> >>> http://groups.google.com/group/linux.debian.ports.x86-64/browse_t=
hread/thread/12f2084ceace4c08?pli=3D1
> >>> ) that card uses fake raid
> >
> > [...]
> >>
> >> Hi, thanks for the link! I was planning on just
> using it as a means to get
> >> more ports - and then use mdadm to actually to the
> raid part.
> >
> > Been doing a spot of Googling around this myself.
> Looks like there's open
> > source code available to support seeing the discs,
> either with sata_mv or
> > Adaptec's own aar81xx drivers, which will get you
> going for what you say
> > above. However, if you did want to use HostRAID
> (Adaptec's name for
> > fakeraid) you either have to build Adaptec's driver
> linking in their
> > closed-source binary HostRAID code or use the open
> source dmraid.
> >
> > I'm a bit mystified at the idea of Adaptec using
> Marvell chips, though. I
> > wonder what that's all about?
> >
> > Cheers,
> >
> > John.
> >
>=20
>=20
>=20
> --=20
> =A0 =A0 =A0=A0=A0Majed B.
>=20

Are you referring to the Addonics ADSA4R5? Thanks for the heads up! Is =
PCI straight up got the throughput for 4 devices? I have a 2 port cheap=
y PCI via card Sata 1 and it has turned out to be abit of a mare...

Whilst I have a skilled audience :) Do you have any experience with por=
t multiplier?

-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
'Do not worry about tomorrow, for tomorrow will bring worries of its ow=
n.'
-----------------------


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
