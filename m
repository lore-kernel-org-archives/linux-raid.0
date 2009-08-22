From: Kyle Liddell <kyle@foobox.homelinux.net>
Subject: Re: linux disk access when idle
Date: Sat, 22 Aug 2009 01:02:44 -0400
Message-ID: <1250917364.2889.29.camel@athlon>
References: <20090820163522.GA29215@sewage>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090820163522.GA29215@sewage>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 2009-08-20 at 11:35 -0500, Matt Garman wrote:
> So what I'm trying to figure out is, what is causing the disk
> access?  It could be any one of:
> 
>     - Kernel
>     - RAID subsystem (i.e. md)
>     - XFS filesystem
>     - NFS
>     - Samba
>     - ???

For one, syslogd.  
It's probably worthwhile to look up information for laptop power saving.
In particular, laptop-mode in the kernel, and laptop-mode-tools:
http://samwel.tk/laptop_mode
I use this on my laptop, and I don't think I ever have a "surprise" disk
spinup.  The whole laptop-mode-tools setup is probably much more than
you want, but it's a good place to start.  The FAQ there also mentions
how to get syslog to stop syncing to disk.  
You may also find 'lm-profiler' useful - this will tell you the which
process is causing disk accesses.  Finally, for general power saving,
'powertop' tracks the power state information for your CPU, and will
list the processes that are causing your CPU to come out of any
sleep/idle states.



