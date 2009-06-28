From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Adding a smaller drive
Date: Sun, 28 Jun 2009 14:47:00 -0500
Message-ID: <20090628194705152.ITZI24524@cdptpa-omta02.mail.rr.com>
References: <4A47BEEA.3080608@anonymous.org.uk>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A47BEEA.3080608@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > 	I have a few questions.  Some RAID implementations will simply
> > refuse to create or grow an array if all the targets are not precisely
> the
> > same size.  Clearly this is not the case for mdadm.  Not all drives of a
> > given "size" are actually precisely the same size, however, and I am
> using
> > unpartitioned drives for my RAID systems.  What happens if I add a drive
> > whose apparent physical size is a bit smaller than the device size used
> to
> > create the array?
> 
> For RAID 4/5/6, I think it'll be refused.

	Do you know if the refusal would include an error message clearly
indicating why the growth is refused?

> You have to shrink the
> filesystem, and LVM if you use it, then the array, so the used size is
> no bigger than the new drive - as you've noted, md doesn't mind if it
> doesn't use all the available space on its constituent devices. If it's
> a small reduction, as I imagine it would be, and your filesystem
> supports shrinking, it won't take long to do the the shrinks. Then
> adding the new drive will be painless. If your filesystem won't shrink -
> and some (many?) won't - I suspect you're scuppered.

	I'm no longer using LVM on any of the servers, and I've converted to
XFS on RAID 5 and RAID 6 arrays.  At this time XFS does not support
shrinking.  I've seen some chatter on the web about 3rd party utilities
which might make it possible.

	For growing an array, this would be a bit of a pain, but probably
not a show stopper.  Even for a failed drive I could probably just send the
new drive back and purchase a different model whose real size is as large or
larger than the extant drives.  The problem is, waiting that long for a new
drive or doing anything significant (like multiple shrinks!) to a partially
failed array sends shivers up my spine.

	I may have to rethink my position on using raw drives.  If I
partition the drives, I can make the partition a bit smaller than the whole
drive, allowing for the addition of a future drive whose size is a bit off.
I hate to waste space, but being stuck with an undersized or limping array
is worse.

