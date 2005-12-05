From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: what does this mean: ioctl lock interrupted
Date: Mon, 05 Dec 2005 20:12:47 +1100
Message-ID: <4394048F.1090906@eyal.emu.id.au>
References: <43915D75.5040601@eyal.emu.id.au> <17299.44022.145167.504614@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17299.44022.145167.504614@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> If you feel adventurous, you could edit drivers/md/md.c, find
> where it prints that message, and get it to print the string
>   current->comm
> as well. 

Seeing how I was running 'e2fsck -cc /dev/md0' this may not be
a big surprise:

md: ioctl lock interrupted, reason -4, cmd 4705 current->comm='badblocks'
md: ioctl lock interrupted, reason -4, cmd 4705 current->comm='badblocks'
rtc: lost some interrupts at 1024Hz.

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au) <http://samba.org/eyal/>
	attach .zip as .dat
