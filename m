From: "Ravi (Tom) Hale" <ravi@hale.ee>
Subject: Re: Fault tolerance with badblocks
Date: Fri, 5 May 2017 11:03:05 +0700
Message-ID: <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
 <590B3039.3060000@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <590B3039.3060000@youngman.org.uk>
Content-Language: en-AU
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/05/17 20:44, Wols Lists wrote:
> On 04/05/17 11:04, Ravi (Tom) Hale wrote:
>> Is there a way of having blocks from a spare device automatically
>> replacing bad blocks when they are next written to (like SMART does for
>> HDDs)?
> 
> What quite do you mean?

I mean: should a bad block be identified, any writes to that virtual
block are redirected to another good LBA block held in a spare pool
which would need to be inaccessible for other purposes (so that they are
indeed spare).

>> Or would mdadm be able to add a "badblocks layer" to btrfs in some other
>> way?
> 
> No. With modern hard drives, no filesystem should pay any attention to
> badblocks - it's all handled in the drive firmware.

ext4 supports this, and is a relatively modern filesystem released in
December 2008. While it could be argued that this is for legacy support,
This feature still adds value (see below).

> mdadm has had a lot of grief with its handling of badblocks,
> and getting drives confused, and it's all totally unnecessary anyway.

The use case is simple: What if I want to have more goodblocks to
correct for badblocks than Seagate thinks I should have?

Eg, a charity or poor student wanting to get the most out of their old
hardware.

In my case, I don't care about actual data loss (RAID0).

However, in the usual case, running RAID 1, 5 or 6 with a pool of spare
goodblocks would allow extending the life of hardware considerably while
still providing a poor-man's margin of redundancy.

> Let the drive worry about what blocks are bad. One major point behind
> LBA is it hides the actual disk layout from the computer, and allows the
> drive to relocate blocks that aren't working properly. Let it do its job.

Until it can't do its job any more because it runs out of its
manufacturer determined fixed-size spare pool. Yes there are things to
consider for performance like having the physical good sector being
close to the physical bad sector, so a spare data area could be
allocated every N usable data areas.

And perhaps I could write that one day. :)

>> My use case is mining storj - I don't mind some data loss.
> 
> Using a badblock list will have no impact on this whatsoever.

A corrupted file is a corrupted file, and can be deleted at minimal
loss. I just don't want the next file being corrupted by the same badblock.

-- 
Tom
