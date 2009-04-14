From: John Hughes <john@Calva.COM>
Subject: Using linux software raid (mdadm) in a shared-disk cluster.
Date: Tue, 14 Apr 2009 10:58:44 +0200
Message-ID: <49E45044.5000406@Calva.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've got a little shared disk cluster (parallel SCSI, external DELL 
PV210 disk cabinet).

I've used linux raid to make a nice RAID10 on the external disks.

I can access this from either machine in the cluster, only one at a time 
of course, it works very well and I'm happy.

Now I'm running XEN and I want to be able to migrate a XEN domU from one 
machine to the other while the domU is using the RAID10 device.  I can 
make this "work" using XEN's migration hooks - it calls a script when it 
has stopped the running domU and I can start the raid device on the 
destination node, ready for the arrival of the domU.

There is one small problem - I can't stop the RAID10 on the source node 
until the domU has finished, so it seems to me there is a window that 
could lead to data corruption:

Source node                             Destination node

mdadm --assemble /dev/md0 ....
Start migrate
domU suspended
call migration script
               \-------------------->   mdadm --assemble /dev/md0 ...
                                        domU starts running
...
domU destroyed
mdadm --stop /dev/md0


I seems to me that the source node could still be messing with the 
bitmap and resyncing between the moment the destination node
starts the RAID10 and the source node stops it[*].

Am I right?  Is there a window?

If there is a window it could be closed if there was some kind of mdadm 
--freeze command which would stop the sync activity, which could be run 
on the source node before doing the assemble on the destination node.

([*] - imagine some block is marked unsynced in the bitmap.  The 
destination node does the assemble, so now it's in-memory bitmap has the 
block marked.  The source node syncs the block, updates the on disk 
bitmap.   Now the destination node happens to write that block,  it 
thinks the block is marked unsynced on the disk so it doesn't bother 
updating the bitmnap.  If the destination node crashes at this point 
there is a block on the disk that is unsyced, but the bitmap claims it's 
in sync.)

