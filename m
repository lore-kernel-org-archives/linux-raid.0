From: Ethan Wilson <ethan.wilson@shiftmail.org>
Subject: Re: Extremely High mismatch_cnt on RAID1 system
Date: Tue, 07 Oct 2014 15:14:22 +0200
Message-ID: <5433E72E.60805@shiftmail.org>
References: <CAOWcSW5+8ZkWAyXL7VTk9JO+yrozFJS8RwroKqtudkiKD-fvXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOWcSW5+8ZkWAyXL7VTk9JO+yrozFJS8RwroKqtudkiKD-fvXA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/10/2014 15:46, Dennis Grant wrote:
> Hello all.
>
> ...
>
> Even after multiple checks, repairs, and rebuilds, the arrays on the
> bigger drives (/ and /home) are showing insanely high mismatch_cnt
> values. This has me concerned.
>

Dennis,
since nobody more knowledgeable replied, I will try.

Some mismatches on raid1 have been there since always, and nobody ever 
deeply investigated what they were caused by, nor if they happen on 
unallocated filesystem space or on real live data. It seems that if LVM 
is between raid1 and the filesystem then they don't happen anymore, but 
again nobody is really sure of why.

Recently some changes in the raid1 resync algorithm introduced some bugs 
that could possibly generate additional mismatches, but if you haven't 
had resyncs then I am not so sure if such bugs and their fixes are 
relevant. However the fixes are here:
https://www.kernel.org/pub/linux/kernel/v3.x/ChangeLog-3.14.20
search for "raid".

You might want to upgrade to kernel 3.14.20, which is probably not what 
your Ubuntu LTS has currently, then repair the arrays, then see if they 
grow again.
Note that you need to do repair and not check:
echo repair > /sys/block/md0/md/sync_action
at the next "check" the mismatch_cnt should be 0 (not just after 
"repair", because that would count the number of mismatches that have 
been repaired).

I'd say that mismatches in general are pretty worrisome, they shouldn't 
happen, they are likely to indicate corruption, so if what I said 
doesn't work, e.g. mismatches grow again, try to report it again on the 
list and somebody might be able to help further to track down this problem.

Regards
EW

