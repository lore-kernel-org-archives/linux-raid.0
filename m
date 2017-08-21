From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: Filesystem corruption on RAID1
Date: Mon, 21 Aug 2017 15:03:59 +0100
Message-ID: <de4af3a8-aee2-4632-6038-4adb006bed92@youngman.org.uk>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
 <9eea45ddc0f80f4f4e238b5c2527a1fa@assyoma.it>
 <f01b4649-df39-9835-728d-545cbd45976d@assyoma.it>
 <CAAMCDefXYdDKrFjEgeS8JAYt1GNP0-fL1chEXrGqxY8=xEf4Cw@mail.gmail.com>
 <7ca98351facca6e3668d3271422e1376@assyoma.it>
 <5995D377.9080100@youngman.org.uk>
 <83f4572f09e7fbab9d4e6de4a5257232@assyoma.it>
 <59961DD7.3060208@youngman.org.uk>
 <784bec391a00b9e074744f31901df636@assyoma.it>
 <CAAMCDefNRMuTwyXn_=3v_EWHwkjy3mhod1dLw3RQpjU=9VHNJQ@mail.gmail.com>
 <a93cf0cc1d39c30f585eb53ed36aa4c0@assyoma.it>
 <alpine.DEB.2.20.1708200907440.3655@uplift.swm.pp.se>
 <7d0af770699948fb0ecb66185145be05@assyoma.it>
 <alpine.DEB.2.20.1708201241400.3655@uplift.swm.pp.se>
 <59998974.60103@youngman.org.uk>
 <5df0037e-fc76-1127-e2e8-c4992b6d216e@websitemanagers.com.au>
 <alpine.DEB.2.20.1708201742080.3655@uplift.swm.pp.se>
 <5999B46C.1050906@youngman.org.uk>
 <bdb354cb-62f4-a254-11f6-6cdb00639341@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bdb354cb-62f4-a254-11f6-6cdb00639341@websitemanagers.com.au>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 21/08/17 00:11, Adam Goryachev wrote:
> On 21/08/17 02:10, Wols Lists wrote:
>> On 20/08/17 16:48, Mikael Abrahamsson wrote:
>>> On Mon, 21 Aug 2017, Adam Goryachev wrote:
>>>
>>>> data (even where it is wrong). So just do a check/repair which will
>>>> ensure both drives are consistent, then you can safely do the fsck.
>>>> (Assuming you fixed the problem causing random write errors first).
>>> This involves manual intervention.
>>>
>>> While I don't know how to implement this, let's at least see if we can
>>> architect something for throwing ideas around.
>>>
>>> What about having an option for any raid level that would do "repair on
>>> read". So you can do "0" or "1" on this. RAID1 would mean it reads all
>>> stripes and if there is inconsistency, pick one and write it to all of
>>> them. It could also be some kind of IOCTL option I guess. For RAID5/6,
>>> read all data drives, and check parity. If parity is wrong, write 
>>> parity.
>>>
>>> This could mean that if filesystem developers wanted to do repair (and
>>> this could be a userspace option or mount option), it would use the
>>> beforementioned option for all fsck-like operation to make sure that
>>> metadata was consistent while doing fsck (this would be different for
>>> different tools, if it's an "fs needs to be mounted"-type of fs, or if
>>> it's an "offline fsck" type filesystem. Then it could go back to normal
>>> operation for everything else that would hopefully not cause
>>> catastrophical failures to the filesystem, but instead just individual
>>> file corruption in case of mismatches.
>>>
>> Look for the thread "RFC Raid error detection and auto-recovery, 10th 
>> May.
>>
>> Basically, that proposed a three-way flag - "default" is the current
>> "read the data section", "check" would read the entire stripe and
>> compare a mirror or calculate parity on a raid and return a read error
>> if it couldn't work out the correct data, and "fix" would write the
>> correct data back if it could work it out.
>>
>> So basically, on a two-disk raid-1, or raid 4 or 5, both "check" and
>> "fix" would return read errors if there's a problem and you're SOL
>> without a backup.
>>
>> With a three-disk or more raid-1, or raid-6, it would return the correct
>> data (and fix the stripe) if it could, otherwise again you're SOL.
> 
>  From memory, the main sticking point was in implementing this with 
> RAID6 and the argument that you might not be able to choose the "right" 
> pieces of data because there wasn't a sufficient amount of data to know 
> which was corrupted.

That was the impression I got, but I really don't understand the 
problem. If *ANY* one stripe is corrupted, we have two unknowns, two 
parity blocks, and we can recalculate the missing stripe.

If two or more stripes are corrupt, the recovery will return garbage 
(which is detectable) and we return a read error. We DO NOT attempt to 
rewrite the stripe! In your words, if we can't choose the "right" piece 
of data, we bail and do nothing.

As I understood it, the worry was that we would run the recovery 
algorithm and then overwrite the data with garbage, but nobody ever gave 
me a plausible scenario where that could happen. The only plausible 
scenario is where multiple stripes are corrupted in such a way that the 
recovery algorithm is fooled into thinking only one stripe is affected. 
And if I read that paper correctly, the odds of that happening are very low.

Short summary - if just one stripe is corrupted, then my proposal will 
fix and return CORRECT data. If however, more than one stripe is 
corrupted, then my proposal will with near-perfect accuracy bail and do 
nothing (apart from returning a read error). As I say, the only risk to 
the data is if the error looks like a single-stripe problem when it 
isn't, and that's unlikely.

I've had enough data-loss scenarios in my career to be rather paranoid 
about scribbling over stuff when I don't know what I'm doing ... (I do 
understand concerns about "using the wrong tool to fix the wrong 
problem", but you don't refuse to sell a punter a wheel-wrench because 
he might not be able to tell the difference between a flat tyre and a 
mis-firing engine).

Cheers,
Wol
