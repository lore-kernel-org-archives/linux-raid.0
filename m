From: Duncan Laurie <duncan@sunbalt.net>
Subject: Re: Problems with RAID1 on cobalt raq3
Date: 19 Aug 2002 20:56:41 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1029815801.7736.13.camel@atherton>
References: <200208172056.g7HKuHm05754@raq.iceblink.org>
	<1029625780.14769.134.camel@atherton>  <20020819083834.GM26818@jinny.ie>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20020819083834.GM26818@jinny.ie>
To: valen@tuatha.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2002-08-19 at 01:38, John P. Looney wrote: 
>
>  First off set_boot_dev was used to set the boot device to hda2 (I 
> tryed hda1, and as you pointed out, you can't move the root device
> easily to hda2 later).
> 
>  I had originally planned that hda1 was /boot and hda2 was / - in the end,
> to get *anything* booting, I'd to copy the /boot files into a /boot
> directory on the / filesystem, and write off hda1 as a waste of disk
> space.

I think you want this to be md1, but to do that and have the kernel on
a separate device (not a member of the raid set) will require you to 
override the root device for the ROM kernel with set_lparams. 

I was incorrect in saying that "set_boot_dev md1" does not have the same 
effect as "set_params root=/dev/md1", what I was seeing is actually a bug 
in the ROM.  When you run "set_boot_dev md1" it updates the major/minor 
bytes in CMOS, but it does not set the variable that is used to create 
the zero-page.  This means it will have the stale value until it is 
rebooted. (this is with a 2.9.x ROM, I am not sure about 2.3.40) 

>  Woo-hoo. Exactly what I wanted. I think.
> 
>  So, do I do 
> 
>      set_boot_dev hda1                      (/boot)
>      set_params "root=/dev/md0 ro"         
> 
>  And that should do what I've been trying to do ? Or do I have to change
> the paramters to the ROM kernel also ?

I would try this:

	set_boot_dev md1
	[reboot here - bug workaround]
	set_lparams root=/dev/hda1

(this is assuming hda1 is /boot, and hda2+hdg1=md1 is /)

The problem with this solution is you no longer get the ability to boot
autonomously.  The different root device is not saved in CMOS so has to
be re-entered each time.

-duncan
