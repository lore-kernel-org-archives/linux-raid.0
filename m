From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: possibly silly question (raid failover)
Date: Wed, 02 Nov 2011 09:17:48 -0400
Message-ID: <4EB142FC.4060506@meetinghouse.net>
References: <4EAF3F78.5060900@meetinghouse.net> <4EB0E613.1040503@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EB0E613.1040503@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Stan,

Stan Hoeppner wrote:
> On 10/31/2011 7:38 PM, Miles Fidelman wrote:
>> Hi Folks,
>>
>> I've been exploring various ways to build a "poor man's high
>> availability cluster."
> Overall advice:  Don't attempt to reinvent the wheel.
>
> Building such a thing is normally a means to end, not an end itself.  If
> your goal is supporting an actual workload and not simply the above,
> there are a number of good options readily available.
well, normally I'd agree with you, but...

- we're both an R&D organization and a (small, but aspiring) provider of 
hosted services - so experimenting with infrastructure is part of the 
actual work -- and part of where I'd like to head is an environment 
that's built out of commodity boxes configured in a way that scales out 
(Sheepdog is really the model I have in mind)

- I'd sure like to find something that does what we need:
-- we're using DRBD/Pacemaker/etc. - but that's sort of brittle and only 
supports pair-wise migration/failover
-- if Sheepdog was a little more mature, and supported Xen, it would be 
exactly what I'm looking for
-- Xen over the newest release of GlustFS is starting to look attractive
-- some of the single system image projects (OpenMosix, Kerrighed) would 
be attractive if the projects were alive
>> Currently I'm running two nodes, using raid on
>> each box, running DRBD across the boxes, and running Xen virtual
>> machines on top of that.
>>
>> I now have two brand new servers - for a total of four nodes - each with
>> four large drives, and four gigE ports.
> A good option in this case would be to simply take the 8 new drives and
> add 4 each to the existing servers, expanding existing md RAID devices
> and filesystems where appropriate.  Then setup NFS cluster services and
> export the appropriate filesystems to the two new servers.  This keeps
> your overall complexity low, reliability and performance high, and
> yields a setup many are familiar with if you need troubleshooting
> assistance in the future.  This is a widely used architecture and has
> been for many years.

unfortunately, we're currently trying to make do with 4U of rackspace, 
and 4 1U servers, each of which holds 4 drives, can't quite move the 
disks around the way you're talking about -- unfortunately, the older 
boxes don't have hardware virtualization support or I'd seriously 
consider migrating to KVM and Sheepdog -- if Sheepdog were just a bit 
more mature, I'd seriously consider simply replacing the older boxes

>> The approach that looks most interesting is Sheepdog - but it's both
>> tied to KVM rather than Xen, and a bit immature.
> Interesting disclaimer for an open source project, specifically the 2nd
> half of the statement:
>
> "There is no guarantee that this software will be included in future
> software releases, and it probably will not be included."

Yeah, but it seems to have some traction and support, and the OpenStack 
community seems to be looking at it seriously.

Having said that, it's things like that that are pushing me toward 
GlusterFS (doesn't hurt that Red Hat just purchased Gluster and seems to 
be putting some serious resources into it).
>
>> But it lead me to wonder if something like this might make sense:
>> - mount each drive using AoE
>> - run md RAID 10 across all 16 drives one one node
>> - mount the resulting md device using AoE
>> - if the node running the md device fails, use pacemaker/crm to
>> auto-start an md device on another node, re-assemble and republish the
>> array
>> - resulting in a 16-drive raid10 array that's accessible from all nodes
> The level of complexity here is too high for a production architecture.
>   In addition, doing something like this puts you way out in uncharted
> waters, where you will have few, if any, peers to assist in time of
> need.  When (not if) something breaks in an unexpected way, how quickly
> will you be able to troubleshoot and resolve a problem in such a complex
> architecture?

Understood.  This path is somewhat more of a matter of curiosity.  AoE 
is pretty mature, and there does seem to be a RAID resource agent for 
CRM - so some of the pieces exist.  Seems like the pieces would fit 
together - so I was wondering if anybody had actually tried it.
> If I were doing such a setup to fit your stated needs, I'd spend 
> ~$10-15K USD on a low/midrange iSCSI SAN box with 2GB cache dual 
> controllers/PSUs and 16 x 500GB SATA drives. I'd create a single RAID6 
> array of 14 drives with two standby spares, yielding 7TB of space for 
> carving up LUNS. Carve and export the LUNS you need to each node's 
> dual/quad NIC MACs with multipathing setup on each node, and format 
> the LUNs with GFS2. All nodes now have access to all storage you 
> assign. With such a setup you can easily add future nodes. It's not 
> complex, it is a well understood architecture, and relatively 
> straightforward to troubleshoot. Now, if that solution is out of your 
> price range, I think the redundant cluster NFS server architecture is 
> in your immediate future. It's in essence free, and it will give you 
> everything you need, in spite of the fact that the "node symmetry" 
> isn't what you apparently envision as "optimal" for a cluster. 

Hmm... if I were spending real money, and had more rack space to put 
things in, I'd probably do something more like a small OpenStack 
configuration, but that's me.

Thanks for your comments.  Lots of food for thought!

Miles


-- 
In theory, there is no difference between theory and practice.
In<fnord>  practice, there is.   .... Yogi Berra


