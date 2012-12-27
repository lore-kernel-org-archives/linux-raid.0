From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: possibly silly configuration question
Date: Wed, 26 Dec 2012 23:16:08 -0500
Message-ID: <50DBCB88.5070408@meetinghouse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Folks,

I find myself having four servers, each with 4 large disks, that I'm 
trying to assemble into a high-availability cluster.  (Note: I've got 4 
gigE ports on each box, 2 set aside for outside access, 2 for inter-node 
clustering)

Now it's easy enough to RAID disks on each server, and/or mirror disks 
pair-wise with DRBD, but DRBD doesn't work as well with >2 servers.

No what I really should do is separate storage nodes from compute nodes 
- but I'm limited by rack space and chassis configuration of the 
hardware I've got, and I've been thinking through various configurations 
to make use of the resources at hand.

One option is to put all the drives into one large pool managed by 
gluster - but I expect that would result in some serious performance 
hits (and gluster's replicated/distributed mode is fairly new).

It's late at night and a thought occurred to me that is probably 
wrongheaded (or at least silly) - but maybe I'm too tired to see any 
obvious problems.  So I'd welcome 2nd (and 3rd) opinions.

The basic notion:
- mount all 16 drives as network block devices via iSCSI or AoE
- build 4 RAID10 volumes - each volume consisting of one drive from each 
server
- run LVM on top of the RAID volumes
- then use NFS or maybe OCFS2 to make volumes available across nodes
- of course md would be running on only one node (for each array), so if 
a node goes down, use pacemaker to startup md on another node, 
reassemble the array, and remount everything

Does this make sense, or is it totally crazy?

Thanks much,

Miles Fidelman

-- 
In theory, there is no difference between theory and practice.
In practice, there is.   .... Yogi Berra

