From: Matti Aarnio <matti.aarnio@zmailer.org>
Subject: Re: Move md raid5 from intel to sparc?
Date: Wed, 11 Jun 2003 23:44:21 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030611204421.GZ28900@mea-ext.zmailer.org>
References: <3EE76EDA.1060000@geodev.com> <200306111908.h5BJ8SsX012002@imsebackup.imse.ksu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200306111908.h5BJ8SsX012002@imsebackup.imse.ksu.edu>
To: Matt Stegman <matts@ksu.edu>
Cc: matthew@geodev.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 11, 2003 at 02:08:28PM -0500, Matt Stegman wrote:
> On 11 Jun, Matthew Mitchell wrote:
> > What _about_ the filesystem and data, though?  Some filesystems are 
> > certainly written in a known byte-order, like ISO 9660.  Are there any 
> > of (ext3, XFS, JFS, reiserfs) that this is true for?  Or are they all 
> > written in cpu native byte-order?
> 
> I know XFS always uses big-endian on disk; one of SGI's selling points
> was that you can move disks back and forth between MIPS and Intel
> computers.  I think ext2/3 also uses the same format between big and
> little endian archs.

  EXT2 has two on-disk byte orders, and kernel code understands both.
  The MD physical format could be handled similarly.  Present code
  (drivers/md/md.c) becomes rather upset when it sees unexpected things.

  This quick review was based on 2.4.20, and doesn't say anything
  about 2.5 series.

  Just for the kicks from linux/fs/ext2/super.c:
     *  Big-endian to little-endian byte-swapping/bitmaps by
     *        David S. Miller (davem@caip.rutgers.edu), 1995

  Yes, it was made to support same disk at SPARC and at i386  ;-)

> -- 
>     -Matt Stegman

/Matti Aarnio
