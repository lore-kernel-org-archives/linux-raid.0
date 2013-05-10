From: Tregaron Bayly <tbayly@bluehost.com>
Subject: Re: Unusual RAID 1 recovery problem
Date: Fri, 10 May 2013 13:23:30 -0600
Message-ID: <1368213810.10126.35.camel@148>
References: <1368207075.17201.49695.camel@amp>
	 <20130510181349.GA5168@lazy.lzy>
Reply-To: tbayly@bluehost.com
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130510181349.GA5168@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: John Rowe <J.M.Rowe@exeter.ac.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2013-05-10 at 20:13 +0200, Piergiorgio Sartor wrote:
> > This worked, following the usual warning about how the partitions had
> > previously been part of an array. But now:
> > 
> > > mount -r /md0 /bob
> > 
> > refuses to do anything even if I try:
> > 
> > > mount -t ext2 -r /md0 /bob
> > 
> > I get an error message listing various possibilities such as "bad
> > superblock". dmesg tells me it can't find an ext2 file system
> > on /dev/md0
> > 
> > 
> > Clearly I had misunderstood the meaning of "you can be sure that no data
> > will be affected unless you actually write to the array" but I'm hoping
> > there is still a way of accessing this unaffected data.
> 
> Actually, you wrote to the array.
> Using "create", you wrote a new superblock and, possibly,
> a new "data offset".
> 
> Problem is that different versions of "mdadm" use different
> offset for the data.
> So now, likely, it could be your data starting point, were
> ext2 should lie, is a bit more far than it was and ext2 is
> not found anymore (obviously).
> 
> I think probably you can still recover you data, if the
> offset could be somehow recovered.

You are probably correct here.  The good news is that the filesystem is
still likely intact if you haven't done any operations on the new md0
device and you didn't choose a different raid metadata version when you
recreated it.  

Your best solution is to figure out which version of mdadm was used to
create this array originally and do your create again with that version.
If you don't know what version was used or you can't get hold of it then
you're going to have to figure out the true offset of the data.  This is
most easily accomplished by finding an old mdadm -E output from this
array.  If you don't have that you're going to have to go hunting on one
of your disks looking for a 0x55 0xaa boot signature that could indicate
an MBR.  Armed with the offset information you can either get the
development version of mdadm which Phil Turmel indicates has a
--data-offset option and create again or setup a loop device with that
offset on sda4 or sdb4 and mount it to get your data off to a new
device.

Good Luck,

Tregaron

