From: Theodore Tso <tytso@mit.edu>
Subject: Re: bonnie++ benchmarks for ext2,ext3,ext4,jfs,reiserfs,xfs,zfs on software raid 5
Date: Mon, 30 Jul 2007 22:41:44 -0400
Message-ID: <20070731024144.GC25876@thunk.org>
References: <Pine.LNX.4.64.0707301021090.12456@p34.internal.lan> <200707302207.02672.a1426z@gawab.com> <E1IFb5f-00006O-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E1IFb5f-00006O-00@dorka.pomaz.szeredi.hu>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: a1426z@gawab.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jul 30, 2007 at 09:39:39PM +0200, Miklos Szeredi wrote:
> > Extrapolating these %cpu number makes ZFS the fastest.
> > 
> > Are you sure these numbers are correct?
> 
> Note, that %cpu numbers for fuse filesystems are inherently skewed,
> because the CPU usage of the filesystem process itself is not taken
> into account.
> 
> So the numbers are not all that good, but according to the zfs-fuse
> author it hasn't been optimized yet, so they may improve.

Also, something which is data i/o intensive is going to be the best
case for a FUSE filesystem.  If you try something which is much more
metadata intensive (i.e., lots of file creates and deletes, chmods,
etc.) like say with a Postmark benchmark, you would almost certainly
get very different results.  That's not to say that bonnie++
benchmarks aren't useful, but when doing comparisons between
filesystems, it's a good idea to use a wide variety of benchmarks to
avoid getting potentially misleading results.

					- Ted
