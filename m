From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: wish for Linux MD mirrored raid types
Date: Fri, 6 May 2011 11:27:48 +0200
Message-ID: <20110506092748.GB22245@www2.open-std.org>
References: <20110506071752.GA22063@www2.open-std.org> <iq098e$tqo$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <iq098e$tqo$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 06, 2011 at 09:51:45AM +0200, David Brown wrote:
> On 06/05/2011 09:17, Keld J=F8rn Simonsen wrote:
> >Hi List
> >
> >based on the recent discussion, that showed lacking knowledge
> >on Linux MD RAID10 features, I have some thoughts:
> >
> >It is really hard to disseminate information on "new" features
> >in MD RAID. RAID10 has been in the kernel since 2.6.9 - from 2004.
> >I have tried to give info on RAID10 at a number of web pages,
> >and still many people, even on our linux-raid list are not aware
> >of it.
> >
> >Also many people are confused about Linux MD raid10 and RAID1+0.
> >
> >So I think we shopuld rather name things in another way.
> >
> >I would like linux MD raid10 functionality to be part of the Linux M=
D
> >RAID1 module, and be called raid1. This is in accordance with the
> >use of the RAID1 term as standadized by SNIA. In fact the RAID10-off=
set
> >layout is an implementation of a SNIA RAID specification. The RAID10=
-near
> >layout is an implementation of a simple RAID layout. And the RAID10-=
far
> >layout is just another layout far a mirrored RAID.  So all these typ=
es
> >could just be defined as different RAID1 layouts.
> >
> >I would then also wish for RAID10-far to be the default RAID1
> >layout. There is general agreement on this list that RAID10-far
> >is the best mirrored layout for most purposes. In the interest of gi=
ving
> >the best performance to the Linux RAID users, we should make
> >the defaults the best practise - users tend to choose defaults,
> >especially often they do not have much knowledge.
> >
> >We could still keep the RAID10 code for backwards compatibility,
> >or even let this new naming just be calls to the raid10 code
> >from the raid1 module.
> >
>=20
> I mostly agree with you, but for a few points:
>=20
> You say the various raid10 layouts match SNIA RAID1 specifications an=
d=20
> layouts - does that also apply if you have more than two disks?  And=20
> what about weird things like raid10 over three disks?

I don't know. But anyway, you can see it as an extension of SNIA
standard RAID1 layouts. And then if the SNIA standard does not cover it=
,
the standard should be enhanced. I have sent specs on the far layout to
SNIA twice, but witout any response.

> There are times when it is important that a standard raid1 element is=
=20
> also accessible as a normal disk (with metadata 0.90).  Examples incl=
ude=20
> booting and sometimes data recovery or transferring the disk to anoth=
er=20
> machine.

yes, and then we should document how this is done. Also boot loaders ar=
e
becoming more intelligent, so one common case where the raid also need
to be seen as a normal disk is going away.

> There are things you can do with raid1 that you cannot do with raid10=
 at=20
> the moment, such as re-shaping and re-sizing.  It wouldn't make sense=
 to=20
> classify raid10 as a type of raid1 until it also has this capability.

Well, theoretically Linux MD RAID10 is a mirrored RAID type - that is a
RAID1 in standard parlance. You could document that some RAID1 layouts
cannot be re-shaped or re-sized.  I generally like to be backward
compatible, and I think this can be esily done just by naming the
different layouts of RAID1, for example: classic, near, far, offset,
directly corresponding to the functionalities and possibly kernel
modules that we have today.


> It is also not clear how adding an extra drive to a raid10,far layout=
=20
> should work.  If you add an extra drive to a raid1 set, you get a=20
> three-way mirror.=20

You need to be clear on how you add disks - if you want more copies, or
more space with the same number of copies. I think the default would=20
be to add more space. It is quite uncommon to want more than 2 copies,
while a need for more space happens all the time.


> If you add an extra drive to a raid10,far drive,=20
> should it directly mirror one of the existing drives?  Should it resh=
ape=20
> to a raid10,far3 arrangement?  Should it turn into a raid10,far2 and=20
> re-balance across the disks?  Any of these might be valid choices.

Agree that any of these are valid. And thus all of them should be doabl=
e.
But implementation will most likely be piece wise. I see no problem wit=
h
architecture there. You can always say that some features are
implemented, and some are not. That is at least the current situation,
and this is a very normal situation.

> I support your "campaign for raid10,far awareness", but I'm not sure=20
> that making it the default for raid1 is appropriate at the moment.  O=
nce=20
> raid10 re-shapes and re-sizes are fully supported, and once all main=20
> distros have moved to a new enough version of grub (which supports=20
> booting from raid10, and different metadata versions), then there wil=
l=20
> be few reasons for anyone to choose "standard" raid1 rather than raid=
10,far.

Everything takes time. But we can set a goal, and then plan for
reaching the goal. I am sure if we do it right, we can get there in
a time less than what we have had since the introduction of the raid10
driver in 2004.

> just ask you which drive you want to use - if the support raid at all=
=20
> during installation, it is accessed through "advanced" and "manual=20
> partition" screens.  And getting grub onto both disks is very much a=20
> post-install manual operation, for those that know that it needs to b=
e=20
> done.  Getting distro installers to set up raid10,far by default woul=
d=20
> be a much bigger step.

I would like it to be done in distro installers, with the help of grub
et al. And work is underway in some distros to do that.

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
