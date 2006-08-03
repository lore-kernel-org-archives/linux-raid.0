From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: new bitmap sysfs interface
Date: Thu, 3 Aug 2006 11:42:26 +1000
Message-ID: <17617.21634.568180.436250@cse.unsw.edu.au>
References: <44C5BA6F.3010404@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Tuesday July 25
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday July 25, paul.clements@steeleye.com wrote:
> This patch (tested against 2.6.18-rc1-mm1) adds a new sysfs interface 
> that allows the bitmap of an array to be dirtied. The interface is 
> write-only, and is used as follows:
> 
> echo "1000" > /sys/block/md2/md/bitmap
> 
> (dirty the bit for chunk 1000 [offset 0] in the in-memory and on-disk 
> bitmaps of array md2)
> 
> echo "1000-2000" > /sys/block/md1/md/bitmap
> 
> (dirty the bits for chunks 1000-2000 in md1's bitmap)
> 

Thanks.  Only one remaining issue (which I didn't think of last time :-)

Is 'bitmap' the best name for the sysfs file?
It seems a bit generic to me.

  write-bits-here-to-dirty-them-in-the-bitmap

is probably (no, definitely) too verbose.

 dirty-in-bitmap
maybe?
 bitmap-set-bits

None of these seem completely satisfying.
I like to start with the most important word - which is 'bitmap' in
this case, but that isn't completely essential.

Any better suggestions?

Thanks,
NeilBrown
