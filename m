From: David Rees <drees76@gmail.com>
Subject: RAID10 - migrating disks without failing/degrading array?
Date: Fri, 2 Oct 2009 11:22:09 -0700
Message-ID: <72dbd3150910021122r474c43f6m2f1d953b5af9c3e0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've got an 8 disk RAID10 array (near2 layout) where I am moving data
off some older disks onto newer disks.

Currently what I'm doing is adding the newer disks as spares and then
failing/removing the older disks one at a time.

This works fine, but leaves me with an hour or so of running the array
degraded while the spare drive syncs up which leaves me open for
data-loss during this time period.

It seems like I should be able to add a drive as a directly
replacement for one of the drives I'm pulling out (so I temporarily
end up with 3-copies of that chunk instead of 2) until I pull
fail/remove the older disk.  If I was using RAID0 striped over RAID1
mirrors, for example, I know this is possible.

Is this possible to do with RAID10?

Thanks

Dave
