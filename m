From: antlists <antlists@youngman.org.uk>
Subject: Re: Grow array and convert from raid 5 to 6
Date: Sun, 1 Mar 2020 20:16:55 +0000
Message-ID: <cf69979e-8df7-31f4-a2f0-a6187aef6f6d@youngman.org.uk>
References: <CALc6PW7C30Z6bccQLXLPf8zYuM=aBVZ_hLgW3i5gqZFVsLRpfA@mail.gmail.com>
 <fa393999-3f56-0bcf-b097-462a209f1eae@youngman.org.uk>
 <20200302004806.54852908@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200302004806.54852908@natsu>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: William Morgan <therealbrewer@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/03/2020 19:48, Roman Mamedov wrote:
> On Sun, 1 Mar 2020 19:07:56 +0000
> antlists <antlists@youngman.org.uk> wrote:
>   
>> --add disk2 ..." to give an array with 4 active drives and 4 spares.
>> Then you can upgrade to raid 6 - "--grow --level=6 --raid-devices=8".
> This feels risky and unclear, for instance what will be the array state if 2
> disks fail during this conversion? Would it depend on which ones have failed?
>
> Instead I'd suggest doing this in two steps. First and foremost, add one disk
> and convert to RAID6 in a special way:
>
>    --grow --level=6 --raid-devices=5 --layout=preserve
I didn't know about that ...
>
> ...due to the last bit (see the man page), this will be really fast and will
> not even rewrite existing data on the old 4 disks; But you will get a
> full-blown RAID6 redundancy array, albeit with a weird on-disk layout.
>
> Then add 3 remaining disks, and
>
>    --grow --level=6 --raid-devices=8 --layout=normalise
>
> Additionally, before you even begin, consider do you really want to go with
> such a setup in the first place. I used to run large RAID6s with a single
> filesystem on top, but then found them to be too much of a single point of
> failure, and now moved on to merging individual disks on the FS level (using
> MergerFS or mhddfs) for convenience, and doing 100% backups of everything
> for data loss protection. Backups which you have to do anyway, as anyone will
> tell you RAID is not a replacement for backup; but with a RAID6 there's too
> much of a temptation to skimp on them, which tends to bite badly in the end.
> Also back then it seemed way too expensive to backup everything, now with
> todays HDD sizes and prices that's no longer so.

Or use lvm to claim the new space, move all the old partitions into lvm, 
and use that to manage the raid. Okay, you still need to take backups to 
protect against a raid failure, but that makes backups to protect 
against accidental damage dead easy - lvm just takes copy-on-write copies.

Cheers,

Wol
