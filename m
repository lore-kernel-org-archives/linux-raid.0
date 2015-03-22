From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: is mdadm RAID1 disk full sync
Date: Sun, 22 Mar 2015 18:28:02 +1100
Message-ID: <550E6F02.3090800@websitemanagers.com.au>
References: <CAN+bsqhy0Bao1hAn3R-KtXWOjYb8O2LDo+E1jNdktWdduUL4vw@mail.gmail.com>	<20150322142033.0af10b1a@notabene.brown> <CAN+bsqg2wp4VMCA8O0b2rUfbGDGXZY=mFvj1hA=tWaVkdCMXtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAN+bsqg2wp4VMCA8O0b2rUfbGDGXZY=mFvj1hA=tWaVkdCMXtA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: lingli tang <tanglingli001@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 22/03/2015 16:00, lingli tang wrote:
> Thanks for reply.
>
> I have create a raid1 with two fusion io PCIe flash disk:
> mdadm --create /dev/md/master --name=master --level=1 --raid-devices=2
> /dev/fioa2 /dev/mapper/mpathc
> /dev/fioa2 is local disk on server A and /dev/mapper/mpathc is a iscsi
> load disk export from server B.
>
> After that we mkfs.ext4 on /dev/md/master and mount with 'sync' option on /data1
> and we will run mysql binlog on it.
> In order to avoid data loss  of mysql binlog we have set
> sync_binlog=1. so every sql commit will call fsync() to flush to disk.
>
> according to your description. if we reboot the server A, the two disk
> data on different server will be the same.
> but after the server A restarted, we assemble the two disk on two
> server, data is different on the two server, disk on server B lost
> more than one sql commit.
>
> I have checked it with strace 'mysqld' on Server A.
> I found a sql commit and fsync() on binlog file handle on server A but
> this sql can not find in assembled disk on server B.
>
> I also test it with two SAS disk, Server B still has more than one sql
> commit lost.
Sounds like you might be better using something like DRBD (www.drbd.org) 
which has different modes, one of which will do what you are asking (not 
respond until both systems have confirmed the data is written to the 
local disk).

In your current case, even if md is correctly writing to both underlying 
'devices' you have multiple layers under one of the devices, so you 
should confirm that *all* of those layers are properly passing through 
the data without any caching/etc.

Regards,
Adam
