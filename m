From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Mismatches
Date: Sun, 2 Jan 2011 17:22:30 -0800
Message-ID: <AANLkTimqKmegXCyPqeMn=fDVyPtNgyexUrC6QE4vRBzf@mail.gmail.com>
References: <A3.34.13137.F02212D4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A3.34.13137.F02212D4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jan 2, 2011 at 5:10 PM, Leslie Rhorer <lrhorer@satx.rr.com> wro=
te:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0OK, I asked this question here before, and=
 I got no answer
> whatsoever. =C2=A0I wasn't too concerned previously, but now that I l=
ost the
> entire array the last time I tried to do a growth, I am truly concern=
ed.
> Would someone please answer my question this time, and perhaps point =
me
> toward a resolution? =C2=A0The monthly array check just finished on m=
y main
> machine. =C2=A0For many months, this happened at the first of the mon=
th and
> completed without issue and with zero mismatches. =C2=A0As of a coupl=
e of months
> ago, it started to report large numbers of mismatches. =C2=A0It just =
completed
> this afternoon with the following:
>
> RebuildFinished /dev/md0 mismatches found: 96614968
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Now, 96,000,000 mismatches would seem to b=
e a matter of great
> concern, if you ask me. =C2=A0How can there be any, really, when the =
entire array
> - all 11T - was re-written just a few weeks ago? =C2=A0How can I find=
 out what
> the nature of these mismatches is, and how can I correct them without
> destroying the data on the array? =C2=A0How can I look to prevent the=
m in the
> future? =C2=A0I take it the monthly checkarray routine (which basical=
ly
> implements ` echo check > /sys/block/md0/md/sync_action`) does not at=
tempt
> to fix any errors it finds?
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0I just recently found out md uses simple p=
arity to try to maintain
> the validity of the data. =C2=A0I had always thought it was ECC. =C2=A0=
With simple
> parity it can be difficult or even impossible to tell which data memb=
er is
> in error, given two conflicting members. =C2=A0Where should I go from=
 here? =C2=A0Can
> I use `echo repair > /sys/block/md0/md/sync_action` with impunity? =C2=
=A0What,
> exactly, will this do when it comes across a mismatch between one or =
more
> members?
>
> RAID6 array
> mdadm - v2.6.7.2
> kernel 2.6.26-2-amd64

What commands are you running? Is it just the sync_action or other
things in addition?

It was my understanding when researching RAID6 last week that the two
parity calculations are actually different. Only one of them is simple
parity. The the other is part of an advanced math degree. ;-)
(According to Wikipedia, not a definitive source for sure...)

- Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
