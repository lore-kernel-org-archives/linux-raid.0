From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Tue, 12 Feb 2013 16:33:04 +1100
Message-ID: <5119D410.5090300@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <511471EA.2000605@hardwarefreak.com> <5114A53B.9060103@websitemanagers.com.au> <5115316F.1090502@hardwarefreak.com> <5115478A.8010004@websitemanagers.com.au> <5115CC02.2010400@hardwarefreak.com> <d34a6caf-d1b5-403c-aee2-525a9b3c3db7@email.android.com> <51179F09.1020503@hardwarefreak.com> <6990fbda-f741-454a-80cd-bdcdfd8c971c@email.android.com> <5119AD1C.8030000@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5119AD1C.8030000@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/02/13 13:46, Stan Hoeppner wrote:
> If it's OK I'm going to snip a bunch of this and get to the meat of it,
> so hopefully it's less confusing.

Thanks, was getting way over the top :)

> That is correct.  Long story short, the last time I messed with a
> configuration such as this I was using a Cisco that fanned over 802.3ad
> groups based on L3/4 info.  Stock 802.3ad won't do this.  

Yes, Cisco have their own proprietary extensions... EtherChannel I think
it is called.

> I apologize
> for the confusion, and for the delay in responding (twas a weekend after
> all).

No problem, I expected as much... Just because I'm silly enough to work
on a weekend, I realise most others don't. Besides, any help I get here
is a bonus :)

However, I did end up already making the solution proposal to the
client, and have already ordered some equipment, but see below...

>  I just finished reading the relevant section of your GS716T-200
> (GST716-v2) manual, and it does not appear to have this capability.

Nope.

> All is not lost.  I've done a considerable amount of analysis of all the
> information you've provided.  In fact I've spent way to much time on
> this.  But it's an intriguing problem involving interesting systems
> assembled from channel parts, i.e. "DIY", and I couldn't put it down.  I
> was hoping to come up with a long term solution that didn't require any
> more hardware than a NIC and HBA, but that's just not really feasible.

That's OK, I was fully prepared to get additional equipment, and the
customer was happy to throw money at it to get it fixed...

> So, my conclusions and recommendations, based on all the information I
> have to date:
> 
> 2.  To scale iSCSI throughput using a single switch will require
>     multiple host ports and MPIO, but no LAG for these ports.

I'm assuming MPIO is Multi Path IO (ie, MultiPath iSCSI)?

> 3.  Given the facts above, an extra port could be added to each TS Xen
>     box.  A separate subnet would be created for the iSCSI SAN traffic,
>     and each port given an IP in the subnet.  Both ports would carry
>     MPIO iSCSI packets, but only one port would carry user traffic.

This would allow iSCSI up to 2Gbit bi-directional traffic per xen box,
though some of it would also be consumed for the VM's. Also, the iSCSI
server would only be capable of a total 2Gbps on each network, so it
could handle two xen boxes demanding 100% throughput, which is a total
of 4Gbps which is pretty impressive (assuming SAN server uses
balance-alb). However, ignore this, I'll concentrate on what you suggest
below.

> 4.  Given the fact that there will almost certainly be TS users on the
>     target box when the DC VM gets migrated due to some kind of failure
>     or maintenance, adding the load of file sharing may not prove
>     desirable.  And you'd need another switch.  Thus, I'd recommend:
> 
> A.  Dedicate the DC Xen box as a file server and dedicate a non-TS
>     Xen box as its failover partner.  Each machine will receive a quad
>     port NIC.  Two ports on each host will be connected to the current
>     16 port switch.  The two ports will be configured to balance-alb
>     using the current user network IP address.  All switch ports will
>     be reconfigured to standard mode, no LAGs, as they are not needed
>     for Linux balance-alb.  Disconnect the 8111 mobo ports on these two
>     boxes from the switch as they're no longer needed.  Prioritize RDP
>     in the switch, leave all other protocols alone.

BTW, the switch has a maximum of 4 LAG's, so one option I was going to
try would not have worked anyway. Though that was probably just bad
design on my part... I think I'm passed that now :)

> B.  We remove 4 links each from the iSCSI servers, the primary and the
>     DRBD backup server, from the switch.  This frees up 8 ports for
>     connecting the file servers' 4 ports, and connecting a motherboard
>     ethernet port from each iSCSI server to the switch for management.
>     If my math is correct this should leave two ports free.

I already have one motherboard port from SAN1/2 connected to another
switch, and also one motherboard port is a direct crossover cable
between san1 and san2 which is configured for DRBD traffic sync (so this
traffic is kept away from the iSCSI traffic).

However, after this, the only connection between the xen boxes running
the terminal servers to the iSCSI server is the single "management"
ethernet port. The Terminal Servers C: is also on the iSCSI server... so
this doesn't quite work.

> C.  MPIO is designed specifically for IO scaling, and works well.
>     So it's a better fit, and you save the cost of the additional
>     switch(es) that would be required to do perfect balance-rr bonding
>     between iSCSI hosts (which can be done easily with each host
>     ethernet port connected to a different dedicated SAN switch.  In
>     this case it would require 4 additional switches.

I assume this means that if you have a quad port card in each machine,
with a single ethernet connected to each of 4 switches, then you can do
balance-rr because bandwidth on both endpoints is equal ? That doesn't
quite work for me because I don't want the expense of a quad port card
in each machine, and also I don't want equal bandwidth.... I want the
server to have more bandwidth than the clients. In any case, let's
ignore this since it doesn't get us closer to the solution.

>     Instead what
>     we'll do here is connect the remaining 2 ports from each Xen file
>     server box, the primary and the backup, and all 4 ports on each
>     iSCSI server, the primary and the backup, to a new 12-16 port
>     switch.  It can be any cheap unmanaged GbE switch of 12 or more
>     ports.  We'll assign an IP address in the new SAN subnet to each
>     physical port on these 4 boxes and configure MPIO accordingly.

As mentioned, this cuts off the iSCSI from the rest of the 6 xen boxes.

>     So what we end up with is decent session based scaling of user CIFS
>     traffic between the TS hosts and the DC Xen servers, with no single
>     TS host bogging everyone down, and no desktop lag if both links are
>     full due to two greedy users.  We end up with nearly perfect
>     ~200MB/s iSCSI scaling in both directions between the DC Xen box
>     (and/or backup) and the iSCSI servers, and we end up with nearly
>     perfect ~400MB/s each way between the two iSCSI servers via DRBD,
>     allowing you to easily do mirroring in real-time.

I'm assuming MPIO requires the following:
SAN must have multiple physical links over 'disconnected' networks (ie,
different networks) on different subnets.
iSCSI client must meet the same requirements.

> All for the cost of two quad port NICs and an inexpensive switch, and
> possibly a new high performance SAS HBA.  I analyzed many possible paths
> to a solution, and I think this one is probably close to ideal.

OK, what about this option:

Install dual port ethernet card into each of the 8 xen boxes
Install 2 x quad port ethernet card into each of the san boxes

Connect one port from each of the xen boxes plus 4 ports from each san
box to a single switch (16ports)

Connect the second port from each of the xen boxes plus 4 ports from
each san box to a second switch (16 ports)

Connect the motherboard port (existing) from each of the xen boxes plus
one port from each of the SAN boxes (management port) to a single switch
(10 ports).

Total of 42 ports.

Leave the existing motherboard port configured with existing IP's/etc,
and dedicate this as the management/user network (RDP/SMB/etc).

We then configure the SAN boxes with two bond devices, each consisting
of a set of 4 x 1Gbps as balance-alb, with one IP address each (from 2
new subnets).

Add a "floating" IP to the current primary SAN on each of the bond
interfaces from the new subnets.

We configure each of the xen boxes with two new ethernets with one IP
address each (from the 2 new subnets).

Configure multipath to talk to the two floating IP's

See a rough sketch at:
http://suspended.wesolveit.com.au/graphs/diagram.JPG
I couldn't fit any detail like IP addresses without making it a complete
mess. BTW, sw1 and sw2 I'm thinking can be the same physical switch,
using VLAN to make them separate (although different physical switches
adds to the reliability factor, so that is also something to think about).

Now, this provides up to 2Gbps traffic for any one host, and up to 8Gbps
traffic in total for the SAN server, which is equivalent to 4 clients at
full speed.

It also allows for the user network to operate at a full 1Gbps for
SMB/RDP/etc, and I could still prioritise RDP at the switch....

I'm thinking 200MB/s should be enough performance for any one machine
disk access, and 1Gbps for any single user side network access should be
ample given this is the same as what they had previously.

The only question left is what will happen when there is only one xen
box asking to read data from the SAN? Will the SAN attempt to send the
data at 8Gbps, flooding the 2Gbps that the client can handle, and
generate all the pause messages, or is this not relevant and it will
"just work". Actually, I think from reading the docs, it will only use
one link out of each group of 4 to send the data, hence it won't attempt
to send at more than 2Gbps to each client....

I don't think this system will scale any further than this, I can only
add additional single Gbps ports to the xen hosts, and I can only add
one extra 4 x 1Gbps ports to each SAN server.... Best case is add 4 x
10Gbps to the SAN, 2 single 1Gbps ports to each xen, providing a full
32Gbps to the clients, each client gets max 4Gbps. In any case, I think
that would be one kick-ass network, besides being a pain to try and
debug, keep cabling neat and tidy, etc... Oh, and the current SSD's
wouldn't be that fast... At 400MB/s read, times 7 data disks is
2800GB/s, actually, damn, that's fast.

The only additional future upgrade I would plan is to upgrade the
secondary san to use SSD's matching the primary. Or add additional SSD's
to expand storage capacity and I guess speed. I may also need to add
additional ethernet ports to both SAN1 and SAN2 to increase the DRBD
cross connects, but these would I assume be configured using linux
bonding in balance-rr since there is no switch in between.

> You can pull off the same basic concept buying just the quad port HBA
> for the current DC Xen box, removing 2 links between each iSCSI server
> and the switch and direct connecting these 4 NIC ports via 2 cross over
> cables, and using yet another IP subnet for these, with MPIO.  You'd
> have no failover for the DC, and the bandwidth between the iSCSI servers
> for BRBD would be cut in half.  But it only costs one quad port NIC.  A
> dedicated 200MB/s is probably more than plenty for live DRBD, but again
> you have no DC failover.
> 
> However, given that you've designed this system with "redundancy
> everywhere" in mind, I'm guessing the additional redundancy justifies
> the capital outlay for an unmanaged switch and a 2nd quad port NIC.

Let's ignore this... we both agree it isn't a good solution.

> If one of those test boxes could be permanently deployed as the failover
> host for the DC VM, I think the dedicated iSCSI switch architecture
> makes the most sense long term.  If the cost of the switch and another 4
> port NIC isn't in the cards right now, you can go the other route with
> just one new NIC.  And given that you'll be doing no ethernet channel
> bonding on the iSCSI network, but IP based MPIO instead, it's a snap to
> convert to the redundant architecture with new switch later.  All you'll
> be doing is swapping cables to the new switch and changing IP address
> bindings on the NICs as needed.

I'd rather keep all boxes with identical hardware, so that any VM can be
run on any xen host.

So, the current purchase list, which the customer approved yesterday,
and most of it should be delivered tomorrow (insufficient stock, already
ordering from 4 different wholesalers):
4 x Quad port 1Gbps cards
4 x Dual port 1Gbps cards
2 x LSI HBA's (the suggested model)
1 x 48port 1Gbps switch (same as the current 16port, but more ports).

The idea being to pull out 4 x dual port cards from san1/2 and install
the 4 x quad port cards. Then install a single dual port card on each
xen box. Install one LSI HBA in each san box. Use the 48 port switch to
connect it all together.

However, I'm going to be short 1 x quad ethernet, and 1 x sata
controller, so the secondary san is going to be even more lacking for up
to 2 weeks when these parts arrive, but IMHO, that is not important at
this stage, if san1 falls over, I'm going to be screwed anyway running
on spinning disks :) though not as screwed as being plain
down/offline/nothing/just go home folks...

> Again, apologies for the false start with the 802.3ad confusion on my
> part.  I think you'll find all (or at least most) of the ducks in a row
> in the recommendations above.

No problem, this has been a definite learning experience for me and I
appreciate all the time and effort you've put into assisting.

BTW, I went last night (monday night) and removed one dual port card
from the san2, installed into the xen host running the DC VM. Configured
the two new ports on the xen box as active-backup (couldn't get LACP to
work since the switch only supports max of 4 LAG's anyway). Removed one
port from the LAG on san1, and setup the three ports (1 x san + 2 x
xen1) as a VLAN with private IP address on a new subnet. Today,
complaints have been non-existant, mostly relating to issues they had
yesterday but didn't bother to call until today. It's now 4:30pm, so I'm
thinking that the problem is solved just with that done. I was going to
do this across all 8 boxes, using 2 x ethernet on each xen box plus one
x ethernet on each san, producing a max of 1Gbps ethernet for each xen
box. However, I think your suggestion of MPIO is much better, and
grouping the SAN ports into two bundles makes a lot more sense, and
produces 2Gbps per xen box.

Thanks again, I appreciate all the help.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
