From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: raid over ethernet
Date: Sat, 29 Jan 2011 17:04:31 -0600
Message-ID: <4D449CFF.9010701@hardwarefreak.com>
References: <AANLkTi=2PDZdVSEgF0mQ_ZdwxvkPoSywM6U0e4hMxTXS@mail.gmail.com> <alpine.DEB.1.10.1101290741510.13151@uplift.swm.pp.se> <AANLkTikFHBD_TjTe96tgd4Kmy6zZuD8kdE0W-0ncdCev@mail.gmail.com> <20110129133457.GB15784@mordor.angband.thangorodrim.de> <AANLkTi=6ridRPnHpfdOC=f2_ESndSARmQRkvT_shYO3s@mail.gmail.com> <20110129210815.GC15784@mordor.angband.thangorodrim.de> <4D448CAF.6020409@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D448CAF.6020409@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Alexander Schreiber <als@thangorodrim.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

John Robinson put forth on 1/29/2011 3:54 PM:

> Now that is interesting, to me at least. More as a thought experiment for now, I
> was wondering how one would go about setting up a small cluster of commodity
> servers (maybe 8 machines) running Xen (or perhaps now KVM) VMs, such that if
> one (or potentially two) of the machines died, the VMs could be picked up by the
> other machines in the cluster, and only using locally-attached SATA/SAS discs in
> each machine.

Doing N-way active replication with DRBD increases network utilization
substantially.  With two DRBD active nodes you will have a maximum of _2_
simultaneous data streams, one in each direction.  With 8 active nodes you will
have a maximum of _56_ simultaneous data streams.  Your scenario requires all
nodes be active.

This may work for a hobby cluster or something with very low volume of data
being written to disk.  This solution most likely won't scale for a cluster with
any amount of real traffic.  GbE peaks at 100 MB/s.  Therefore each node will
have only about 12 MB/s of bidirectional bandwidth for each other cluster member
if my math is correct.  A single SATA disk run about 80-120 MB/s, so your
network DRBD disk bandwidth is about 1/7th to 1/10th that of a single local
disk.  In a 2 node cluster it's closer to 1:1.  For you scenario to actually be
feasible, you'd need at least bonded quad GbE interfaces if not single 10 GbE
interfaces to get all the bandwidth you'd need.

You'd be _MUCH_ better off using 2 active DRBD mirrored NFS servers with GFS2
filesystems and having the aforementioned 8 nodes do their data sharing via NFS.
 In this setup each node only writes once (to NFS) dramatically reducing network
bandwidth required per node, with only 16 maximum data streams instead of 56.
If you need more bandwidth or IOPS than a single disk NFS server can produce,
simply RAID 4-10 disks on each NFS server via RAID 10, then mirror the two RAIDs
with DRBD.

You may need 2-4 GbE interfaces between the two NFS servers just for DRBD
traffic, but the cost of that is much less than having the same number of
interfaces in each of 8 cluster nodes.  This will also give you much better
performance after a node or two fails and you have to boot their VM guests on
other hosts.  Having fast central RAID storage will allow those guests to boot
much more quickly and without causing degraded performance on the other nodes
due to lack of disk bandwidth in your suggested model.

-- 
Stan
