From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: linux raid wiki - backup files
Date: Tue, 22 Nov 2016 23:16:30 +0000
Message-ID: <d0544b77-cc70-e6b0-8fd5-ad16b6e275ee@youngman.org.uk>
References: <583077D0.5070804@youngman.org.uk>
 <ffb47575-b655-924d-8626-07b9e48a6371@turmel.org>
 <5831B7B9.8090008@youngman.org.uk>
 <4febebb6-0442-cc5e-45d5-e041e21e2d95@turmel.org>
 <c3d16a30-b36e-3d26-f30a-441b236f7107@youngman.org.uk>
 <87vavgcuzv.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87vavgcuzv.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Phil Turmel <philip@turmel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Okay, after all that I've ended up not mentioning backup files at all. I 
get the feeling that in pretty much all modern scenarios they are not 
required. If we have v1.1 or v1.2 there should be enough spare metadata 
space, and a modern system shouldn't be using v1.0. It's only of 
interest if you are doing a bios boot off a mirror with no initramfs. 
Not a likely option for a system being set up today. And from the man 
page, mdadm leaves 128K at the end of each device - would a v1.0 array 
have that? Would that be used for backup?

I probably ought to work out how I can get it to fit neatly in my mdadm 
page, especially if it's only needed for older setups.

Can you take a look at the page and make sure it's not got anything 
obviously wrong ...

https://raid.wiki.kernel.org/index.php/A_guide_to_mdadm

And then I'll try and sort out a page on finding lost arrays - we've had 
a few on the list recently ...

Cheers,
Wol

On 21/11/16 22:45, NeilBrown wrote:
> On Tue, Nov 22 2016, Anthony Youngman wrote:
>
>> On 21/11/16 14:07, Phil Turmel wrote:
>>> On 11/20/2016 09:48 AM, Wols Lists wrote:
>>>> On 20/11/16 00:27, Phil Turmel wrote:
>>>>> Yes.  But the new stripes lay on top of the old stripes, unless you move
>>>>> the data offset.  Which is why a backup file holds the old stripe just
>>>>> in case.  If you can move the offset, you use the lower offset for the
>>>>> lower addresses in the array, and the higher offset for the higher
>>>>> addresses, on either side of the reshape position.
>>>>
>>>> Okay, understood. So v0.9 and v1.0 always need a backup for a reshape.
>>
>> Having looked at the man page, this now seems obvious - the superblock
>> is at the end, so the data offset is 0. But for a 1.0 array, could we
>> create a data offset?
>
> Yes.  But usually the purpose for using 1.0 is to have data_offset == 0,
> so you might not want to.
>
>>
>> (So, if we created a data offset, we could then move the superblock and
>> convert a 1.0 to 1.1 or 1.2? Okay, it can't do it now, but it looks to
>> me like it shouldn't be that hard ... ?)
>
> It would be quite easy to extend "--update=metadata" to change the
> version once the data_offset had been changed.
>
>>>>
>>>> But if we have a data offset with v1.2, a reshape will use that space if
>>>> it can rather than needing a backup file?
>>>
>> I'm guessing that 1.0 and 1.1 defaulted to no data offset to speak of?
>> And if we (can) create a decent data offset, we can then use that in
>> exactly the same way as with v1.2?
>
> 1.0 defaults to no data_offset.
> 1.1 uses the safe choice function as 1.2.
>
> NeilBrown
>
