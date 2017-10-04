From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: hung grow
Date: Wed, 4 Oct 2017 19:57:37 +0100
Message-ID: <909461a8-64db-3975-91a9-9dc79daf11be@youngman.org.uk>
References: <CADg2FGbgdgHWbaJN94p36-SUjfDEKNi2VYuyHXJN1pDJ9Kdg7w@mail.gmail.com>
 <a528459f-8bf5-3e47-9c9a-7c040ad7ab81@youngman.org.uk>
 <CADg2FGYPENaUb7oDhOUu08VMhzygE365mqw=Lw332jBGbe1dGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADg2FGYPENaUb7oDhOUu08VMhzygE365mqw=Lw332jBGbe1dGQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Curt <lightspd@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/10/17 19:16, Curt wrote:
> Hi,
> 
> I was reading this one https://raid.wiki.kernel.org/index.php/RAID_Recovery
> 
> I don't have any spare bays on that server...I'd have to make a trip
> to my datacenter and bring the drives back to my house.  The bad thing
> is the 2 drives I replaced, failed a while ago, so they were behind.
> I was hoping I could still use the 4 drives I had before I did a grow
> on them.  Do they need to be up-to-date or do I just need the config
> from them to recover the 3 drives that were still good?
> 
> Oh, I originally started with 7, 2 failed a few moths back and the 3rd
> one just recently. FML
> 
Okay, that makes it a lot clearer what happened. First things first. 
That "grow" is trying to change your array from "7 with 3 failed" to "9 
with 3 failed". A complete balls-up. Sorry.

So firstly. We NEED to stop that grow. I think the option you want is 
--revert-reshape, but I'd rather an expert chimed in and said I've got 
it right.

Secondly, you NEED to ddrescue that failed drive number 5. If that drive 
is toast, then so is your array :-( If that means a trip to the 
datacentre then so be it. What you really don't want is for that drive 
to die beyond recovery before you get the chance to copy it. If it does 
appear to be toast, ime, leaving it powered off for a few days MAY give 
you the opportunity to recover it. Other people swear by putting it in 
the freezer. If it's dead, what have you got to lose?

Once you've got that far, you can now forcibly assemble your array, 
which will give you a "7 with 2 failed" working but degraded array.

Now you can do what you *should* have done with your two new drives - do 
a "--fail --remove --add" to delete the failed drives and put the new 
drives in.

Nice and simple, but it all depends on that failed drive ... if the 
worst does come to the worst, and the data is valuable enough, head 
crashes are rare nowadays and a specialist recovery firm may well be 
able to salvage it for you, but that won't be cheap ...

Another "worst case" recovery scenario is to force in your replacement 
drive with "--assume-clean" - I'm not sure how to do that ... But it 
will give you a working array with a LOT of damage. With five drives, 
though, that will give you a good chance of recovering a lot of the 
files with some data recovery software.

Cheers,
Wol

> Cheers,
> Curt
> 
> On Wed, Oct 4, 2017 at 1:51 PM, Anthony Youngman
> <antlists@youngman.org.uk> wrote:
>> On 04/10/17 18:18, Curt wrote:
>>>
>>> Is my raid completely fucked or can I still recover some data with
>>> doing the create assume clean?
>>
>>
>> PLEASE PLEASE PLEASE DON'T !!!!!!
>>
>> I take it you haven't read the raid wiki?
>>
>> https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn
>>
>> The bad news is your array is well borked. The good news is I don't think
>> you have - YET - managed to bork it irretrievably. A create will almost
>> certainly trash it beyond recovery!!!
>>
>> I think we can stop/revert the grow, and get the array back to a usable
>> state, where we can force an assemble. If a bit of data gets lost, sorry.
>>
>> Do you have spare SATA ports? So you have the bad drives you replaced (can
>> you ddrescue them on to new drives?). What was the original configuration of
>> the raid - you say you lost three drives, but how many did you have to start
>> with?
>>
>> I'll let the experts talk you through the actual recovery, but the steps
>> need to be to revert the grow, ddrescue the best of your failed drives,
>> force an assembly, and then replace the other two failed drives. No
>> guarantees as to how much data will be left at the end, although hopefully
>> we'll save most of it.
>>
>> Cheers,
>> Wol
> 
