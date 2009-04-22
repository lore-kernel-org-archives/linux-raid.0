From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Using linux software raid (mdadm) in a shared-disk cluster.
Date: Wed, 22 Apr 2009 10:54:26 +0200
Message-ID: <87prf5m5kt.fsf@frosties.localdomain>
References: <49E45044.5000406@Calva.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49E45044.5000406@Calva.COM> (John Hughes's message of "Tue, 14
	Apr 2009 10:58:44 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: John Hughes <john@Calva.COM>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Hughes <john@Calva.COM> writes:

> I've got a little shared disk cluster (parallel SCSI, external DELL
> PV210 disk cabinet).
>
> I've used linux raid to make a nice RAID10 on the external disks.
>
> I can access this from either machine in the cluster, only one at a
> time of course, it works very well and I'm happy.
>
> Now I'm running XEN and I want to be able to migrate a XEN domU from
> one machine to the other while the domU is using the RAID10 device.  I
> can make this "work" using XEN's migration hooks - it calls a script
> when it has stopped the running domU and I can start the raid device
> on the destination node, ready for the arrival of the domU.
>
> There is one small problem - I can't stop the RAID10 on the source
> node until the domU has finished, so it seems to me there is a window
> that could lead to data corruption:

Can you put it into read-only mode?

> Source node                             Destination node
>
> mdadm --assemble /dev/md0 ....
> Start migrate
> domU suspended
> call migration script
>               \-------------------->   mdadm --assemble /dev/md0 ...
>                                        domU starts running
> ...
> domU destroyed
> mdadm --stop /dev/md0
>
>
> I seems to me that the source node could still be messing with the
> bitmap and resyncing between the moment the destination node
> starts the RAID10 and the source node stops it[*].
>
> Am I right?  Is there a window?

Certainly.

> If there is a window it could be closed if there was some kind of
> mdadm --freeze command which would stop the sync activity, which could
> be run on the source node before doing the assemble on the destination
> node.

> ([*] - imagine some block is marked unsynced in the bitmap.  The
> destination node does the assemble, so now it's in-memory bitmap has
> the block marked.  The source node syncs the block, updates the on
> disk bitmap.   Now the destination node happens to write that block,
> it thinks the block is marked unsynced on the disk so it doesn't
> bother updating the bitmnap.  If the destination node crashes at this
> point there is a block on the disk that is unsyced, but the bitmap
> claims it's in sync.)

Source node                             Destination node

read block X for sync
                                        Write block X
                                        Write mirror of block X
write mirror of block X

Now block X and its mirror have different content while being marked
in sync.

I'm not even sure putting a raid in read-only mode will stop
background syncing.



As an alternative approach how about running the raid10 inside the
domU?

MfG
        Goswin
