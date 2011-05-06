From: David Brown <david@westcontrol.com>
Subject: Re: wish for Linux MD mirrored raid types
Date: Fri, 06 May 2011 09:51:45 +0200
Message-ID: <iq098e$tqo$1@dough.gmane.org>
References: <20110506071752.GA22063@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110506071752.GA22063@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/05/2011 09:17, Keld J=F8rn Simonsen wrote:
> Hi List
>
> based on the recent discussion, that showed lacking knowledge
> on Linux MD RAID10 features, I have some thoughts:
>
> It is really hard to disseminate information on "new" features
> in MD RAID. RAID10 has been in the kernel since 2.6.9 - from 2004.
> I have tried to give info on RAID10 at a number of web pages,
> and still many people, even on our linux-raid list are not aware
> of it.
>
> Also many people are confused about Linux MD raid10 and RAID1+0.
>
> So I think we shopuld rather name things in another way.
>
> I would like linux MD raid10 functionality to be part of the Linux MD
> RAID1 module, and be called raid1. This is in accordance with the
> use of the RAID1 term as standadized by SNIA. In fact the RAID10-offs=
et
> layout is an implementation of a SNIA RAID specification. The RAID10-=
near
> layout is an implementation of a simple RAID layout. And the RAID10-f=
ar
> layout is just another layout far a mirrored RAID.  So all these type=
s
> could just be defined as different RAID1 layouts.
>
> I would then also wish for RAID10-far to be the default RAID1
> layout. There is general agreement on this list that RAID10-far
> is the best mirrored layout for most purposes. In the interest of giv=
ing
> the best performance to the Linux RAID users, we should make
> the defaults the best practise - users tend to choose defaults,
> especially often they do not have much knowledge.
>
> We could still keep the RAID10 code for backwards compatibility,
> or even let this new naming just be calls to the raid10 code
> from the raid1 module.
>

I mostly agree with you, but for a few points:

You say the various raid10 layouts match SNIA RAID1 specifications and=20
layouts - does that also apply if you have more than two disks?  And=20
what about weird things like raid10 over three disks?

There are times when it is important that a standard raid1 element is=20
also accessible as a normal disk (with metadata 0.90).  Examples includ=
e=20
booting and sometimes data recovery or transferring the disk to another=
=20
machine.

There are things you can do with raid1 that you cannot do with raid10 a=
t=20
the moment, such as re-shaping and re-sizing.  It wouldn't make sense t=
o=20
classify raid10 as a type of raid1 until it also has this capability.

It is also not clear how adding an extra drive to a raid10,far layout=20
should work.  If you add an extra drive to a raid1 set, you get a=20
three-way mirror.  If you add an extra drive to a raid10,far drive,=20
should it directly mirror one of the existing drives?  Should it reshap=
e=20
to a raid10,far3 arrangement?  Should it turn into a raid10,far2 and=20
re-balance across the disks?  Any of these might be valid choices.


I support your "campaign for raid10,far awareness", but I'm not sure=20
that making it the default for raid1 is appropriate at the moment.  Onc=
e=20
raid10 re-shapes and re-sizes are fully supported, and once all main=20
distros have moved to a new enough version of grub (which supports=20
booting from raid10, and different metadata versions), then there will=20
be few reasons for anyone to choose "standard" raid1 rather than raid10=
,far.


What would make a bigger difference is to get better raid support into=20
the distro's installers.  Most of these, when faced with two disks, wil=
l=20
just ask you which drive you want to use - if the support raid at all=20
during installation, it is accessed through "advanced" and "manual=20
partition" screens.  And getting grub onto both disks is very much a=20
post-install manual operation, for those that know that it needs to be=20
done.  Getting distro installers to set up raid10,far by default would=20
be a much bigger step.


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
