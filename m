From: Thomas Andrews <tandrews@grok.co.za>
Subject: Re: One partition degraded after every reboot
Date: Thu, 1 Apr 2004 19:52:18 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040401175218.GL9632@gaspode.nextlink.co.za>
References: <406C00E3.4030205@chello.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <406C00E3.4030205@chello.at>
To: Philipp Gortan <gortan@chello.at>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 01, 2004 at 01:45:39PM +0200, Philipp Gortan wrote:

> and created a new initrd
> # mkinitrd -k -r /dev/md0 -o /boot/initrd.img-2.6.3-1-k7

Yes I found I had to do that from the start because the initrd image
from before the raid conversion was set up for a different root device,
so in my case that isn't the solution.

> and ran lilo again

I'm using grub. I wonder if that's a problem ?

-Thomas
