From: Tyler <pml@dtbb.net>
Subject: Re: confused raid1
Date: Mon, 15 Aug 2005 09:41:58 -0700
Message-ID: <4300C5D6.3090706@dtbb.net>
References: <Pine.LNX.4.61.0508151131020.10349@soloth.lewis.org> <4300BC7E.6030009@dtbb.net> <Pine.LNX.4.61.0508151202160.10349@soloth.lewis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0508151202160.10349@soloth.lewis.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Lewis <jlewis@lewis.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Try this suggestion (regarding modules.conf).

https://www.redhat.com/archives/fedora-list/2003-December/msg05205.html

Tyler.

Jon Lewis wrote:

> On Mon, 15 Aug 2005, Tyler wrote:
>
>> A few questions:
>>
>> a) what kernel version are you using?
>> b) what mdadm version are you using?
>> c) what messages conscerning the raid are in the log when its failing
>> one of the drives and making hdc1 an active drive?
>> d) what linux distribution (and version) are you using?
>
>
> The server is RH 8.0.  The kernel is a 3rd party "meant for RH 8" one, 
> 2.4.20-28_36.rh8.0.atsmp.  We've had alot of issues with drivers for 
> the QLA2100 FC host adapter and XFS, so I'm somewhat hesitant to try 
> different kernels.  Last one we tried was a 2.4.31 snapshot from SGI's 
> cvs (supposed to have the latest/greatest XFS driver, and I'd added 
> the latest QLA2100 driver module from qlogic to it).  In that kernel, 
> NFS export of XFS was broken.  Clients could mount, but not actually 
> read files.
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
> Aug  9 02:02:39  kernel: md: superblock update time inconsistency -- 
> using the most recent one
> Aug  9 02:02:39  kernel: md: freshest: hde1
> Aug  9 02:02:39  kernel: md: kicking non-fresh hdg1 from array!
> Aug  9 02:02:39  kernel: md: unbind<hdg1,2>
> Aug  9 02:02:39  kernel: md: export_rdev(hdg1)
> Aug  9 02:02:39  kernel: md: RAID level 1 does not need chunksize! 
> Continuing anyway.
> Aug  9 02:02:39  kernel: kmod: failed to exec /sbin/modprobe -s -k 
> md-personality-3, errno = 2
> Aug  9 02:02:39  kernel: md: personality 3 is not loaded!
> Aug  9 02:02:39  kernel: md :do_md_run() returned -22
> Aug  9 02:02:39  kernel: md: md1 stopped.
> Aug  9 02:02:39  kernel: md: unbind<hde1,1>
> Aug  9 02:02:39  kernel: md: export_rdev(hde1)
> Aug  9 02:02:39  kernel: md: unbind<hdc1,0>
> Aug  9 02:02:39  kernel: md: export_rdev(hdc1)
> Aug  9 02:02:39  kernel: md: ... autorun DONE.
>
> mdadm - v1.4.0 - 29 Oct 2003 (not exactly the latest)
>
> ----------------------------------------------------------------------
>  Jon Lewis                   |  I route
>  Senior Network Engineer     |  therefore you are
>  Atlantic Net                | _________ 
> http://www.lewis.org/~jlewis/pgp for PGP public key_________
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
No virus found in this outgoing message.
Checked by AVG Anti-Virus.
Version: 7.0.338 / Virus Database: 267.10.9/72 - Release Date: 8/14/2005

