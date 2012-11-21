From: Ross Boylan <ross@biostat.ucsf.edu>
Subject: Re: mdadm --fail doesn't mark device as failed?
Date: Wed, 21 Nov 2012 11:52:08 -0800
Message-ID: <1353527528.5795.107.camel@corn.betterworld.us>
References: <1353514677.5795.14.camel@corn.betterworld.us>
	 <50AD0726.9090509@profitbricks.com>
	 <1353517421.5795.58.camel@corn.betterworld.us>
	 <50AD0B01.7020300@profitbricks.com>
	 <1353518608.5795.76.camel@corn.betterworld.us>
	 <50AD13A3.5040709@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50AD13A3.5040709@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Cc: ross@biostat.ucsf.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2012-11-21 at 18:47 +0100, Sebastian Riemer wrote:
> > OK.  So if I understand correctly, mdadm -fail has no effect that
> > persists past a reboot, and doesn't write to disk anything that
> would
> > prevent the use of the failed RAID component.(*)  But if I write to
> > sysfs, the failure wil persist across reboots.
> >
> > This behavior is quite surprising to me.  Is there some reason for
> this
> > design?
> 
> Yes, sometimes hardware has only a short issue and operates as
> expected
> afterwards. Therefore, there is an error threshold. It could be very
> annoying to zero the superblock and to resync everything only because
> there was a short controller issue or something similar. Without this
> you also couldn't remove and re-add devices for testing.
BTW, the part that was surprising was not that the device could be
re-added, but that it was re-added automatically on reboot.

At the moment I have quite a few partitions running around with the same
md UUID but slightly different information on them.
Ross

