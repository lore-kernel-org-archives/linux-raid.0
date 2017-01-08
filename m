From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Recommendation on new system Arrays
Date: Sun, 8 Jan 2017 09:07:10 +0000
Message-ID: <5872013E.6000801@youngman.org.uk>
References: <4259f5ef-42f7-ad4c-c8af-7b6e5c19354c@gmail.com>
 <5870BD30.3020302@youngman.org.uk>
 <6017e35e-6328-bf8b-fb25-eb8afbf163ba@gmail.com>
 <db381235-8eb9-3efe-2346-110c13af48d7@hardwarefreak.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <db381235-8eb9-3efe-2346-110c13af48d7@hardwarefreak.org>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.org>, Benjammin2068 <benjammin2068@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/01/17 04:13, Stan Hoeppner wrote:
>>>
>>> This sounds like one of the few use cases where they might be a good
>>> idea. Worth considering, at least. Might even work well in your planned
>>> raid-6 config.
>>>

>> Yea, I thought about that too. So you're suggesting a RAID1 consisting
>> of (2) RAID6 arrays.

> That's not sane.  RAID 10, or more precisely, RAID 0 over many RAID 1
> pairs, will yield more usable capacity and without the parity penalty or
> RMW cycles.

I was actually thinking pure raid-6. Which was Benjammin's original
idea. The thing to bear in mind is that for these drives, rewrite
performance is going to be abysmal, but in this particular scenario
rewriting is going to be unusual, anyway. What we *don't* want with
these drives is RMW.

It's just struck me, this might be where it's worth sticking a small SSD
in front of the array as a journal, and flagging these drives as "write
mostly". But I'm not sure whether this functionality is yet standard or
are the devs still working on it?

Cheers,
Wol
