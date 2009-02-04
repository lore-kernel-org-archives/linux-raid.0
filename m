From: KwangErn Liew <admin@musmo.com>
Subject: Re: How to start SW raid later in boot?
Date: Wed, 04 Feb 2009 22:47:58 +0100
Message-ID: <498A0D0E.70000@musmo.com>
References: <20090204193039.M36676@estone.ca>
Reply-To: admin@musmo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090204193039.M36676@estone.ca>
Sender: linux-raid-owner@vger.kernel.org
To: michael <michael@estone.ca>
Cc: linuxraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


michael wrote:
  > /dev/md0 assembes just fine except upon a reboot. I'm "guessing" the 
raid
> driver rr232 is loaded after mdadm tries to assemble md0 and therefore
> doesn't fully assemble because the system can't see the pci plugged in 
> drives. dmesg seems to have this order.
> 
> Is there a way to delay the mdadm assemble until after the driver is loaded?
> The / system is on single disk /dev/sda.

Do you have initrd enabled?


KwangErn
