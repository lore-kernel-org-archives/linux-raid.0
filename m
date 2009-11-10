From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: mismatch_cnt again
Date: Tue, 10 Nov 2009 13:05:32 -0500
Message-ID: <4AF9AB6C.4010608@tmr.com>
References: <4AF4C247.6050303@eyal.emu.id.au> <4AF4D323.6020108@panix.com>    <4AF5268D.60900@eyal.emu.id.au>    <4877c76c0911070008m789507f8h799d419287740ca5@mail.gmail.com>    <87tyx6tpcb.fsf@frosties.localdomain> <4AF58B20.3000409@redhat.com>    <87iqdlaujb.fsf@frosties.localdomain> <20091108160433.GA5338@lazy.lzy>    <4AF85DCB.3030909@tmr.com> <df8de4eb79e2bf13d0e5c2c83cdc7cf1.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <df8de4eb79e2bf13d0e5c2c83cdc7cf1.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Goswin von Brederlow <goswin-v-b@web.de>, Doug Ledford <dledford@redhat.com>, Michael Evans <mjevans1983@gmail.com>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

NeilBrown wrote:
> On Tue, November 10, 2009 5:22 am, Bill Davidsen wrote:
>   
>> Piergiorgio Sartor wrote:
>>     
>>> Hi,
>>>
>>>
>>>       
>>>> But unless your drive firmware is broken the drive with only ever give
>>>> the correct data or an error. Smart has a counter for blocks that have
>>>> gone bad and will be fixed pending a write to them:
>>>> Current_Pending_Sector.
>>>>
>>>> The only way the drive should be able to give you bad data is if
>>>> multiple bits toggle in such a way that the ECC still fits.
>>>>
>>>>         
>>> Not really, I've disks which are *perfect* in smart sense
>>> and nevertheless I had mistmatch count.
>>> This was a SW problem, I think now fixed, in RAID-10 code.
>>>
>>>
>>>       
>> IIRC there still is an error in raid-1 code, in that data is written to
>> multiple drives without preventing modification of the memory between
>> writes. As I understand Neil's explanation, this happens (a) when memory
>> is being changed rapidly and frequently via memory mapped files, or (b)
>> writing via O_DIRECT, or (c) when raid-1 is being used for swap. I'm not
>> totally sure why the last one, but I have always seem mismatches on swap
>> in a system which is actually swapping. What is more troubling is that
>> if I do a hibernate, which writes to swap, and then force a boot from
>> other media to a Live-CD, doing a check of the swap array occasionally
>> shows a mismatch. That doesn't give me a secure feeling, although I have
>> never had an issue in practice, I was just curious.
>>     
>
> I don't think this is really an error in the RAID1 code.
> The only thing that the RAID1 code could do differently is make a local
> copy of the data and then write that to all of the devices (a bit like
> RAID5 does so it can generate a parity block reliably).
> Doing this would introduce a performance penalty with not real
> benefit (the only benefit would be to stop long email threads about
> mismatch_cnt :-)
>
>   
After thinking about it, I agree that "limitation" would be a more 
accurate term. Apologies. This is one of the few reasons to consider 
hardware raid. By writing all copies of the data from a single cache 
buffer in the controller they are always consistent and only take up the 
bandwidth on the memory bus needed to transfer the initial data to the 
controller.

Of course unless the cache on the controller is really large it can 
become a choke point, adds controller firmware as a failure point, adds 
to the cost... so I regard hardware raid as useful only when it 
justified spending big bucks to get a really good controller.

> You could possibly argue that it is a weakness in the interface to block
> devices that the block device cannot ask for the buffer to be guaranteed
> to be stable for the duration of the write, but as there is little real
> need for that and it would probably be fairly hard to implement both
> efficiently and generally.
>
>   
The raid code would need it's own copy of the data in a private buffer, 
or would have to mark the write memory as copy on write. I suspect the 
2nd if far more efficient, but I have no idea how hard it would be to 
implement.

> A filesystem is well placed to do this sort of thing and it is quite
> likely that BTRFS does something appropriate to ensure that the block
> checksums it creates are reliable.
> All the filesystem needs to do is forcibly unmap the page from any
> process address space and make sure it doesn't get remapped or otherwise
> modified until the write completes.
>
>   
That sounds like a lot more overhead than just making the page COW for 
the duration, since only a very small number of writes every actually do 
get changed.  No easy answer, but at least the filesystem can align the 
buffers in a reasonable way.
> The (c) option is actually the most likely to cause inconsistencies.
> If a page is modified while being written out to swap, the swap
> system will effective forget that it ever tried to write it so
> any inconsistency is likely to remain (but never be read, so there
> is no problem).
> With a filesystem, if the page is changed while being written, it is
> very likely that the filesystem will try to write the page to the same
> location again, thus fixing the inconsistency.
>
>   
Well, I do get a *ton* of mismatches in swap, I just ran a check and got 
12032 in the mismatch count. Another raid1 on partitions of the same 
drives showed 128, which still bothers me, since /boot hasn't changed in 
months.
> When suspend-to-disk writes to swap, it stops all changes from happening
> and then writes the data and waits for it to complete, so you will never
> find inconsistencies in blocks on swap that actually contain a
> suspend-to-disk image.
>   

Then that's not an issue for restart, at least.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

