From: thornber@redhat.com
Subject: Re: [dm-devel] [ANNOUNCE] multipath-tools-0.1.6
Date: Tue, 27 Apr 2004 11:09:31 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040427100930.GA24944@nimzo>
References: <1082930099.3158.13.camel@zezette> <20040426081842.GN8379@nimzo> <1083059878.408e2ea6eab69@imp1-q.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1083059878.408e2ea6eab69@imp1-q.free.fr>
To: christophe.varoqui@free.fr
Cc: thornber@redhat.com, device-mapper development <dm-devel@redhat.com>, linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net
List-Id: linux-raid.ids

On Tue, Apr 27, 2004 at 11:57:58AM +0200, christophe.varoqui@free.fr wrote:
> Selon thornber@redhat.com:
> 
> > On Sun, Apr 25, 2004 at 11:54:59PM +0200, christophe varoqui wrote:
> > > * add the dmadm WIP tool (read MD superblocks and create
> > >   corresponding devmaps when possible)
> > 
> > :)
> > 
> Any insight on where to put the log of the mirror target when mapping over a
> MD-created raid1 ?

MD effectively uses a log with a single region in it.  So we only need
3 sectors (2 for the header 1 for the bitset) for the log, is there
any space in the MD metadata where this could be placed ?

- Joe
