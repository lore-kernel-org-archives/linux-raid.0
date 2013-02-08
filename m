From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Fri, 08 Feb 2013 18:11:55 +1100
Message-ID: <5114A53B.9060103@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <511471EA.2000605@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511471EA.2000605@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/02/13 14:32, Stan Hoeppner wrote:
> On 2/7/2013 5:07 AM, Dave Cundiff wrote:
> 
>> Its not going to help your remote access any. From your configuration
>> it looks like you are limited to 4 gigabits. At least as long as your
>> NICs are not in the slot shared with the disks. If they are you might
>> get some contention.
>>
>> http://download.intel.com/support/motherboards/server/sb/g13326004_s1200bt_tps_r2_0.pdf
>>
>> See page 17 for a block diagram of your motherboard. You have a 4x DMI
>> connection that PCI slot 3, your disks, and every other onboard device
>> share. That should be about 1.2GB(10Gigabits) of bandwidth. 
> 
> This is not an issue.  The C204 to LGA1155 connection is 4 lane DMI 2.0,
> not 1.0, so that's 40Gb/s and 5GB/s duplex, 2.5GB/s each way, which is
> more than sufficient for his devices.

Thanks, good to know, though I will still check that the network cards
are in the right slots (ie, in slot 4 and 5)

>> Your SSDs
>> alone could saturate that if you performed a local operation. 
> 
> See above.  However, using an LSI  9211-8i, or better yet a 9207-8i, in
> SLOT6 would be more optimal:
> 
> 1.  These board's ASICs are capable of 320K and 700K IOPS respectively.
>  As good as it may be, the Intel C204 Southbridge SATA IO processor is
> simply not in this league.  Whether it is a bottleneck in this case is
> unknown at this time, but it's a possibility, as the C204 wasn't
> designed with SSDs in mind.
> 
> 2.  SLOT6 is PCIe x8 with 8GB/s bandwidth, 4GB/s each way, which can
> handle the full bandwidth of 8 of these Intel 480GB SSDs.

OK, so potentially, I may need to get a new controller board.
Is there a test I can run which will determine the capability of the
chipset? I can shutdown all the VM's tonight, and run the required tests...

>> Get your
>> NIC's going at 4Gig and all of it a sudden you'll really want that
>> SATA card in slot 4 or 5.
> 
> Which brings me to the issue of the W2K DC that seems to be at the root
> of the performance problems.  Adam mentioned one scenario, where a user
> was copying a 50GB file from "one drive to another" through the Windows
> DC.  That's a big load on any network, and would tie up both bonded GbE
> links for quite a while.  All of these Windows machines are VM guests
> whose local disks are apparently iSCSI targets on the server holding the
> SSD md/RAID5 array.  This suggests a few possible causes:
> 
> 1.  Ethernet interface saturation on Xen host under this W2K file server
> 2.  Ethernet bonding isn't configured properly and all iSCSI traffic
>     for this W2K DC is over a single GbE link, limiting throughput to
>     less than 100MB/s.

From the switch stats, ports 5 to 8 are the bonded ports on the storage
server (iSCSI traffic):

Int  PacketsRX  ErrorsRX  BroadcastRX PacketsTX  ErrorsTX  BroadcastTX
5    734007958  0         110         120729310  0         0
6    733085348  0         114         54059704   0         0
7    734264296  0         113         45917956   0         0
8    732964685  0         102         95655835   0         0

So, traffic seems reasonably well balanced across all four links, though
these stats were reset 16.5 days ago, so I'm not sure if they have
wrapped. The PacketsTX numbers look a little funny, with 5 and 8 getting
double compared to 6 and 7, but they are all certainly in use.

> 3.  All traffic, user and iSCSI, traversing a single link.

This is true for the VM's, but "all traffic" is mostly iSCSI, user
traffic is just RDP, which is minimal.

> 4.  A deficiency in the iSCSI configuration yielding significantly less
>     than 100MB/s throughput.

Possible, but in the past, silly, useless, performance testing with a
single physical machine, all VM's stopped, produced read performance of
100 to 110MB/s (using dd with DIRECT option). I also tested two in
parallel, and did see some reduction, but I think both would get around
90MB/s... I can do more of this testing tonight. (This testing did
produce one issue that some machines were only getting 70MB/s, but this
was due to being connected to a second gigabit switch using a single
gigabit port for the uplink. Now, all physical machines and all 4 of the
iSCSI ports are on the same switch.

> 5.  A deficiency in IO traffic between the W2K guest and the Xen host.

I can try and do some basic testing here.... The xen hosts have a single
Intel SSD drive, but I think disk space is very limited. I might be able
to copy a small winXP onto a local disk to test performance.

> 6.  And number of kernel tuning issues on the W2K DC guest causing
>     network and/or iSCSI IO issues, memory allocation problems, pagefile
>     problems, etc.

On most of the terminal servers and application servers, they were using
the pagefile during peak load (win2003 is limited to 4G RAM), so I have
allocated 4GB of RAM as a block device, and allocated to windows, which
windows then places a 4G pagefile on it. This removed the pagefile load
from the network and storage system, but had minimal noticeable impact.

> 7.  A problem with the 16 port GbE switch, bonding or other.  It would
>     be very worthwhile to gather metrics from the switch for the ports
>     connected to the Xen host with the W2K DC, and the storage server.
>     This could prove to be enlightening.

The win2k DC is on physical machine 1 which is on port 9 of the switch,
I've included the above stats here as well:

Int  PacketsRX  ErrorsRX  BroadcastRX PacketsTX  ErrorsTX  BroadcastTX
5    734007958  0         110         120729310  0         0
6    733085348  0         114         54059704   0         0
7    734264296  0         113         45917956   0         0
8    732964685  0         102         95655835   0         0
9    1808508983 0         72998       1942345594 0         0

I can also see very detailed stats per port, I'll show port 9 detailed
stats here, and comment below. If you think any other port would be
useful, please let me know.

Interface				g9
MST ID					CST
ifIndex					9
Port Type
Port Channel ID				Disable
Port Role				Disabled
STP Mode
STP State				Manual forwarding
Admin Mode				Enable
LACP Mode				Enable
Physical Mode				Auto
Physical Status				1000 Mbps Full Duplex
Link Status				Link Up
Link Trap				Enable
Packets RX and TX 64 Octets		49459211
Packets RX and TX 65-127 Octets		1618637216
Packets RX and TX 128-255 Octets	226809713
Packets RX and TX 256-511 Octets	26365450
Packets RX and TX 512-1023 Octets	246692277
Packets RX and TX 1024-1518 Octets	1587427388
Packets RX and TX > 1522 Octets		0
Octets Received				625082658823
Packets Received 64 Octets		15738586
Packets Received 65-127 Octets		1232246454
Packets Received 128-255 Octets		104644153
Packets Received 256-511 Octets		9450877
Packets Received 512-1023 Octets	208875645
Packets Received 1024-1518 Octets	239934983
Packets Received > 1522 Octets		0
Total Packets Received Without Errors	1810890698
Unicast Packets Received		1810793833
Multicast Packets Received		23697
Broadcast Packets Received		73168
Total Packets Received with MAC Errors	0
Jabbers Received			0
Fragments Received			0
Undersize Received			0
Alignment Errors			0
Rx FCS Errors				0
Overruns				0
Total Received Packets Not Forwarded	0
Local Traffic Frames			0
802.3x Pause Frames Received		0
Unacceptable Frame Type			0
Multicast Tree Viable Discards		0
Reserved Address Discards		0
Broadcast Storm Recovery		0
CFI Discards				0
Upstream Threshold			0
Total Packets Transmitted (Octets)	2070575251257
Packets Transmitted 64 Octets		33720625
Packets Transmitted 65-127 Octets	386390762
Packets Transmitted 128-255 Octets	122165560
Packets Transmitted 256-511 Octets	16914573
Packets Transmitted 512-1023 Octets	37816632
Packets Transmitted 1024-1518 Octets	1347492405
Packets Transmitted > 1522 Octets	0
Maximum Frame Size			1518
Total Packets Transmitted Successfully	1944500557
Unicast Packets Transmitted		1940616380
Multicast Packets Transmitted		2164121
Broadcast Packets Transmitted		1720056
Total Transmit Errors			0
Tx FCS Errors				0
Underrun Errors				0
Total Transmit Packets Discarded	0
Single Collision Frames			0
Multiple Collision Frames		0
Excessive Collision Frames		0
Port Membership Discards		0
STP BPDUs Received			0
STP BPDUs Transmitted			0
RSTP BPDUs Received			0
RSTP BPDUs Transmitted			0
MSTP BPDUs Received			0
MSTP BPDUs Transmitted			0
802.3x Pause Frames Transmitted		1230476
EAPOL Frames Received			0
EAPOL Frames Transmitted		0
Time Since Counters Last Cleared	16 day 16 hr 11 min 52 sec

To me, there are two interesting bits of information here.

1) We can see a breakdown of packet sizes, and this shows no jumbo
frames at all, I'm not real sure if this would help, or how to go about
configuring it, though I guess it only needs to be done within the linux
storage server, linux physical machines, and the switch.

2) The value for Pause Frames Transmitted, I'm not sure what this is,
but it doesn't sound like a good thing....
http://en.wikipedia.org/wiki/Ethernet_flow_control
Seems to indicate that the switch is telling the physical machine to
slow down sending data, and if these happen at even time intervals, then
that is an average of one per second for the past 16 days.....

Looking at the port 5 (one of the ports connected to the storage server)
this value is much higher (approx 24 per second averaged over 16 days).

I can understand that the storage server can send faster that any
individual receiver, so I can see why the switch might tell it to slow
down, but I don't see why the switch would tell the physical machine to
slow down.

So, to summarise, I think I need to look into the network performance,
and find out what is going on there. However, before I get too complex,
I'd like to confirm that things are working properly on the local
machine at the RAID5, and hopefully DRBD + LVM layers. So, I got some
fio tests last night to run, which I'll do afterhours tonight, and then
post those stats. If that shows:
1) RAID5 performance is excellent, then I should be able to avoid
purchase of an extra controller card, and mark the SATA chipset OK
2) DRBD performance is excellent, then I can ignore config errors there
3) LVM performance is excellent, then I can ignore config errors there

That then leaves me with iSCSI issues, network issues, etc, but, like I
said, one thing at a time.

Are there any other or related tests you think I should be running on
the local machine to ensure things are working properly? Any other
suggestions or information I need to provide? Should I setup and start
graphing some of these values from the switch? I'm sure it supports
SNMP, so I could poll and dump the values into some RRD files for analysis.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
