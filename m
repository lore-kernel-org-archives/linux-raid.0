From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: Degraded raid5 returns mdadm: /dev/hdc5 has no superblock - assembly aborted
Date: Fri, 8 Jul 2005 10:43:46 +0200
Message-ID: <62b0912f05070801436421ea0e@mail.gmail.com>
References: <42CDE44C.9020804@phys.unsw.edu.au>
	 <874qb6m0fr.fsf@enki.rimspace.net>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <874qb6m0fr.fsf@enki.rimspace.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: melinda@phys.unsw.edu.au
List-Id: linux-raid.ids

> On 8 Jul 2005, Melinda Taylor wrote:
> > We have a computer based at the South Pole which has a degraded raid 5
> > array across 4 disks. One of the 4 HDD's mechanically failed but we have
> > bought the majority of the system back online except for the raid5
> > array. I am pretty sure that data on the remaining 3 partitions that
> > made up the raid5 array is intact - just confused. The reason I know
> > this is that just before we took the system down, the raid5 array
> > (mounted as /home) was still readable and writable even though
> > /proc/mdstat said:

On 7/8/05, Daniel Pittman wrote:
> What you want to do is start the array as degraded, using *only* the
> devices that were part of the disk set.  Substitute 'missing' for the
> last device if needed but, IIRC, you should be able to say just:
> 
> ] mdadm --assemble --force /dev/md2 /dev/hd[abd]5
> 
> Don't forget to fsck the filesystem thoroughly at this point. :)

At this point, before adding the new disk, I'd suggest making *very*
sure that the event counters match on the three existing disks. 
Because if they don't, MD will add the new disk with an event counter
matching the freshest disk in the array.  That will cause it to start
synchronizing onto one of the good disks instead of onto the newly
added disk....  Happened to me once, gah.

> Once the array is up and running, you *then* add the new disk to it by
> saying:
> 
> ] mdadm -a /dev/md2 /dev/hdc5
> 
> The array will then recover and, hopefully, life is good.
