From: Mike Hardy <mhardy@h3c.com>
Subject: Re: RAID5 drive failure, please verify my commands
Date: Sun, 16 Jan 2005 15:13:42 -0800
Message-ID: <41EAF526.2000707@h3c.com>
References: <7C8198B3-67EA-11D9-9A87-00039363AEBE@bitart.com> <41EADBAE.6070400@h3c.com> <F856C764-680B-11D9-9A87-00039363AEBE@bitart.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F856C764-680B-11D9-9A87-00039363AEBE@bitart.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids




Gerd Knops wrote:

> Seems to be a whole slew of bad sectors, here is what the log says:

I typically get bad sectors in little mini-batches. Under a hundred - 
typically 40 or so in one chunk. There are 8 sectors per block, and I 
guess when a block goes, whatever took it out (some dust or something? a 
bad alignment of metal in the media?) gets the blocks near it too.

Anyway, it still looks to me like its semi-normal. Definitely check out 
the bad block howto and (after removing the drive from the array) try 
doing a dd if=/dev/sda of=/dev/null bs=4096 skip=(whatever the sector is 
divided by 8) count=1

You should see the read errors in the log then, that verifies that 
you've got the right offset in the disk.

At that point, do a dd if=/dev/zero of=/dev/sda bs=4096 skip=(sector 
address divided by 8) count=1

If you repeat the read after that block write, the read should succeed - 
you've told the drive you don't need that data any more (you wrote into 
the block) so it shouuld be able to reallocate

If you take that single-block idea, and expand it to the first block 
address and a count= number that includes all the bad blocks, you should 
clear them all

??

Or the drive is shot :-). Without a SMART self-test and a check of the 
results where you can really interrogate the drive, its hard to say

Glad this helps though

-Mike
