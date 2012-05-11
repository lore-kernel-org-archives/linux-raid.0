From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Fri, 11 May 2012 17:28:19 -0500
Message-ID: <4FAD9283.7020809@hardwarefreak.com>
References: <4FAAE8F1.8000600@pocock.com.au> <CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com> <4FABC7C6.4030107@turmel.org> <4FAC2FF2.5060305@hardwarefreak.com> <4FAC40BC.1060300@hesbynett.no> <CABYL=ToORULrdhBVQk0K8zQqFYkOomY-wgG7PpnJnzP9u7iBnA@mail.gmail.com> <4FACBB68.2080304@hesbynett.no> <4FACCAC8.4020206@pocock.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FACCAC8.4020206@pocock.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Pocock <daniel@pocock.com.au>
Cc: David Brown <david.brown@hesbynett.no>, Roberto Spadim <roberto@spadim.com.br>, Phil Turmel <philip@turmel.org>, Marcus Sorensen <shadowsor@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/11/2012 3:16 AM, Daniel Pocock wrote:

> My understanding of BBWC:
> 
> - for things like an NFS server, where the OS and disk hardware can't
> cache write data very aggressively (due to the contract between NFS
> client and server), the BBWC allows you to enable more aggressive
> behavior (e.g. setting barrier=0 on the filesystem level) and gain a
> speed boost

RAID cache works just like CPU L2 cache. In this case it's a buffer
between the system block layer and the physical storage.  It can speed
up reads and writes.  In the case of writes, it can be configured to
return success to the block layer before it actually writes the data to
disk, speeding up random write IO tremendously in many cases.

> - on the other hand, is BBWC universally effective?  E.g. does it just
> write to disk in a crash scenario, or only in the event of an outright
> power failure?  Does it depend on any hints from the OS or drivers to
> know about system state?

You're concentrating here specifically on the "B" aspect, which is the
battery.  It protects you from power failure and system crashes that
cause a reset of the motherboard.  When the card is back up, it's
firmware being executed, it checks that the drives are all up, then
writes the data in the cache to the target sectors of the drives.  It's
worked this way for over a decade.

> This is my main point - the fact that md RAID is hardware independent,
> e.g. I can swap from HP to IBM servers and use the same disks.
> 
> If I wanted more than RAID1 (e.g. RAID6) maybe I would re-evaluate the
> issue, but for RAID1, a software solution seems fine.

That's the one scenario where I abhor using md raid, as I mentioned.  At
least, a boot raid 1 pair.  Using layered md raid 1 + 0, or 1 + linear
is a great solution for many workloads.  Ask me why I say raid 1 + 0
instead of raid 10.

-- 
Stan
