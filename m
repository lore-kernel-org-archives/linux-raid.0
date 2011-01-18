From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Hi! Why having LSR's chunk size 2^n limitation?
Date: Tue, 18 Jan 2011 18:05:47 +0000
Message-ID: <4D35D67B.20004@anonymous.org.uk>
References: <AANLkTi=Nk_4vNH5BpHj5fMJxOaSAGjuiSD8agbACdzaQ@mail.gmail.com> <4D35C9BB.20908@anonymous.org.uk> <AANLkTimn9j08BPvE0hZdBk3NvqJ6_iQELQczBOA8LruO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimn9j08BPvE0hZdBk3NvqJ6_iQELQczBOA8LruO@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: for.poige+linux@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/01/2011 17:23, Igor Podlesny wrote:
> On 19 January 2011 00:11, John Robinson<john.robinson@anonymous.org.uk>  wrote:
>> On 18/01/2011 15:59, Igor Podlesny wrote:
> [...]
>> You're slightly confusing things. Stripe size and chunk size are different
>> things, but related. Stripe size = number of data discs * chunk size. Linux
> [...]
>
>     Am I? Take a look
> http://www.freebsd.org/cgi/man.cgi?query=vinum&apropos=0&sektion=0&manpath=FreeBSD+4.9-RELEASE&format=html

Why should I be reading FreeBSD man pages when this is a Linux list? I 
am using the terms stripe size and chunk size in the sense I understand 
them, which is I believe the Linux sense. If you and FreeBSD choose to 
use the terms differently, so be it, but please don't pull me up about 
my use of terms when you're the one using the wrong ones in this context.

[...]
>> Secondly, as far as I know all Linux filesystems are RAID-aware so know how
>
>     You're mistaken. There're too many are not.

I'll concede, only all the major filesystems you'd ever use in a 
production environment.

> Also, don't forget
> LVM-2 in middle.

Not a problem, the same mechanisms by which filesystems can be aware of 
RAID means filesystems are aware of LVM and LVM is aware of RAID.

>     P. S. I think now everyone can see why this letter was
> intentionally addressed to the author of LSR, not to the list.

There's absolutely no need for that. Please leave, and take your 
condescension, ignorance and offensiveness with you.

Cheers,

John.
