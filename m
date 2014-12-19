From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH 01/24] md-cluster: Design Documentation
Date: Fri, 19 Dec 2014 16:38:14 -0600
Message-ID: <5494A8D6.3090702@suse.de>
References: <20141218161510.GA29543@shrek.lan> <21652.18047.978617.730122@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21652.18047.978617.730122@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: neilb@suse.de, lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi John,

Thanks for the review.

On 12/19/2014 09:38 AM, John Stoffel wrote:
>>>>>> "Goldwyn" == Goldwyn Rodrigues <rgoldwyn@suse.de> writes:
>
> This is an interesting concept, but I think you're glossing over the
> details here way too much.  You're so close to the trees, that you're
> missing the forest.   You need to spell out the requirements in terms
> of software, configuration, etc ahead of time.
>
> Showing how people can configure this for testing would be good as
> well.  Right now though, I wouldn't touch this with a ten foot pole.

I mentioned a quick howto in patch zero. However, putting it in the 
design document will not hurt. Currently, it is known to work with 
corosync 2.3.x and pacemaker 1.1 on Kernels 3.14.x

>
> Goldwyn> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Goldwyn> ---
> Goldwyn>  Documentation/md-cluster.txt | 178 +++++++++++++++++++++++++++++++++++++++++++
> Goldwyn>  1 file changed, 178 insertions(+)
> Goldwyn>  create mode 100644 Documentation/md-cluster.txt
>
> Goldwyn> diff --git a/Documentation/md-cluster.txt b/Documentation/md-cluster.txt
> Goldwyn> new file mode 100644
> Goldwyn> index 0000000..038d0f0
> Goldwyn> --- /dev/null
> Goldwyn> +++ b/Documentation/md-cluster.txt
> Goldwyn> @@ -0,0 +1,178 @@
> Goldwyn> +The cluster MD is a shared-device RAID for a cluster.
>
>
> How is this cluster setup?  What are the restrictions?  You just
> straight into the ondisk format, without any introduction to the
> problem and how you solve it.

The cluster is a regular corosync/pacemaker cluster with DLM setup. I 
mentioned this in patch zero as well. However, I assumed configuring a 
cluster is not in the scope of the design document. This is the design 
of cluster-md. I agree it could use a foreword though.

>
> Goldwyn> +
> Goldwyn> +
> Goldwyn> +1. On-disk format
> Goldwyn> +
> Goldwyn> +Separate write-intent-bitmap are used for each cluster node.
> Goldwyn> +The bitmaps record all writes that may have been started on that node,
> Goldwyn> +and may not yet have finished. The on-disk layout is:
> Goldwyn> +
> Goldwyn> +0                    4k                     8k                    12k
> Goldwyn> +-------------------------------------------------------------------
> Goldwyn> +| idle                | md super            | bm super [0] + bits |
> Goldwyn> +| bm bits[0, contd]   | bm super[1] + bits  | bm bits[1, contd]   |
> Goldwyn> +| bm super[2] + bits  | bm bits [2, contd]  | bm super[3] + bits  |
> Goldwyn> +| bm bits [3, contd]  |                     |                     |
> Goldwyn> +
> Goldwyn> +During "normal" functioning we assume the filesystem ensures that only one
> Goldwyn> +node writes to any given block at a time, so a write
> Goldwyn> +request will
> Goldwyn> + - set the appropriate bit (if not already set)
> Goldwyn> + - commit the write to all mirrors
> Goldwyn> + - schedule the bit to be cleared after a timeout.
> Goldwyn> +
> Goldwyn> +Reads are just handled normally.  It is up to the filesystem to
> Goldwyn> +ensure one node doesn't read from a location where another node (or the same
> Goldwyn> +node) is writing.
>
>
> GAH!  So what filesystem(s) are supported and known to work?  Why this
> this information not in the introduction?  You just toss off this
> statement without any context.

The point here is data integrity is the responsibility of the 
filesystem. The cluster-md just ensures that all it has confirmed as 
written is stable and mirrored (RAID1). As for filesystem support, all 
device based filesystems are supported. However, we are targeting 
cluster based filesystems such as ocfs2. Yes, it could be moved in the 
Introduction.


>
> And you also seem to imply that I can't just put LVM volumes ontop of
> this mirror either, which to me is a huge layering violation.  If I'm

No, I am not implying LVM cannot be used. LVM can be used in conjunction 
with cluster-md.

> using MD to build RAID1 devices, I don't care how MD handles
> reads/writes being out of sync.  My filesystem or volumes on top get
> consistent storage without having to know anything special.

If you are reading the design document of cluster-md. I think you should 
be concerned on how out of sync data is handled in order to understand 
the design better. Filesystem just treat this as a normal block device 
and do not need to know anything special.

>
>
> Goldwyn> +2. DLM Locks for management
> Goldwyn> +
> Goldwyn> +There are two locks for managing the device:
> Goldwyn> +
> Goldwyn> +2.1 Bitmap lock resource (bm_lockres)
> Goldwyn> +
> Goldwyn> + The bm_lockres protects individual node bitmaps. They are named in the
> Goldwyn> + form bitmap001 for node 1, bitmap002 for node and so on. When a node
> Goldwyn> + joins the cluster, it acquires the lock in PW mode and it stays so
>
> PW is what?  Make sure you expand all your acronyms the first time you
> use them so we can confirm we all understand them please.

PW is Protected Write. I will add that.

>
> Goldwyn> + during the lifetime the node is part of the cluster. The lock resource
> Goldwyn> + number is based on the slot number returned by the DLM subsystem. Since
> Goldwyn> + DLM starts node count from one and bitmap slots start from zero, one is
> Goldwyn> + subtracted from the DLM slot number to arrive at the bitmap slot number.
>
> Why do you bother?  Why not just make the bitmap slots start at 1 and
> reserve zero for a special case?  Say that the bitmap is setup but not
> initialized?

What would that special case be? The bitmap setup is not a two-step 
process. If it is setup, it is also initialized.

>
> Goldwyn> +
> Goldwyn> +3. Communication
> Goldwyn> +
> Goldwyn> +Each node has to communicate with other nodes when starting or ending
> Goldwyn> +resync, and metadata superblock updates.
>
> HOW!!!!  Does this all depend on DRDB being installed?  Or some other
> HA software?

DLM. Mentioned later in the design. Yes, I will add that as well.

>
> Goldwyn> +
> Goldwyn> +3.1 Message Types
> Goldwyn> +
> Goldwyn> + There are 3 types, of messages which are passed
> Goldwyn> +
> Goldwyn> + 3.1.1 METADATA_UPDATED: informs other nodes that the metadata has been
> Goldwyn> +   updated, and the node must re-read the md superblock. This is performed
> Goldwyn> +   synchronously.
> Goldwyn> +
> Goldwyn> + 3.1.2 RESYNC: informs other nodes that a resync is initiated or ended
> Goldwyn> +   so that each node may suspend or resume the region.
> Goldwyn> +
> Goldwyn> +3.2 Communication mechanism
> Goldwyn> +
> Goldwyn> + The DLM LVB is used to communicate within nodes of the cluster. There
> Goldwyn> + are three resources used for the purpose:
> Goldwyn> +
> Goldwyn> +  3.2.1 Token: The resource which protects the entire communication
> Goldwyn> +   system. The node having the token resource is allowed to
> Goldwyn> +   communicate.
> Goldwyn> +
> Goldwyn> +  3.2.2 Message: The lock resource which carries the data to
> Goldwyn> +   communicate.
> Goldwyn> +
> Goldwyn> +  3.2.3 Ack: The resource, acquiring which means the message has been
> Goldwyn> +   acknowledged by all nodes in the cluster. The BAST of the resource
> Goldwyn> +   is used to inform the receive node that a node wants to communicate.
> Goldwyn> +
> Goldwyn> +The algorithm is:
> Goldwyn> +
> Goldwyn> + 1. receive status
> Goldwyn> +
> Goldwyn> +   sender                         receiver                   receiver
> Goldwyn> +   ACK:CR                          ACK:CR                     ACK:CR
> Goldwyn> +
> Goldwyn> + 2. sender get EX of TOKEN
> Goldwyn> +    sender get EX of MESSAGE
> Goldwyn> +    sender                        receiver                 receiver
> Goldwyn> +    TOKEN:EX                       ACK:CR                   ACK:CR
> Goldwyn> +    MESSAGE:EX
> Goldwyn> +    ACK:CR
> Goldwyn> +
> Goldwyn> +    Sender checks that it still needs to send a message. Messages received
> Goldwyn> +    or other events that happened while waiting for the TOKEN may have made
> Goldwyn> +    this message inappropriate or redundant.
> Goldwyn> +
> Goldwyn> + 3. sender write LVB.
> Goldwyn> +    sender down-convert MESSAGE from EX to CR
> Goldwyn> +    sender try to get EX of ACK
> Goldwyn> +    [ wait until all receiver has *processed* the MESSAGE ]
> Goldwyn> +
> Goldwyn> +                                     [ triggered by bast of ACK ]
> Goldwyn> +                                     receiver get CR of MESSAGE
> Goldwyn> +                                     receiver read LVB
> Goldwyn> +                                     receiver processes the message
> Goldwyn> +                                     [ wait finish ]
> Goldwyn> +                                     receiver release ACK
> Goldwyn> +
> Goldwyn> +   sender                         receiver                   receiver
> Goldwyn> +   TOKEN:EX                       MESSAGE:CR                 MESSAGE:CR
> Goldwyn> +   MESSAGE:CR
> Goldwyn> +   ACK:EX
> Goldwyn> +
> Goldwyn> + 4. triggered by grant of EX on ACK (indicating all receivers have processed
> Goldwyn> +    message)
> Goldwyn> +    sender down-convert ACK from EX to CR
> Goldwyn> +    sender release MESSAGE
> Goldwyn> +    sender release TOKEN
> Goldwyn> +                               receiver upconvert to EX of MESSAGE
> Goldwyn> +                               receiver get CR of ACK
> Goldwyn> +                               receiver release MESSAGE
> Goldwyn> +
> Goldwyn> +   sender                      receiver                   receiver
> Goldwyn> +   ACK:CR                       ACK:CR                     ACK:CR
> Goldwyn> +
> Goldwyn> +
> Goldwyn> +4. Handling Failures
> Goldwyn> +
> Goldwyn> +4.1 Node Failure
> Goldwyn> + When a node fails, the DLM informs the cluster with the slot. The node
>
> This needs to be re-worded.  The cluster is the entire group of
> machines, I think you mean:
>
>    The DLM informs the node with the slot.

Correct.

>
> And is a node failure as simple as a reboot?  How about if the entire
> cluster crashes, how to do you know which node is the more upto date
> and should be the master?

There is not concept of master here since everything is distributed. We 
do not want a central dependency. A node failure is it's inability to 
respond. It is usually STONITHd (Shoot the Other node in the Head) by 
the cluster resource management.

The concept of bitmap is that data needs to be synced (that what I had 
been trying to explain in the point where you mentioned about 
filesystem). In case of a cluster failure, The first node to come up 
performs the "bitmap recovery" for all the bitmaps.


>
> Goldwyn> + starts a cluster recovery thread. The cluster recovery thread:
> Goldwyn> +	- acquires the bitmap<number> lock of the failed node
> Goldwyn> +	- opens the bitmap
> Goldwyn> +	- reads the bitmap of the failed node
> Goldwyn> +	- copies the set bitmap to local node
> Goldwyn> +	- cleans the bitmap of the failed node
> Goldwyn> +	- releases bitmap<number> lock of the failed node
> Goldwyn> +	- initiates resync of the bitmap on the current node
> Goldwyn> +
> Goldwyn> + The resync process, is the regular md resync. However, in a clustered
> Goldwyn> + environment when a resync is performed, it needs to tell other nodes
> Goldwyn> + of the areas which are suspended. Before a resync starts, the node
> Goldwyn> + send out RESYNC_START with the (lo,hi) range of the area which needs
> Goldwyn> + to be suspended. Each node maintains a suspend_list, which contains
> Goldwyn> + the list  of ranges which are currently suspended. On receiving
> Goldwyn> + RESYNC_START, the node adds the range to the suspend_list. Similarly,
> Goldwyn> + when the node performing resync finishes, it send RESYNC_FINISHED
> Goldwyn> + to other nodes and other nodes remove the corresponding entry from
> Goldwyn> + the suspend_list.
> Goldwyn> +
> Goldwyn> + A helper function, should_suspend() can be used to check if a particular
> Goldwyn> + I/O range should be suspended or not.
> Goldwyn> +
> Goldwyn> +4.2 Device Failure
> Goldwyn> + Device failures are handled and communicated with the metadata update
> Goldwyn> + routine.
> Goldwyn> +
> Goldwyn> +5. Adding a new Device
> Goldwyn> +For adding a new device, it is necessary that all nodes "see" the new device
> Goldwyn> +to be added. For this, the following algorithm is used:
> Goldwyn> +
> Goldwyn> +    1. Node 1 issues mdadm --manage /dev/mdX --add /dev/sdYY which issues
> Goldwyn> +       ioctl(ADD_NEW_DISC with disc.state set to MD_DISK_CLUSTER_ADD)
> Goldwyn> +    2. Node 1 sends NEWDISK with uuid and slot number
> Goldwyn> +    3. Other nodes issue kobject_uevent_env with uuid and slot number
> Goldwyn> +       (Steps 4,5 could be a udev rule)
> Goldwyn> +    4. In userspace, the node searches for the disk, perhaps
> Goldwyn> +       using blkid -t SUB_UUID=""
> Goldwyn> +    5. Other nodes issue either of the following depending on whether the disk
> Goldwyn> +       was found:
> Goldwyn> +       ioctl(ADD_NEW_DISK with disc.state set to MD_DISK_CANDIDATE and
> Goldwyn> +                disc.number set to slot number)
> Goldwyn> +       ioctl(CLUSTERED_DISK_NACK)
> Goldwyn> +    6. Other nodes drop lock on no-new-devs (CR) if device is found
> Goldwyn> +    7. Node 1 attempts EX lock on no-new-devs
> Goldwyn> +    8. If node 1 gets the lock, it sends METADATA_UPDATED after unmarking the disk
> Goldwyn> +       as SpareLocal
> Goldwyn> +    9. If not (get no-new-dev lock), it fails the operation and sends METADATA_UPDATED
> Goldwyn> +    10. Other nodes get the information whether a disk is added or not
> Goldwyn> +	by the following METADATA_UPDATED.
> Goldwyn> +
> Goldwyn> +
> Goldwyn> --
> Goldwyn> 2.1.2
>

-- 
Goldwyn
