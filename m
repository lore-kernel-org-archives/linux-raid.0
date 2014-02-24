From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: feature re-quest for "re-write"
Date: Tue, 25 Feb 2014 07:39:14 +1100
Message-ID: <530BADF2.3090907@eyal.emu.id.au>
References: <alpine.DEB.2.02.1402211903030.15054@uplift.swm.pp.se>	 <530AA09B.3090708@fnarfbargle.com> <530AA460.602@eyal.emu.id.au>	 <530AAA55.2080508@fnarfbargle.com> <530ABF21.7030200@eyal.emu.id.au> <BLU0-SMTP340FC1C74C40495FA5F94298860@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP340FC1C74C40495FA5F94298860@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

My main interest is to understand why 'check' does not actually check.
I already know how to fix the problem, by writing to the location I
can force the pending reallocation to happen, but then I will not have
the test case anymore.

The OP asks for a specific solution, but I think that the 'check' action
should already correctly rewrite failed (i/o error) sectors. It does not
always know which sector to rewrite when it finds a raid6 mismatch
without an i/o error (with raid5 it never knows).

Eyal

On 02/25/14 01:14, Wilson Jonathan wrote:
>
>> # echo 3 >'/proc/sys/vm/drop_caches'
>> # dd if=/dev/md127 of=/dev/null count=$((20*1024*1024))
>> 20971520+0 records in
>> 20971520+0 records out
>> 10737418240 bytes (11 GB) copied, 13.5717 s, 791 MB/s
>>
>> Note that I do not expect to get an error because reading the array will not read the P/Q checksums
>> (it assumes good data and avoids the calculations overhead of verifying P/Q).
>>
>> BTW, due to the use of a buffer layer I could have done the whole test using 4k blocks rather than
>> sectors, but it makes no difference in this case.
>>
>> Eyal
>>
>
> I wonder, could you not use dd to perform a "refresh"?
>
> dd if=/dev/md127 of=/dev/md127 count=... bs=....
>
> As that would force a re-calc and write of P & Q and data.
>
> That said, its just a "could you/would it" suggestion not a "do it" due
> to the inherent dangers of dd.

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
