From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: Creating partitionable raid on existing disk (was: Re: Partitioned raid and major number)
Date: Tue, 9 Mar 2004 16:32:23 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040309153223.GI3084@traveler.cistron.net>
References: <20040225145624.GA1513@cistron.nl> <16445.12026.812778.621025@notabene.cse.unsw.edu.au> <20040226215144.GC11831@drinkel.cistron.nl> <16446.36226.591283.495194@notabene.cse.unsw.edu.au> <16446.39583.968782.41221@notabene.cse.unsw.edu.au> <20040227165614.GO23988@traveler.cistron.net> <16450.32963.829675.526061@notabene.cse.unsw.edu.au> <20040301004256.GI14194@drinkel.cistron.nl> <16450.36145.988988.684449@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16450.36145.988988.684449@notabene.cse.unsw.edu.au> (from neilb@cse.unsw.edu.au on Mon, Mar 01, 2004 at 02:09:05 +0100)
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Miquel van Smoorenburg <miquels@cistron.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2004.03.01 02:09, Neil Brown wrote:
> On Monday March 1, miquels@cistron.nl wrote:
> > 
> > What do you think of that approach ? Converting from a 1 disk setup
> > to a 2-disk RAID1 setup on an existing system is something that lots
> > of people want to do, seeing that the software raid howto even has
> > a few paragraphs dedicated to it.
> 
> What I am thinking of doing is allowing:
> 
>    md=0,1,/dev/sda
> 
> to assemble a raid1 array without a superblock which uses just
> /dev/sda.
> Then
> 
>    md=d0,1,/dev/sda root=/dev/md_d0p1
> 
> would boot off md/d0p1 instead of sda1, but it would be the same data.
> 
> Then you would be able to add mirrors to this with something like:
> 
>   mdadm --grow /dev/md/d0 --disks=2
>   mdadm /dev/md/d0 --add /dev/sdb
> 
> and you could convert it into an array with a persistent superblock
> using:
>    mdadm --grow /dev/md/d0 --persistent=yes
> 
> The only difficult bit is the setting a persistent superblock means
> reducing the size of the device, and I would like it to be hard to do
> that in error, but not impossible to do it.

Any progress on this?

The right thing to do would probably be to check if the device actually has
partitions - refuse to reduce the size of the device if it doesn't have
any partitions, or if any partition overlaps with the MD superblock.
That should be easy enough I think.

But it would take changes in both userlevel tools (add --grow to mdadm) and
the kernel, right ? So in the short run, I'll be better off by booting a
Knoppix CD and running mdadm from there, I suppose.

Are you interested in the patch I made to be able to initialize (but not run!)
an array on a disk that is otherwise busy (i.e. can't be bd_claim()ed) ?
Basically it just adds a SET_ARRAY_INFO_CONFONLY ioctl. I have patches for
both the kernel and mkraid, and they're pretty simple.

Mike.
