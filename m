From: "Andrew Herdman" <andrew@whine.com>
Subject: Re: RAID1: Disks alternating on reads
Date: Mon, 22 Sep 2003 12:23:00 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <01ca01c38125$cab15c20$0180a8c0@what>
References: <014b01c38053$0358ad90$0180a8c0@what> <news2mail-bkmfvp$a7u$1@cartman.spoiled.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Juri;

Thanks for your reply, some comments inline below.

----- Original Message ----- 
From: "Juri Haberland" <list-linux.raid@spoiled.org>
To: <linux-raid@vger.kernel.org>
Sent: Monday, September 22, 2003 5:39 AM
Subject: Re: RAID1: Disks alternating on reads


> "Andrew Herdman" <andrew@whine.com> wrote:
> > Pardon me if my assumption was incorrect, but I was under the belief
that
> > when using software RAID1, that when reads occurred on the RAID device
that
> > it would read from both drives in a striped fashion similar to how RAID0
> > works to improve the speed of the md devices.   I am actually seeing
this,
> > but it appears that the reads on each drive are continuing for 10 to 20
> > seconds before moving onto the next drive and then another 10-20 seconds
and
> > back again.  This is not allowing for any performance increase, it just
lets
> > the drives rest alternately.
> >
> > This link http://www.whine.com/~andrew/alternating_disk.png is a gkrellm
> > snapshot of the activity, hda and hde are the two disks in the RAID
array.
> > Each disk is the master on it's own channel.
>
> Was that a single large file that you read or multiple files?

Multiple files 1-2MB in size

> As far as I could observe, the RAID1 code reads one file from one disk
> and never changes disks during this read - so you get the performance
> of one disk.
> *But* the code distributes different writes to different disks.

Well this is what I am seeing, so it's being consistent then.

> Try the following:
> dd if=/dev/mdX of=/dev/null&

Looks just like the graph in gkrellm I showed earlier.

> Now watch gkrellm and see that it reads only from one disk.
> Then start another instance of dd. You will see that this instance reads
> from the other RAID disk.

Well look at that, it is now starting to consistently use both disks.  I did
notice that after a length of time of running both instances that it stopped
using hda for an extended time.  Starting a 3rd instance again invoked the
use of hda.  The implementation doesn't seem perfect, but appears to be more
than adequate.

> This way one disk can seek for a file while the other one is transfering
> one. A single read won't be faster but concurrent access to the same
> filesystem will be much faster than on a non-RAID filesystem.

Does this mean that the md driver is filesystem aware?  Or is it just
because i'm using EXT3?  How does md know how many file accesses i'm doing?

Thanks for your explaination, it certainly clears things up.

Andrew


