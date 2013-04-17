From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance - new kernel results
Date: Wed, 17 Apr 2013 20:15:51 +1000
Message-ID: <516E7657.1010403@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <20776.59138.27235.908118@quad.stoffel.home> <5130D2EB.1070507@websitemanagers.com.au> <20130310153518.GQ5411@kevin> <516BF13B.4010704@websitemanagers.com.au> <20844.7530.817412.979677@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20844.7530.817412.979677@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm amalgamating a few different replies into a single post here to
reduce the noise on-list...

On 16/04/13 01:31, John Stoffel wrote:
> Now, from looking over your report, it strongly smells of a problem in
> the network switch.  I think you have just one in the core of your
> network, correct?  I'd probably try to bring up a test network (if you
> have the spare systems in a lab) and try to replicate the packet
> drops.

Definitely not unfortunately.... Besides the main issue would be to
generate sufficient load to cause it to happen... I'm fairly sure that
it is load related, since it only happens during the day, and generally
at times when a lot of users are logging in, or logging out.

However, there are about 5 switches in the network in total.
Switch 1 is the "core", it connects directly to switch 2, 3 and 4 (or 5,
4 is the unmanaged switch, 5 is the managed switch).

Switches 1, 2 and 3 connect to various
workstations/printers/devices/routers/etc.

Switch 4/5 connects to ALL the servers that are under
analysis/discussion here.

Then, there is switch 6, which is a 48 port managed switch, and it
connects the 8 ports from san1 (storage server 1) and 8 ports from san2,
and 2 ports from each of the 8 machines. (Total 32 ports used). There is
no connection from this switch to any other switch, it is a separate
subnet/isolated network just for iSCSI.

> But in general, I'd probably:
>   - remove the iSCSI bonding, goto a single 1Gb link.

Not relevant, iSCSI is on a different network

>   - get rid of jumbo frames, if you're using it.

No jumbo frames on this network, jumbo frames is on the iSCSI network only.

>   - can you reduce the size of your bond0 on the storage box?  

There are no bonded ethernet on the network with an issue.

> I wonder if the switch is having some sort of table over-flow, or is
> just having some sort of brain fart and droppping a packet and then
> needs time to rebuild it's tables internally to get things going
> again?

Quite possible, although when using the smart switch, it said the MAC
address table had a maximum ever number of 64 entries, I didn't bother
looking up the specs, but I'm sure they usually support at least 1000
entries... The current number of learned entries is 45.

> I'd try to borrow a similar sized switch from another vendor and try
> using that instead if you can.  Another thing is to try and use SNMP
> to grab stats from the switch and look for patterns.  When you see
> connectivity problems, do you see a corresponding drop on one of the
> links on the bond0 connection?  Or on another bond?  

There are definitely no link drops (on any of the networks), because
Linux never logs the link drop on any ethernet interface, and I presume
windows would also log that as an event, but in any case, none of the
linux PC's which have been affected have recorded that.

> But, thinking about it more, you don't mention if you're dropping
> packets on the iSCSI side of things, or just on the regular network.
> That's a key observation, since it will either suggest, or refute my
> idea of the problem being in the bond(s).  

Right, packet loss is only happening on the regular network. Although
I've not done any ping tests on the iSCSI network, everything seems to
be working and performing perfectly with every test I do, and there are
no complaints whose cause could be blamed as a disk/iSCSI issue. So I
don't suspect any issue on the iSCSI network at this stage.

> Do you see any errors in the dmesg logs on the Xen/Linux/Windows
> boxes?  And when you have an outage between two hosts, do pings to
> *other* hosts still work just fine, or does all network traffic on
> that host come to a stop?

It is interesting...
1) pings from host1 to host2 shows no replies for a period of 10 seconds.
2) pings from host3 to host2 shows no replies for the same period
3) traffic sniffing (with tcpdump) and analysis (with wireshark) for the
physical ethernet interface of a machine which is running a windows VM
shows a *lot* of TCP retransmissions, and some of the ICMP requests are
seen (but not all, and obviously most traffic quickly dies off due to no
ACK's being sent out). In addition, a very small number of outbound
packets can be seen, including some ICMP replies, but the remote party
clearly never received it.
4) During the same period, every ICMP request/reply to the physical
machine is successful.

> It really smells of a switch problem.  Have you checked that the
> switch firmware is upto date?

Yes, switch firmware is up to date

> It might just be that Netgear makes a
> crappy switch (cue people to chime on on this! :-) which can't handle
> the load you're tossing at it.  Which is why I suggest you try another
> vendor's switch.

I wouldn't suggest netgear make the best equipment ever, but I've used
their switches for many years, and in many customers networks and have
yet to have a real problem. Certainly, a couple have eventually died,
but never really had a problem with one before now. Also, have of course
tried two different models.

> Cisco is probably reliable but expensive.  Dell has some ok switches
> in my experience, but nothing recent.  I've heard good things about
> other brands such as Juniper, Force10 (now Dell) and others.  

I would certainly be happy to buy another switch, of any brand, even
cisco if it could solve the problem. The issue is that the chance it
will solve the problem seems so small, that it would result in a waste
of money possibly better spent elsewhere.

On 16/04/13 02:35, Romain Francoise wrote:
> Total shot in the dark, but maybe you're seeing the effect of an
> interface changing its MAC address. This typically happens with
> bridge interfaces, which can change their MAC when you add a new
> member, the highest-numbered address gets used automatically.
> 
> When the MAC address changes, all the other hosts have to do a new
> ARP resolution to update their tables, which causes a few seconds of
> delay.

Using the above tcpdump/wireshark, I can see the ARP requests prior to
the outage, and after the outage, and the MAC address matches. In
addition, there is no network changes generally, no machines being
rebooted, etc. It's a pretty stable network overall. (This excludes the
various workstations/etc that are actually on the same network/broadcast
domain, they are regularly rebooted by the user etc as needed).

On 16/04/13 02:49, Roy Sigurd Karlsbakk wrote:
> What sort of bonding? 802.3ad or something else? if using the
> former, this probably won't work on the non-managed switch. if using
> the latter, then please detail

I'm using bond-mode balance-alb, but as mentioned, that is on the iSCSI
network, so it has no impact/relevance here (well, it should not).

On 17/04/13 07:03, Phil Turmel wrote:> On 04/16/2013 03:28 PM, Roy
Sigurd Karlsbakk wrote:
>>>> I suspect that the single ping packets being lost are an
>>>> indication of a problem, but this should not impact the users
>>>> (TCP should look after the re-transmission, etc). Wether this is
>>>> related to the longer 10-50 second outage I'm not sure.
>>>
>>> No, single lost pings are *not* a sign of a problem. It is
>>> perfectly normal for a network to have random traffic spikes that
>>> fill a switch's store-and-forward buffers. ICMP pings are
>>> *datagrams*, like UDP, so they aren't retransmitted when dropped.
>>> Losing them as infrequently as you say suggests your network isn't
>>> heavily loaded.
>>
>> Switches (unlike bridges) do not use store-and-forward. They use
>> cut-through, meaning they use store-and-forward for the initial
>> packet from A to B and then store the path and switch it later,
>> sniffing the MAC addresses and just use pass-through.
>
> Nothing you said changes my statement that switches often drop single
> packets.  The occasional dropped ping is a red herring.  A cheap
> switch that can't ever buffer will simply drop *more* random packets.

However, if the switch dropped the packet, it should be counted, yet the
switch is reporting 0 dropped packets across every port (which is what I
would expect, this isn't, or shouldn't, be a very busy network).

>> As was said, the traffic on the network was minimal, so I really
>> doubt this had an impact. Getting 30 seconds+ of drops must come from
>> a bad network stack or a really bad switch, but then again, two
>> switches were tested, so I doubt the switches alone could do that.
> We seem to violently agree here.  Multiple consecutive drops is a real
> problem.

Right, and this is really the only reason I'm even noticing the
occasional single packet being dropped.....

>> What may be doing it, is bad (or perhaps incompatible) bonding
>> setup.
> My point was to not prematurely conclude that the problem is in the
> network.

It can't (I don't think) be bonding, since the bonded interfaces are on
the other network. This network that I'm seeing the packet loss on
doesn't have any machine with more than a single 1Gbps ethernet
interface connected to this switch.

Given the number of switches on the network, and even though the packet
loss is mostly happening on only one of those switches, could it be a
STP mis-configuration of some sort?

The topology is reasonably flat:
Unmanaged Switch = US
Managed Switch = MS
Linux Bridge = LB

     US1
   /  |  \
 US2 US3 MS5
        / |  \
      LB1 LB2 LB3

Note: The Linux Bridge is configured in debian /etc/network/interfaces
auto xenbr0
iface xenbr0 inet static
	address 10.2.2.3
	netmask 255.255.240.0
	gateway 10.2.2.254
	bridge_maxwait 5
	bridge_ports regex eth0

When the VM is created, an additional interface is created and added to
the bridge, but this is not done during the day (or even very often at
night).....

The managed switch has the following config:
Spanning Tree State: Disable
STP Operation Mode: STP RSTP MSTP (Selected option is MSTP)
Configuration Name:
Configuration Revision Level: 0 (Valid values 0 - 65535)
Configuration Digest Key:
BPDU Flooding: All (or specific port number) Disable/Enable (Selected
option is Disable)

The "System Log" on the switch is full of useless "SNTP system clock
synchronized" messages every 10 minutes or so.



Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au

