From: dlists@technobrat.com
Subject: Re: Raidreconf w/ 2.6.2
Date: Tue, 21 Sep 2004 11:42:36 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040921184236.GC31433@baby.technobrat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

I've got a large raid and I was hit by this problem.  I used raidreconf to add 
a disk to my raid 5. The disk was larger than the other disks already in the 
array. So I created a partition on the disk that was about the same size as the 
other disks so that they would match up. The only problem is, I later found an 
extra 10k in the partition I created on the new disk. 

Obviously linux has no problem with this extra space. It just ignores it.  The 
super block shows all the disks the same size (apparent disk size).

We've started getting some corruption in the array though. But not at a low level. 
Badblocks shows no problems on the low level disks. The raid array never complains 
or resyncs. But I have some applications that work with large files on the arrays. 
If I have them check their files after a large amount of time they soemtimes find 
that some small amount of data has gotten corrupted. I've tried this with multiple 
unrelated applications.

Additionally I had created an ext2 partition on the extra space of the new drive. 
That partiton also showed this corruption.

Obviously after testing other applications my next step was to shrink the array 
removing the new disk and see if this still happens.

But the problem is, if I try to shrink the array I get this raid5_global_to_local 
error which I believe is due to the different disk sizes. In this case the 
partition on the new disk has the extra 10k. The error happens at the start of the 
raidreconf so a quick fsck finds no issues. And I'm willing to deal with a little 
data loss so I'm not concerned.

Finally my question is this. Am I correct in assuming that the extra 10k is going 
to go completely untouched by the raid system? And thus I could resolve my 
raidreconf issues by truncating the partition on the new disk down to the same 
size as the other disks. And then merely fixing up anything that would be confused 
by the new partition size.

Any help is appreciated.

Jason S.

> 
> Hi Mike,
> 
> Glad to know that it's helped someone else.  It's a little worrying to
> see
> the error messages...
> 
> I believe that is the error message I received.  It appears to happen
> when
> the disks are of differing sizes.  I think what's happening is that it
> runs off of the end of one of the disks - i.e., Disk1 = 200 blocks and
> Disk2 =99 blocks.  It assumes that all of the disks are the same size
> instead of looking at the lowest common denominator.
> 
> Hope this helps.
> 
> -steffan-
> 
> 
> On Mon, 16 Aug 2004, Mike Baynton wrote:
> 
> > Hi
> > This is related to a message you put on linux-raid months ago
> > (http://marc.theaimsgroup.com/?l=linux-raid&m=108509877724484&w=2 ). I
> > am having the same problem (as near as I can tell so far all my data's
> > intact using the method you suggested in that post...I had no data
> > near
> > the end of my array) but I'd like to be sure we're dealing with the
> > same
> > problem/bug before I start speculating about a bug in raidreconf on
> > linux-raid.
> >
> > Do you remember if you got an error message like
> >
> > raid5_map_global_to_local: disk 0 block out of range: 2442004
> > (2442004)
> > gblock = 7326012
> > aborted (core dumped)
> >
> > when this happened to you?
> >
> > Thanks,
> > Mike Baynton
> >
>
>

