From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Sat, 18 Apr 2009 09:48:33 -0500
Message-ID: <cccedfc60904180748t58cf0980jf8b7c501db0cf653@mail.gmail.com>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com>
	<cccedfc60904010815h4056f55doebff4827705d231b@mail.gmail.com>
	<18899.61151.445765.360191@notabene.brown> <51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com>
	<18919.64597.426128.498393@notabene.brown> <D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com>
	<20090418081239.GB2124@maude.comedia.it> <F43DC4EB-8E83-4284-A2BE-85EF146AE956@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F43DC4EB-8E83-4284-A2BE-85EF146AE956@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Apr 18, 2009 at 8:35 AM, Doug Ledford <dledford@redhat.com> wro=
te:
> I've been thinking about this, and this is the method I would suggest=
=2E
>
> Add two new keywords to the mdadm.conf file:
>
> ASSEMBLE
> INCREMENTAL
>
> Allow each of those keywords to have one of three set values:
> None - Don't attempt to assemble any arrays regardless of whether or =
not they are in the mdadm.conf file or not
> Known - Only assemble arrays with a matching array line
> All - Attempt to assemble any array found
>
> The combination of the two options and the three settings would allow=
 you to control mdadm behavior for both array assembly modes independen=
tly. =A0That, combined with my previous patch, should allow arrays to a=
ssemble well, with known names, allow you to control auto assembly by u=
dev, and in the event that your machine just exports volumes to other m=
achines for their use, stop assembly entirely.
>
> --



Of the proposals thus far, I think I like this one the best.
More or less, it's what I thought homehost was supposed to do (if
homehost did not match, ignore!) but given the morass around homehost,
this seems like a very reasonable approach to solving this class of
issues. With the increasing prevalence of block devices which may
appear on many hosts (like AoE, etc...) it seems as though this issue
isn't going to go away easily.



--
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
