From: Ian Dall <ian@beware.dropbear.id.au>
Subject: Re: raid=noautodetect is apparently ignored?
Date: Wed, 27 Jun 2007 00:23:51 +0930
Message-ID: <1182869632.4115.20.camel@sibyl.beware.dropbear.id.au>
References: <1182837145.3627.27.camel@sibyl.beware.dropbear.id.au>
	 <18048.46195.870920.626128@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18048.46195.870920.626128@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ha! I think I have almost figured this out and it is to do with initrd.
I went back to 2.16.17 kernel, which I happened to have the source tree
for, and put in some printks.

First, if there is a ramdisk, the kernel doesn't auto detect
raids /regardless/ of whether raid=noautodetect is specified or not.

This is because md_run_setup() is never called, which in turn is because
of the following code in init/main.c  

	 * check if there is an early userspace init.  If yes, let it do all
	 * the work
	 */

	if (!ramdisk_execute_command)
		ramdisk_execute_command = "/init";

	if (sys_access((const char __user *) ramdisk_execute_command, 0) != 0) {
		ramdisk_execute_command = NULL;
		prepare_namespace();   /* which eventually calls md_run_setup() */
	}

The only other way the kernel's raid autodetection can be triggered is
from userspace with a RAID_AUTORUN ioctl. Something in the initrd is
sending the ioctl. It must be one of the functions of nash, but I don't
have the source handy to check.

This all seems reasonable enough, but it would be good if the
documentation for md mentioned that the options would be ignored if you
use an initrd.

One thing, changing the partition type seems to have fixed my immediate
problem.

Ian

On Tue, 2007-06-26 at 16:38 +1000, Neil Brown wrote:
> On Tuesday June 26, ian@beware.dropbear.id.au wrote:
> > When I try and disable auto detection, with kernel boot parameters, it
> > goes ahead and auto assembles and runs anyway. The md= parameters seem
> > to be noticed, but don't seem to have any other effect (beyond resulting
> > in a dmesg).
> 
> Odd....
>  Maybe you have an initrd which is loading md as a module, then
>  running "raidautorun" or similar?
> 
> > 
> > This is driving me nuts. Maybe changing the type of the hda partitions
> > would help?
> 
> Definitely.  Change the partition types.
> 
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Ian Dall <ian@beware.dropbear.id.au>
