From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: md raid across physical servers?
Date: Thu, 18 Jul 2013 21:26:13 -0400
Message-ID: <51E895B5.9010500@meetinghouse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm trying to figure out if this is a stupid idea or not, comments please:

I have a small, somewhat aging, 4-node cluster (legacy of a former 
web-hosting business), that currently hosts a few web sites and a 
mailing list server for some local community groups.  I've also been 
using it as a development sandbox, and playing with technology a bit.

Right now, I have it set up for poor-man's high availability:
- each node has 4 2TB drives, and 2 gigE NICs - 1 net is used for 
outside communication, 1 for node-to-node stuff
- xen virtualization, with a couple of VMs for production, and others 
for development/playing around
- md RAID-10 on each node
- DRBD across pairs of nodes to support the production VMs, with 
pacemaker-based failover

I keep looking for ways to get beyond the pairwise nature of DRBD, but 
don't quite have the horsepower or memory to spare to run something like 
Gluster to provide replication across a cluster file system.

The following thought keeps coming to mind: what about mounting drives 
using AoE, then running md RAID across the nodes?
- use LVM to create and manage logical volumes on each node
- publish a group of logical volumes via AoE (e.g., 1 from each of the 4 
servers)
- use md within a VM, to assemble a RAID10 array
- if a node fails, taking down the VM, it's instance of md, and the 
volume on that node, failover to another node, bring up the same VM, and 
it's instance of md will re-assemble the array from the 3 remaining nodes

Does this make any sense?  Will it work with any kind of performance at 
all?  Am I all wet?

Thanks for any comments.

Miles Fidelman

-- 
In theory, there is no difference between theory and practice.
In practice, there is.   .... Yogi Berra

