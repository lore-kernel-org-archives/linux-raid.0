From: Neil Brown <neilb@suse.de>
Subject: Re: Raid5 Reshape gone wrong, please help
Date: Sat, 18 Aug 2007 18:56:29 +1000
Message-ID: <18118.46141.966406.577626@notabene.brown>
References: <c92bcddf0708171826n5991b3ffw1094e0e8c44c97e8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Greg Nicholson on Friday August 17
Sender: linux-raid-owner@vger.kernel.org
To: Greg Nicholson <d0gz.net@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday August 17, d0gz.net@gmail.com wrote:
> I was trying to resize a Raid 5 array of 4 500G drives to 5.  Kernel
> version 2.6.23-rc3 was the kernel I STARTED on this.
> 
>   I added the device to the array :
> mdadm --add /dev/md0 /dev/sdb1
> 
> Then I started to grow the array :
>  mdadm --grow /dev/md0 --raid-devices=5
> 
> At this point the machine locked up.  Not good.

No, not good.  But it shouldn't be fatal.

> 
> I ended up having to hard reboot.  Now, I have the following in dmesg :
> 
> md: md0: raid array is not clean -- starting background reconstruction
> raid5: reshape_position too early for auto-recovery - aborting.
> md: pers->run() failed ...

Looks like you crashed during the 'critical' period.

> 
> /proc/mdstat is :
> 
> Personalities : [raid6] [raid5] [raid4]
> md0 : inactive sdf1[0] sdb1[4] sdc1[3] sdd1[2] sde1[1]
>       2441918720 blocks super 0.91
> 
> unused devices: <none>
> 
> 
> It doesn't look like it actually DID anything besides update the raid
> count to 5 from 4. (I think.)
> 
> How do I do a manual recovery on this?

Simply use mdadm to assemble the array:

  mdadm -A /dev/md0 /dev/sd[bcdef]1

It should notice that the kernel needs help, and will provide
that help.
Specifically, when you started the 'grow', mdadm copied the first few
stripes into unused space in the new device.  When you re-assemble, it
will copy those stripes back into the new layout, then let the kernel
do the rest.

Please let us know how it goes.

NeilBrown
