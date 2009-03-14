From: Harry Mangalam <harry.mangalam@uci.edu>
Subject: Re: rescue an alien md raid5
Date: Sat, 14 Mar 2009 10:15:58 -0800
Message-ID: <200903141115.59105.harry.mangalam@uci.edu>
References: <200902231013.46082.harry.mangalam@uci.edu> <200902241311.33442.harry.mangalam@uci.edu> <7d86ddb90903140712v358c170bq554e9fd963099a1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7d86ddb90903140712v358c170bq554e9fd963099a1@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Ryan Wagoner <rswagoner@gmail.com>
Cc: hgichon <kpkim@gluesys.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I mentioned the OSS layer because if LVM was involved, it would have=20
been included in the GPL'ed SW listing.

As noted, there's no LVM software in the GPL listing, and none of the=20
commands were found on the NAS device - it can be telnet'ed into, but=20
has a limited set of tools available (busybox and not much else=20
besides mdadm)

I've since found out that the data on the RAID was a set of VM images=20
that were recoverable via other means so I'm stopping my efforts to=20
restore it. =20

It was an interesting diversion tho and I thank all of the comments=20
and suggestions.  I've learned a lot.

Harry


On Saturday 14 March 2009, Ryan Wagoner wrote:
> No LVM has no correlation with mdadm. LVM stands for logical volume
> manager and lets you dynamically partition space on top of a real
> partition. Try running the commands below. If LVM is not used it
> won't affect the data on the disk. If it is used then your problem
> is resolved.
>
> On Tue, Feb 24, 2009 at 4:11 PM, Harry Mangalam=20
<harry.mangalam@uci.edu> wrote:
> > Hi kpkim,
> >
> > You mean that the system needs an lvm/lvm2 layer to properly
> > interpret the underlying filesystem?
> >
> > Possible, but the USR OSS list:
> > <http://www.usr.com/support/gpl/8700-OpenSourcesList-0.63_USR.xls
> >> doesn't list lvm as part of their implementation. =A0Would mdadm
> > have been able to detect this?
> >
> > Harry
> >
> > On Monday 23 February 2009, hgichon wrote:
> >> I read USRobotics 8700 feature.
> >>
> >> # Supports linear storage use (all drives as one logical drive)
> >> or use multiple drives as primary and back-up storage
> >> # Dynamic logical drive sizing - Add an additional drive, when
> >> needed, and it will be integrated into the logical drive with no
> >> effect on data
> >>
> >> maybe... there is no lvm layer?
> >> try vgscan / vgchange -ay
> >>
> >> best regards.
> >
> > --
> > Harry Mangalam - Research Computing, NACS, E2148, Engineering
> > Gateway, UC Irvine 92697 =A0949 824-0084(o), 949 285-4487(c)
> > ---
> > Good judgment comes from experience;
> > Experience comes from bad judgment. [F. Brooks.]
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-raid" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at
> > =A0http://vger.kernel.org/majordomo-info.html



--=20
Harry Mangalam - Research Computing, NACS, E2148, Engineering Gateway,=20
UC Irvine 92697  949 824-0084(o), 949 285-4487(c)
---
Good judgment comes from experience;=20
Experience comes from bad judgment. [F. Brooks.]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
