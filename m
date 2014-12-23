From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH 00/24] Clustered MD RAID1
Date: Tue, 23 Dec 2014 11:24:46 -0600
Message-ID: <5499A55E.3010705@suse.de>
References: <20141218161456.GA29504@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141218161456.GA29504@shrek.lan>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: lzhong@suse.com, john@stoffel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Since, I missed on important setup details, I am sending an addendum to 
explain in more detail how to setup a cluster-md.

Requirements
============
You would require a multi-node cluster setup using corosync and
pacemaker. You can read more about how to setup a cluster from the
one of the guides available [3]. Make sure that you are using corosync
version greater than 2.3.1

You need to have the Distributed Lock Manager (DLM) service running on
all the nodes of the cluster. A simple CRM configuration on my virtual
cluster is:

node 1084752262: node3
node 1084752351: node1
node 1084752358: node2
primitive dlm ocf:pacemaker:controld \
         op start interval=0 timeout=90 \
         op stop interval=0 timeout=100 \
         op monitor interval=60 timeout=60
primitive stone stonith:external/libvirt \
         params hostlist="node1,node2,node3"
hypervisor_uri="qemu+tcp://vmhnost/system" \
         op start timeout=120s interval=0 \
         op stop timeout=120s interval=0 \
         op monitor interval=40s timeout=120s \
         meta target-role=Started
group base-group dlm
clone base-clone base-group \
         meta interleave=true target-role=Started

Note: The configuration may be different for your scenario.

This work requires some patches for the mdadm tool [1]. The changes in
mdadm are basic enough to get the clustered-md up and running. There are
a couple of options checks which are missing. Use with care. You would
need the corosync libraries to compile cluster related stuff in mdadm.

Download and install the patched mdadm.

A howto to use cluster-md:

1. With your corosync/pacemaker based cluster with DLM running execute:
# mdadm --create md0 --bitmap=clustered --raid-devices=2 --level=mirror 
--assume-clean <device1> <device2>

With the option of --bitmap=clustered, it automatically creates multiple
bitmaps (one for each node). The default currently is set to 4 nodes.
However, you can set it by --nodes=<number> option.
It also detects the cluster name which is required for creating a
clustered md. In order to specify that, use --cluster-name=<name>

2. On other nodes, issue:
# mdadm --assemble md0 <device1> <device2>

This md device can be used as a regular shared device. There are no
restrictions on the type of filesystem or LVM you can use, as long as
you observe clustering rules of using a shared device.

There is only one special case as opposed to a regular non-clustered md, 
which is to add a device. This is because all nodes should be able to 
"see" the device before adding it.

You can (hot) add a spare device by issuing the regular --add command.

# mdadm --manage /dev/md0 --add <device3>

The other nodes must acknowledge that they see the device by issuing:

# mdadm --manage /dev/md0 --cluster-confirm 2:<device3>

where 2 is the raid slot number. This step can be automated
using a udev script because the module sends a udev event when another
node issues an --add. The uevent is with the usual device name
parameters and:

EVENT=ADD_DEVICE
DEVICE_UUID=<uuid of the device>
RAID_DISK=<slot number>

Usually, you would use blkid to find the devices uuid and issue the
--cluster-confirm command.

If the node does not "see" the device, it must issue (or timeout):

# mdadm --manage /dev/md0 --cluster-confirm 2:missing

References:
[1] mdadm tool changes: https://github.com/goldwynr/mdadm branch:cluster-md
[2] Patches against stable 3.14: https://github.com/goldwynr/linux 
branch: cluster-md-devel
[3] A guide to setup a cluster using corosync/pacemaker
https://www.suse.com/documentation/sle-ha-12/singlehtml/book_sleha/book_sleha.html 
(Note: The basic concepts of this guide should work with any distro)





-- 
-- 
Goldwyn
