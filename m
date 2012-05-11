From: Daniel Pocock <daniel@pocock.com.au>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Fri, 11 May 2012 08:16:08 +0000
Message-ID: <4FACCAC8.4020206@pocock.com.au>
References: <4FAAE8F1.8000600@pocock.com.au> <CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com> <4FABC7C6.4030107@turmel.org> <4FAC2FF2.5060305@hardwarefreak.com> <4FAC40BC.1060300@hesbynett.no> <CABYL=ToORULrdhBVQk0K8zQqFYkOomY-wgG7PpnJnzP9u7iBnA@mail.gmail.com> <4FACBB68.2080304@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FACBB68.2080304@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Roberto Spadim <roberto@spadim.com.br>, stan@hardwarefreak.com, Phil Turmel <philip@turmel.org>, Marcus Sorensen <shadowsor@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 11/05/12 07:10, David Brown wrote:
> On 11/05/2012 00:49, Roberto Spadim wrote:
>> i have dell servers and  i use raid1 in every servers just raid10 or
>> raid0 are in hardware because hotswap with hardware is easier to
>> implement, but if mdraid could do the job, i don=B4t see why use har=
dware
>> raid devices (just if they have batery)
>>
>=20
> I think for simple situations, such as just wanting a straight mirror=
 of
> two disks, then hardware raid provided by the supplier is often a goo=
d
> choice.  As you say, it can make hotswap easier - you get things like
> little red and green lights on the disk drives.  And the vendor suppo=
rts
> it and knows how it works.  Also if you've got a more serious hardwar=
e
> with BBWC or similar features, then these features may be the decidin=
g
> points.

My understanding of BBWC:

- for things like an NFS server, where the OS and disk hardware can't
cache write data very aggressively (due to the contract between NFS
client and server), the BBWC allows you to enable more aggressive
behavior (e.g. setting barrier=3D0 on the filesystem level) and gain a
speed boost

- on the other hand, is BBWC universally effective?  E.g. does it just
write to disk in a crash scenario, or only in the event of an outright
power failure?  Does it depend on any hints from the OS or drivers to
know about system state?

> One thing that may be an advantage either way is ease of configuratio=
n,
> monitoring, maintenance, and transfer of disks between systems.  With=
 md
> raid, you have a consistent system that is independent of the hardwar=
e
> and setup, while every hardware raid system has its own proprietary
> tools, setup, hardware, monitoring software, etc.  So this is often a
> win for md raid - but if you support several hardware raid arrays, an=
d
> use the same vendor for them all, then you have a consistent system
> there too.

This is my main point - the fact that md RAID is hardware independent,
e.g. I can swap from HP to IBM servers and use the same disks.

If I wanted more than RAID1 (e.g. RAID6) maybe I would re-evaluate the
issue, but for RAID1, a software solution seems fine.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
