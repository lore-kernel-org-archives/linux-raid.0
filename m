From: David Brown <david.brown@hesbynett.no>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Fri, 11 May 2012 09:10:32 +0200
Message-ID: <4FACBB68.2080304@hesbynett.no>
References: <4FAAE8F1.8000600@pocock.com.au> <CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com> <4FABC7C6.4030107@turmel.org> <4FAC2FF2.5060305@hardwarefreak.com> <4FAC40BC.1060300@hesbynett.no> <CABYL=ToORULrdhBVQk0K8zQqFYkOomY-wgG7PpnJnzP9u7iBnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABYL=ToORULrdhBVQk0K8zQqFYkOomY-wgG7PpnJnzP9u7iBnA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: stan@hardwarefreak.com, Phil Turmel <philip@turmel.org>, Marcus Sorensen <shadowsor@gmail.com>, Daniel Pocock <daniel@pocock.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/05/2012 00:49, Roberto Spadim wrote:
> i have dell servers and  i use raid1 in every servers just raid10 or
> raid0 are in hardware because hotswap with hardware is easier to
> implement, but if mdraid could do the job, i don=B4t see why use hard=
ware
> raid devices (just if they have batery)
>

I think for simple situations, such as just wanting a straight mirror o=
f=20
two disks, then hardware raid provided by the supplier is often a good=20
choice.  As you say, it can make hotswap easier - you get things like=20
little red and green lights on the disk drives.  And the vendor support=
s=20
it and knows how it works.  Also if you've got a more serious hardware=20
with BBWC or similar features, then these features may be the deciding=20
points.

But there is no doubt that md raid is a lot more flexible than any othe=
r=20
raid system, it is often faster (especially for smaller setups -=20
raid10,far being a prime example), and the money you save on raid cards=
=20
can be spent on extra disks, UPS, etc.

One thing that may be an advantage either way is ease of configuration,=
=20
monitoring, maintenance, and transfer of disks between systems.  With m=
d=20
raid, you have a consistent system that is independent of the hardware=20
and setup, while every hardware raid system has its own proprietary=20
tools, setup, hardware, monitoring software, etc.  So this is often a=20
win for md raid - but if you support several hardware raid arrays, and=20
use the same vendor for them all, then you have a consistent system=20
there too.



> 2012/5/10 David Brown <david.brown@hesbynett.no
> <mailto:david.brown@hesbynett.no>>
>
>     On 10/05/12 23:15, Stan Hoeppner wrote:
>
>         On 5/10/2012 8:51 AM, Phil Turmel wrote:
>
>             Hardware RAID cards usually offer battery-backed write
>             cache, which is
>             very valuable in some applications.  I don't have a need =
for
>             that kind
>             of performance, so I can't speak to the details.  (Is Sta=
n H.
>             listening?)
>
>
>         Yes, I'm here to drop the hammer, and start a flame war. ;)
>           I've been
>         lurking and trying to stay out of the fray, but you "keep
>         dragging me
>         back in!" --Michael Corleone
>
>         I find the mere existence of this thread a bit comical, as wi=
th all
>         others that have preceded it.  I made the comment on this lis=
t quite
>         some time ago that md raid is mostly used by hobbyists, and t=
ook
>         a lot
>         of heat for that.  The existence of this thread adds ammuniti=
on
>         to that
>         argument.
>
>
>     I think you've got that a bit backwards.  Most hobbyists (or
>     low-budget users) who use raid other than motherboard fakeraid wi=
ll
>     choose Linux md raid.  It may well be that most users of md raid
>     /are/ hobby or low-budget users.  But your implication - that
>     professionals don't use md raid - is completely wrong.
>
>     It's more likely that it is hobby users that discuss these sorts =
of
>     things - professionals just pay the money that the server
>     manufacturer asks for its supported disks, since paying that is
>     cheaper than spending time discussing things.  I know I mostly
>     follow lists like this in my free time (as a hobbiest) rather tha=
n
>     in work time (as a professional).
>
>
>     --
>     To unsubscribe from this list: send the line "unsubscribe linux-r=
aid" in
>     the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>     More majordomo info at http://vger.kernel.org/__majordomo-info.ht=
ml
>     <http://vger.kernel.org/majordomo-info.html>
>
>
>
>
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
