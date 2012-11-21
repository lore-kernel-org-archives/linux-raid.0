From: Ross Boylan <ross@biostat.ucsf.edu>
Subject: Re: mdadm --fail doesn't mark device as failed?
Date: Wed, 21 Nov 2012 11:41:51 -0800
Message-ID: <1353526912.5795.104.camel@corn.betterworld.us>
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
> On 21.11.2012 18:23, Ross Boylan wrote:
> > On Wed, 2012-11-21 at 18:10 +0100, Sebastian Riemer wrote:
> >> On 21.11.2012 18:03, Ross Boylan wrote:
> >>> On Wed, 2012-11-21 at 17:53 +0100, Sebastian Riemer wrote:
> >>>> On 21.11.2012 17:17, Ross Boylan wrote:
> >>>>> After I failed and removed a partition, mdadm --examine seems to show
> >>>>> that partition is fine.
> >>>>>
> >>>>> Perhaps related to this, I failed a partition and when I rebooted it
> >>>>> came up as the sole member of its RAID array.
> >>>>>
> >>>>> Is this behavior expected?  Is there a way to make the failures more
> >>>>> convincing?
> >>>> Yes, it is expected behavior. Without "mdadm --fail" you can't remove a
> >>>> device from the array. If you stop the array with the failed device,
> >>>> then the state is stored in the superblock.
> >>> I'm confused.  I did run mdadm --fail.  Are you saying that, in addition
> >>> to doing that, I also need to manipulate sysfs as you describe below?
> >>> Or were you assuming I didn't mdadm --fail?
> >> You only need to set the value in the "errors" sysfs file additionally
> >> to ensure that this device isn't used for assembly anymore.
> >>
> >> The kernel reports in "dmesg" then:
> >> md: kicking non-fresh sdb1 from array!
> >>
> > OK.  So if I understand correctly, mdadm -fail has no effect that
> > persists past a reboot, and doesn't write to disk anything that would
> > prevent the use of the failed RAID component.(*)  But if I write to
> > sysfs, the failure wil persist across reboots.
> >
> > This behavior is quite surprising to me.  Is there some reason for this
> > design?
> 
> Yes, sometimes hardware has only a short issue and operates as expected
> afterwards. Therefore, there is an error threshold. It could be very
> annoying to zero the superblock and to resync everything only because
> there was a short controller issue or something similar. Without this
> you also couldn't remove and re-add devices for testing.
So if my intention is to remove the "device" (in this case, partition)
across reboots is using sysfs as you indicated sufficient?  Zeroing the
superblock (--zero-superblock)? Removing the device (mdadm --remove)?

In this particular case the partition was fine, and my thought was I
might add it back later.  But since the info would be dated, I guess
there was no real benefit to preserving the superblock.  I did want to
preserve the data in case things went catastrophically wrong.
> 
> > (*) Also the different update or last use times either aren't recorded
> > or don't affect the RAID assembly decision.  For example, in my case md1
> > included sda3 and sdc3.  I failed sdc3, so that only sda3 had the most
> > current data.  But when the system rebooted, md1 was assembled from sdc3
> > only.
> 
> This is not the expected behavior. The superblock (at least metadata
> 1.2) has an update timestamp "utime". If something changes the
> superblock on the remaining device only, it is clear that this device
> has the most current data.
> I'm not sure if this really works for your kernel and mdadm. Ask Neil
> Brown for further details.
These were 0.90 format disks; the --detail report does include an update
time.

Maybe the "right" md array was considered unbootable and it failed over
to the other one?
At the time I failed sdc3, it was in the md1 array that had sda3 and
sdc3, size 2.
When I rebooted md1 was sda3, sdd4, and sde4, size 3 (+1 spare, I think,
for the failed sdc3).  If the GPT disk partitions were not visible, sdd4
and sde4 would have been unavailable, so the choice would have been
bringing up md1 with 1 of 3 devices, sda3, or md1 with sdc3, one of 2
devices.  At least it didn't try to put sda3 and sdc3 together.

The "invisible GPT" theory fits what I saw with the Knoppix 6
environment, but it does not fit the fact that md0 came up with sda1 and
sdd2 and sdd2 is a GPT partition the first time I booted in Debian.

Thanks for helping me out with this.
Ross

