From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Expanding array by changing disks (one by one)
Date: Thu, 14 Apr 2005 08:08:10 -0700
Message-ID: <425E875A.2010503@h3c.com>
References: <425E41C8.7050704@apartia.fr> <Pine.LNX.4.56.0504141148400.14678@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0504141148400.14678@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Gordon Henderson wrote:
> On Thu, 14 Apr 2005, Laurent CARON wrote:
>>
>>- Copy the data over a new array and replace the disks
> 
> 
> Do this! You know it makes sense. If nothing else, it'll make sure you
> have an archive of the data. Do verify the copy before you replace the
> disks too.

Definitely make a backup, and once you do that the rest is just testing
anyway, isn't it?

>>- Replace each disk (one after the other(after resync)) of the existing
>>array with a bigger one.
> 
> You would have to guarantee that each disk had zero surface defects before
> you started this. Use badblocks (or dd) to do a surface scan of each disk.
> One bad block and you'll be in the 2-disk failure mode which will likely
> cause loss of all data.

Alternatively, you could do a round of SMART long tests via smartctl.

If you have one bad block you will be in 2-disk failure mode, but this
will not result in loss of all data. It will result in loss of whichever
file had the bad block in it. Even then, there are now tools (namely a
script I've posted a couple times) that can calculate the contents of a
given parity block or disk block just from the disk contents (while the
array is offline) so its possible to manually correct single block
failures as long as the rest of the blocks in the stripe are okay.

That solves the most usual scenario, albeit via a process that is pretty
ugly. Should make you feel safer if you feel like experimenting though.

The real takeaway is that making a backup, verifying it, and then doing
your maintenance is going to be the fastest and safest way to do this,
even if the disk-by-disk swap / mdadm grow way works

-Mike
