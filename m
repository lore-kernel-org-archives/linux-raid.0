From: Frank Wittig <fw@weisshuhn.de>
Subject: Re: Questions about software RAID
Date: Tue, 19 Apr 2005 21:46:56 +0200
Message-ID: <42656030.6000506@weisshuhn.de>
References: <200504191100.NAA01462@node130.rhm.de> <20050419144011.GI3103@eychenne.org> <42652352.3050706@dgreaves.com> <20050419155447.GJ3103@eychenne.org> <426537A0.6020007@weisshuhn.de> <20050419175407.GK3103@eychenne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050419175407.GK3103@eychenne.org>
Sender: linux-raid-owner@vger.kernel.org
To: rv@eychenne.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Herv=E9 Eychenne wrote:

>Maybe you are an experienced guy so it seems so simple to you... but
>I'm always amused when an experienced guy refuses to make things
>simpler for those who aren't as much as he is. And sends them to
>Microsoft. Great.
> =20
>
i don't send you to microsoft. i want you to understand the philosophy
behind linux.
the sort of functionality you want doesn't belong to the mdadm tool.
mdadm is the command line interface to dm.
more complex functionality like the one you desire is covered by
frontends like EVMS.
i don't know EVMS but what i heard about it sounds exactly like what yo=
u
want. simple administration without having to know how things work in
the background.

>I personnaly do not consider that this is yet another case.  For me,
>RAID is about have disk availability, right?  So the most common
>production case is definitely when one of your disks crashed, and you
>want to replace it.
>There must be some kind of way to deal with that without typing too
>much contextual command lines.
> =20
>
after the first time you lose data because of a failure of an automated
process you will think different about that.
i think automation is fine for normal operation.
failure of a component is far from normal and in this case full control
is what you want/need.

>Whether this simple way should belong to mdadm is another question, bu=
t
>I personnaly think it should, as it would introduce no overhead
>(would it, really ?) and would be very helpful.
> =20
>
KISS: keep it stupid simple
this is the philosophy. keep low-level tools stupid simple. more
complexity brings a higher risk of failure.
we're talking about raid. not about doing backups or syncing the system
clock.

>>did you ever thought about switching to a hardware where you can remo=
ve
>>and add disks without having to do anything else than pull the old on=
e
>>out and push teh new one in?
>>   =20
>>
>Ok, here we are...
>[First, the RAID controller I'm forced to deal with has no Linux
>driver, but that's not important for our discussion.]
> =20
>
there are some nice boxes arround. ther take a bunch of disks and appea=
r
to the host as a simple SCSI disk. had such a thing in the past.
replacing disks was so simple a secretary could have done that. ;-)

>I don't agree with that. Using grep on vague patterns is not
> =20
>
i think grep is far more powerfull as you think.

>>the more you get used to it, the less "kludgy" they will be.
>>   =20
>>
>Of course, but the very idea is that one shouldn't have to get used to
>it too much to perform simple and common actions.
> =20
>
if replacing disks is a common case to you, you should buy your disks
from a different manufacturer. ;-)
and if you have so many arrays that a disk failure is common because of
the number of disks, you would want to know the basics.

>But I guess we'll never agree anyway... :-(
> =20
>
we're just on different levels of usage. and there's a tool for everyon=
e
on us.
my tool is mdadm.
and yours is EVMS or some other high level frontend which abstracts the
use of the low-level tools behind a nice looking UI.

greetings,
=46rank
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
