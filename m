From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: switching root fs '/' to boot from RAID1 with grub
Date: Wed, 31 Oct 2007 16:01:52 +0100
Message-ID: <20071031160152.764e2a45@absurd>
References: <20071030210721.386ca2fa@absurd>
	<1193781699.10336.585.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193781699.10336.585.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks!

It all worked really great, I had to correct only one typo:

> device /dev/sda (hd0)

into this:

  device (hd0) /dev/sda

I have debian etch here, and I didn't have to rebuild initrd kernel.
Also I didn't have to disconnect hda drive, I just selected a
different boot device during boot (without even going into bios, or
opening the case).

In fact.. the only "trouble" I had here is that I needed to connect a
PS2 keyboard to this box ;-) (it's a just a backup machine)


And now I have a full RAID1 array. Now just two questions:

1. when I `shutdown -r now` I see a worrying message at the end:

    Stopping array md2 .... done (stopped)
    Stopping array md1 .... done (stopped)
    Stopping array md0 .... failed (busy)
    Will now reboot
    md: Stopping all md devices
    md: md0 still in use
  
    <reboots>

   Is that ok ?

2. Will grub update all drives automatically, for instance when I will
   upgrade kernel by 'aptitude upgrade'? Or do I need to repeat your
   grub instructions each time a new kernel is installed?


thanks again!
-- 
Janek Kozicki                                                         |
