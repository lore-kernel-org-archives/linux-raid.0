From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: Q re sync_completed
Date: Sun, 13 Feb 2011 18:09:20 +1100
Message-ID: <4D5783A0.70606@eyal.emu.id.au>
References: <4D571F67.30809@eyal.emu.id.au> <20110213153201.7ceaea0d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110213153201.7ceaea0d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

My bad, my script has the wrong access order
	set `cat $sys/sync_action $sys/mismatch_cnt $sys/sync_completed`
mismatch_cnt should be fetched last.

cheers
	Eyal

On 02/13/11 15:32, NeilBrown wrote:
> On Sun, 13 Feb 2011 11:01:43 +1100 Eyal Lebedinsky<eyal@eyal.emu.id.au>
> wrote:
>
>> I have scripts that do a raid check, then proceed to identify any files
>> affected. I then manually deal with these.
>>
>> I have a few issues with this RADI6 setup, here is one.
>>
>> I am setting sync_min and sync_max, start a check and wait for sync_completed
>> to equal sync_max.
>>
>> I assumed that when equal it means that this address was "completed". After
>> doing this for a while I observed that this is probably not the case.
>>
>> My expectation is that sync_completed has 'none' until it finished a chunk.
>> It then updates it with later completed ones. When it reaches sync_max
>> it pauses, and I then raise sync_max for the next area. This way I can
>> tell where a mismatch occurs. If sync_completed is set before a chunk
>> is completed then I may fetch mismatch_cnt too early (while the last
>> chunk is still being checked). This seems to be the case.
>>
>> Q: Is this the case?
>
> The intention of sync_completed is that it is only updated after
> sync/check/repair/recovery has actually completed to that point.  It may be
> updated well *after* the sync has happened, but should never be updated
> *before*.
>
> However it is entirely possible that the code is not 100% correct.
> If you give me details of what you are seeing together with precise kernel
> version number I can try to explain them for you.
>
>> Setting ranges that are too small (minimum is 1024) makes the check
>> *very* slow. I notice that ranges of 1m or even 4m are required to
>> get the check to move along close to the maximum speed.
>>
>> Q: Does the check take time to speed up rather than immediately go at
>> the nominated sync_speed_max rate?
>
> This is almost certainly an artifact of the way disk drives work.
>
> To get streaming reads from a disk drive you need to request at least a whole
> cylinder at a time.  As cylinders differ in size, it really only works if you
> request multiple cylinders at a time.
>
> I don't know how big cylinders are these days but I suspect they are a few
> hundred K to a Meg.  So needing 4M at a time to get streaming happening
> doesn't surprise me at all.
>
> NeilBrown

-- 
Eyal Lebedinsky	(eyal@eyal.emu.id.au)
