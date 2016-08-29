From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Raid settings
Date: Mon, 29 Aug 2016 12:46:22 +1000
Message-ID: <038ec076-aa03-993f-7c9a-15f09fac02b4@websitemanagers.com.au>
References: <CAPpdf5_T=JjjUw2H5pAShmj4V6b5U8aALxDsiZvjyTUYy58DmQ@mail.gmail.com>
 <57C35ED0.2030107@youngman.org.uk>
 <CAPpdf5-pCNLQXmnNQGTVufCKMULcjFPKL8riTnd8Aba4ORtW2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPpdf5-pCNLQXmnNQGTVufCKMULcjFPKL8riTnd8Aba4ORtW2g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: o1bigtenor <o1bigtenor@gmail.com>, Wols Lists <antlists@youngman.org.uk>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 29/08/16 12:28, o1bigtenor wrote:
> On Sun, Aug 28, 2016 at 4:59 PM, Wols Lists <antlists@youngman.org.uk> wrote:
>> On 28/08/16 22:43, o1bigtenor wrote:
>>> Greetings
>>>
>>> I have been doing some research thinking toward the future.
>>>
>>> Is there a 'best' raid setup?
>> What do you want to achieve? There's no such thing as "best" - there's
>> only "most suitable for the circumstances".
>>> It seems to me (a noob) that each of the options carries some negatives with it.
>>>
>>> Is there a good option for say:
>>>
>>> 2 - 5 disks
>>> 4 - 8 disks
>>> 6 - 12 disks
>>> 10 - 30 disks
>>> etc.
>>>
>>> I looked at raid 5/6/10/50/60/100 and I am wondering where is the
>>> 'best' use of each of these options?
>>>
>> Ignoring linear or stripe (which you seem to have done), with 2 disks
>> the only option is raid 1 (mirror). 3 disks gives you raid 5, and 4
>> disks gives you raid 6.
>>
>> But do you want to make maximum use of the disk space (raid 6 is your
>> friend) or do you want maximum redundancy (raid 1)?
>>
>> For my home system I've got 2 x 3TB in a raid1 config. I had intended to
>> add a 3rd drive and go raid5, but with two Barracudas I'd be an idiot
>> :-( If I want to go that route, I need three new proper raid drives :-(
>> I want maximum disk capacity with some redundancy, so raid 5 or 6 makes
>> most sense for me.
>>
>> Without knowing what you want, we can't know what's best for you.
> That's what it seems like - - - its possible to justify any setup.
>
> I have 2 - 4 disc setups both running raid 10 trying to get s fairly high level
> of security yet also some through put.
>
> I'm asking because what do I do if I need to have say 10 to 25 TB of online
> storage.
>
> Do I go for my raid 10 with 2 sets of 6 TB discs or is there a better way to
> achieve high levels of security AND throughput?
>
> What about for the next level of storage (my thinking here) or at 35 to 100 TB?
>
> Maybe the better question is - - - how do I decide what I want?
>

Hi,
I think you are forgetting that there are multiple factors, you are only 
looking at the storage capacity, and to some degree protection. You also 
need to consider what sort of performance you want to achieve, and this 
is usually the deciding factor.

To get 25TB, you can easily use 3 x 10TB drives in RAID0 .... but if you 
want some level of protection, then you could choose 4 in RAID5, or 5 in 
RAID6, or 6 in RAID10.
You of course have the same options when you want 35, or 100, or 1000TB 
etc...
RAID10 will scale linearly, simply keep adding drives in pairs, and you 
will continue to have the similar level of protection (I guess the 
chance of a pair of drives failing increases as you have more pairs)...
RAID5/6 you will likely want to use RAID50/60 with no more than X drives 
in each RAID5/6 part, where X is determined by your 
performance/storage/reliability decisions.

After all that, you then need to look at another dozen options, (bitmap, 
chunk size, etc etc), which will also have a significant impact on 
performance (and reliability).

To get 35TB, you might do either 16 x 8TB drives in RAID10 (40TB) or you 
can do 7 x 8TB drives in RAID6 (at these capacities, I'd strongly 
suggest you skip RAID5). You could also consider doing 14 x 8TB drives 
in RAID60 (two sets of 7 drives).

PS, you will want to use this range of drives:
http://www.wdc.com/en/products/internal/nas/

Or equivalent, as long as it definitely supports SCT/ERC.

Regards,
Adam


-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
