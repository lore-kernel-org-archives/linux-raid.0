From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID performance
Date: Sun, 10 Feb 2013 18:19:19 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1302101812060.32644@uplift.swm.pp.se>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <511471EA.2000605@hardwarefreak.com>
 <5114A53B.9060103@websitemanagers.com.au> <5115316F.1090502@hardwarefreak.com> <5115478A.8010004@websitemanagers.com.au> <5115CC02.2010400@hardwarefreak.com> <d34a6caf-d1b5-403c-aee2-525a9b3c3db7@email.android.com> <51179F09.1020503@hardwarefreak.com>
 <6990fbda-f741-454a-80cd-bdcdfd8c971c@email.android.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6990fbda-f741-454a-80cd-bdcdfd8c971c@email.android.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Stan Hoeppner <stan@hardwarefreak.com>Stan Hoeppner <stan@hardwarefreak.com>, Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 11 Feb 2013, Adam Goryachev wrote:

> Nope, I'm saying that on 5 different (specifically machines 1, 4, 5, 6, 
> 7) physical boxes, (the xen host) if I do a dd 
> if=/dev/disk/by-path/iscsivm1 of=/dev/null on 5 machines concurrently, 
> then they only get 20Mbps each. If I do one at a time, I get 130Mbps, if 
> I do two at a time, I get 60Mbps, etc... If I do the same test on 
> machines 1, 2, 3, 8 at the same time, each gets 130Mbps

When you say Mbps, I read that as Megabit/s. Are you in fact referring to 
megabyte/s?

I suspect the load balancing (hasing) function on the switch terminating 
the LAG is causing your problem. Typically this hashing function doesn't 
look at load on individual links, but a specific src/dst/port hash points 
to a certain link, and there isn't really anything you can do about it. 
The only way around it is to go 10GE instead of the LAG, or move away from 
the LAG and assign 4 different IPs, one per physical link, and then make 
sure routing to/from server/client always goes onto the same link, cutting 
worst-case down to two servers sharing one link (8 servers, 4 links).

> The problem is that (from my understanding) LACP will balance the 
> traffic based on the destination MAC address, by default. So the 
> bandwidth between any two machines is limited to a single 1Gbps link. So 
> regardless of the number of ethernet ports on the DC box, it will only 
> ever use a max of 1Gb[s to talk to the iSCSI server.

LACP is a way to set up a bunch of ports in a channel. It doesn't affect 
how traffic will be shared, that is a property of the hardware/software 
mix in the switch/operating (LACP is control plane, it's not forwarding 
plane). Device egressing the packet onto a link decides what port it goes 
out of, typically done on properties on L2, L3 and L4 (different for 
different devices).

> However, if I configure Linux to use xmit_hash_policy=1 it will use the 
> IP address and port (layer 3+4) to decide which trunk to use. It will 
> still only use 1Gbps to talk to that IP:port combination.

As expected. You do not want to send packets belonging to a single 
"session" out different ports, because then you might get packet 
reordering. This is called "per-packet load sharing", if it's desireable 
then it might be possible to enable in the equipment. TCP doesn't like it 
though, don't know how storage protocols react.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
