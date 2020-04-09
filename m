From: Phil Turmel <philip@turmel.org>
Subject: Re: Repairing a RAID1 with non-zero mismatch_cnt, vol. 2
Date: Wed, 8 Apr 2020 21:06:55 -0400
Message-ID: <f620910d-52be-6e50-2dee-7c7faf3074ee@turmel.org>
References: <CADSg1Jh1i+OPq0_hWOvHxK0xroUbn_w0_ZjxjwcnrbSsBXGY5A@mail.gmail.com>
 <5E25876A.1030004@youngman.org.uk>
 <CADSg1Jj3XmD_RmSedn3AT9uCXbHQGa6ATBK1UP33onS8Vi=60g@mail.gmail.com>
 <CADSg1Jh7=6XHXbDqWVWg=fa-+09Vd9E+KBuTy6AWucJesFkBmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADSg1Jh7=6XHXbDqWVWg=fa-+09Vd9E+KBuTy6AWucJesFkBmQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: andrewbass@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Andrew,

On 4/8/20 6:13 PM, Andrey ``Bass'' Shcheglov wrote:
> Greetings,

[trim /]

> Okay, so far, so good. I don't have any data, so a repair action can't
> possibly harm it.
> 
>> echo repair >>/sys/block/md4/md/sync_action
> 
> And the value of mismatch_cnt is still 384.
> 
> My first guess was that one of the hard drives was degrading, but
> SMART attributes of both disks are ok (and nearly identical).
> 
> 
> Can you please propose the explanation of the non-zero value?
> And what else can I do to finally make it drop to zero (w/o
> reassembling the whole array)?

This has always been a phenomenon possible with raid1, particularly when 
swap is involved anywhere on top, but also where filesystems don't 
exactly fill the raid device.  Tail-packing inodes can leave strays, too.

My understanding is that it is an artifact of abandoned writes from 
buffer cache, where the write to at least one mirror made it to the 
device, but not to all mirrors.  Logically harmless, except when scrubbing.

If it bothers you that much, fail one device, fill the entire device 
with zeroes (dd with bs=512), then repartition, --add and wait for 
rebuild complete.  Then fail and do the same with the other.  Use 
--replace with a temporary third device if degraded is too risky.

Phil
