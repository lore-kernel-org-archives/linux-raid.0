From: Mike Tran <mhtran@us.ibm.com>
Subject: Re: [dm-devel] [ANNOUNCE] multipath-tools-0.1.6
Date: 27 Apr 2004 10:32:27 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1083079947.21372.16.camel@star2.austin.ibm.com>
References: <1082930099.3158.13.camel@zezette> <20040426081842.GN8379@nimzo>
	 <1083059878.408e2ea6eab69@imp1-q.free.fr>  <20040427100930.GA24944@nimzo>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040427100930.GA24944@nimzo>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 2004-04-27 at 05:09, thornber@redhat.com wrote:
> On Tue, Apr 27, 2004 at 11:57:58AM +0200, christophe.varoqui@free.fr wrote:
> > Selon thornber@redhat.com:
> > 
> > > On Sun, Apr 25, 2004 at 11:54:59PM +0200, christophe varoqui wrote:
> > > > * add the dmadm WIP tool (read MD superblocks and create
> > > >   corresponding devmaps when possible)
> > > 
> > > :)
> > > 
> > Any insight on where to put the log of the mirror target when mapping over a
> > MD-created raid1 ?
> 
> MD effectively uses a log with a single region in it.  So we only need
> 3 sectors (2 for the header 1 for the bitset) for the log, is there
> any space in the MD metadata where this could be placed ?
> 
> - Joe

The MD device size is 64K aligned and MD superblock size is 4K.  In term
of sectors, the calculation is as follows:

MD_SB_BYTES 4096
MD_SB_SECTORS (MD_SB_BYTES / 512)

// x is the child device size in sectors.

#define MD_RESERVED_BYTES (64 * 1024)
#define MD_RESERVED_SECTORS (MD_RESERVED_BYTES / 512)
#define MD_NEW_SIZE_SECTORS(x) (((x) & ~(MD_RESERVED_SECTORS -1)) - MD_RESERVED_SECTORS)

It's safe to write the log after the MD superblock.

Regards,
Mike T.





