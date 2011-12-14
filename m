From: Troy Telford <ttelford.groups@gmail.com>
Subject: Re: RAID-6 disk superblock issue
Date: Wed, 14 Dec 2011 14:41:52 -0700
Message-ID: <jcb570$1do$1@dough.gmane.org>
References: <jc8kca$mf$1@dough.gmane.org> <4EE8F26D.7010608@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2011-12-14 19:01:01 +0000, Phil Turmel said:

> Hi Troy,
> 
> On 12/13/2011 05:42 PM, Troy Telford wrote:
> 
> Let me guess:  You have version 0.90 superblock, and sdl1 covers the 
> whole device?

sdl1 does cover the entire device, but I'm fairly certain I do not have 
a 0.90 superblock (Unless 0.90 was the standard version for Linux 2.6 
about two years ago.)

Unfortunately, I'm not sure how to get my current superblock version:
$ sudo mdadm --examine /dev/md2
mdadm: No md superblock detected on /dev/md2.

I find it curious that I can't detect the superblock for the MD device, 
even though the device is up, active, and working.

> Short term, change your mdadm.conf to only accept device names that end 
> with a digit.  Like so:
> 
> DEVICE /dev/sd[a-z][1-9]

OK, I'll give that a whirl.  For the record, it was DEVICE partitions 
previously.

> Then rebuild your initramfs to include the new mdadm.conf.
> 
> Long term, rebuild your array with v1.x metadata.

You know, I was hoping to be able to wait until btrfs handles RAID-6 
(or "raid-z") arrays by the time I had to rebuild the array.  I guess 
I'm not that lucky.
-- 
Troy Telford


