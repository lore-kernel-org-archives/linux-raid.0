From: David Greaves <david@dgreaves.com>
Subject: Re: After partition resize, RAID5 array does not assemble on boot
Date: Wed, 04 Jun 2008 08:58:50 +0100
Message-ID: <48464B3A.7070206@dgreaves.com>
References: <4844E994.8020808@jellybean.co.uk>    <4845B573.7090801@jellybean.co.uk> <48675.192.168.1.70.1212528422.squirrel@neil.brown.name> <484636B9.20700@jellybean.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <484636B9.20700@jellybean.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Jules Bean <jules@jellybean.co.uk>, NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jules Bean wrote:
> As to where my superblock has gone, the only theory I have is that the
> MD layer knew that my partitions were 400G large while the kernel was
> convinced they were 250G large, so the md layer tried to write the
> superblock at (approx) +400G, and the kernel refused to do that.

I failed to do a similar grow operation recently and had to re-create.

I was using 0.9 sb which is stored at the end of the disk.
I have no idea how this is supposed to work...

If I have sda1 at 250Mb then the sb is at 250-d Mb
I'd like to stop the array, remove the partition, grow the partition to 400Mb
and start the array.
This won't work because md won't find an sb at 400-d Mb and so won't know that
it's an md component.

However, with a 1.1 or 1.2 sb I think it would work.

I tried using Michael Tokarev's mdsuper to pull the sb from the partition,
resize and then push it to the end of the new partition but that went wrong
somewhere.


I think the process should be:

1 stop array
2 mdadm --save-superblock=component.sb /dev/<component>
3 grow partition
4 mdadm --write-superblock=component.sb /dev/<component>
5 start array
6 grow array
7 grow fs

For sb 1.1 and 1.2 steps 2+4 should be no-ops
in step 4 mdadm may want to call the reread pt ioctl (which is what blockdev
--rereadpt does)

This approach, it seems to me, would avoid any reconstruction and would be a
'safer' way to grow the components.

If this sounds reasonable then I'd happily have a go at implementing
--save-superblock/--write-superblock

David
