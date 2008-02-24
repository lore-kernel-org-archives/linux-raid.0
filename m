From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: RAID10 far (f2) read throughput on random and sequential / read-ahead
Date: Sun, 24 Feb 2008 03:17:52 +0100
Message-ID: <20080224021752.GB6835@rap.rap.dk>
References: <loom.20080222T035556-308@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <loom.20080222T035556-308@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Nat Makarevitch <nat@makarevitch.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I made a reference to your work in the wiki howto on performance.
Thanks!

Keld

On Fri, Feb 22, 2008 at 04:14:05AM +0000, Nat Makarevitch wrote:
> 'md' performs wonderfully. Thanks to every contributor!
> 
> I pitted it against a 3ware 9650 and 'md' won on nearly every account (albeit on
> RAID5 for sequential I/O the 3ware is a distant winner):
> http://www.makarevitch.org/rant/raid/#3wmd
> 
> On RAID10 f2 a small read-ahead reduces the throughput on sequential read, but
> even a low value (768 for the whole 'md' block device, 0 for the underlying
> spindles) enables very good sequential read performance (300 MB/s on 6 low-end
> Hitachi 500 GB spindles).
> 
> What baffles me is that, on a 1.4TB array served by a box having 12 GB RAM (low
> cache-hit ratio), the random access performance remains stable and high (450
> IOPS with 48 threads, 20% writes - 10% fsync'ed), even with a fairly high
> read-ahead (16k). How comes?!
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
