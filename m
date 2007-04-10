From: Henrik Holst <holst@matmech.com>
Subject: Re: LINEAR RAID, little help
Date: Tue, 10 Apr 2007 23:49:28 +0200
Message-ID: <1176241768.27056.28.camel@morticia>
References: <46177DD8.9080707@pcfusion.co.uk>
	 <20070407173352.GA23645@gmail.com> <4617E5E2.2090609@pcfusion.co.uk>
	 <20070407203435.GA32499@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070407203435.GA32499@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gavin McCullagh <gmccullagh@gmail.com>
Cc: Rich <rich@pcfusion.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2007-04-07 at 21:34 +0100, Gavin McCullagh wrote:
> Hi,
> 
> On Sat, 07 Apr 2007, Rich wrote:
> 
> > Er, I went with Linear as reading around people seemed to recommend this 
> > for odd sized drives (my old drives are 80's, 120 and 320's) also a read 
> > somewhere that data on the other drives is more recoverable that most of 
> > the other RAID's.
> 
> You just want to make a large filesystem out of odd sized disks.  I guess
> that's fair enough.  The only reservation I'd have is that with N disks
> your likelihood of failure is multiplied by N as any disk failure takes the
> array down.  Personally, I'd be more inclined to try and put a separate
> filesystem on each disk and use symlinks to pull them together into one
> tree.
> 
> But now I know why linear raid can be more useful than raid-0, thanks.
> 

(This is maybe sort of off topic since this list about raid and not
filesystems and virtual such either.)

Maybe you just want the appearance of things being as one volume? I
might recommend you looking into unionfs:

http://www.filesystems.org/project-unionfs.html

It's actually quite useful. You might have some logical division of the
data. Put TV stuff on one disk, Movies on another. The unionfs overlay
maps everything together into a virtual bigdisk. It's also very simple
and no superblocks or headers needed either.

-- 
Henrik Holst <holst@matmech.com>
