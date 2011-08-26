From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: RAID1, changed disk, 2nd has errors ...
Date: Fri, 26 Aug 2011 17:41:47 +0200
Message-ID: <4E57BEBB.2000606@xunil.at>
References: <4E5787A1.7080807@xunil.at> <20110826125653.GA13709@cthulhu.home.robinhill.me.uk> <4E57A4D5.3070004@xunil.at> <20110826140810.GB13709@cthulhu.home.robinhill.me.uk>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110826140810.GB13709@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, robin.hill47@ntlworld.com
List-Id: linux-raid.ids

Am 2011-08-26 16:08, schrieb Robin Hill:
> sda4 is still in the array, with some unreadable sectors. sdb4 is a
>  spare because the resync failed due to unreadable sectors on
> sda4. You cannot add a disk to an array unless the data can all be
> read (or recovered if there's still enough redundancy).

Ah, now I got it.
I misinterpreted this:

md2 : active raid1 sdb4[2](S) sda4[0]
      962454080 blocks [2/1] [U_]

I thought [U_] maps to the first line "sdb4 sda4" and somehow read
"sdb4 is UP and sda4 is down"

I could have seen it at

    Number   Major   Minor   RaidDevice State
       0       8        4        0      active sync   /dev/sda4
       1       0        0        1      removed

       2       8       20        -      spare   /dev/sdb4

but you know, panic ;-)

So basically I am where I was before swapping sdb: everything running
on sda, which has some corrupt sectors. Which may never have been
touched so far.

>> As far as I understand it might be possible to spot the defective
>>  sectors and the related LV?
>> 
> A read of the relevant block device (dd if=/dev/xxx of=/dev/null) 
> will result in read errors for whichever block device contains the 
> bad sectors. You could also probably map the sectors reported by
> the kernel to the position on the disk to tell what LV it.

There is only 350GB out of ~920GB mapped to active LVs. It might be
the case that the corrupt stuff isn't even mapped yet.

I once knew how to figure that out, I will have a closer look.

>> I have backups, yes ...
>> 
> In which case the absolute safest option is just to recreate 
> whatever arrays, PVs, LVs, etc. on sdb4 and restore the data, 
> ignoring whatever's on sda4 currently.

I understand now, yes.

>> re-adding sda4 and starting such a check would be possible? Or 
>> would a re-add damage things?
>> 
> You can't add sda4 because it's already in the array.

Sure, now that I figured out the mentioned misunderstanding.

>> Should I shutdown the box for safety?
>> 
> For absolute safety, yes, though I don't think the risk is too
> high at the moment, and I don't think things'll get any worse in
> the short term.

That sounds good for my weekend! Thanks ...

>> I am really feeling unsafe now, and getting another hdd for 
>> swapping will take me at least until monday.
>> 
>> (I would like to dd-rescue to another new disk to keep sdb, just
>> in case)
>> 
> I doubt you'd be able to recover anything useful from sdb4 at the 
> moment, but that's up to you.

Yep, also clear now.
I wait with that ddrescue-stuff anyway.

Thanks for your help!
Stefan
