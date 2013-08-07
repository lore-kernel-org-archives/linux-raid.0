From: Albert Pauw <albert.pauw@gmail.com>
Subject: Re: Bugreport ddf rebuild problems
Date: Wed, 07 Aug 2013 20:07:15 +0200
Message-ID: <52028CD3.5050606@gmail.com>
References: <51FAB74B.4030200@gmail.com>	<51FAB282.6040303@arcor.de>	<CAGkViCFT0+qm9YAnAJM7JGgVg0RTJi8=HAYDTMs-mfhXinqdcg@mail.gmail.com>	<51FACF7C.50400@arcor.de>	<51FADCA5.1080801@arcor.de>	<51FAE319.6030604@arcor.de>	<51FCD0BB.1040402@gmail.com>	<51FE234A.4060808@gmail.com>	<51FFD913.1090301@gmail.com>	<5200180C.6060604@arcor.de> <20130806101633.4b8f2374@notabene.brown> <52016A06.8070400@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52016A06.8070400@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just to let you guys know that I pulled the latest git version 
(including DDF: Write new conf entries with a single write.)

As for now, it all seems to work rather nicely.

Thanks guys,

Albert


On 08/06/2013 11:26 PM, Martin Wilck wrote:
> On 08/06/2013 02:16 AM, NeilBrown wrote:
>> On Mon, 05 Aug 2013 23:24:28 +0200 Martin Wilck <mwilck@arcor.de> wrote:
>>
>>> Hi Albert, Neil,
>>>
>>> I just submitted a new patch series; patch 3/5 integrates your 2nd case
>>> as a new unit test and 4/5 should fix it.
>>>
>>> However @Neil: I am not yet entirely happy with this solution. AFAICS
>>> there is a possible race condition here, if a disk fails and mdadm -CR
>>> is called to create a new array before the metadata reflecting the
>>> failure is written to disk. If a disk failure happens in one array,
>>> mdmon will call reconcile_failed() to propagate the failure to other
>>> already known arrays in the same container, by writing "faulty" to the
>>> sysfs state attribute. It can't do that for a new container though.
>>>
>>> I thought that process_update() may need to check the kernel state of
>>> array members against meta data state when a new VD configuration record
>>> is received, but that's impossible because we can't call open() on the
>>> respective sysfs files. It could be done in prepare_update(), but that
>>> would require major changes, I wanted to ask you first.
>>>
>>> Another option would be changing manage_new(). But we don't seem to have
>>> a suitable metadata handler method to pass the meta data state to the
>>> manager....
>>>
>>> Ideas?
>> Thanks for the patches - I applied them all.
> I don't see them in the public repo yet.
>
>> Is there a race here?  When "mdadm -C" looks at the metadata the device will
>> either be an active member of another array, or it will be marked faulty.
>> Either way mdadm won't use it.
> That's right, thanks.
>
>> If the first array was created to use only (say) half of each device and the
>> second array was created with a size to fit in the other half of the device
>> then it might get interesting.
>> "mdadm -C" might see that everything looks good, create the array using the
>> second half of that drive that has just failed, and give that info to mdmon.
> Yes, I have created a test case for this (10ddf-fail-create-race) which
> I am going to submit soon.
>
>> I suspect that ddf_open_new (which currently looks like it is just a stub)
>> needs to help out here.
> Great idea, I made an implementation. I found that I needed to freeze
> the array in Create(), too, to avoid the kernel starting a rebuild
> before the mdmon checked the correctness of the new array. Please review
> that, I'm not 100% positive I got it right.
>
>> When manage_new() gets told about a new array it will collect relevant info
>> from sysfs and call ->open_new() to make sure it matches the metadata.
>> ddf_open_new should check that all the devices in the array are recorded as
>> working in the metadata.  If any are failed, it can write 'faulty' to the
>> relevant state_fd.
>>
>> Possibly the same thing can be done generically in manage_new() as you
>> suggested.  After the new array has been passed over to the monitor thread,
>> manage_new() could check if any devices should be failed much like
>> reconcile_failed() does and just fail them.
>>
>> Does that make any sense?  Did I miss something?
> It makes a lot of sense.
>
> While testing, I found another minor problem case:
>
>   1 disk fails in array taking half size
>   2 mdmon activates spare
>   3 mdadm -C is called and finds old meta data, allocates extent at
> offset 0 on the spare
>   4 Create() gets an error writing to the "size" sysfs attribute because
> offset 0 has been grabbed by the spare recovery already
>
> That's not too bad, after all, because the array won't be created. The
> user just needs to re-issue his mdadm -C command which will now succeed
> because the meta data should have been written to disk in the meantime.
>
> That said, some kind of locking between mdadm and mdmon (mdadm won't
> read meta data as long as mdmon is busy writing them) might be
> desirable. It would be even better to do all meta data operations
> through mdmon, mdadm just sending messages to it. That would be a major
> architectural change for mdadm, but it would avoid this kind of
> "different meta data here and there" problem altogether.
>
> Thanks
> Martin
>
>> Thanks,
>> NeilBrown



