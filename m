From: Neil Brown <neilb@suse.de>
Subject: Re: Creating RAID1 with bitmap fails
Date: Thu, 31 May 2007 09:09:49 +1000
Message-ID: <18014.1085.785167.411655@notabene.brown>
References: <Pine.LNX.4.61.0705301229370.11140@yvahk01.tjqt.qr>
	<18013.26771.126894.425898@notabene.brown>
	<Pine.LNX.4.61.0705301409180.11140@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jan Engelhardt on Wednesday May 30
Sender: linux-raid-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday May 30, jengelh@linux01.gwdg.de wrote:
> 
> On May 30 2007 22:05, Neil Brown wrote:
> >> 
> >> the following command strangely gives -EIO ...
> >> 12:27 sun:~ # mdadm -C /dev/md4 -l 1 -n 2 -e 1.0 -b internal /dev/ram0 
> >> missing
> >> 
> >> md: md4: raid array is not clean -- starting background reconstruction
> >> md4: failed to create bitmap (-5)
> >> md: pers->run() failed ...
> >> mdadm: RUN_ARRAY failed: Input/output error
> >> mdadm: stopped /dev/md4
> >> 
> >> Leaving out -b internal creates the array. /dev/ram0 or /dev/sda5 - EIO 
> >> happens on both. (But the disk is fine, like ram0)
> >> Where could I start looking?
> >> 
> >> Linux sun 2.6.21-1.3149.al3.8smp #3 SMP Wed May 30 09:43:00 CEST 2007 
> >> sparc64 sparc64 sparc64 GNU/Linux
> >> mdadm 2.5.4
> >
> >I'm fairly sure this is fixed in 2.6.2.  It is certainly worth a try.
> 
> The same command works on a x86_64 with mdadm 2.5.3...

Are you sure?
I suspect that the difference is more in the kernel version.
mdadm used to create some arrays with the bitmap positioned so that it
overlapped the data.  Recent kernels check for that and reject the
array if there is an overlap.  mdadm-2.6.2 makes sure not to create
any overlap.

NeilBrown
