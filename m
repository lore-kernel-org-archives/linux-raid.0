From: Maarten van den Berg <maarten@ultratux.net>
Subject: Re: md questions [forwarded from already sent mail]
Date: Sat, 24 Jan 2004 14:20:50 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401241420.50326.maarten@ultratux.net>
References: <200401221928.00985.gene.heskett@verizon.net> <200401241258.38857.maarten@ultratux.net> <200401240531.05477.gene.heskett@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200401240531.05477.gene.heskett@verizon.net>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday 24 January 2004 11:31, you wrote:
> On Saturday 24 January 2004 06:58, Maarten van den Berg wrote:
> >On Saturday 24 January 2004 01:31, Gene Heskett wrote:
> >> On Thursday 22 January 2004 19:28, Gene Heskett wrote:

> >All of the above ;-) No seriously, it sounds like a problem with the
> > hardware somewhere along the line. Can you test the array on the
> > OLD motherboard, by just plugging everything in ?  Also, if you're
> > using persistent superblocks and type=0xFD, messing with the order
> > in which the drives are attached / recognized should not matter. It
> > is confusing, but the array should nonetheless assemble itself
> > perfectly. At least in my experience.
>
> How do we make sure the persistent superblocks are in use?  And the
> 0xFD is I assume what fdisk would show us as the disk type?

It's all in the manual. Yes, the partition type in fdisk.

> Jim has been beating his head on this thing for a week.  Trying the
> old mobo might be a possibility, but its boot drive would need
> formatted and 7.2 re-installed and recompiled so md is builtin to dup
> what we had before, or at least make a reasonable copy of it.  What
> I'm trying to say is that we probably cannot recreate it exactly.
> It was the boot drive, not the raid, that got trashed on the other,
> older mobo.  I'm now confused as to whether the 4 160Gb's in the raid
> array are new, or the same ones from 2 years ago when we built the
> first one which had a 400mhz K6-II on it IIRC, with 256 megs of
> dimms.  This one has a bit more horsepower than that.

No, no, NO.  I don't mean recreate the old setup with the old software. I mean 
use the exact same bootdrive as you're using now and the exact same setup !
It's linux, you know, not windows. You can, in most all cases, just change 
hardware without any changes. The exception being if you have a kernel that 
is optimized for a certain cpu. But even then, a new kernel is compiled 
easily, seen as you have already done that anyway.
So the question is: what happens if you ONLY swap the motherboard but leave 
all else in place (controllers, disks and linux bootdrive)

P.S. I'd appreciate it if you reply to the list instead of to me directly.

Maarten

