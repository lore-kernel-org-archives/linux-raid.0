From: Neil Brown <neilb@suse.de>
Subject: Re: IBM xSeries stop responding during RAID1 reconstruction
Date: Thu, 15 Jun 2006 20:13:48 +1000
Message-ID: <17553.13020.134589.292543@cse.unsw.edu.au>
References: <20060614085354.GA18106@rigacci.org>
	<44902F41.8030300@rcn.com>
	<20060615091219.GB2080@rigacci.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Niccolo Rigacci on Thursday June 15
Sender: linux-raid-owner@vger.kernel.org
To: Niccolo Rigacci <niccolo@rigacci.org>
Cc: Bill Cizek <cizek@rcn.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday June 15, niccolo@rigacci.org wrote:
> On Wed, Jun 14, 2006 at 10:46:09AM -0500, Bill Cizek wrote:
> > Niccolo Rigacci wrote:
> > 
> > >When the sync is complete, the machine start to respond again 
> > >perfectly.
> > >
> > I was able to work around this by lowering 
> > /proc/sys/dev/raid/speed_limit_max to a value
> > below my disk thruput value (~ 50 MB/s) as follows:
> > 
> > $ echo 45000 > /proc/sys/dev/raid/speed_limit_max
> 
> Thanks!
> 
> This hack seems to solve my problem too. So it seems that the 
> RAID subsystem does not detect a proper speed to throttle the 
> sync.

The RAID subsystem doesn't try to detect a 'proper' speed.
When there is nothing else happening, it just drives the disks as fast
as they will go.
If this is causing a lockup, then there is something else wrong, just
as any single process should not - by writing constantly to disks - be
able to clog up the whole system.

Maybe if you could get the result of 
  alt-sysrq-P
or even
  alt-sysrq-T
while the system seems to hang.

NeilBrown
