From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: Forcing raid1 resync
Date: Wed, 18 Aug 2004 07:42:41 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16674.31697.887056.108276@cse.unsw.edu.au>
References: <8075D5C3061B9441944E1373776451186488C3@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Rechenberg, Andrew on Tuesday August 17
To: "Rechenberg, Andrew" <ARechenberg@sfg.com>
Cc: Mark Hahn <hahn@physics.mcmaster.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday August 17, ARechenberg@sfg.com wrote:
> 
> Is there any way to make the kernel "less smart?" :)  Maybe there should
> be a /proc entry to specify the number of simultaneous arrays to allow
> to sync at once.  None of the arrays in this box share the same spindles
> (although there are 6 or 7 disks per SCSI channel; each SCSI card is on
> it's own PCI bus as to make sure each set of disks has the most
> available bus bandwidth).

Didn't I already reply to this??..

The kernel isn't being "smart".
The code in 2.4 always does reconstruction (i.e. rebuilding a failed
drive) one array at a time, simply because that is the way the code
works. 
The code in 2.6 is more sensible and allows parallel reconstruction
provided there is no sharing of devices.

resync (after an unclean shutdown) happens in parallel (except where
device sharing exists) in both 2.4 and 2.6

NeilBrown

