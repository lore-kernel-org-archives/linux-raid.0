From: Info@quantum-sci.net
Subject: Re: RAID10 Layouts
Date: Fri, 21 Aug 2009 11:02:58 -0700
Message-ID: <200908211102.58744.Info@quantum-sci.net>
References: <200908210627.06241.Info@quantum-sci.net> <87ljldce33.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ljldce33.fsf@frosties.localdomain>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Thank you Goswin.


On Friday 21 August 2009 09:43:28 Goswin von Brederlow wrote:
> I don't think lilo or grub1 can boot from raid10 at all with offset or
> far copies. With near copies you are identical to a simple raid1 so
> that would boot.
> 
> So to be bootable even with a failed drive you should partition the
> disk. Create a small raid1 for the system and a large raid10 for the
> data.

Uh oh, already set all 3 parts for RAID10, but haven't switched over yet.

As it happens my / is on sda1 and /home is sda3  (swap is sda2), so it'll be pretty easy to just make / RAID1.  Do I need to make swap RAID1 and not 10?

 
> I would stay away from any half baked bios stuff. It will be no better
> than linux software raid but will tie you to the specific bios. If
> your mainboard fails and the next one has a different bios you can't
> boot your disks.

Thank you.

 
> > How does this look:
> > # mdadm --create /dev/md0 --level=raid10 --layout=o2 --metadata=1.2 --chunk=64 --raid-disks=2 missing /dev/sdb1
> 
> On partitions it is save to use 1.1 format. Saves you 4k. Jupey.

4k of what?  One time only, or on every cluster?  Any additional benefit to 1.2?

My system records mpeg4 from DishNetwork satellite (R5000-HD), so it handles mostly files over 1GB.  However its most rigorous duty is scanning those videos for commercials, and marking locations in a mysql database.  The disk light is constantly on and system response is sluggish when this is being done.  I don't understand how an advanced drive like this can be so bogged down, but I hope RAID10 will speed things up.  Maybe there is a way to increase disk cache size?


> You should play with the chunksize though and try with and without
> bitmap and different bitmap sizes. Bitmap costs some write performance
> but it greatly speeds up resyncs after a crash or temporary drive
> failure.

My partitions and data are so enormous that I can't really do any experimenting.  Definitely will use write-intent log.










