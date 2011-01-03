From: Neil Brown <neilb@suse.de>
Subject: Re: filesystem corruption
Date: Mon, 3 Jan 2011 14:16:03 +1100
Message-ID: <20110103141603.632fdf3e@notabene.brown>
References: <4D212D4A.3040003@feystorm.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D212D4A.3040003@feystorm.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Patrick H." <linux-raid@feystorm.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 02 Jan 2011 18:58:34 -0700 "Patrick H." <linux-raid@feystorm.net>
wrote:

> I've been trying to track down an issue for a while now and from digging 
> around it appears (though not certain) the issue lies with the md raid 
> device.
> Whats happening is that after improperly shutting down a raid-5 array, 
> upon reassembly, a few files on the filesystem will be corrupt. I dont 
> think this is normal filesystem corruption from files being modified 
> during the shut down because some of the files that end up corrupted are 
> several hours old.
> 
> The exact details of what I'm doing:
> I have a 3-node test cluster I'm doing integrity testing on. Each node 
> in the cluster is exporting a couple of disks via ATAoE.
> I have the first disk of all 3 nodes in a raid-1 that is holding the 
> journal data for the ext3 filesystem. The array is running with an 
> internal bitmap as well.
> The second disk of all 3 nodes is a raid-5 array holding the ext3 
> filesystem itself. This is also running with an internal bitmap.
> The ext3 filesystem is mounted with 'data=journal,barrier=1,sync'.
> When I power down the node which is actively running both md raid 
> devices, another node in the cluster takes over and starts both arrays 
> up (in degraded mode of course).
> Once the original node comes back up, the new master re-adds its disks 
> back into the raid arrays and re-syncs them.
> During all this, the filesystem is exported through nfs (nfs also has 
> sync turned on) and a client is randomly creating, removing, and 
> verifying checksums on the files in the filesystem (nfs is hard mounted 
> so operations always retry). The client script averages about 30 
> creations/s, 30 deletes/s, and 30 checksums/s.
> 
> So, as stated above, every now and then (1 in 50 chance or so), when the 
> master is hard-rebooted, the client will detect a few files with invalid 
> md5 checksums. These files could be hours old so they were not being 
> actively modified.
> Another key point that leads me to believe its a md raid issue is that 
> before I had the ext3 journal running internally on the raid-5 array 
> (part of the filesystem itself). When I did this, there would 
> occasionally be massive corruption. As in file modification times in the 
> future, lots of corrupt files, thousands of files put in the 
> 'lost+found' dir upon fsck, etc. After I put it on a separate raid-1, 
> there are no more invalid modification times, there hasnt been a single 
> file added to 'lost+found', and the number of corrupt files dropped 
> significantly. This would seem to indicate that the journal was getting 
> corrupted, and when it was played back, it went horribly wrong.
> 
> So it would seem there's something wrong with the raid-5 array, but I 
> dont know what it could be. Any ideas or input would be much 
> appreciated. I can modify the clustering scripts to obtain whatever 
> information is needed when they start the arrays.

What you are doing cannot work reliably.

If a RAID5 suffers an unclean shutdown and is restarted without a full
complement of devices, then it can corrupt data that has not been changed
recently, just as you are seeing.
This is why mdadm will not assemble that array unless you provide the --force
flag which essentially says "I know what I am doing and accept the risk".

When md needs to update a block in your 3-drive RAID5, it will read the other
block in the same stripe (if that isn't in the cache or being written at the
same time) and then write out the data block (or blocks) and the newly
computed parity block.

If you crash after one of those writes has completed, but before all of the
writes have completed, then the parity block will not match the data blocks
on disk.

When you re-assemble the array with one device missing, md will compute the
data that was on the device using the other data block and the parity block.
As the parity and data blocks could be inconsistent, the result could easily
be wrong.

With RAID1 there is no similar problem.  When you read after a crash you will
always get "correct" data.  It maybe from before the last write that was
attempted, or after, but if the data was not written recently you will read
exactly the right data.

This is why the situation improved substantially when you moved the journal
to RAID1.

The get full improvement, you need to move the data to RAID1 (or RAID10) as
well.

NeilBrown

