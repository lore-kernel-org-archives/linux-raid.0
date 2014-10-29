From: Ethan Wilson <ethan.wilson@shiftmail.org>
Subject: Re: Split RAID: Proposal for archival RAID using incremental batch
 checksum
Date: Wed, 29 Oct 2014 20:27:52 +0100
Message-ID: <54513FB8.2050407@shiftmail.org>
References: <CAK-d5dbdF160hoa1==jWxEQZRpwQ7Sa76=9MREmp2V6Y24U8Kw@mail.gmail.com> <20141029200501.1f01269d@notabene.brown> <CAK-d5dah-NyQzVNBScYoVSo2cpGA8F3vuK_Zh1YzQn5Mr+_-oQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK-d5dah-NyQzVNBScYoVSo2cpGA8F3vuK_Zh1YzQn5Mr+_-oQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29/10/2014 10:25, Anshuman Aggarwal wrote:
> Right on most counts but please see comments below.
>
> On 29 October 2014 14:35, NeilBrown <neilb@suse.de> wrote:
>> Just to be sure I understand, you would have N + X devices.  Each of the N
>> devices contains an independent filesystem and could be accessed directly if
>> needed.  Each of the X devices contains some codes so that if at most X
>> devices in total died, you would still be able to recover all of the data.
>> If more than X devices failed, you would still get complete data from the
>> working devices.
>>
>> Every update would only write to the particular N device on which it is
>> relevant, and  all of the X devices.  So N needs to be quite a bit bigger
>> than X for the spin-down to be really worth it.
>>
>> Am I right so far?
> Perfectly right so far. I typically have a N to X ratio of 4 (4
> devices to 1 data) so spin down is totally worth it for data
> protection but more on that below.
>
>> For some reason the writes to X are delayed...  I don't really understand
>> that part.
> This delay is basically designed around archival devices which are
> rarely read from and even more rarely written to. By delaying writes
> on 2 criteria ( designated cache buffer filling up or preset time
> duration from last write expiring) we can significantly reduce the
> writes on the parity device. This assumes that we are ok to lose a
> movie or two in case the parity disk is not totally up to date but are
> more interested in device longevity.
>
>> Sounds like multi-parity RAID6 with no parity rotation and
>>    chunksize == devicesize
> RAID6 would present us with a joint device and currently only allows
> writes to that directly, yes? Any writes will be striped.

I am not totally sure I understand your design, but it seems to me that 
the following solution could work for you:

MD raid-6, maybe multi-parity (multi-parity not implemented yet in MD 
yet, but just do a periodic scrub and 2 parities can be fine. Wake-up is 
not so expensive that you can't scrub)

Over that you put a raid1 of 2 x 4TB disks as a bcache cache device 
(those two will never spin-down) in writeback mode with 
writeback_running=off . This will prevent writes to backend and leave 
the backend array spun down.
When bcache is almost full (poll dirty_data), switch to 
writeback_running=on and writethrough: it will wake up the backend raid6 
array and flush all dirty data. You can then then revert to writeback 
and writeback_running=off. After this you can spin-down the backend 
array again.

You also get read caching for free, which helps the backend array to 
stay spun down as much as possible.

Maybe you can modify bcache slightly so to implement an automatic 
switching between the modes as described above, instead of polling the 
state from outside.

Would that work, or you are asking something different?

EW

