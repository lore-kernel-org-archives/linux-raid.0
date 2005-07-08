From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Degraded raid5 returns mdadm: /dev/hdc5 has no superblock - assembly aborted
Date: Fri, 8 Jul 2005 21:24:00 +1000
Message-ID: <17102.25168.888298.566858@cse.unsw.edu.au>
References: <42CDE44C.9020804@phys.unsw.edu.au>
	<874qb6m0fr.fsf@enki.rimspace.net>
	<62b0912f05070801436421ea0e@mail.gmail.com>
	<87oe9dlkc2.fsf@enki.rimspace.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Daniel Pittman on Friday July 8
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Pittman <daniel@rimspace.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday July 8, daniel@rimspace.net wrote:
> On 8 Jul 2005, Molle Bestefich wrote:
> >> On 8 Jul 2005, Melinda Taylor wrote:
> >>> We have a computer based at the South Pole which has a degraded raid 5
> >>> array across 4 disks. One of the 4 HDD's mechanically failed but we have
> >>> bought the majority of the system back online except for the raid5
> >>> array. I am pretty sure that data on the remaining 3 partitions that
> >>> made up the raid5 array is intact - just confused. The reason I know
> >>> this is that just before we took the system down, the raid5 array
> >>> (mounted as /home) was still readable and writable even though
> >>> /proc/mdstat said:
> >
> > On 7/8/05, Daniel Pittman wrote:
> >> What you want to do is start the array as degraded, using *only* the
> >> devices that were part of the disk set.  Substitute 'missing' for the
> >> last device if needed but, IIRC, you should be able to say just:
> >>
> >> ] mdadm --assemble --force /dev/md2 /dev/hd[abd]5
> >>
> >> Don't forget to fsck the filesystem thoroughly at this point. :)
> >
> > At this point, before adding the new disk, I'd suggest making *very*
> > sure that the event counters match on the three existing disks. 
> > Because if they don't, MD will add the new disk with an event counter
> > matching the freshest disk in the array.  That will cause it to start
> > synchronizing onto one of the good disks instead of onto the newly
> > added disk....  Happened to me once, gah.
> 
> Ack!  I didn't know that.  If the event counters don't match up, what
> can you do to correct the problem?  

The "--assemble --force" should result in all the event counters of
the named drives being the same.  Then it should be perfectly safe the
add the new drive.

I cannot quite imagine a situation as described by Molle.  If it was
at all reproducible I'd love to hear more details.

NeilBrown
