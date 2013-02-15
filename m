From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance
Date: Fri, 15 Feb 2013 07:31:51 -0600
Message-ID: <511E38C7.6000203@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <511471EA.2000605@hardwarefreak.com> <5114A53B.9060103@websitemanagers.com.au> <5115316F.1090502@hardwarefreak.com> <5115478A.8010004@websitemanagers.com.au> <5115CC02.2010400@hardwarefreak.com> <d34a6caf-d1b5-403c-aee2-525a9b3c3db7@email.android.com> <51179F09.1020503@hardwarefreak.com> <6990fbda-f741-454a-80cd-bdcdfd8c971c@email.android.com> <5119AD1C.8030000@hardwarefreak.com> <5119D410.5090300@websitemanagers.com.au> <511B4719.6060607@hardwarefreak.com> <aecd39d9-2184-4df0-97bb-d63de0d29e5c@email.android.com> <555253fb-86d2-448b-a85b-43dae1a2a33d@email.and
 roid.com> <511CD709.6070506@hardwarefreak.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511CD709.6070506@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/14/2013 6:22 AM, Stan Hoeppner wrote:

> Then create 8 table entries with names, such as port_0 thru port_7:
> 
> ~$ echo 100 port_0 >> /etc/iproute2/rt_tables
> ......
> ~$ echo 101 port_7 >> /etc/iproute2/rt_tables

Correcting a typo here, this 2nd line above should read:

~$ echo 107 port_7 >> /etc/iproute2/rt_tables


These 7 commands result in a routing table like this:

100	port_0
101	port_1
102	port_2
103	port_3
104	port_4
105	port_5
106	port_6
107	port_7

The commands below this in the previous email populate the table with
the source routing rules.  With arp_filter enabled, what all of this
does is allow each of the 8 interfaces to behave just like 8 individual
hosts on the same subnet would.  And thinking about this for a brief
moment, you realize this should work just fine on a single switch
without any special switch configuration.  arp_filter docs tell us:

arp_filter - BOOLEAN
	1 - Allows you to have multiple network interfaces on the same
	subnet, and have the ARPs for each interface be answered
	based on whether or not the kernel would route a packet from
	the ARP'd IP out that interface (therefore you must use source
	based routing for this to work). In other words it allows
	control of which cards (usually 1) will respond to an arp
	request.


	0 - (default) The kernel can respond to arp requests with
	addresses from other interfaces. This may seem wrong but it
	usually makes sense, because it increases the chance of
	successful communication.  IP addresses are owned by the
	complete host on Linux, not by particular interfaces. Only for
	more complex setups like load-balancing, does this behaviour
	cause problems.

	arp_filter for the interface will be enabled if at least one of
	conf/{all,interface}/arp_filter is set to TRUE,
	it will be disabled otherwise

As you have other interfaces on the user subnet, we're enabling this
only for the SAN subnet, on a per interface basis, otherwise it would
cause problems with the user subnet interfaces.

So now all SAN subnet traffic from a given interface is properly sent
from that interface.  With your previous arp tweaks it seems each
interface was responding to arps, but TCP packets were still all going
out a single interface.  This configuration fixes that.

** IMPORTANT **
All of the work you've done with iscsiadm to this point has been with
clients having a single iSCSI ethernet port and single server target
port, and everything "just worked" without specifying local and target
addresses (BTW, don't use the server hostname for any of these
operations, obviously, only the IP addresses as they won't map).  Since
you will now have two local iSCSI addresses and potentially 8 target
addresses, discovery and possibly operations should probably be done on
a 1:1 port basis to make sure both client ports are working and both are
logging into the correct remote ports and mapping the correct LUNs.
Executing the same shell command 128 times across 8 hosts, changing
source and port IP addresses each time, seems susceptible to input
errors.  Two per host less so.

On paper, if multipath will fan all 8 remote ports from each client
port, theoretically you could getter better utilization in some client
access pattern scenarios.  But in real world use, you won't see a
difference.  Given the complexity of trying to use all 8 server ports
per client port, if this was my network, I'd do it like this,
conceptually:  http://www.hardwarefreak.com/lun-mapping.png
Going the "all 8" route you'd add another 112 lines to that diagram atop
the current 16.  That seems a little "busy" and unnecessary, more
difficult to troubleshoot.

Yes, I originally suggested fanning across all 8 ports, but after
weighing the marginal potential benefit against the many negatives, it's
clear to me that it's not the way to go.

So during your next trip to the client, once you have all of your new
cables and ties, it should be relatively quick to set this up.  Going
the "all 8" route maybe not so quick.

-- 
Stan

