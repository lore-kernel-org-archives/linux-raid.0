From: Luca Berra <bluca@comedia.it>
Subject: Re: raid1 devices not autostarting
Date: Wed, 31 Mar 2004 11:24:52 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <406A8E64.2040009@comedia.it>
References: <20040331062507.76253.qmail@web40704.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040331062507.76253.qmail@web40704.mail.yahoo.com>
To: David Nedved <david_nedved@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Nedved wrote:
> Hi All,
> 
> I'm trying to move my system off a failing disk onto a raid1 device. 
> I've got the device built, but when passing root=/dev/md0 to the kernel
> it can't find it.  When I boot my raid devices are NOT autostarting, so
> I believe that to be my problem.  I'm running RH9 fully updated with
> their latest kernel (2.4.20-30.9SMP), all the partitions are type fd,
> and I *think* I have the persistant superblock option on.  I even
> recreated md1 to make sure, but still when I boot I have to start the
> raids manually.  raidstart --all DOES work.
redhat has modular raid, so you need to recreate an initrd with raid 
support.

-- 
Luca Berra -- bluca@comedia.it
