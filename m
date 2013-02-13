From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance
Date: Wed, 13 Feb 2013 01:56:09 -0600
Message-ID: <511B4719.6060607@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <511471EA.2000605@hardwarefreak.com> <5114A53B.9060103@websitemanagers.com.au> <5115316F.1090502@hardwarefreak.com> <5115478A.8010004@websitemanagers.com.au> <5115CC02.2010400@hardwarefreak.com> <d34a6caf-d1b5-403c-aee2-525a9b3c3db7@email.android.com> <51179F09.1020503@hardwarefreak.com> <6990fbda-f741-454a-80cd-bdcdfd8c971c@email.android.com> <5119AD1C.8030000@hardwarefreak.com> <5119D410.5090300@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5119D410.5090300@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/11/2013 11:33 PM, Adam Goryachev wrote:

> I'm assuming MPIO is Multi Path IO (ie, MultiPath iSCSI)?

Yes.  Shorter to type. ;)

> I assume this means that if you have a quad port card in each machine,
> with a single ethernet connected to each of 4 switches, then you can do
> balance-rr because bandwidth on both endpoints is equal ? 

It's not simply that bandwidth is equal, but that the ports are
symmetrical.  Every source port on a host has only one path and one
destination port on another host.  It's identical to using crossover
cables between hosts, but the multiple independent switches allow for
more hosts to participate than could otherwise if using crossover cables.

> As mentioned, this cuts off the iSCSI from the rest of the 6 xen boxes.

Palm, meet forehead.  I forgot you were using iSCSI for anything other
than live migrating the DC VM amongst the Xen hosts.

> I'm assuming MPIO requires the following:
> SAN must have multiple physical links over 'disconnected' networks (ie,
> different networks) on different subnets.
> iSCSI client must meet the same requirements.

I fubar'd this.  See below for a thorough explanation.  The IPs should
all be in the same subnet.

> OK, what about this option:
> 
> Install dual port ethernet card into each of the 8 xen boxes
> Install 2 x quad port ethernet card into each of the san boxes
> 
> Connect one port from each of the xen boxes plus 4 ports from each san
> box to a single switch (16ports)
> 
> Connect the second port from each of the xen boxes plus 4 ports from
> each san box to a second switch (16 ports)
> 
> Connect the motherboard port (existing) from each of the xen boxes plus
> one port from each of the SAN boxes (management port) to a single switch
> (10 ports).
> 
> Total of 42 ports.
> 
> Leave the existing motherboard port configured with existing IP's/etc,
> and dedicate this as the management/user network (RDP/SMB/etc).

Keeping the LAN and SAN traffic on different segments is a big plus.
But I still wonder if a single link for SMB traffic is enough for that
greedy bloke moving 50GB files over the network.

> We then configure the SAN boxes with two bond devices, each consisting
> of a set of 4 x 1Gbps as balance-alb, with one IP address each (from 2
> new subnets).

Use MPIO (multipath) only.  Do not use channel bonding.  MPIO runs
circles around channel bonding.  Read this carefully.  I'm pretty sure
you'll like this.

Ok, so this fibre channel guy has been brushing up a bit on iSCSI
multipath, and it looks like the IP subnetting is a non issue, and after
thinking it through I've put palm to forehead.  As long as you have an
IP path between ethernet ports, the network driver uses the MAC address
from that point forward, DUH!.  Remember that IP addresses exist solely
for routing packets from one network to another.  But within a network
the hardware address is used, i.e. the MAC address.  This has been true
for the 30+ years of networking.  Palm to forehead again. ;)

So, pick a unique subnet for SAN traffic, and assign an IP and
appropriate mask to each physical port in all the machines' iSCSI ports.
 The rest of the iSCSI setup you already know how to do.  The only
advice I can give you here is to expose every server target LUN out
every physical port so the Xen box ports see the LUNs on every server
port.  I assume you've already done this with the current IP subnet, as
it's required to live migrate your VMs amongst the Xen servers.  So you
just need to change it over for the new SAN specific subnet/ports.  Now,
when you run 'multipath -ll' on each Xen box it'll see all the LUNs on
all 8 ports of each iSCSI server (as well as local disks), and
automatically do round robin fanning of SCSI block IO packets across all
8 server ports.  You may need to blacklist local devices.  You'll
obviously want to keep the LUNs on the standby iSCSI server masked, or
simply not used until needed.

You only install the multipath driver on the initiators (Xen clients),
--NOT ON THE TARGETS (servers)-- .  All block IO transactions are
initiated by the client (think desktop PC with single SATA drive--who
talks first, mobo or drive?).  The iSCSI server will always reply on the
port a packet arrived on.  So, you get automatic perfect block IO
scaling on all server ports, all the time, no matter how many clients
are talking.  Told ya you'd like this. ;)  Here's a relatively
informative read on multipath:

http://linfrastructure.blogspot.com/2008/02/multipath-and-equallogic-iscsi.html

> Add a "floating" IP to the current primary SAN on each of the bond
> interfaces from the new subnets.

No, see above.

> We configure each of the xen boxes with two new ethernets with one IP
> address each (from the 2 new subnets).
> 
> Configure multipath to talk to the two floating IP's

See above.

> See a rough sketch at:
> http://suspended.wesolveit.com.au/graphs/diagram.JPG
> I couldn't fit any detail like IP addresses without making it a complete
> mess. BTW, sw1 and sw2 I'm thinking can be the same physical switch,
> using VLAN to make them separate (although different physical switches
> adds to the reliability factor, so that is also something to think about).
> 
> Now, this provides up to 2Gbps traffic for any one host, and up to 8Gbps
> traffic in total for the SAN server, which is equivalent to 4 clients at
> full speed.

With multipath, this architecture configured as above is going to be
pretty speedy.

> It also allows for the user network to operate at a full 1Gbps for
> SMB/RDP/etc, and I could still prioritise RDP at the switch....

Prioritizing RDP is a necessity for responsiveness.  But unloading the
SAN traffic from that single interface makes a huge difference, as
you've already seen.

> I'm thinking 200MB/s should be enough performance for any one machine
> disk access, and 1Gbps for any single user side network access should be
> ample given this is the same as what they had previously.

Coincidentally, the last 'decent' size network I managed had 525'ish
users, but our 4 Citrix servers were bare metal blades.  All our CIFS
traffic hit a single blade's GbE port.  That blade, ESX3, hosted our DC
file server VM and 6 other Linux and Windows VMs, some of which had
significant traffic.  User traffic HBA was single GbE, and the SAN HBA
was 2Gb/s fibre channel.  Same bandwidth as your soon-to-be setup.
Though the backend was different, one FasTt600 and one SataBlade, each
with a single 2Gb FC link.

> The only question left is what will happen when there is only one xen
> box asking to read data from the SAN? Will the SAN attempt to send the
> data at 8Gbps, flooding the 2Gbps that the client can handle, and

You're not using balance-rr inappropriately here.  So, no, this isn't an
issue.  In a request/reply chain, responses will only go out at the same
rate requests come in.  With two ports making requests to 8 ports, each
of the 8 will receive and reply to 1/4th of the total requests,
generating ~1/4th of the total bandwidth.  200/8=25, so each of the 8
ports will transmit ~25MB/s in replies.  Reply packets will be larger
due to the data payload, but the packet queuing, window scaling, etc in
the receiver TCP stack FOR EACH PORT will slow down the sender when
necessary.

And you're now wondering why TCP packet queuing didn't kick in with
balance-rr, causing all of those ethernet pause frames and other issues.
 Answer:  I think the problem was that the TCP back off features were
short circuited.  When you were using balance-rr, packets were likely
arriving wildly out of sequence, from the same session, but from
different MAC addresses.  You were sending from one IP stack out 4 MACs
to one 1 IP stack on one MAC.

With multipath iSCSI, each MAC has its own IP address and own TCP stack,
so all packets always arrive in order or are easily reordered, allowing
packet queuing, window scaling, etc, to work properly.  Balance-rr works
in the cluster scenario up top because the packets still arrive in
sequence, even though on different ports from different MACs.  Say
1/2/3/4, 5/6/7/8, etc.  Previously you probably had packet ordering
something like 4/1/3/2/7/8/6/5 on occasion.  This short circuited the
receiving TCP stack preventing it from sending back offs.  The TCP stack
on the server thought all was fine and kept slinging packets until the
switch started sending back ethernet pause frames.  I'm not enough of an
ethernet or TCP expert to explain what happens next, but I'd bet those
Windows write errors are related to this.

Again, ya don't have to worry about any of this mess using multipath.
And, you get full port balanced bandwidth on all Xen hosts, and all
server ports, all the time.  Pretty slick.

> generate all the pause messages, or is this not relevant and it will
> "just work". Actually, I think from reading the docs, it will only use
> one link out of each group of 4 to send the data, hence it won't attempt
> to send at more than 2Gbps to each client....

See above.

> I don't think this system will scale any further than this, I can only
> add additional single Gbps ports to the xen hosts, and I can only add
> one extra 4 x 1Gbps ports to each SAN server.... Best case is add 4 x
> 10Gbps to the SAN, 2 single 1Gbps ports to each xen, providing a full
> 32Gbps to the clients, each client gets max 4Gbps. In any case, I think
> that would be one kick-ass network, besides being a pain to try and
> debug, keep cabling neat and tidy, etc... Oh, and the current SSD's
> wouldn't be that fast... At 400MB/s read, times 7 data disks is
> 2800GB/s, actually, damn, that's fast.

You could easily get by with a single quad port NIC on iSCSI target duty
in each server.  That's 800MB/s duplex, same as 4Gb fibre channel.
That's more than sufficient for your 8 Xen nodes, especially given the
bulk of your traffic is SMB, which is limited to ~100MB/s, which means
~100MB/s on the SAN, with ~300MB/s breathing room.  Use the other quad
port NIC direct connected with x-over cables to the other server for
DRBD using balance-rr.

> The only additional future upgrade I would plan is to upgrade the
> secondary san to use SSD's matching the primary. Or add additional SSD's
> to expand storage capacity and I guess speed. I may also need to add
> additional ethernet ports to both SAN1 and SAN2 to increase the DRBD
> cross connects, but these would I assume be configured using linux
> bonding in balance-rr since there is no switch in between.

See above.

> I'd rather keep all boxes with identical hardware, so that any VM can be
> run on any xen host.

Looks like you've got the right architecture for it nailed down now.

> So, the current purchase list, which the customer approved yesterday,
> and most of it should be delivered tomorrow (insufficient stock, already
> ordering from 4 different wholesalers):
> 4 x Quad port 1Gbps cards
> 4 x Dual port 1Gbps cards
> 2 x LSI HBA's (the suggested model)
> 1 x 48port 1Gbps switch (same as the current 16port, but more ports).

And more than sufficient hardware.  I was under the impression that this
much capital was not available, or I'd had different recommendations.
One being very similar to what you came up with here.

> The idea being to pull out 4 x dual port cards from san1/2 and install
> the 4 x quad port cards. Then install a single dual port card on each
> xen box. Install one LSI HBA in each san box. Use the 48 port switch to
> connect it all together.

> However, I'm going to be short 1 x quad ethernet, and 1 x sata
> controller, so the secondary san is going to be even more lacking for up
> to 2 weeks when these parts arrive, but IMHO, that is not important at
> this stage, if san1 falls over, I'm going to be screwed anyway running
> on spinning disks :) though not as screwed as being plain
> down/offline/nothing/just go home folks...

Two words:  Murphy's law

;)

> No problem, this has been a definite learning experience for me and I
> appreciate all the time and effort you've put into assisting.

There are millions of folks spewing vitriol at one another at any moment
on the net.  I prefer to be constructive, help people out when I can,
pass a little knowledge and creativity when possible, learn things
myself.  That's not to say I don't pop at folks now and then when
frustration boils. ;)  I'm human too.

> BTW, I went last night (monday night) and removed one dual port card
> from the san2, installed into the xen host running the DC VM. Configured
> the two new ports on the xen box as active-backup (couldn't get LACP to
> work since the switch only supports max of 4 LAG's anyway). Removed one
> port from the LAG on san1, and setup the three ports (1 x san + 2 x
> xen1) as a VLAN with private IP address on a new subnet.  Today,
> complaints have been non-existant, mostly relating to issues they had
> yesterday but didn't bother to call until today. It's now 4:30pm, so I'm
> thinking that the problem is solved just with that done.

So the biggest part of the problem was simply SMB and iSCSI on the same
link on the DC.  Let's see how the new system does with that user in
need of a clue stick, doing his 50GB SMB xfer when all users are humming
away.

> I was going to
> do this across all 8 boxes, using 2 x ethernet on each xen box plus one
> x ethernet on each san, producing a max of 1Gbps ethernet for each xen
> box. However, I think your suggestion of MPIO is much better, and
> grouping the SAN ports into two bundles makes a lot more sense, and
> produces 2Gbps per xen box.

Nope, no bundles.  As with balance-rr, MPIO is awesome when deployed
properly.

> Thanks again, I appreciate all the help.

I appreciate the fact you posted the topic.  I had to go (re)learn a
little bit myself.  I just hope read you this email before trying to
stick MPIO on top of a channel bond. ;)

Send me a picture of the racked gear when it's all done, front, and
back, so I can see how ugly that Medusa is, and remind myself of one of
many reasons I prefer fibre channel. ;)

-- 
Stan

