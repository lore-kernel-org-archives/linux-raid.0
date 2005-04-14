From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Expanding array by changing disks (one by one)
Date: Thu, 14 Apr 2005 12:02:08 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0504141148400.14678@lion.drogon.net>
References: <425E41C8.7050704@apartia.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <425E41C8.7050704@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 14 Apr 2005, Laurent CARON wrote:

> Hello,
>
> We are in the process of increasing the size our RAID Arrays as our
> storage needs increase.
>
> I've got 2 solutions for this:
>
> - Copy the data over a new array and replace the disks

Do this! You know it makes sense. If nothing else, it'll make sure you
have an archive of the data. Do verify the copy before you replace the
disks too.

> - Replace each disk (one after the other(after resync)) of the existing
> array with a bigger one.
>
> Start:
>     - Array is ok
> - Remove 1 disk
>     - Array is degraded
> - Add a bigger disk
>     - Resync
> - Remove another disk
>     - Array is degraded
> - Add a bigger disk
>     - Resync
> .....
>
> Would this be the 'state of the art' way ?

You would have to guarantee that each disk had zero surface defects before
you started this. Use badblocks (or dd) to do a surface scan of each disk.
One bad block and you'll be in the 2-disk failure mode which will likely
cause loss of all data.

> Will the filesystem cope with it?

Firstly, will the RAID cope with it, and my understanding is that it might
not - initially. When you put in a new, bigger disk, it will only use the
same number of blocks as the disk you are replacing it had.

So after doing all the disks, the array size won't have changed!

So next you'd need to look at the grow the array mechanism, and as I
understand it, this is supported in the 2.6 kernel and mdadm, but the man
page is short on examples, but I'm sure someone here might fill in the
details.

Then you'd have to grow the filesystem under it.

> Is my mind completely broken?

Well - not really, but IMO, doing it the individual disk swapping way is
just too prone to errors and failure. I'd backup the data, replace the
drives and restore it.

And even if you do go down this route, I'd backup my data first anyway!
(And then, since you have a backup, you have nothing to lose doing it the
multiple disk swapping way, so write back and let us know if it worked :)

Good luck!

Gordon

