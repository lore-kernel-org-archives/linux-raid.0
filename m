From: Christian Pernegger <pernegger@gmail.com>
Subject: Re: unbelievably bad performance: 2.6.27.37 and raid6
Date: Sat, 31 Oct 2009 20:59:39 +0100
Message-ID: <bb145bd20910311259j7b2506c8v4e8907eb73598275@mail.gmail.com>
References: <cccedfc60910310855l5ca6c42aj503fb0e4fd6232ad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60910310855l5ca6c42aj503fb0e4fd6232ad@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> md0 : active raid6 sda4[0] sdc4[5] sdd4[4] sdb4[6]
>      613409536 blocks super 1.1 level 6, 64k chunk, algorithm 2 [4/4]=
 [UUUU]

Why would you use a 4 disk raid6? If 50% of raw capacity is enough
just go with raid10.
The default 64KiB chunk size has always been very slow for me, try
something larger, perhaps even 1MiB.

> While rsyncing a file from an ext3 filesystem to a jfs filesystem,

rsync isn't really a good diagnostic, how's performance with something
simple, dd, bonnie++, whatever?

> I looked at stripe_cache_size and increased it to 384

Much too low, I usually set it to 8192. Take care you don't run out of
RAM, though, it's in pages/disk (16KiB in your case).

> blockdev --getra reports 256 for all involved raid components.

In my experience only the top component of a layered block device
matters at all, that would be the LV. 256 sectors / 128 KiB seems
awfully low, try something higher, 2MiB at least.

> Am I crazy? =C2=A0Is 12.5MB/s (average) what I should expect, here?

No, it's probably just that the default tunining options are not very g=
ood.

Cheers,

C.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
