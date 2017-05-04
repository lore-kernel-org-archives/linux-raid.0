From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Fault tolerance in RAID0 with badblocks
Date: Thu, 4 May 2017 14:44:25 +0100
Message-ID: <590B3039.3060000@youngman.org.uk>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
Sender: linux-raid-owner@vger.kernel.org
To: "Ravi (Tom) Hale" <ravi@hale.ee>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/05/17 11:04, Ravi (Tom) Hale wrote:
> Since btrfs doesn't support badblocks, this btrfs mailing list post[1]
> suggested to use mdadm RAID0 3.1+.

Having read the email you linked to, I don't think mdadm will be any
help at all ...
> 
> Is there a way of having blocks from a spare device automatically
> replacing bad blocks when they are next written to (like SMART does for
> HDDs)?

What quite do you mean?
> 
> Or would mdadm be able to add a "badblocks layer" to btrfs in some other
> way?

No. With modern hard drives, no filesystem should pay any attention to
badblocks - it's all handled in the drive firmware. Badblocks is an
unfortunate legacy from the past when drives really were CHS, and the
layer above needed some way of knowing which blocks were bad and should
be avoided. mdadm has had a lot of grief with its handling of badblocks,
and getting drives confused, and it's all totally unnecessary anyway.

Let the drive worry about what blocks are bad. One major point behind
LBA is it hides the actual disk layout from the computer, and allows the
drive to relocate blocks that aren't working properly. Let it do its job.

If you want to use raid, don't bother with 0. Use mdadm and raid 5 or 6
to combine your drives, and create a btrfs filesystem on top. (Don't
bother with raid1 - that part of btrfs apparently works well, so use the
filesystem variant, not an external one.)
> 
> My use case is mining storj - I don't mind some data loss.

Using a badblock list will have no impact on this whatsoever.
> 
> [1] https://www.spinics.net/lists/linux-btrfs/msg40909.html
> 
Cheers,
Wol
