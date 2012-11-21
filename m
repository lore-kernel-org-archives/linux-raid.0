From: Ross Boylan <ross@biostat.ucsf.edu>
Subject: Re: mdadm --fail doesn't mark device as failed?
Date: Wed, 21 Nov 2012 09:23:28 -0800
Message-ID: <1353518608.5795.76.camel@corn.betterworld.us>
References: <1353514677.5795.14.camel@corn.betterworld.us>
	 <50AD0726.9090509@profitbricks.com>
	 <1353517421.5795.58.camel@corn.betterworld.us>
	 <50AD0B01.7020300@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50AD0B01.7020300@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Sebastian Riemer <sebastian.riemer@profitbricks.com>
Cc: ross@biostat.ucsf.edu
List-Id: linux-raid.ids

On Wed, 2012-11-21 at 18:10 +0100, Sebastian Riemer wrote:
> On 21.11.2012 18:03, Ross Boylan wrote:
> > On Wed, 2012-11-21 at 17:53 +0100, Sebastian Riemer wrote:
> >> On 21.11.2012 17:17, Ross Boylan wrote:
> >>> After I failed and removed a partition, mdadm --examine seems to show
> >>> that partition is fine.
> >>>
> >>> Perhaps related to this, I failed a partition and when I rebooted it
> >>> came up as the sole member of its RAID array.
> >>>
> >>> Is this behavior expected?  Is there a way to make the failures more
> >>> convincing?
> >> Yes, it is expected behavior. Without "mdadm --fail" you can't remove a
> >> device from the array. If you stop the array with the failed device,
> >> then the state is stored in the superblock.
> > I'm confused.  I did run mdadm --fail.  Are you saying that, in addition
> > to doing that, I also need to manipulate sysfs as you describe below?
> > Or were you assuming I didn't mdadm --fail?
> 
> You only need to set the value in the "errors" sysfs file additionally
> to ensure that this device isn't used for assembly anymore.
> 
> The kernel reports in "dmesg" then:
> md: kicking non-fresh sdb1 from array!
> 
OK.  So if I understand correctly, mdadm -fail has no effect that
persists past a reboot, and doesn't write to disk anything that would
prevent the use of the failed RAID component.(*)  But if I write to
sysfs, the failure wil persist across reboots.

This behavior is quite surprising to me.  Is there some reason for this
design?

Ross

(*) Also the different update or last use times either aren't recorded
or don't affect the RAID assembly decision.  For example, in my case md1
included sda3 and sdc3.  I failed sdc3, so that only sda3 had the most
current data.  But when the system rebooted, md1 was assembled from sdc3
only.

