From: "Patrick H." <linux-raid@feystorm.net>
Subject: filesystem corruption
Date: Sun, 02 Jan 2011 18:58:34 -0700
Message-ID: <4D212D4A.3040003@feystorm.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been trying to track down an issue for a while now and from digging 
around it appears (though not certain) the issue lies with the md raid 
device.
Whats happening is that after improperly shutting down a raid-5 array, 
upon reassembly, a few files on the filesystem will be corrupt. I dont 
think this is normal filesystem corruption from files being modified 
during the shut down because some of the files that end up corrupted are 
several hours old.

The exact details of what I'm doing:
I have a 3-node test cluster I'm doing integrity testing on. Each node 
in the cluster is exporting a couple of disks via ATAoE.
I have the first disk of all 3 nodes in a raid-1 that is holding the 
journal data for the ext3 filesystem. The array is running with an 
internal bitmap as well.
The second disk of all 3 nodes is a raid-5 array holding the ext3 
filesystem itself. This is also running with an internal bitmap.
The ext3 filesystem is mounted with 'data=journal,barrier=1,sync'.
When I power down the node which is actively running both md raid 
devices, another node in the cluster takes over and starts both arrays 
up (in degraded mode of course).
Once the original node comes back up, the new master re-adds its disks 
back into the raid arrays and re-syncs them.
During all this, the filesystem is exported through nfs (nfs also has 
sync turned on) and a client is randomly creating, removing, and 
verifying checksums on the files in the filesystem (nfs is hard mounted 
so operations always retry). The client script averages about 30 
creations/s, 30 deletes/s, and 30 checksums/s.

So, as stated above, every now and then (1 in 50 chance or so), when the 
master is hard-rebooted, the client will detect a few files with invalid 
md5 checksums. These files could be hours old so they were not being 
actively modified.
Another key point that leads me to believe its a md raid issue is that 
before I had the ext3 journal running internally on the raid-5 array 
(part of the filesystem itself). When I did this, there would 
occasionally be massive corruption. As in file modification times in the 
future, lots of corrupt files, thousands of files put in the 
'lost+found' dir upon fsck, etc. After I put it on a separate raid-1, 
there are no more invalid modification times, there hasnt been a single 
file added to 'lost+found', and the number of corrupt files dropped 
significantly. This would seem to indicate that the journal was getting 
corrupted, and when it was played back, it went horribly wrong.

So it would seem there's something wrong with the raid-5 array, but I 
dont know what it could be. Any ideas or input would be much 
appreciated. I can modify the clustering scripts to obtain whatever 
information is needed when they start the arrays.

-Patrick
