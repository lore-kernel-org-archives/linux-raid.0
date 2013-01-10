From: Chris Murphy <lists@colorremedies.com>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Thu, 10 Jan 2013 14:36:57 -0700
Message-ID: <6FD79D70-01A4-4DC9-9494-157773CD0F11@colorremedies.com>
References: <201212212357.19292.thomas@fjellstrom.ca> <201301091141.52238.thomas@fjellstrom.ca> <4A81E770-60DD-4C5F-A341-B449BF2C381F@colorremedies.com> <201301100349.46794.thomas@fjellstrom.ca>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201301100349.46794.thomas@fjellstrom.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 10, 2013, at 3:49 AM, Thomas Fjellstrom <thomas@fjellstrom.ca> wrote:

> A lot of it will be streaming. Some may end up being random read/writes. The 
> test is just to gauge over all performance of the setup. 600MBs read is far 
> more than I need, but having writes at 1/3 that seems odd to me.

Tell us how many disks there are, and what the chunk size is. It could be too small if you have too few disks which results in a small full stripe size for a video context. If you're using the default, it could be too big and you're getting a lot of RWM. Stan, and others, can better answer this.

You said these are unpartitioned disks, I think. In which case alignment of 4096 byte sectors isn't a factor if these are AF disks. 

Unlikely to make up the difference is the scheduler. Parallel fs's like XFS don't perform nearly as well with CFQ, so you should have a kernel parameter elevator=noop. 

Another thing to look at is md/stripe_cache_size which probably needs to be higher for your application.

Another thing to look at is if you're using XFS, what your mount options are. Invariably with an array of this size you need to be mounting with the inode64 option.

> The reason I've selected RAID6 to begin with is I've read (on this mailing 
> list, and on some hardware tech sites) that even with SAS drives, the 
> rebuild/resync time on a large array using large disks (2TB+) is long enough 
> that it gives more than enough time for another disk to hit a random read 
> error,


This is true for high density consumer SATA drives. It's not nearly as applicable for low to moderate density nearline SATA which has an order of magnitude lower UER, or for enterprise SAS (and some enterprise SATA) which has yet another order of magnitude lower UER.  So it depends on the disks, and the RAID size, and the backup/restore strategy.

Another way people get into trouble with the event you're talking about, is they don't do regular scrubs or poll drive SMART data. I have no empirical data, but I'd expect much better than order of magnitude lower array loss during a rebuild when the array is being properly maintained, rather than considering it a push button "it's magic" appliance to be forgotten about.


Chris Murphy