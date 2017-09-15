From: Shaohua Li <shli@kernel.org>
Subject: Linux Plumbers MD BOF discussion notes
Date: Fri, 15 Sep 2017 07:27:37 -0700
Message-ID: <20170915142737.qafwl3vgl6vhfi5q@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a short note based on Song's record. Please reply to the list if
anything is missing.

*IMSM - PPL
Fix write hole without extra device; Updated status and upcomming mdadm change
to support it. Intel guys are improving it, like fixing current 'disable disk
cache' problem.

*Hiding member drives
Hiding RAID array member drives from user, so MD RAID array looks more like a
hardware raid array. This turns out to be real customer requirement.
We do need to access the member drives for different reasons (create/assembly,
mdmon, iostat). Working around this issue might be possible, eg, delete the
/dev/xxx after array assembly. But must justify the value and also discuss with
block guys since this is a general issue.

*Block-mq
Converting MD to use block-mq? md is bio based (not request based) driver, so
no value to go mq. md dispatches bio directly to low level disks. blk-mq still
benefits if low level disk supports it but this is transparent to md.
 
*NVDIMM caching
NVDIMM supports block interface. Using it as a raid5 cache disk should be
straightforward.
Directly storing raid5 stripe cache in NVDIMM without current raid5-cache log
device? Had problems for example how to detect/fix data mismatch after power
failure. Need major changes in raid5 code.
 
*stream ID
Support stream ID in MD. It should be fairly easy to support stream ID in
raid0/1/10. Intel guys described a scenario in raid5 which breaks stream ID,
eg, write stripe data multiple times because of read-modify-write (clarify?).
Probably detecting IO pattern like what DM does can help.

*split/merge problem
md layer splits bio and block layer will do bio merge for low level disks. The
merge/split overhead is noticeable for raid0 with fast SSD and small chunk
size. Fixing the issue for raid0 is doable. Fixing for raid5 is not sure.
Discussed increasing stripe size of raid5 to reduce the split/merge overhead.
There is tradeoff here for example more unnecessary IO for read-modify-write
with bigger stripe size.

*Testing
md need recover data after disk failures, mdadm has test suite, but not
covering all cases. mdadm test suite is fragile, may kill the machine
We need to build more completed tests.

The recent null_blk block device driver can emulate several types of disk
failures. The plan is to make null_blk support all disk failures which md can
handle and create a test suite using null_blk. Help is welcome!
 
*RAID-1 RAID-10 barrier inconsistency
Coly improved the barrier scalibility for raid1, hopefully he can do the same
for raid10
 
*DAX
Support DAX in raid0/linear should not be hard. Does it make sense to support
other raid types?

*sysfs / ioctl
Jes started working on it. Goal is to replace ioctl with sysfs based interfaces.
There are gaps currently, eg, some operations can only be done with ioctl. Suse
guys promised to close the gap in kernel side.

Using configfs instead of sysfs?
 
*Stop nested RAID device
For example a raid0 on top of raid5. Userspace must understand the topology to
stop the nested raid arrays.
mdadm stop is async, need sync option for stop array (clarify?)
 
*More stable in kernel API
race condition when access md_dev data: data could be changed because of
resync. dm-raid need to get reliable resync status report. Need further
discussion on this side, email/draft patch could be helpful.
