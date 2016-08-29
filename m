From: o1bigtenor <o1bigtenor@gmail.com>
Subject: Re: Raid settings
Date: Sun, 28 Aug 2016 21:28:10 -0500
Message-ID: <CAPpdf5-pCNLQXmnNQGTVufCKMULcjFPKL8riTnd8Aba4ORtW2g@mail.gmail.com>
References: <CAPpdf5_T=JjjUw2H5pAShmj4V6b5U8aALxDsiZvjyTUYy58DmQ@mail.gmail.com>
 <57C35ED0.2030107@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57C35ED0.2030107@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Aug 28, 2016 at 4:59 PM, Wols Lists <antlists@youngman.org.uk> wrote:
> On 28/08/16 22:43, o1bigtenor wrote:
>> Greetings
>>
>> I have been doing some research thinking toward the future.
>>
>> Is there a 'best' raid setup?
>
> What do you want to achieve? There's no such thing as "best" - there's
> only "most suitable for the circumstances".
>>
>> It seems to me (a noob) that each of the options carries some negatives with it.
>>
>> Is there a good option for say:
>>
>> 2 - 5 disks
>> 4 - 8 disks
>> 6 - 12 disks
>> 10 - 30 disks
>> etc.
>>
>> I looked at raid 5/6/10/50/60/100 and I am wondering where is the
>> 'best' use of each of these options?
>>
> Ignoring linear or stripe (which you seem to have done), with 2 disks
> the only option is raid 1 (mirror). 3 disks gives you raid 5, and 4
> disks gives you raid 6.
>
> But do you want to make maximum use of the disk space (raid 6 is your
> friend) or do you want maximum redundancy (raid 1)?
>
> For my home system I've got 2 x 3TB in a raid1 config. I had intended to
> add a 3rd drive and go raid5, but with two Barracudas I'd be an idiot
> :-( If I want to go that route, I need three new proper raid drives :-(
> I want maximum disk capacity with some redundancy, so raid 5 or 6 makes
> most sense for me.
>
> Without knowing what you want, we can't know what's best for you.

That's what it seems like - - - its possible to justify any setup.

I have 2 - 4 disc setups both running raid 10 trying to get s fairly high level
of security yet also some through put.

I'm asking because what do I do if I need to have say 10 to 25 TB of online
storage.

Do I go for my raid 10 with 2 sets of 6 TB discs or is there a better way to
achieve high levels of security AND throughput?

What about for the next level of storage (my thinking here) or at 35 to 100 TB?

Maybe the better question is - - - how do I decide what I want?

TIA

Dee
