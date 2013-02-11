From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Mon, 11 Feb 2013 14:41:58 +1100
Message-ID: <51186886.6000102@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <511471EA.2000605@hardwarefreak.com> <5114A53B.9060103@websitemanagers.com.au> <5115316F.1090502@hardwarefreak.com> <5115478A.8010004@websitemanagers.com.au> <5115CC02.2010400@hardwarefreak.com> <d34a6caf-d1b5-403c-aee2-525a9b3c3db7@email.android.com> <51179F09.1020503@hardwarefreak.com> <6990fbda-f741-454a-80cd-bdcdfd8c971c@email.android.com> <alpine.DEB.2.00.1302101812060.32644@uplift.swm.pp.se> <511817D8.7020809@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511817D8.7020809@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

OK, I'm starting this all over....

At this point, I think regardless of what I do, the maximum bandwidth I
will get is 1Gbps per physical machine (VM server), since the switch
will only ever direct data over a single port (without going to 10Gbps
ethernet).

So, I think the best way to ensure there is always 1Gbps for each
physical machine (VM server) is this:
Get and install 2 x LSI HBA's for the iSCSI servers (1 each) to maximise
performance for the SSD's
Get a 48port switch to support all the additional ethernet ports
Install 8 ethernet ports into the iSCSI server
Install dual ethernet ports into each physical machine (really only need
single, but cost difference is minimal and availability is quicker)
Configure the switch so one port from each of the iSCSI servers plus
both ports on the physical box are on an individual VLAN (ie, 4 ports in
each VLAN)
The physical boxes are configured with ethernet bonding LACP
Configure unique IP addresses/ranges on each VLAN (only need small
subnets, enough for two IP's on each one for the physical machine and
one for the iSCSI server, but since this is totally private IP space it
doesn't matter much anyway).

Now, I lose the current reliability of ethernet connectivity at the
iSCSI server (loss of a single port means loss of a physical machine,
but that is acceptable since the VM can restart on another physical machine.
I get a minimum (and maximum) of 1Gbps of iSCSI performance for each
physical machine, a theoretical maximum of 16Gbps duplex. I don't think
my SSD's will stretch to that performance level (800MB/s read and write
concurrently), but even if it did, I doubt all servers would be asking
to do that anyway.
I get a full 1Gbps for user level data access (SMB/RDP/etc) which is
equivalent to what they had before when all the machines were physical
machines with local HDD's

Thus, I don't have any server sending/receiving data more quickly than
the other side can handle.
I don't have any one server that can steal all available IO from the others

The only downside here is added complexity to setup the 8 networks on
the iSCSI servers (minimal effort), configure the additional ethernet
and bonding on the 8 x physical machines (minimal), and configure the
failover from primary SAN to secondary (more complex, but this isn't
actually a primary concern right now anyway, and to actually run with
the secondary SAN would be a nightmare anyway since it only has 4 x
7200rpm HDD in RAID10, it will need an upgrade to SSD's before it is
really going to be useful).

Finally, the only additional thing I could attempt, would be to
configure the ports on the iSCSI server in pairs, so that a pair of
ports on the iSCSI and all ports from 2 physical machines (total of 8
ports) are on the same VLAN. This will work IF both linux and the switch
will properly balance LACP so that each physical server uses it's own
port. The only thing this adds is resiliency from ethernet failure on
the iSCSI server. If the LACP doesn't properly balance traffic, then I'd
just scratch this and use as above.

Any comments/suggestions?

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au

