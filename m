From: Mike Tran <mhtran@us.ibm.com>
Subject: Re: [dm-devel] [ANNOUNCE] multipath-tools-0.1.6
Date: 27 Apr 2004 10:40:21 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1083080421.21372.21.camel@star2.austin.ibm.com>
References: <1082930099.3158.13.camel@zezette> <20040426081842.GN8379@nimzo>
	 <1083059878.408e2ea6eab69@imp1-q.free.fr>  <20040427100930.GA24944@nimzo>
	 <1083079947.21372.16.camel@star2.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1083079947.21372.16.camel@star2.austin.ibm.com>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 2004-04-27 at 10:32, Mike Tran wrote:
> On Tue, 2004-04-27 at 05:09, thornber@redhat.com wrote:
> > On Tue, Apr 27, 2004 at 11:57:58AM +0200, christophe.varoqui@free.fr wrote:
> > > Selon thornber@redhat.com:
> > > 
> > > > On Sun, Apr 25, 2004 at 11:54:59PM +0200, christophe varoqui wrote:
> > > > > * add the dmadm WIP tool (read MD superblocks and create
> > > > >   corresponding devmaps when possible)
> > > > 
> > > > :)
> > > > 
> > > Any insight on where to put the log of the mirror target when mapping over a
> > > MD-created raid1 ?
> > 
> > MD effectively uses a log with a single region in it.  So we only need
> > 3 sectors (2 for the header 1 for the bitset) for the log, is there
> > any space in the MD metadata where this could be placed ?
> > 
> > - Joe
> 
> The MD device size is 64K aligned and MD superblock size is 4K.  In term
> of sectors, the calculation is as follows:

Oops.  I was thinking raid1 when saying : "The MD device size is 64K
aligned."  I should have said : "The new MD child size is 64K aligned."

Mike T.

