From: vincent Ferrer <vincentchicago1@gmail.com>
Subject: Re: status of patches ( raid5 multiple threads )
Date: Tue, 19 Feb 2013 20:04:35 -0800
Message-ID: <CAEyJA_sJx12UHHjYs6HKNOZQQHjSFpnJieK=rqTHvjZVT7OmKg@mail.gmail.com>
References: <CAEyJA_uzE++2TDntK6pcdmgLgXbPE_9--XdHwdsFR72vaUeHng@mail.gmail.com>
	<20120911094420.044cfa98@notabene.brown>
	<CAEyJA_ubguH+9k_xXmjFwXN=QHp9E1t+UbTxFYdVqEAT59Lzrw@mail.gmail.com>
	<20130220141309.1928358b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130220141309.1928358b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Have'nt tested/tried  yet. Which kernel version these patches can work with ?

On Tue, Feb 19, 2013 at 7:13 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 19 Feb 2013 11:22:06 -0800 vincent Ferrer <vincentchicago1@gmail.com>
> wrote:
>
>> Hi  Neil / Shaohua,
>>
>> Did the patches for  "raid5  create multiple threads" got
>> reviewed/merged into  3.8 kernel ?  Or otherwise what is the plan and
>> current state of multi-thread raid5 support in latest linux kernels ?
>>
>> Appreciate your answers and great work.
>>
>
> No, not in 3.8.  I really should spend some time reviewing that code, but
> I've had a very busy summer...
>
> Have you (or anyone else) tested them?  Can you report anything positive or
> negative?  Having someone other than the author say "this helped a lot" would
> be a very strong motivator for me....
>
> NeilBrown
>
>
>> -Vincy
>>
>>
>>
>> On Mon, Sep 10, 2012 at 4:44 PM, NeilBrown <neilb@suse.de> wrote:
>> > On Mon, 10 Sep 2012 11:45:18 -0700 vincent Ferrer <vincentchicago1@gmail.com>
>> > wrote:
>> >
>> >> Hi Shaohua  (and linux-raid maintainers),
>> >>
>> >> Interested in knowing status of patches  "raid5  create multiple threads "
>> >> http://www.spinics.net/lists/raid/msg39978.html
>> >>
>> >> Specifically want to know if it is available in any of the latest
>> >> kernel releases 3.x ?
>> >>
>> >> Or otherwise when are these patches expected to get merged into linux
>> >> kernel tree.
>> >
>> > I don't plan to submit them for 3.7, though I might for 3.8 if I get a change
>> > to give them a proper review.
>> >
>> > NeilBrown
>
