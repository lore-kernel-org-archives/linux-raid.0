From: viro@parcelfarce.linux.theplanet.co.uk
Subject: Re: [RFCI] How best to partition MD/raid devices in 2.6
Date: Fri, 14 Nov 2003 06:10:45 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031114061045.GJ24159@parcelfarce.linux.theplanet.co.uk>
References: <16308.18387.142415.469027@notabene.cse.unsw.edu.au> <87smkrecyw.fsf@enki.rimspace.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87smkrecyw.fsf@enki.rimspace.net>
To: Daniel Pittman <daniel@rimspace.net>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Nov 14, 2003 at 04:27:51PM +1100, Daniel Pittman wrote:
> How about assigning the partition space above 
> 
>   9,0 => md0
>   9,1 => md1
>   ...
>   9,257 => md0p1
>   9,258 => md0p2
>   ...
>   9,320 => md1p1
> 
> That should be sensibly backward compatible, I think, and still allow
> all the MD devices to be partitioned.

Kernel should be mostly OK with partitions having device numbers far from
that of entire disk.  However, mostly != entirely and I can't tell right
now what amount of work would that take.  One obvious problem is boot-time
stuff - code parses root= and its ilk does so by digging in sysfs and that
definitely will need changes.  There might be more.  I'm more or less sure
than all common codepaths are clean and will be OK with having probe do
whatever it wants, but I wouldn't bet a dime on the ioctl side/procfs/sysfs/
devfs.

I would *really* expect breakage in userland, though, and that might be a
killer.  Up until now, we had all partitions getting device numbers in a range
that included entire disk and did not include any device numbers of anything
unrelated.

Folks, we are in 2.6.0-test freeze.  Neil's #3 fits entirely in md.c, is small
and has minimal damage potential for userland code.  Playing games with the
scheme above, nice as it might be, is *not* safe for now and it's not even
safe for 2.6.early.
