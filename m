From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Fri, 11 May 2012 17:17:13 -0500
Message-ID: <4FAD8FE9.4090704@hardwarefreak.com>
References: <4FAAE8F1.8000600@pocock.com.au> <CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com> <4FABC7C6.4030107@turmel.org> <4FAC2FF2.5060305@hardwarefreak.com> <4FAC40BC.1060300@hesbynett.no> <CABYL=ToORULrdhBVQk0K8zQqFYkOomY-wgG7PpnJnzP9u7iBnA@mail.gmail.com> <4FACBB68.2080304@hesbynett.no>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FACBB68.2080304@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Roberto Spadim <roberto@spadim.com.br>, Phil Turmel <philip@turmel.org>, Marcus Sorensen <shadowsor@gmail.com>, Daniel Pocock <daniel@pocock.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/11/2012 2:10 AM, David Brown wrote:

> Also if you've got a more serious hardware
> with BBWC or similar features, then these features may be the deciding
> points.

md RAID is used with BBWC raid controllers, both PCIe and SAN heads,
fairly widely.  I've discussed the benefits of such setups on this list
many times.  It's not an either/or decision.

> But there is no doubt that md raid is a lot more flexible than any other
> raid system, 

This is simply not true, not in the wholesale fashion you state.  For
many things md raid is more flexible.  For others definitely not.
Bootable arrays being one very important one.  The md raid/grub solution
is far too complicated, cumbersome, and unreliable.  A relatively low
performance and cheap 2/4 port real SATA raid card or real mobo based
raid such as an LSI SAS2008 is a far superior mirrored boot disk
solution, with a straight SAS/SATA multiport HBA with md managing the
data array.

> it is often faster (especially for smaller setups -
> raid10,far being a prime example), 

You need a lot of qualifiers embedded in that statement.  A decent raid
card w/ small drive count array will runs circles around md raid w/ a
random write or streaming workload.  It may be slightly slower in a
streaming read workload compared to the 'optimzed' md raid "10" layouts.
 Where hardware raid usually starts trailing md raid is with parity
arrays on large drive counts, starting at around 8-16 drives and up.

> and the money you save on raid cards
> can be spent on extra disks, UPS, etc.

Relatively speaking, in overall system cost terms, RAID HBAs aren't that
much more expensive than standard HBAs.  In the case of LSI, $240 vs
$480 for 8 port cards.  The cost is double, the but total cost of the 8
drives we'll connect is $3200-$5000.  That extra $250 is negligible in
the overall picture.

> One thing that may be an advantage either way is ease of configuration,
> monitoring, maintenance, and transfer of disks between systems.  With md
> raid, you have a consistent system that is independent of the hardware
> and setup, while every hardware raid system has its own proprietary
> tools, setup, hardware, monitoring software, etc.  So this is often a
> win for md raid - but if you support several hardware raid arrays, and
> use the same vendor for them all, then you have a consistent system
> there too.

Corporations have used SNMP for a consistent monitoring interface across
heterogeneous platforms for over a decade, including servers, switches,
routers, PBXes, APs, security cameras, electronics entry access, etc.
Every decent hardware RAID card is designed for corporate use, and
includes SNMP support and a MIB file.  So from a monitoring standpoint,
I disagree with your statement above.  And who transfers drives between
running systems?

Regarding proprietary tools, most corporate setups will have mobo RAID
(Dell, HP, IBM) for the boot drives, and will have an FC/iSCSI HBA for
connecting to one or more SAN controllers.  Most corporate setups don't
involve local RAID based data storage.  The single overriding reason for
this is the pervasiveness of SAN based snapshot backups and remote site
mirroring from SAN to SAN.  md raid has no comparable capability.

-- 
Stan
