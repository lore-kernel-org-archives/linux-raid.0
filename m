From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: mdadm rebuild
Date: Sun, 8 Dec 2013 21:56:29 +0000
Message-ID: <21156.60173.349991.503828@tree.ty.sabi.co.uk>
References: <B49ACD0F-BAD8-4D61-B87C-A06295B58A56@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B49ACD0F-BAD8-4D61-B87C-A06295B58A56@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> I am wondering whether it is possible for mdadm to
> auto-rebuild a failed raid1 driver upon its replacement with a
> new drive?

MD or 'mdadm' or something else?

> The goal is to get mdadm software raid1 to behave the same as
> hardware raid1, when replacing failed hard drive.

The crucial difference between hw RAID and MD RAID is that with
hw RAID all members of a RAID set are attached the same card,
while MD can build RAID sets that span several cards,
potentially on all host adapters.

This means that while it may be appropriate for a hw RAID card
to assume that any new drives it sees are for one of the RAID
sets it defines, for MD RAID it is not appropriate to use *any*
drive added to a system to add to one of its RAID sets.

> It should automatically detect new drive and rebuild the new
> drive into part of raid1 [ ... ]

That already happens with "spare" drives, and MD itself does it.
The point with that is that "spare" drives are already marked by
'mdadm' as drives usable by MD, so MD knows that they are to be
used for its RAID sets; and they can be marked by the list of
RAID sets they are usable for.

Because in general there is a some reluctance to have a default
behaviour that takes *any* drive added to a system and adds it
to any MD RAID set.

If you want really to do that, you could add a suitable 'udev'
rule for a script that is triggered on a device insertion,
checks it, and invokes 'madm' to add it as a spare. Then if
there is a missing member in a related RAID set, MD will make
use of that spare.
