From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: SSD + Rust as raid1
Date: Fri, 07 Jun 2013 18:23:56 -0400
Message-ID: <51B25D7C.4090403@tmr.com>
References: <51A7C36F.4030605@timedicer.co.uk> <20130531133018.77cd9285@natsu> <51A85574.8080709@timedicer.co.uk> <20130531135434.5b6bdddb@natsu> <51A864E1.9070903@timedicer.co.uk> <51ADA1AF.6040405@timedicer.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51ADA1AF.6040405@timedicer.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Dominic Raferd <dominic@timedicer.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dominic Raferd wrote:
>
> On 31/05/2013 09:52, Dominic Raferd wrote:
>> On 31/05/2013 08:54, Roman Mamedov wrote:
>>> On Fri, 31 May 2013 08:47:00 +0100
>>> Dominic Raferd <dominic@timedicer.co.uk> wrote:
>>>
>>>> This is my idea too (see my OP), but I am concerned about optimisation
>>>> (--write-behind, --bitmap and --bitmap-chunk settings) especially for
>>>> writes.
>>>> --write-behind=16384
>>> I think this will not work, you will have to use 16383.
>> Oh, OK, so 16383 is the maximum then?
>>
>>>> --bitmap=/mnt/sda1/write-intent-bitmap.file
>>> Save yourself lots of maintenance headache, just use --bitmap=internal
>>>
>>>> --bitmap-chunk=256M
>>> Looks OK.
>>>
>> Thanks Roman, but the problem with using --bitmap=internal is that, as
>> Neil Brown posted here on another topic a while ago, this requires a
>> synch write to both devices, and the use-case for which write-behind was
>> developed involved an external bitmap. Hence my plan to use external
>> bitmap file on a fast (SSD-based) separate partition - minimises any
>> slow-down caused by having to maintain the write-intent bitmap file.
>>
>
> I would be very grateful if someone could confirm whether, if I set up RAID1 
> and with one of the drives specify --write-mostly --write-behind=n, that 
> maximum 'n' is 16383, and also whether it is permitted in this configuration 
> to set --bitmap=none and thus avoid the overhead of maintaining a write-intent 
> bitmap file? (My thinking is that for my  needs the extra safety provided by 
> the bitmap file is overkill and the slowing effect (and life-shortening of my 
> SSD) might be more significant.) If I have to have a bitmap file, it is 
> presumably faster to have a larger chunk size, is the maximum permitted 256M?

If you want performance I think a too big chunk size will hurt you. And as I 
understand the way repair on a RAID1 is done, without the bitmap you have a 
chance of the older data on the HDD being used to "correct" the likely better 
data on the SDD.

-- 
Bill Davidsen <davidsen@tmr.com>
   We are not out of the woods yet, but we know the direction and have
taken the first step. The steps are many, but finite in number, and if
we persevere we will reach our destination.  -me, 2010


