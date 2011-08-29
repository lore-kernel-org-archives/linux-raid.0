From: NeilBrown <neilb@suse.de>
Subject: Re: MD devnode still present after 'remove' udev event, and mdadm
 reports 'does not appear to be active'
Date: Tue, 30 Aug 2011 07:25:57 +1000
Message-ID: <20110830072557.428fab35@notabene.brown>
References: <CAGRgLy4K-sFpeHhu_f+7-F8Fa_L1OP7ki0X-_9858BbBQrnWOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy4K-sFpeHhu_f+7-F8Fa_L1OP7ki0X-_9858BbBQrnWOA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 29 Aug 2011 20:17:34 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Greetings everybody,
> 
> I issue
> mdadm --stop /dev/md0
> and I want to reliably determine that the MD devnode (/dev/md0) is gone.
> So I look for the udev 'remove' event for that devnode.
> However, in some cases even after I see the udev event, I issue
> mdadm --detail /dev/md0
> and I get:
> mdadm: md device /dev/md0 does not appear to be active
> 
> According to Detail.c, this means that mdadm can successfully do
> open("/dev/md0") and receive a valid fd.
> But later, when issuing ioctl(fd, GET_ARRAY_INFO) it receives ENODEV
> from the kernel.
> 
> Can somebody suggest an explanation for this behavior? Is there a
> reliable way to know when a MD devnode is gone?

run "udevadm settle" after stopping /dev/md0  is most likely to work.

I suspect that udev removes the node *after* you see the 'remove' event.
Sometimes so soon after that you don't see the lag - sometimes a bit later.

NeilBrown

> 
> Thanks,
>   Alex.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

