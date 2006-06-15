From: Niccolo Rigacci <niccolo@rigacci.org>
Subject: Re: IBM xSeries stop responding during RAID1 reconstruction
Date: Thu, 15 Jun 2006 11:12:19 +0200
Message-ID: <20060615091219.GB2080@rigacci.org>
References: <20060614085354.GA18106@rigacci.org> <44902F41.8030300@rcn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <44902F41.8030300@rcn.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Cizek <cizek@rcn.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 14, 2006 at 10:46:09AM -0500, Bill Cizek wrote:
> Niccolo Rigacci wrote:
> 
> >When the sync is complete, the machine start to respond again 
> >perfectly.
> >
> I was able to work around this by lowering 
> /proc/sys/dev/raid/speed_limit_max to a value
> below my disk thruput value (~ 50 MB/s) as follows:
> 
> $ echo 45000 > /proc/sys/dev/raid/speed_limit_max

Thanks!

This hack seems to solve my problem too. So it seems that the 
RAID subsystem does not detect a proper speed to throttle the 
sync.

Can you please send me some details of your system?

- SATA chipset (or motherboard model)?
- Disks make/model?
- Do you have the config file of the kernel that you was running
  (look at /boot/config-<version> file)?

I wonder if kernel preemption can be blamed for that, or burst 
speed of disks can fool the throttle calculation.

-- 
Niccolo Rigacci
Firenze - Italy

Iraq, missione di pace: 38355 morti - www.iraqbodycount.net
