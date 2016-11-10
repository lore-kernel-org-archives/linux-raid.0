From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Help in recovering a RAID5 volume
Date: Thu, 10 Nov 2016 18:58:28 +0000
Message-ID: <5824C354.3060209@youngman.org.uk>
References: <CA+GmhESH-2hDJrOjvNzVBsgCP65BnUE2AbfOZ1Bbrp02jyBNUQ@mail.gmail.com>
 <5824A918.3030300@youngman.org.uk>
 <CA+GmhESqEQd6J3CSteR08qw907NnC7r1ewecs3NkWUmpei6BVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+GmhESqEQd6J3CSteR08qw907NnC7r1ewecs3NkWUmpei6BVw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Felipe Kich <fkich1977@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/11/16 17:47, Felipe Kich wrote:
> Hi Anthony,
> 
> Thanks for the reply. Here's some answers to your questions and also
> another question.
> 
> It really seems that 2 disks are bad, but 2 are still good, according
> to SMART. I'll replace them ASAP.
> For now, I don't need to increase the array size. It's more than
> enough for what I need.
> 
You might find the extra price of larger drives is minimal. It's down to
you. And even 2TB drives would give you the space to go raid-6.

> About the drive duplication, I don't have spare discs available now
> for that, I only have one 4TB disk at hand, so I'd like to know if
> it's possible to create device images that I can mount and try to
> rebuild the array, to test if it would work, then I can go and buy new
> disks to replace the defective ones.

Okay, if you've got a 4TB drive ...

I can't remember what the second bad drive was ... iirc the one that was
truly dud was sdc ...

So. What I'd do is create two partitions on the 4TB that are the same
(or possibly slightly larger) than your sdx1 partition. ddrescue the 1
partition from the best of the dud drives across. Create two partitions
the same size (or larger) than your sdx2 partition, and likewise
ddrescue the 2 partition.

Do a --force assembly, and then mount the arrays read-only. The
partition should be fine. Look over it and see. I think you can do a
fsck without it actually changing anything. fsck will probably find a
few problems.

If everything's fine, add in the other two partitions and let it rebuild.

And then replace the drives as quickly as possible. With this setup
you're critically vulnerable to the 4TB failing. Read up on the
--replace option to replace the drives with minimal risk.
> 
> And sure, I'll send you the logs you asked, no problem.
> 
> Regards.
> 
Ta muchly.

Cheers,
Wol
