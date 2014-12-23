From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH 00/24] Clustered MD RAID1
Date: Tue, 23 Dec 2014 16:47:00 -0500
Message-ID: <21657.58068.46803.909368@quad.stoffel.home>
References: <20141218161456.GA29504@shrek.lan>
	<5499A55E.3010705@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5499A55E.3010705@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: neilb@suse.de, lzhong@suse.com, john@stoffel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is much improved, thanks for takign the time to listen to my
comments.  But I do have some questions and clarifications I think you
neeed to make.  


Goldwyn> A howto to use cluster-md:

Goldwyn> 1. With your corosync/pacemaker based cluster with DLM
Goldwyn> running execute: # mdadm --create md0 --bitmap=clustered
Goldwyn> --raid-devices=2 --level=mirror --assume-clean <device1>
Goldwyn> <device2>

What are <device1> and <device2>?  in terms of block devices?  Are
they local?  Shared across the cluster?  Are the iSCSI or FibreChannel
block devices accessible from all nodes at the same time?  It's not
clear, and this is a *key* issue to address and make sure end users
understand.  

Goldwyn> With the option of --bitmap=clustered, it automatically
Goldwyn> creates multiple bitmaps (one for each node). The default
Goldwyn> currently is set to 4 nodes.  However, you can set it by
Goldwyn> --nodes=<number> option.  It also detects the cluster name
Goldwyn> which is required for creating a clustered md. In order to
Goldwyn> specify that, use --cluster-name=<name>

Goldwyn> 2. On other nodes, issue: # mdadm --assemble md0 <device1>
Goldwyn> <device2>

Same comment here, what are the limits/restrictions/expectations of
devices?  

Goldwyn> This md device can be used as a regular shared device. There
Goldwyn> are no restrictions on the type of filesystem or LVM you can
Goldwyn> use, as long as you observe clustering rules of using a
Goldwyn> shared device.

Another place where you need to be more explicit.  For example, if I'm
running ext3, I assume my cluster needs to be running in an
Active/Passive mode, so that only one node is accessing the filesystem
at a time, correct?

But if I'm running glusterfs, I could be using the block device and
the filesystem in an Active/Active mode?  

Goldwyn> There is only one special case as opposed to a regular
Goldwyn> non-clustered md, which is to add a device. This is because
Goldwyn> all nodes should be able to "see" the device before adding
Goldwyn> it.

So this little snipped implies that my question above about device
restrictions is that you MUST be able to see each device from all
nodes, correct?  

Goldwyn> You can (hot) add a spare device by issuing the regular --add
Goldwyn> command.

Goldwyn> # mdadm --manage /dev/md0 --add <device3>

Again, this device needs to be visible to all nodes.  

Goldwyn> The other nodes must acknowledge that they see the device by
Goldwyn> issuing:

Goldwyn> # mdadm --manage /dev/md0 --cluster-confirm 2:<device3>

Goldwyn> where 2 is the raid slot number. This step can be automated
Goldwyn> using a udev script because the module sends a udev event
Goldwyn> when another node issues an --add. The uevent is with the
Goldwyn> usual device name parameters and:

Goldwyn> EVENT=ADD_DEVICE DEVICE_UUID=<uuid of the device>
Goldwyn> RAID_DISK=<slot number>

Goldwyn> Usually, you would use blkid to find the devices uuid and
Goldwyn> issue the --cluster-confirm command.

Goldwyn> If the node does not "see" the device, it must issue (or
Goldwyn> timeout):

Goldwyn> # mdadm --manage /dev/md0 --cluster-confirm 2:missing

This seems wrong, if the other node doesn't see the new device, how
will the other nodes know that it's there or not?  What is the
communication channel between nodes?  Do they use the DLM?  


And what are the performance impacts and benefits of using this setup?
Why not use a cluster aware filesystem which already does RAID in some
manner?  I'm honestly clueless about glusterFS or other Linux based
cluster filesystems, haven't had any need to run them, nor the time to
play with them.

I think you've got a good start now on the documentation, but you need
to expand more on the why and what is expected as an infrastructure.
Just a note that all devices must be visible on all nodes would be a
key thing to include. 

Thanks,
John
