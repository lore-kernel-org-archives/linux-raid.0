From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: mismatch_cnt questions
Date: Mon, 12 May 2008 10:31:09 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0805121031030.25016@p34.internal.lan>
References: <bb145bd20703040322g1e5e8784i93a933c0c61b43f6@mail.gmail.com> <17898.45673.573800.56474@notabene.brown> <482826F0.2070405@tuxes.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <482826F0.2070405@tuxes.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Bas van Schaik <bas@tuxes.nl>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 12 May 2008, Bas van Schaik wrote:

> Neil Brown wrote:
>> On Sunday March 4, pernegger@gmail.com wrote:
>>
>> (...)
>>> 3) Is the "repair" sync action safe to use on the above kernel? Any
>>> other methods / additional steps for fixing this?
>>>
>>
>> "repair" is safe, though it may not be effective.
>> "repair" for raid1 was did not work until Jan 26th this year.
>> Before then it was identical in effect to 'check'.
>>
> Sorry to dig up such an old thread, but I'd like to know since when
> (which kernel version) "repair" (recompute parity, assuming data is
> consistent) for raid5 is effective?
Good question.
