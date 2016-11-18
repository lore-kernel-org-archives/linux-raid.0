From: Andy Smith <andy@strugglers.net>
Subject: Re: Newly-created arrays don't auto-assemble - related to hostname
 change?
Date: Fri, 18 Nov 2016 02:31:44 +0000
Message-ID: <20161118023144.GC1804@bitfolk.com>
References: <20161117035230.GG21587@bitfolk.com>
 <87lgwihc2v.fsf@notabene.neil.brown.name>
 <20161117150954.GH21587@bitfolk.com>
 <87d1hthgm7.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87d1hthgm7.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On Fri, Nov 18, 2016 at 09:43:44AM +1100, NeilBrown wrote:
> Something you could try, after boot and while the arrays are still not
> assembled, is
> 
>   echo change > /sys/block/sdc/uevent
>   echo change > /sys/block/sdd/uevent
> 
> That should cause udev to assemble the array.

Nothing appeared to happen. There was nothing interesting in syslog
or systemd's journal. Here's the output from "udevadm monitor":

$ sudo udevadm monitor
monitor will print the received events for:
UDEV - the event which udev sends out after rule processing
KERNEL - the kernel uevent

KERNEL[12376.719100] change   /devices/pci0000:00/0000:00:01.0/0000:01:00.0/host10/port-10:0/end_device-10:0/target10:0:0/10:0:0:0/block/sdc (block)
UDEV  [12376.722996] change   /devices/pci0000:00/0000:00:01.0/0000:01:00.0/host10/port-10:0/end_device-10:0/target10:0:0/10:0:0:0/block/sdc (block)
KERNEL[12388.329566] change   /devices/pci0000:00/0000:00:01.0/0000:01:00.0/host10/port-10:1/end_device-10:1/target10:0:1/10:0:1:0/block/sdd (block)
UDEV  [12388.333441] change   /devices/pci0000:00/0000:00:01.0/0000:01:00.0/host10/port-10:1/end_device-10:1/target10:0:1/10:0:1:0/block/sdd (block)

> If that doesn't work, the looking over the udev logs, and possibly
> turning on extra udev logging, might lead to an answer.

I don't know how to do that, but I'll look into it - thanks.

Cheers,
Andy
