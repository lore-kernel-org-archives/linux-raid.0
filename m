From: Matt Thrailkill <xwred1@modestolan.com>
Subject: Re: mkraid, busted raid0 superblock
Date: Sun, 15 Feb 2004 03:09:19 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1076843359.28006.10.camel@stoneburner.xwredwing.net>
References: <1076817569.7354.8.camel@tallgeese.xwredwing.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1076817569.7354.8.camel@tallgeese.xwredwing.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After mulling over it for 10 hours, I decided to bite the bullet and do
it.

It worked fine.

Just for reference, I ran this:
`lsraid -R -a /dev/md2 -d /dev/hdN` where hdN was on of the constituents
of my stripe.  That tells it to print the array info in raidtab format
by reading the superblock off that drive.  I checked that to make sure
it matched my real raidtab, which it did.  I did it on both constituents
also.

After that, I rean `mkraid --force /dev/md2` and let it overwrite my
superblocks.  Same idea as overwriting a corrupt partition table with
one you know is valid.  Worked fine, syslog said xfs recovery started
and ended, didn't mention it having to fix anything.

Thats a rock off my chest :)

On Sat, 2004-02-14 at 19:59, Matt Thrailkill wrote:
> Last night I triggered a bug in the driver for my ide controller, the
> controller that the drives for my raid0 were hanging off of, and the
> superblocks got out of sync.  After some googling and reading
> (especially this:
> http://marc.theaimsgroup.com/?l=linux-raid&m=107282085211211&w=2) it
> looks like I should do an mkraid -R on my array.  My raidtab is the same
> as when I created it, so I assume it is consistent.  
> 
> Only thing is, is there something I should examine with lsraid?  mkraid
> mentions an lsraid howto which I can't find.  I did a few things with
> lsraid, it reported the constituent drives of my array as being good. 
> Whatever I do, I obviously want to keep the filesystem intact.  Any
> tips?
> 
> Thanks.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

