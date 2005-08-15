From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: confused raid1
Date: Tue, 16 Aug 2005 08:57:40 +1000
Message-ID: <17153.7652.11545.728235@cse.unsw.edu.au>
References: <Pine.LNX.4.61.0508151131020.10349@soloth.lewis.org>
	<4300BC7E.6030009@dtbb.net>
	<Pine.LNX.4.61.0508151202160.10349@soloth.lewis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Lewis on Monday August 15
Sender: linux-raid-owner@vger.kernel.org
To: Jon Lewis <jlewis@lewis.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 15, jlewis@lewis.org wrote:
> 
> It's quite probable, that before the following reboot, md1 was hdc1 
> and hde1.
> 
> Aug  9 02:02:39  kernel: md: created md1
> Aug  9 02:02:39  kernel: md: bind<hdc1,1>
> Aug  9 02:02:39  kernel: md: bind<hde1,2>
> Aug  9 02:02:39  kernel: md: bind<hdg1,3>
> Aug  9 02:02:39  kernel: md: running: <hdg1><hde1><hdc1>
> Aug  9 02:02:39  kernel: md: hdg1's event counter: 000000b0
> Aug  9 02:02:39  kernel: md: hde1's event counter: 000000b4
> Aug  9 02:02:39  kernel: md: hdc1's event counter: 000000b4
> Aug  9 02:02:39  kernel: md: superblock update time inconsistency -- using the most recent one
> Aug  9 02:02:39  kernel: md: freshest: hde1
> Aug  9 02:02:39  kernel: md: kicking non-fresh hdg1 from array!
> Aug  9 02:02:39  kernel: md: unbind<hdg1,2>
> Aug  9 02:02:39  kernel: md: export_rdev(hdg1)
> Aug  9 02:02:39  kernel: md: RAID level 1 does not need chunksize! Continuing anyway.
> Aug  9 02:02:39  kernel: kmod: failed to exec /sbin/modprobe -s -k md-personality-3, errno = 2
> Aug  9 02:02:39  kernel: md: personality 3 is not loaded!
> Aug  9 02:02:39  kernel: md :do_md_run() returned -22
> Aug  9 02:02:39  kernel: md: md1 stopped.
> Aug  9 02:02:39  kernel: md: unbind<hde1,1>
> Aug  9 02:02:39  kernel: md: export_rdev(hde1)
> Aug  9 02:02:39  kernel: md: unbind<hdc1,0>
> Aug  9 02:02:39  kernel: md: export_rdev(hdc1)
> Aug  9 02:02:39  kernel: md: ... autorun DONE.

So md-personality-3 doesn't get loaded, and the array doesn't get
started at all.  i.e. the 'partition type FD' is not having any
useful effect.

So how does the array get started?  
Are there other message about md later in the kernel logs that talk
about md1 ??

My guess is that 'raidstart' is being used to start the array
somewhere along the line.  'raidstart' doesn't not start raid arrays
reliably.  Don't use it.  Remove it from your system.  It is unsafe.

If you cannot get the raid1 module to be loaded properly, make sure
that 'mdadm' is being used to assemble the array.  It has a much
better chance of getting it right.

NeilBrown

