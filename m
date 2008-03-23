From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: component growing in raid5
Date: Sun, 23 Mar 2008 11:24:04 +0000
Message-ID: <18406.15828.841849.122546@tree.ty.sabi.co.uk>
References: <47E5FFB8.5030903@bteam.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47E5FFB8.5030903@bteam.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

>     * leaf nodes composes raid5 arrays from their disks, and
>       export it as a iSCSI target
>     * the root node creates a raid5 on top of the exported
>       targets

That's "amazing" to say the least. A way to prove that
syntactically valid setups can and do work. I am particularly
"amazed" by the idea of using a whole RAID5 subarray just for
parity on the top level RAID5.

> in this setup i will have to face that an array component
> can(and would) grow, [ ... ]

This idea seems to me beyond "amazing", and I think that even
"stunning" is an understatement.

kirk> one more thing: when i first assembled the array with
kirk> 4096KB chunks,

Indeed, 4MiB chunk sizes are syntactically possible, and it is a
rather "exciting" choice, especially for a RAID55.

[ ... ]
>			cryptsetup luksFormat /dev/md0 key				||	exit 1

Even more "amazing", using 'dm-crypt' over an already "stunning"
setup.

[ ... ]
>			mkfs.xfs $FS_DEV

Entirely consistently, the syntactically valid setup above is
used for a single (presumably very large) filesystem. Very
"courageous".

Surely there must be extraordinarily good reasons for building a
RAID55 with 4MiB chunk (with "amazing" performance for writes,
and "stunning" resilience) and with the expectation that one
will extend it by growing each subarray, triggering a full
two-level reshape every time, and putting 'dm-crypt' and a
single filesystem on top of it all.

It would be interesting to learn those reasons for people like
me whose imagination is limited by stolid pragmatics.
