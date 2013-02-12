From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance
Date: Mon, 11 Feb 2013 20:46:52 -0600
Message-ID: <5119AD1C.8030000@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <511471EA.2000605@hardwarefreak.com> <5114A53B.9060103@websitemanagers.com.au> <5115316F.1090502@hardwarefreak.com> <5115478A.8010004@websitemanagers.com.au> <5115CC02.2010400@hardwarefreak.com> <d34a6caf-d1b5-403c-aee2-525a9b3c3db7@email.android.com> <51179F09.1020503@hardwarefreak.com> <6990fbda-f741-454a-80cd-bdcdfd8c971c@email.android.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6990fbda-f741-454a-80cd-bdcdfd8c971c@email.android.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If it's OK I'm going to snip a bunch of this and get to the meat of it,
so hopefully it's less confusing.

On 2/10/2013 10:16 AM, Adam Goryachev wrote:
...
...
> The problem is that (from my understanding) LACP will balance the traffic based on the destination MAC address, by default. So the bandwidth between any two machines is limited to a single 1Gbps link. So regardless of the number of ethernet ports on the DC box, it will only ever use a max of 1Gb[s to talk to the iSCSI server.

> However, if I configure Linux to use xmit_hash_policy=1 it will use the IP address and port (layer 3+4) to decide which trunk to use. It will still only use 1Gbps to talk to that IP:port combination.

That is correct.  Long story short, the last time I messed with a
configuration such as this I was using a Cisco that fanned over 802.3ad
groups based on L3/4 info.  Stock 802.3ad won't do this.  I apologize
for the confusion, and for the delay in responding (twas a weekend after
all).  I just finished reading the relevant section of your GS716T-200
(GST716-v2) manual, and it does not appear to have this capability.

All is not lost.  I've done a considerable amount of analysis of all the
information you've provided.  In fact I've spent way to much time on
this.  But it's an intriguing problem involving interesting systems
assembled from channel parts, i.e. "DIY", and I couldn't put it down.  I
was hoping to come up with a long term solution that didn't require any
more hardware than a NIC and HBA, but that's just not really feasible.
So, my conclusions and recommendations, based on all the information I
have to date:

1.  Channel bonding via a single switch using standard link aggregation
    protocols cannot scale iSCSI throughput between two hosts.  The
    various Linux packet fanning modes don't work well here either for
    scaling both transmit and receive traffic.

2.  To scale iSCSI throughput using a single switch will require
    multiple host ports and MPIO, but no LAG for these ports.

3.  Given the facts above, an extra port could be added to each TS Xen
    box.  A separate subnet would be created for the iSCSI SAN traffic,
    and each port given an IP in the subnet.  Both ports would carry
    MPIO iSCSI packets, but only one port would carry user traffic.

4.  Given the fact that there will almost certainly be TS users on the
    target box when the DC VM gets migrated due to some kind of failure
    or maintenance, adding the load of file sharing may not prove
    desirable.  And you'd need another switch.  Thus, I'd recommend:

A.  Dedicate the DC Xen box as a file server and dedicate a non-TS
    Xen box as its failover partner.  Each machine will receive a quad
    port NIC.  Two ports on each host will be connected to the current
    16 port switch.  The two ports will be configured to balance-alb
    using the current user network IP address.  All switch ports will
    be reconfigured to standard mode, no LAGs, as they are not needed
    for Linux balance-alb.  Disconnect the 8111 mobo ports on these two
    boxes from the switch as they're no longer needed.  Prioritize RDP
    in the switch, leave all other protocols alone.

B.  We remove 4 links each from the iSCSI servers, the primary and the
    DRBD backup server, from the switch.  This frees up 8 ports for
    connecting the file servers' 4 ports, and connecting a motherboard
    ethernet port from each iSCSI server to the switch for management.
    If my math is correct this should leave two ports free.

C.  MPIO is designed specifically for IO scaling, and works well.
    So it's a better fit, and you save the cost of the additional
    switch(es) that would be required to do perfect balance-rr bonding
    between iSCSI hosts (which can be done easily with each host
    ethernet port connected to a different dedicated SAN switch.  In
    this case it would require 4 additional switches.  Instead what
    we'll do here is connect the remaining 2 ports from each Xen file
    server box, the primary and the backup, and all 4 ports on each
    iSCSI server, the primary and the backup, to a new 12-16 port
    switch.  It can be any cheap unmanaged GbE switch of 12 or more
    ports.  We'll assign an IP address in the new SAN subnet to each
    physical port on these 4 boxes and configure MPIO accordingly.

    So what we end up with is decent session based scaling of user CIFS
    traffic between the TS hosts and the DC Xen servers, with no single
    TS host bogging everyone down, and no desktop lag if both links are
    full due to two greedy users.  We end up with nearly perfect
    ~200MB/s iSCSI scaling in both directions between the DC Xen box
    (and/or backup) and the iSCSI servers, and we end up with nearly
    perfect ~400MB/s each way between the two iSCSI servers via DRBD,
    allowing you to easily do mirroring in real-time.

All for the cost of two quad port NICs and an inexpensive switch, and
possibly a new high performance SAS HBA.  I analyzed many possible paths
to a solution, and I think this one is probably close to ideal.

You can pull off the same basic concept buying just the quad port HBA
for the current DC Xen box, removing 2 links between each iSCSI server
and the switch and direct connecting these 4 NIC ports via 2 cross over
cables, and using yet another IP subnet for these, with MPIO.  You'd
have no failover for the DC, and the bandwidth between the iSCSI servers
for BRBD would be cut in half.  But it only costs one quad port NIC.  A
dedicated 200MB/s is probably more than plenty for live DRBD, but again
you have no DC failover.

However, given that you've designed this system with "redundancy
everywhere" in mind, I'm guessing the additional redundancy justifies
the capital outlay for an unmanaged switch and a 2nd quad port NIC.

<BIG snip>

> So, given the above, would you still suggest only adding a 4port ethernet to the DC box configured with LACP, or should I really look at something else.

I think LACP is out, regardless of transmit hash mode.

If one of those test boxes could be permanently deployed as the failover
host for the DC VM, I think the dedicated iSCSI switch architecture
makes the most sense long term.  If the cost of the switch and another 4
port NIC isn't in the cards right now, you can go the other route with
just one new NIC.  And given that you'll be doing no ethernet channel
bonding on the iSCSI network, but IP based MPIO instead, it's a snap to
convert to the redundant architecture with new switch later.  All you'll
be doing is swapping cables to the new switch and changing IP address
bindings on the NICs as needed.

Again, apologies for the false start with the 802.3ad confusion on my
part.  I think you'll find all (or at least most) of the ducks in a row
in the recommendations above.

-- 
Stan

