From: Thomas Harold <thomas-lists@nybeta.com>
Subject: Re: 2.6.39: raid1 check blocks jbd on other md more than 120 seconds
Date: Fri, 03 Jun 2011 08:08:01 -0400
Message-ID: <4DE8CEA1.9090906@nybeta.com>
References: <20110602093644.GA8620@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110602093644.GA8620@janus>
Sender: linux-raid-owner@vger.kernel.org
To: Frank van Maarseveen <frankvm@frankvm.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/2/2011 5:36 AM, Frank van Maarseveen wrote:
> The system runs FC14 with an (almost) stock 2.6.39 kernel, configured to
> panic if it seems to hang. That's exactly what started to happen without
> anything being logged in the normal way except over netconsole.
>
> /proc/mdstat:
> Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4]
> md3 : active raid1 sda3[0] sdb3[1]
>        1885338488 blocks super 1.2 [2/2] [UU]
>
> md1 : active raid1 sda1[0] sdb1[1]
>        33555384 blocks super 1.2 [2/2] [UU]
>
> kernel messages:
> 	(/etc/cron.weekly/99-raid-check kicks in)
> Jun  2 04:04:00 janus md: data-check of RAID array md3
> Jun  2 04:04:00 janus md: delaying data-check of md1 until md3 has finished (they share one or more physical units)
> Jun  2 04:04:00 janus md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> Jun  2 04:04:00 janus md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
> Jun  2 04:04:00 janus md: using 128k window, over a total of 1885338488 blocks.
> Jun  2 04:55:54 janus INFO: task jbd2/md1-8:1188 blocked for more than 120 seconds.
> Jun  2 04:55:54 "echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Jun  2 04:55:54 janus jbd2/md1-8     D

That's a bug that you'll see in CentOS/RHEL in cases where there are 
multiple arrays to be checked, that use the same set of disks.  I first 
saw it in CentOS 5.5 (or maybe 5.6).

https://bugzilla.redhat.com/show_bug.cgi?id=573106

It's an annoying message, but the weekly raid sync runs fine.
