From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance
Date: Thu, 14 Feb 2013 06:22:33 -0600
Message-ID: <511CD709.6070506@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <511471EA.2000605@hardwarefreak.com> <5114A53B.9060103@websitemanagers.com.au> <5115316F.1090502@hardwarefreak.com> <5115478A.8010004@websitemanagers.com.au> <5115CC02.2010400@hardwarefreak.com> <d34a6caf-d1b5-403c-aee2-525a9b3c3db7@email.android.com> <51179F09.1020503@hardwarefreak.com> <6990fbda-f741-454a-80cd-bdcdfd8c971c@email.android.com> <5119AD1C.8030000@hardwarefreak.com> <5119D410.5090300@websitemanagers.com.au> <511B4719.6060607@hardwarefreak.com> <aecd39d9-2184-4df0-97bb-d63de0d29e5c@email.android.com> <555253fb-86d2-448b-a85b-43dae1a2a33d@email.and
 roid.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <555253fb-86d2-448b-a85b-43dae1a2a33d@email.android.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/13/2013 2:20 PM, Adam Goryachev wrote:
> Well, it's 7am, and I'm still here.... It all didn't go as well as I had
> planned....

Never does...

> I initially could ping perfectly from either of the two IP's on the xen
> box to any of the 8 IP's on the san1, even ping -f worked perfectly.
> Whatever I did, I couldn't get a iscsiadm .... discover to work... I
> could see the packets being sent from the san box (tcpdump) but never
> received by the xen box.

I'm pretty sure I know what most, if not all, of the problem is here.
For this iSCSI/multipath setup to work with all the ethernet ports
(clients and server) on a single subnet, you have to configure source
routing.  Otherwise the Linux kernel is going to use a single interface
for all outbound IP packets destined for the subnet.  So, you have two
options:

1.  Keep a single subnet and configure source routing
2.  Switch to using 8 unique subnets, one per server port

With more than two iSCSI target IPs/ports on the server, using unique
subnets on each port will be a PITA to configure on the Xen client
machines, as you'll have to bind 8 different addresses to each ethernet
port.  And keeping track of how you've setup 8 different subnets will be
a PITA.  So assuming you already have all the interfaces on a single
subnet, source routing is probably much easier.  I believe this how we
do it.

I don't know your port or IP info so I'm using fictitious values in this
example how-to, and subnet 192.168.101.0/24.

Let's start with the iSCSI target server, san1.  First, you probably
need to revert the arp changes you made back to their original values.
The changes you made earlier, according to your email, were:

echo 1 > /proc/sys/net/ipv4/conf/all/arp_ignore
echo 2 > /proc/sys/net/ipv4/conf/all/arp_announce


Next enable arp_filter on all 8 SAN ports:

~$ echo 1 > /proc/sys/net/ipv4/conf/eth0/arp_filter
......
~$ echo 1 > /proc/sys/net/ipv4/conf/eth7/arp_filter


Then create 8 table entries with names, such as port_0 thru port_7:

~$ echo 100 port_0 >> /etc/iproute2/rt_tables
......
~$ echo 101 port_7 >> /etc/iproute2/rt_tables


Next add the route table for your 8 interfaces.

~$ ip route add 192.168.101.0/24 dev eth0 src 192.168.101.0 table port_0
......
~$ ip route add 192.168.101.0/24 dev eth7 src 192.168.101.7 table port_7


Now create the source policy rules:

~$ ip rule add from 192.168.101.0 table port_0
......
~$ ip rule add from 192.168.101.7 table port_7


Now we flush the routing table cache to make the new policy active:

~$ ip route flush cache

If I have this right, now all packets from a given IP address will be
sent out the interface to which the IP is bound.

Now you need to make these same changes for the two SAN ports on each
Xen box.  Obviously start with one box and then test it before doing the
others.

This should get iscsiadm working and seeing all of the LUNs on all 8
ports on san1, and dm-multipath should work.  If it turns out that
dm-multipath doesn't fan across all 8 remote interfaces, you'll need to
manually set each Xen box to hit a specific pair of ports on san1, two
Xen boxen per pair of san1 ports.  Set it up so the Xen pairs have one
port on each quad port NIC, for redundancy.  It doesn't really make a
different whether dm-multipath fans over all 8 LUNs because you have
only 200MB/s per Xen client anyway.  That's 1.6GB/s client bandwidth and
800MB/s server.  So as long as you have port and path redundancy, two
LUN connections per client is as good as 8.  I've actually never seen a
SAN setup with clients logging into more than two head ports.

Most configurations such as this use multiple switches.  So the switch
may still give us problems.  If so we'll have to figure out an
appropriate multiple VLAN setup.  And do all of the above with standard
frame size.  If/when it's working try larger MTU.

> Eventually I pulled the disabled all except one ethernet device on both
> machines, still no luck. 

After so much reconfiguration it's hard to tell what all was going wrong
at this point.

> Finally, out of desperation I pulled the cables
> from both machines, dropped in a direct cable (ie, bypass the nice shiny
> new switch), and discover worked immediately. So I tried with the old
> switch, but same problem, so I've now connected each xen box direct to
> san1 ethernet port, so they now all get a dedicated 1 Gbps port each.

If the source routing config above doesn't immediately work, or if you
get full bandwidth out to the Xen hosts, but only half into to san1, you
may need to create 2 isolated VLANs, put two ports of each quad NIC in
each, and one port of each Xen box in each VLAN.

> I think the problem with the switch is that I didn't configure it
> properly to support the 9000 MTU, or something like that, which now
> makes more sense that lots of small packets are fine (not faulty cables,
> network cards, switches, etc) but big packets fail (like the response to
> a DiscoveryAll packet).

You may have simply confused it with all the link plugging and chugging.
 In the past I've seen odd things like switches holding onto a MAC on
port1 ten minutes after I pulled the server from port1 and plugged it
into port10, forcing me to reboot or power cycle the switch to clear the
MAC table.  Other switches handle this with aplomb.  It's been many
years since I've seen that though, and it was a low end model.

> Anyway, all systems are online, and I think I will leave things as is
> for now.

The fact that it's working well enough (and far better than previously),
even if not yet perfected, is the most important part. :)  The client
isn't screaming anymore.

Worth noting is with direct connection you eliminate the switch latency,
increasing throughput.  Though you need to get this all working through
a switch, with both links for redundancy, and so you can expand with
more Xen hosts if needed.  Right now you're out of server ports.  And
you're probably close to exhausting the PCIe slots in san1.

> What I have accomplished:
> 1) All systems should be using dedicated 1Gbps for iSCSI and 1Gbps for
> everything else
> 2) All hardware is physically installed

> What I think I need next time
> 1) 10 x colour coded 2m cables (management/user LAN ports), probably
> blue to match all the rest of the user cabling
> 2) 8 cables in green (port 1 xen)
> 3) 8 cables in yellow (port 2 xen)
> 4) 8 cables in white (4 each for san1/san2 on 1st card)
> 5) 8 cables in grey (4 each for san1/san2 on 2nd card)
> 6) Lotsa cable ties to keep each bundle together

There's your problem.  No orange. ;)

(most LC multimode fiber SAN cables are orange)

> Don't really know what colour cables are available, or even sure if it
> is such a good idea to use so many different colours.... Another option
> would be to stick with two colours, one for the iSCSI SAN network, and
> the second colour for the user LAN. Just makes it hard trying to work
> out which port/machine the other end of this random cable is connected
> to.....

Two colors for SAN: one for Xen boxen, one for servers.  Label each
cable end with it's respective switch or host port assignment.  One inch
printer labels work well as they stick to the cable and themselves, so
well you have to cut them off.  I think somebody sells something fancier
but why bother, as long as you can read your own handwriting.  Label the
Intel NIC ports if they aren't numbered.  That's how I normally do it.

> Anyway, monitoring systems say everything is ok, testing says it's
> working, so I'm off home. No pictures yet, so messy it's embarrassing,

*ALL* racks/closets are messy.  It's only environments where folks are
under worked and overpaid that everything is tidy: govt, uni, big corp.
 Nobody else has time.  And if you're a VAR/consultant paid by the hour,
clients don't give a crap about looks, as long as it works.  They don't,
or rarely, go into the server room, closet, etc anyway.

> and it isn't even working properly. Hopefully when I'm finished it will
> be worth a picture or two :)

You'll get there before long.  The final configuration may not be
exactly what you envisioned, but I guarantee your overall goals will be
met soon.  You've doubled your bandwidth by isolating user/san traffic
so you're half way there already.

-- 
Stan

