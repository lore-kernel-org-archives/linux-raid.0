From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Panicked and deleted superblock
Date: Sun, 30 Oct 2016 22:11:03 +0100
Message-ID: <20161030211103.GA7196@metamorpher.de>
References: <0e68051d-1008-cf9b-1f8f-0a0736b1c58f@gmx.net>
 <20161030194326.GA6727@metamorpher.de>
 <7f1dd791-ed1c-5db6-555d-ed377995420e@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7f1dd791-ed1c-5db6-555d-ed377995420e@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Hoffmann <Hoffmann.P@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Oct 30, 2016 at 09:45:27PM +0100, Peter Hoffmann wrote:
> there shouldn't anything be lost as growing consumes more
> than it writes, stripe wise speaking

That's what I meant by 'overlap' - it's the wrong word I guess.

> /dev/sda2 --luks--> /dev/mapper/HDD_0 \
> /dev/sdb2 --luks--> /dev/mapper/HDD_1 --raid--> /dev/md127 -ext4-> /raid
> /dev/sdc2 --luks--> /dev/mapper/HDD_2 /

You're hoping it be faster since three threads instead of one?
Adds the overhead of encrypting parity. Not sure if worth it.
This idea belongs to another era (before AES-NI).

But it's good, that way, you have "unencrypted" data on your RAID and can 
make deductions from that raw data as to chunk size and such things. 

> * anything else?

This is where I don't know how to provide specific help.
Since you did not provide specific data I can work with.
Your data offset sounds strange to me but with overlay, 
it's faster to just go ahead and try.

You'll have to figure out the details by yourself, pretty much.

Once you have the correct offset you might be able to deduct the other 
offset. Create 4 loop devices size of your disks (sparse files in tmpfs, 
truncate -s thefile, losetup), create a 3 disk raid, grow to 4 disks, 
check with mdadm --examine if & how the data offset changed.

> So I'm looking for a sequence of bytes that is duplicated on both
> overlays. This way I find the border between both parts.

Yes, there should be an identical region (let's hope not zeroes)
and you should roughly determine the end of that region and that's 
your entry point for a linear device mapping.

Regards
Andreas Klauer
