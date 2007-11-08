From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Was: [RFC PATCH 2.6.23.1] md: add dm-raid1 read balancing
Date: Thu, 08 Nov 2007 12:35:35 -0500
Message-ID: <473348E7.8010002@tmr.com>
References: <1194084522.1353.10.camel@localhost>	<87fxziju0z.fsf@informatik.uni-tuebingen.de>	<1194520008.17369.19.camel@localhost> <87prykaeh6.fsf@informatik.uni-tuebingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87prykaeh6.fsf@informatik.uni-tuebingen.de>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Cc: konstantin.sharlaimov@gmail.com, linux-raid <linux-raid@vger.kernel.org>, Rik van Riel <riel@redhat.com>, "; Ingo Molnar" <mingo@redhat.com>, "; Neil Brown" <neilb@suse.de>
List-Id: linux-raid.ids

Goswin von Brederlow wrote:
> Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com> writes:
>
>   
>> On Wed, 2007-11-07 at 10:15 +0100, Goswin von Brederlow wrote:
>>     
>>> I wonder if there shouldn't be a way to turn this off (or if there
>>> already is one).
>>>
>>> Or more generaly an option to say what is "near". Specifically I would
>>> like to teach the raid1 layer that I have 2 external raid boxes with a
>>> 16k chunk size. So read/write within a 16k chunk will be the same disk
>>> but the next 16k are a different disk and "near" doesn't apply
>>> anymore.
>>>       
>> Currently there is no way to turn this feature off (this is only a
>> "request for comments" patch), but I'm planning to make it configurable
>> via sysfs and module parameters.
>>
>> Thanks for suggestion for the "near" definition. What do you think about
>> adding the "chunk_size" parameter (with the default value of 1 chunk = 1
>> sector). Setting it to 32 will make all reads within 16k chunk to be
>> considered "near" (with zero distance) so they will go to the same disk.
>>
>> Max distance will also be configurable (after this distance the "read"
>> operation is considered "far" and will go to randomly chosen disk)
>>
>> Regards,
>> Konstantin
>>     
>
> Maybe you need more parameter:
>
> chunk_size    - size of a continious chunk on the (multi disk) device
> stripe_size   - size of a stripe of chunks spanning all disks
> rotation_size - size of multiple stripes before parity rotates to a
>                 new disk (sign gives direction of rotation)
> near_size     - size that is considered to be near on a disk
>
> I would give all sizes in blocks of 512 bytes or bytes.
>   

Why? Would there ever be a time when there  would be a significant (or 
any) benefit from a size other than a multiple of chunk size? If you 
give the rest of the sizes in multiples of chunk size it invites less 
human math.
> Default would be:
>   

Default would be "zero" to indicate that the raid system should figure 
out what to use, allowing the value of "one" to actually mean what it 
says. It also invites use of zero for the rest of the calculated sizes, 
indicating the raid subsystem should select values. With coming SSD 
hardware you may actually want one to mean one.
> chunk_size    = 1 (block)
> stripe_size   = 1 (block)
> rotation_size = 0 (no rotation)
> near_size     = 256
>
> That would reflect that you have all chunks continious on a normal
> disk and read/writes are done in 128K chunks.
>
> For raid 1 on raid 0:
>
> chunk_size  = raid chunk size
> stripe_size = num disks * chunk_size
> rotation_size = 0
> near_size = 256
>
> For raid 1 on raid 5:
>
> chunk_size  = raid chunk size
> stripe_size = (num disks - 1) * chunk_size
> rotation_size = (num disks - 1) * chunk_size  (?)
> near_size = 256
>
> and so on.
>
> MfG
>         Goswin
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

