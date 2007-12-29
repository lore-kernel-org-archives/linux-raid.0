From: "Cody Yellan" <cody@mochamail.com>
Subject: Re: raid5 grow reshaping speed is unchangeable
Date: Fri, 28 Dec 2007 16:52:44 -0800
Message-ID: <380-220071262905244879@mochamail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>>2007/12/27, Cody Yellan <cody@mochamail.com>:
>>> I had a 4x500GB SATA2 array, md0.  I added one 500GB drive and
>>> reshaping began at ~2500K/sec.  Changing
>>> /proc/sys/dev/raid/speed_limit_m{in,ax} or
>>> /sys/block/md0/md/sync_speed_m{in,ax} had no effect.  I shut down
>all
>>> unnecessary services and the array is offline (not mounted).  I
>have
>>> read that the throttling code is "fragile" (esp. with regard to
>>> raid5) but does this make sense?  I will wait (in)patiently for it
>to
>>> finish, but I do wonder why the configuration parameters have no
>>> effect.  This is a dual quad 2GHz Xeon machine with 8GB of memory
>>> running RHEL5.  Is this the maximum speed?
>>>
>>I think you may check each SATA2 disk to make sure they are working
>fine.
>>I had a similar situation and it turned out to be caused by one of
>>disks in array. It is  a failed disk indicated by its S.M.A.R.T
>>information.

No problems indicated by SMART but I did have some concerns about the
drive I added.  It contained some data so I tried to delete the
partition and create a new filesystem-free partition.  Both parted
and fdisk simply restored the already existing partition, complete
with the data.  So I just added that drive, figuring mdadm would
overwrite the partition.    It worked but from now on I will try to
use only blank disks.

