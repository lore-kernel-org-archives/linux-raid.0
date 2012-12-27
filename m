From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: possibly silly configuration question
Date: Thu, 27 Dec 2012 15:43:17 +1100
Message-ID: <50DBD1E5.8000206@websitemanagers.com.au>
References: <50DBCB88.5070408@meetinghouse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50DBCB88.5070408@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: Miles Fidelman <mfidelman@meetinghouse.net>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 27/12/12 15:16, Miles Fidelman wrote:
> Hi Folks,
>
> I find myself having four servers, each with 4 large disks, that I'm
> trying to assemble into a high-availability cluster.  (Note: I've got
> 4 gigE ports on each box, 2 set aside for outside access, 2 for
> inter-node clustering)
>
> Now it's easy enough to RAID disks on each server, and/or mirror disks
> pair-wise with DRBD, but DRBD doesn't work as well with >2 servers.
>
> No what I really should do is separate storage nodes from compute
> nodes - but I'm limited by rack space and chassis configuration of the
> hardware I've got, and I've been thinking through various
> configurations to make use of the resources at hand.
>
> One option is to put all the drives into one large pool managed by
> gluster - but I expect that would result in some serious performance
> hits (and gluster's replicated/distributed mode is fairly new).
>
> It's late at night and a thought occurred to me that is probably
> wrongheaded (or at least silly) - but maybe I'm too tired to see any
> obvious problems.  So I'd welcome 2nd (and 3rd) opinions.
>
> The basic notion:
> - mount all 16 drives as network block devices via iSCSI or AoE
> - build 4 RAID10 volumes - each volume consisting of one drive from
> each server
> - run LVM on top of the RAID volumes
> - then use NFS or maybe OCFS2 to make volumes available across nodes
> - of course md would be running on only one node (for each array), so
> if a node goes down, use pacemaker to startup md on another node,
> reassemble the array, and remount everything
>
> Does this make sense, or is it totally crazy?
>
Not entirely crazy... but, how about another option:
On each node:
1) Partition each drive into two halves
2) Create two RAID arrays using each half of the 4 drives (ie, sd[abcd]1
in one RAID and sd[abcd]2 in the second RAID)
3) Create 4 x DRBD volumes where
drbd0 uses server1_raid1 and server2_raid1
drbd1 uses server2_raid2 and server3_raid2
drbd2 uses server3_raid1 and server4_raid1
drbd3 uses server4_raid2 and server1_raid2

Now you can run iscsi on all servers, where each server will export one
DRBD device:
iscsi server1 drbd0
iscsi server2 drbd1
iscsi server3 drbd2
iscsi server4 drbd3

If a server goes down, you need to use pacemaker to start iscsi (and
steal the virtual IP) on the "partner" server.
In this way, you can lose any one server, or you can lose two servers
(if they are the right two).

You could adjust this further to have a third drbd host, and reduce the
total number of iscsi exported devices to 3.

Each VM config would use the specific virtual IP/iSCSI exported location.

Maybe that will provide some ideas.... It is slightly better than two
storage + two working nodes, and gives the added reliability of
potentially losing two servers without losing any services....

PS, I'd probably put LVM2 on top of each drbd device, to divide the
storage for each VM, and export each VM over iscsi individually.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au

