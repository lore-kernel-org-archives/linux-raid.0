From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Unusual RAID 1 recovery problem
Date: Fri, 10 May 2013 20:13:49 +0200
Message-ID: <20130510181349.GA5168@lazy.lzy>
References: <1368207075.17201.49695.camel@amp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1368207075.17201.49695.camel@amp>
Sender: linux-raid-owner@vger.kernel.org
To: John Rowe <J.M.Rowe@exeter.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 10, 2013 at 06:31:15PM +0100, John Rowe wrote:
> Following a system reinstall (an upgrade from Scientific Linux 5.x  to
> to 6.x), I had a RAID1 array that  I could start manually with:
> 
> > mdadm --assemble /dev/md0 /dev/sda4 /dev/sdb4
> 
> but would not start automatically on reboot. SL is a RedHat clone and
> all partitions were of type "fd".
> 
> The above command worked fine and I could see all my data, but every
> time I rebooted the RAID1 array wasn't there.
> 
> Encouraged by the reassuring words of the mdadm man page:
> 
>         --assume-clean
>                       Tell mdadm that the array pre-existed and is known
>         to be clean.  It can be  useful  when trying to recover from a
>         major failure as you can be sure that no data will be affected
>         unless you actually write to the array.
>         
> I tried:
> 
> > mdadm --create -l 1 -n 2 -assume-clean /dev/md0 /dev/sda4 /dev/sdb4

Why oh why?
If assembly works, then the array is good,
likely the problem was in the initramfs or
the like.

> This worked, following the usual warning about how the partitions had
> previously been part of an array. But now:
> 
> > mount -r /md0 /bob
> 
> refuses to do anything even if I try:
> 
> > mount -t ext2 -r /md0 /bob
> 
> I get an error message listing various possibilities such as "bad
> superblock". dmesg tells me it can't find an ext2 file system
> on /dev/md0
> 
> 
> Clearly I had misunderstood the meaning of "you can be sure that no data
> will be affected unless you actually write to the array" but I'm hoping
> there is still a way of accessing this unaffected data.

Actually, you wrote to the array.
Using "create", you wrote a new superblock and, possibly,
a new "data offset".

Problem is that different versions of "mdadm" use different
offset for the data.
So now, likely, it could be your data starting point, were
ext2 should lie, is a bit more far than it was and ext2 is
not found anymore (obviously).

I think probably you can still recover you data, if the
offset could be somehow recovered.

Of course, it could be I'm wrong and something else failed.

bye,

pg

> 
> Thanks.
> 
> John
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

piergiorgio
