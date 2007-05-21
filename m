From: Neil Brown <neilb@suse.de>
Subject: Re: Adding larger disks to RAID5
Date: Tue, 22 May 2007 09:34:06 +1000
Message-ID: <18002.11374.159035.143026@notabene.brown>
References: <465204AA.90301@dhp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Christian on Monday May 21
Sender: linux-raid-owner@vger.kernel.org
To: Christian <cjs@dhp.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 21, cjs@dhp.com wrote:
> Hello,
> 
> I have 8x250gig hard drives in a RAID5 configuration.  What I'm trying
> to do is add more storage to the raid by replacing the 250's with
> larger disks one-by-one over time.  I just replaced the first disk
> with a 750, and the raid resync'd, but now I'm unable to grow it to
> the additional space.  The raid is just using the first 250 gigs and
> nothing more on the drive.   The command I issued in attempt to grow
> it was 'mdadm --grow /dev/md0 -z max', but nothing happens.  Is what
> I'm trying to do possible?  I'm running kernel 2.6.21 w/ raid5 expansion
> enabled.

No, what you are trying to do is not possible.
A raid5 uses equal amounts of space on each device.  So if the devices
are of different sizes, it will use an amount equivalent to the
smallest device from every device.

If you replace all the devices with 750G drives, then you could grow
the array (-z max) to use all the space, not before.

What you could do is partition the new drives in a 250G partition and
a 500G partition.  Add the 250 to the current array.  Create a new
raid5 with the 500G.
With only one large drive, you could make a degraded 2-device raid5
which would store 500G, but would not have any data redundancy.
When you get a second 750G, add that and you will have redundancy.
Then as you replace more drives and get more 500G partitions you can
add them to the array growing it as you go until you ultimately have 2
arrays, one with 8 250G partitions, and one with 8 500G partitions.

That seems the best fit for your needs as you describe them.

If possible, it would be best to get all the drives up front and just
have one large array.

NeilBrown
