From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Fri, 11 Jan 2013 12:50:09 -0600
Message-ID: <50F05EE1.4030707@hardwarefreak.com>
References: <201212212357.19292.thomas@fjellstrom.ca> <201301100349.46794.thomas@fjellstrom.ca> <6FD79D70-01A4-4DC9-9494-157773CD0F11@colorremedies.com> <201301110520.07128.thomas@fjellstrom.ca>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201301110520.07128.thomas@fjellstrom.ca>
Sender: linux-raid-owner@vger.kernel.org
To: thomas@fjellstrom.ca
Cc: Chris Murphy <lists@colorremedies.com>, linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/11/2013 6:20 AM, Thomas Fjellstrom wrote:
> On Thu Jan 10, 2013, Chris Murphy wrote:

>> Another thing to look at is if you're using XFS, what your mount options
>> are. Invariably with an array of this size you need to be mounting with
>> the inode64 option.
> 
> I'm not sure, but I think that's the default.

No, inode32 has always been the default allocator.  It was decided just
recently to make inode64 the default, and the patcheset for this was
committed on 9/20/2012, ~3 months ago, into 3.6-rc1-17:

http://oss.sgi.com/archives/xfs/2012-09/msg00397.html

So with 3.6+ kernels inode64 is the new default.  Any current mainstream
distro kernel defaults to inode32.

Worth noting:  if you upgrade the kernel on a system with existing
inode32 XFS filesystems the allocator for these will remain inode32
unless the mount option is manually changed.  This is the same behavior
as with current kernels.  New filesystems created after upgrading to a
64 bit kernel w/this patch set will be mounted with inode64.  IIRC 32
bit kernels are limited to the inode32 allocator and 32 bit inodes.

There are many workloads that prefer, or even require, 32bit inodes,
and/or the behavior available with the inode32 allocator.  Thus it would
not be smart to auto convert them to inode64 after a kernel upgrade.

-- 
Stan

