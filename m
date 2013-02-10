From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Mon, 11 Feb 2013 08:57:44 +1100
Message-ID: <511817D8.7020809@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <511471EA.2000605@hardwarefreak.com> <5114A53B.9060103@websitemanagers.com.au> <5115316F.1090502@hardwarefreak.com> <5115478A.8010004@websitemanagers.com.au> <5115CC02.2010400@hardwarefreak.com> <d34a6caf-d1b5-403c-aee2-525a9b3c3db7@email.android.com> <51179F09.1020503@hardwarefreak.com> <6990fbda-f741-454a-80cd-bdcdfd8c971c@email.android.com> <alpine.DEB.2.00.1302101812060.32644@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1302101812060.32644@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/02/13 04:19, Mikael Abrahamsson wrote:
> On Mon, 11 Feb 2013, Adam Goryachev wrote:
> 
>> Nope, I'm saying that on 5 different (specifically machines 1, 4, 5,
>> 6, 7) physical boxes, (the xen host) if I do a dd
>> if=/dev/disk/by-path/iscsivm1 of=/dev/null on 5 machines concurrently,
>> then they only get 20Mbps each. If I do one at a time, I get 130Mbps,
>> if I do two at a time, I get 60Mbps, etc... If I do the same test on
>> machines 1, 2, 3, 8 at the same time, each gets 130Mbps
> 
> When you say Mbps, I read that as Megabit/s. Are you in fact referring
> to megabyte/s?

Ooops, my mistake, yes, I meant MB/s for these results, because that is
what dd provides output as.

> I suspect the load balancing (hasing) function on the switch terminating
> the LAG is causing your problem. Typically this hashing function doesn't
> look at load on individual links, but a specific src/dst/port hash
> points to a certain link, and there isn't really anything you can do
> about it. The only way around it is to go 10GE instead of the LAG, or
> move away from the LAG and assign 4 different IPs, one per physical
> link, and then make sure routing to/from server/client always goes onto
> the same link, cutting worst-case down to two servers sharing one link
> (8 servers, 4 links).

Given the flat topology, I think it is difficult (not impossible) to
ensure that both inbound and outbound traffic will be sent/received on
the correct interface. Since the route TO any of the 8 destinations is
on the same network, linux would choose the lowest numbered interface
(AFAIK) for all outbound traffic. Getting the right outbound interface
is the first issue, once solved, ensuring that each interface will only
send an ARP reply for its own IP is the second issue. Both of these are
solvable...

However, this adds lots of complexity, and this system is supposed to
allow heartbeat to automatically move the 'floating' IP to the secondary
server on failure, which certainly adds some complications there also.
It'd be nice to avoid all that, but if that is what is needed, then I'll
have to address all that.

>> The problem is that (from my understanding) LACP will balance the
>> traffic based on the destination MAC address, by default. So the
>> bandwidth between any two machines is limited to a single 1Gbps link.
>> So regardless of the number of ethernet ports on the DC box, it will
>> only ever use a max of 1Gb[s to talk to the iSCSI server.
> 
> LACP is a way to set up a bunch of ports in a channel. It doesn't affect
> how traffic will be shared, that is a property of the hardware/software
> mix in the switch/operating (LACP is control plane, it's not forwarding
> plane). Device egressing the packet onto a link decides what port it
> goes out of, typically done on properties on L2, L3 and L4 (different
> for different devices).
> 
>> However, if I configure Linux to use xmit_hash_policy=1 it will use
>> the IP address and port (layer 3+4) to decide which trunk to use. It
>> will still only use 1Gbps to talk to that IP:port combination.
> 
> As expected. You do not want to send packets belonging to a single
> "session" out different ports, because then you might get packet
> reordering. This is called "per-packet load sharing", if it's desireable
> then it might be possible to enable in the equipment. TCP doesn't like
> it though, don't know how storage protocols react.

Hmmm, so from my reading, it seems that out of order packets will never
be received by the SAN, since the sender only has 1Gbps, and the switch
will only deliver the data over one port anyway.

However, the clients (8 physical machines) would certainly receive out
of order packets, since the SAN is sending over 4 x 1Gbps of data, and
the switch is delivering this too fast to the single 1Gbps port, and so
probably add some packet loss when queues fill up, and this would slow
everything down.

I see a kernel option net.ipv4.tcp_reordering, would setting this value
to a higher figure allow me to use RR for the bonded connections, even
if the server has more total bandwidth than the recipient?

If I use a 10G connection for the SAN, and multiple 1G connections for
the clients, then I will still end up with a max of 1G read speed, since
the switch will only deliver data on a single port. So to get better
than 1G speed, I must use higher bandwidth channels, but using 10G on
all machines allows a single server to "flood" the network...

I suppose accepting max performance of 100MB/s for any individual client
could be acceptable, and if I could ensure that each client would
connect over a distinct port, I could drop in 2 x 4port ethernet devices
to the SAN, but I suspect this won't work because either the switch or
Linux will not properly balance the traffic. Potentially, I could
manually configure the MAC address on the clients, leave Linux to use
MAC based routing, such that the custom MAC address will calculate a
unique port for each. That just leaves the switch sending traffic back
to the SAN, and I don't know how I would go about that... Perhaps it
uses the source MAC address to decide the destination trunk, which will
either work because of the first fix above, or not work because of the
first fix above (if the calculations on Linux are different to the
switch)...

I'm still at a loss on how to correctly configure my network to solve
these issues, any hints would be appreciated.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
