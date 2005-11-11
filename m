From: Andy Liebman <AndyLiebman@editshare.com>
Subject: Re: Still Need Help on mdadm and udev
Date: Thu, 10 Nov 2005 20:18:49 -0500
Message-ID: <4373F179.6040301@editshare.com>
References: <1200.146.115.27.35.1131563572.squirrel@webmail.editshare.com>	<1235.146.115.27.35.1131564483.squirrel@webmail.editshare.com> <17266.60719.545745.800152@cse.unsw.edu.au>
Reply-To: AndyLiebman@editshare.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17266.60719.545745.800152@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Neil Brown wrote:
> On Wednesday November 9, andyliebman@editshare.com wrote:
>   
>>> Okay,
>>>
>>> PLEASE somebody who knows answer the following:
>>>
>>> 1)  what is the difference between running
>>>
>>>              mdadm -A -ayes 1/dev/md1--uuid=xxxxx /dev/sd*
>>>
>>>     and
>>>
>>>              mdadm -A -amd 1/dev/md1 --uuid=xxxxx /dev/sd*
>>>
>>>
>>>     In other words, how do the "yes" and "md" options behave
>>>     differently.
>>>       
>
>  From 'man mdadm'
>
>        -a, --auto{=no,yes,md,mdp,part,p}{NN}
>               Instruct mdadm to create the device file if needed, possibly allocat-
>               ing an unused minor number.  "md" causes a non-partitionable array to
>               be  used.  "mdp", "part" or "p" causes a partitionable array (2.6 and
>               later) to be used.  "yes" requires the named md device to have a from
>               this.  See DEVICE NAMES below.
>
> Hmmm. there is some text missing there.  It should read:
>
>        -a, --auto{=no,yes,md,mdp,part,p}{NN}
>               Instruct  mdadm  to  create  the device file if needed, possibly
>               allocating an unused minor number.  "md" causes a non-partition-
>               able array to be used.  "mdp", "part" or "p" causes a partition-
>               able array (2.6 and later) to be used.  "yes" requires the named
>               md  device  to  have a 'standard' format, and the type and minor
>               number will be determined from this.  See DEVICE NAMES below.
>
> (typo in the mdadm.8 source file).
>
> Does that help?
>
>   
>>> 2)  If you create an array /dev/md0 with mdadm, is there any reason why
>>> you shouldn't start it as /dev/md1?
>>>       
>
> No technical reason.  This works perfectly.
>
>
>   
>>> The second option above (-amd 1) would NOT start an array that was created
>>> as /dev/md0 (under an older mdadm -- 1.8.? ) whereas the first option
>>> (-ayes /dev/md1) had no difficulty.
>>>
>>> Thank you.
>>> Andy Liebman
>>>
>>>
>>>       
>> Sorry, my bad:
>>
>> I meant to give as my examples:
>>
>>       mdadm -A -amd 1 --uuid=xxxxx /dev/sd*
>>     
>
> This is wrong.  It will create a device files called '1' in the
> current directory (assuming it works at all).
>
>   
>>    and
>>
>>       mdadm -A -ayes /dev/md1 --uuid=xxxxx /dev/sd*
>>     
>
> Given that /dev/md1 is a 'standard' format name, this will have the
> same effect as "-amd /dev/md1".  You only get the difference when you
> want to use a name like "/dev/md/home" or "/dev/swap", in which case,
> "-ayes" isn't allowed as mdadm cannot differentiate between
> partitioned and not.
>
>
> NeilBrown
>
>   

Thank you Neil. I get it now. I guess it WOULD have been helpful to have 
that missing text you supplied above!! I really wasn't interested in 
doing anything I couldn't do two years ago with mdadm -- /dev/mdX was 
all I wanted or needed.

But still, a few concrete examples in "man mdadm" would helpful . For 
instance, I don't think it's clear that you can create DEVICE NAMES  
like /dev/md/home. It's a little fuzzy what exactly you are allowed to 
substitute for {NN}. So, it might be useful to give a few more explicit 
examples:

mdadm -A -ayes /dev/md1 --uuid=xxxxx /dev/sd*    OKAY
mdadm -A -ayes /dev/md/home --uuid=xxxxx /dev/sd*    NO GOOD
mdadm -A -amp /dev/md1 --uuid=xxxxx /dev/sd*     OKAY
mdadm -A -amp /dev/md/home  --uuid=xxxxx /dev/sd*  OKAY
mdadm -A -amp /dev/md/5  -- uuid=xxxxx /dev/sd*   IS THIS OKAY?

...etc, for other options.

I guess it's also the same for "mdadm -C" (spelling it out always helps 
tremendously). In fact, I suppose the MOST important examples would be 
for "mdadm -C" -- because if you can't create an array, you certainly 
won't be assembling one!  It just so happens that in my case I was 
assembling arrays that had been created on another OS that used devfs 
and an older version of mdadm.

And finally, you might give a phrase after each example indicating why 
you might want to create a device with such a name. I understand 
creating a swap partition on a RAID, but I've never heard of naming a 
RAID device /dev/swap.  So, you might give a hint about what the 
advantage of the latter could be (if there is an advantage).

I'm not trying to make work for you. If I could answer these questions, 
I'd be happy to make this additions to the man page.

Thanks again. Couldn't get my work done without mdadm...

Andy Liebman
