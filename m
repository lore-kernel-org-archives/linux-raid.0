From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: RFC - Raid error detection and auto-recovery (was Fault tolerance
 with badblocks)
Date: Fri, 12 May 2017 09:31:49 +1000
Message-ID: <4da6b084-e975-0d33-806f-40cf94434559@eyal.emu.id.au>
References: <591314F4.2010702@youngman.org.uk>
 <20170510170744.GB2925@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170510170744.GB2925@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/05/17 03:07, Piergiorgio Sartor wrote:
> On Wed, May 10, 2017 at 02:26:12PM +0100, Wols Lists wrote:
[trim]
>>
>> Coders and code welcome ... :-)
>
> I just would like to stress the fact that
> there is user-space code (raid6check) which
> perform check, possibily repair, on RAID6.

Short summary: the detect/correct options suggested by the OP are valuable.

raid6check is not the same thing. As an exercise I decided to run raid6check
instead of a raid 'check'. It is *very* slow. It seems to read the disks
sequentially (not in parallel).

After running for a day iostat shows the disks are read at about 6.5MB/s each,
which is a fraction of the raw performance of the disks (above 160MB/s).
These are 4TB disks so I expect the run will last about a week?
It probably started faster and will end slower.

A raid check starts at over 140MB/s and ends at above 70MB/s. It completes
in just under 10 hours.

For reference, the smart long test time suggests around 450 minutes (7.5 hours).

I checked iostat when there was no other activity on this array.
Unfortunately the program does not offer any progress option that I can see.

cheers

> bye,
>
>>
>> Cheers,
>> Wol

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
