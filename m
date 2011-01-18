From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Hi! Why having LSR's chunk size 2^n limitation?
Date: Tue, 18 Jan 2011 17:11:23 +0000
Message-ID: <4D35C9BB.20908@anonymous.org.uk>
References: <AANLkTi=Nk_4vNH5BpHj5fMJxOaSAGjuiSD8agbACdzaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=Nk_4vNH5BpHj5fMJxOaSAGjuiSD8agbACdzaQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: for.poige+linux@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/01/2011 15:59, Igor Podlesny wrote:
>     I had experience of using FreeBSD's vinum (another software RAID).
> Its author, Greg Lehey, stated in vinum's manual: "... A good
> guideline for stripe size is between 256 kB and 512 kB.  Avoid powers
> of 2, however: they tend to cause all superblocks to be placed on the
> first subdisk. ..."
>
>     Meanwhile, with LSR we're given exactly 2^n choices, for e. g.,
> neither 768 KiB, nor 387 KiB won't go: "mdadm: invalid chunk/rounding
> value: 387".
>
>     So, why... ($Subj) and how complex would it be to abolish this
> restriction? I think this could be a key to performance increase.

You're slightly confusing things. Stripe size and chunk size are 
different things, but related. Stripe size = number of data discs * 
chunk size. Linux software RAID does insist on a power of two chunk 
size, which is almost certainly done for performance reasons, but 
obviously it can't insist on a power of two stripe size, e.g. a 3-disc 
RAID-0, 4-disc RAID-5 or 5-disc RAID-6 would all have 3 data discs so 
the stripe size won't be a power of two.

Secondly, as far as I know all Linux filesystems are RAID-aware so know 
how to distribute their superblocks and other metadata evenly across all 
the discs, so they've already got any performance improvement that might 
be had.

Cheers,

John.

