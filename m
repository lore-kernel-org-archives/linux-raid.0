From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: configuration questions & advice
Date: Mon, 10 Oct 2011 11:13:04 -0400
Message-ID: <4E930B80.7030505@meetinghouse.net>
References: <4E93078B.5080306@meetinghouse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E93078B.5080306@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Hi,

I have a small cluster that I use to host a collection of Xen virtual
machines.  I just expanded from 2 nodes to 4 nodes and am looking for
some advice re. configuring a storage subsystem.

The current (2-node) configuration is simple:
- 4 disks per node
- md-based raid10 on each node (separate devices for /boot / swap /<one big storage pool for VMs>
- lvm on the VM storage pool, pairs of logical volumes (/ swap) for each VM
- DRBD to replicate (some) volumes between the two nodes
- (some) VMs set up for auto-failover on node failure (pacemaker, etc.)

In moving to 4 nodes, I'd like to add some flexibility to move VMs
across all 4 nodes, but... that requires using something other than DRBD
to replicate volumes.  I'm thinking of something with the following
characteristics:

- 4-node storage cluster (4 drives per node, total of 16 drives in the
storage pool)
- 4-node VM cluster
- using the SAME 4 nodes for both
- note: I've got 4 gigE ports to play with on each box (plan on using 2
for outside access, 2 for storage/heartbeat networking)

I'm thinking of moving to a cluster filesystem (in particular GlusterFS
seems to fit the bill), but it strikes me that an alternative would be to:

- mount all my drives via iSCSI
-- or use RAID10 on each node for /boot / swap, mount the rest of each drive as iSCSI
- build an md RAID10 storage pool that spans all 16 drives across all 4 nodes
- run LVM and build logical volumes on top of that
- build VM migration/failover on top of that (locking, concurrency control, etc.)

Any thoughts re:
- does this make any sense at all?
if so:
- management tools that might make this easier
- clustering layer to manage locking and such?

Thanks very much for any advice and suggestions,

Miles Fidelman




-- 
In theory, there is no difference between theory and practice.
In<fnord>   practice, there is.   .... Yogi Berra



