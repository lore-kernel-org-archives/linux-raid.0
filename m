From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: possibly silly question (raid failover)
Date: Wed, 02 Nov 2011 01:41:23 -0500
Message-ID: <4EB0E613.1040503@hardwarefreak.com>
References: <4EAF3F78.5060900@meetinghouse.net>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EAF3F78.5060900@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: Miles Fidelman <mfidelman@meetinghouse.net>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/31/2011 7:38 PM, Miles Fidelman wrote:
> Hi Folks,
> 
> I've been exploring various ways to build a "poor man's high
> availability cluster."  

Overall advice:  Don't attempt to reinvent the wheel.

Building such a thing is normally a means to end, not an end itself.  If
your goal is supporting an actual workload and not simply the above,
there are a number of good options readily available.

> Currently I'm running two nodes, using raid on
> each box, running DRBD across the boxes, and running Xen virtual
> machines on top of that.
> 
> I now have two brand new servers - for a total of four nodes - each with
> four large drives, and four gigE ports.

A good option in this case would be to simply take the 8 new drives and
add 4 each to the existing servers, expanding existing md RAID devices
and filesystems where appropriate.  Then setup NFS cluster services and
export the appropriate filesystems to the two new servers.  This keeps
your overall complexity low, reliability and performance high, and
yields a setup many are familiar with if you need troubleshooting
assistance in the future.  This is a widely used architecture and has
been for many years.

> Between the configuration of the systems, and rack space limitations,
> I'm trying to use each server for both storage and processing - and been
> looking at various options for building a cluster file system across all
> 16 drives, that supports VM migration/failover across all for nodes, and
> that's resistant to both single-drive failures, and to losing an entire
> server (and it's 4 drives), and maybe even losing two servers (8 drives).

The solution above gives you all of this, except the unlikely scenario
of losing both storage servers simultaneously.  If that is truly
something you're willing to spend money to mitigate then slap a 3rd
storage server in an off site location and use the DRBD option for such.

> The approach that looks most interesting is Sheepdog - but it's both
> tied to KVM rather than Xen, and a bit immature.

Interesting disclaimer for an open source project, specifically the 2nd
half of the statement:

"There is no guarantee that this software will be included in future
software releases, and it probably will not be included."

> But it lead me to wonder if something like this might make sense:
> - mount each drive using AoE
> - run md RAID 10 across all 16 drives one one node
> - mount the resulting md device using AoE
> - if the node running the md device fails, use pacemaker/crm to
> auto-start an md device on another node, re-assemble and republish the
> array
> - resulting in a 16-drive raid10 array that's accessible from all nodes

The level of complexity here is too high for a production architecture.
 In addition, doing something like this puts you way out in uncharted
waters, where you will have few, if any, peers to assist in time of
need.  When (not if) something breaks in an unexpected way, how quickly
will you be able to troubleshoot and resolve a problem in such a complex
architecture?

> Or is this just silly and/or wrongheaded?

I don't think it's silly.  Maybe a little wrongheaded, to use your term.
 IBM has had GPFS on the market for a decade plus.  It will do exactly
what you want, but the price is likely well beyond your budget, assuming
they'd even return your call WRT a 4 node cluster.  (IBM GPFS customers
are mostly government labs, aerospace giants, and pharma companies, with
very large node count clusters, hundreds to thousands).

If I were doing such a setup to fit your stated needs, I'd spend
~$10-15K USD on a low/midrange iSCSI SAN box with 2GB cache dual
controllers/PSUs and 16 x 500GB SATA drives.  I'd create a single RAID6
array of 14 drives with two standby spares, yielding 7TB of space for
carving up LUNS.  Carve and export the LUNS you need to each node's
dual/quad NIC MACs with multipathing setup on each node, and format the
LUNs with GFS2.  All nodes now have access to all storage you assign.
With such a setup you can easily add future nodes.  It's not complex, it
is a well understood architecture, and relatively straightforward to
troubleshoot.

Now, if that solution is out of your price range, I think the redundant
cluster NFS server architecture is in your immediate future.  It's in
essence free, and it will give you everything you need, in spite of the
fact that the "node symmetry" isn't what you apparently envision as
"optimal" for a cluster.

-- 
Stan

