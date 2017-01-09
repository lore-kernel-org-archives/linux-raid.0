From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: using the raid6check report
Date: Mon, 9 Jan 2017 11:32:33 +1100
Message-ID: <62f5d174-0aef-5a70-68c3-26f7763b5e61@eyal.emu.id.au>
References: <14e8ec23-de4a-e90b-4b67-155e5e3cc228@eyal.emu.id.au>
 <20170108174010.GA3699@lazy.lzy> <5872A698.7000009@youngman.org.uk>
 <20170108214111.GA7933@lazy.lzy> <87pojxjhwt.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87pojxjhwt.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/01/17 09:39, NeilBrown wrote:
> On Mon, Jan 09 2017, Piergiorgio Sartor wrote:
>
[trim]
>>
>> There was a patch adding the write capability,
>> but likely only for the C code, not the man page.
>>
>>>
>>> I can add it to the wiki as a little programming project, but it would
>>> be nice to know the exact status of things - my raid-fu isn't good
>>> enough at present to read the code and work out what's going on.
>>>
>>> It would be nice to be able to write "parity-check" or somesuch to
>>> sync_action, and then for raid5 it would check and update parity, or
>>> raid6 it would check and correct data/parity.
>>
>> At that time, the agreement with Neil was to do
>> such things in user space and not inside the
>> md raid "driver" (so to speak) in kernal space.
>
> This is correct.
>
> With RAID6 it is possible to determine, with high reliability, if a
> single device is corrupt.  There is a mathematical function that can be
> calculated over a set of bytes, one from each device.  If the result is
> a number less than the number of devices in the array (including P and
> Q), then the device with that index number is corrupt (or at least, both
> P and Q can be made correct again by simply changing that one byte).  If
> we compute that function over all 512 (or 4096) bytes in a stripe and
> they all report the same device (or report that there are no errors for
> some bytes) then it is reasonable to assume the block on the identified
> device is corrupt.
>
> raid6check does this and provides very useful functionality for a
> sysadmin to determine which device is corrupt, and to then correct that
> if they wish.
>
> However, I am not comfortable with having that be done transparently
> without any confirmation from the sysadmin.  This is because I don't
> have a credible threat model for how the corruption could have happened
> in the first place.  I understand how hardware failure can make a whole
> device unaccessible, and how media errors can cause a single block to be
> unreadable.  But I don't see a "most likely way" that a single block can
> become corrupt.
>
> Without a clear model, I cannot determine what the correct response is.
> The corruption might have happened on the write path ... so re-writing
> the block could just cause more corruption.  It could have happened on
> the read path, so re-writing won't change anything.  It could have
> happened in memory, so nothing can be trusted.  It could have happened
> due to buggy code.  Without knowing the cause with high probability, it
> is not safe to try to fix anything.
>
> The most likely cause for incorrect P and Q is if the machine crashed
> which a stipe was being updated. In that case, simply updating P and Q
> is the correct response.  So that is the only response that the kernel
> performs.
>
> For more reading, see http://neil.brown.name/blog/20100211050355
>
> NeilBrown
[trim]

I am aware of that discussion and agree with the sentiment (fix in user space).
What I miss is a message from md when a 'check' mismatch is found. Not having
this means I have to run 'raid6check', then after looking at the situation
run 'raid6check autorepair' in the small sections reported as bad. This is time
consuming and risky.

What I resort to doing now is 'cat /proc/mdstat' repeatedly during md 'check'
and use the report as a clue to the location of problem stripes.

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
