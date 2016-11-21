From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: linux raid wiki - backup files
Date: Mon, 21 Nov 2016 20:22:09 +0000
Message-ID: <c3d16a30-b36e-3d26-f30a-441b236f7107@youngman.org.uk>
References: <583077D0.5070804@youngman.org.uk>
 <ffb47575-b655-924d-8626-07b9e48a6371@turmel.org>
 <5831B7B9.8090008@youngman.org.uk>
 <4febebb6-0442-cc5e-45d5-e041e21e2d95@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4febebb6-0442-cc5e-45d5-e041e21e2d95@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid <linux-raid@vger.kernel.org>, neilb@suse.com
List-Id: linux-raid.ids



On 21/11/16 14:07, Phil Turmel wrote:
> On 11/20/2016 09:48 AM, Wols Lists wrote:
>> On 20/11/16 00:27, Phil Turmel wrote:
>>> Yes.  But the new stripes lay on top of the old stripes, unless you move
>>> the data offset.  Which is why a backup file holds the old stripe just
>>> in case.  If you can move the offset, you use the lower offset for the
>>> lower addresses in the array, and the higher offset for the higher
>>> addresses, on either side of the reshape position.
>>
>> Okay, understood. So v0.9 and v1.0 always need a backup for a reshape.

Having looked at the man page, this now seems obvious - the superblock 
is at the end, so the data offset is 0. But for a 1.0 array, could we 
create a data offset?

(So, if we created a data offset, we could then move the superblock and 
convert a 1.0 to 1.1 or 1.2? Okay, it can't do it now, but it looks to 
me like it shouldn't be that hard ... ?)
>>
>> But if we have a data offset with v1.2, a reshape will use that space if
>> it can rather than needing a backup file?
>
I'm guessing that 1.0 and 1.1 defaulted to no data offset to speak of? 
And if we (can) create a decent data offset, we can then use that in 
exactly the same way as with v1.2?

Cheers,
Wol
