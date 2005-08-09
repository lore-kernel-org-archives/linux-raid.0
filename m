From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: endianness of Linux kernel RAID
Date: Tue, 9 Aug 2005 14:57:37 +1000
Message-ID: <17144.14273.684705.729233@cse.unsw.edu.au>
References: <20050809044903.97593.qmail@web35308.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Brent Walsh on Monday August 8
Sender: linux-raid-owner@vger.kernel.org
To: Brent Walsh <blinux_adm@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 8, blinux_adm@yahoo.com wrote:
> 
> I have a PowerPC based NAS device that was damaged by
> a recent a brownout.  The drives in the array are
> fine, but the device's firmware was corrupted.  My
> first attempt to assemble the array on my x86 system
> failed due to the endian differences.  After applying
> this patch, the mdadm examine command worked
> perfectly.  As of yet, I have not attempted to update
> the superblocks.  I would like to leave the original
> superblocks intact so that I can reinstall the drives
> in my NAS device when it is repaired.  Is it possible
> to assemble the array without overwriting the
> superblocks?

Not really....  The kernel reads the superblocks to find out the
details of the array.  If it cannot read them, it won't assemble the
array.

Depending on the type of array, you could --build the array instead.
This allows for arrays that deliberately don't have superblocks.
It should work for raid0, might work for linear, could work for raid1,
but no for anything else.

If you want to try it, send me the --examine output. and I'll suggest
a command.

NeilBrown
