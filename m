From: Igor Podlesny <for.poige+linux@gmail.com>
Subject: Re: Hi! Why having LSR's chunk size 2^n limitation?
Date: Wed, 19 Jan 2011 00:23:48 +0700
Message-ID: <AANLkTimn9j08BPvE0hZdBk3NvqJ6_iQELQczBOA8LruO@mail.gmail.com>
References: <AANLkTi=Nk_4vNH5BpHj5fMJxOaSAGjuiSD8agbACdzaQ@mail.gmail.com> <4D35C9BB.20908@anonymous.org.uk>
Reply-To: for.poige+linux@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D35C9BB.20908@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19 January 2011 00:11, John Robinson <john.robinson@anonymous.org.uk> wrote:
> On 18/01/2011 15:59, Igor Podlesny wrote:
[...]
> You're slightly confusing things. Stripe size and chunk size are different
> things, but related. Stripe size = number of data discs * chunk size. Linux
[...]

   Am I? Take a look
http://www.freebsd.org/cgi/man.cgi?query=vinum&apropos=0&sektion=0&manpath=FreeBSD+4.9-RELEASE&format=html
   Also man mkfs.xfs is recommended too.

   (I wonder how would ya imagine 4k stripe sized RAID-5. Really worth
looking at. :-)

> Secondly, as far as I know all Linux filesystems are RAID-aware so know how

   You're mistaken. There're too many are not. Also, don't forget
LVM-2 in middle.

> to distribute their superblocks and other metadata evenly across all the
> discs, so they've already got any performance improvement that might be had.
>
> Cheers,
>
> John.

   P. S. I think now everyone can see why this letter was
intentionally addressed to the author of LSR, not to the list.

-- 
End of message. Next message?
