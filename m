From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Performance of a software raid 5
Date: Wed, 22 Apr 2009 08:29:36 -0400
Message-ID: <49EF0DB0.6090800@tmr.com>
References: <a5cd9eed0904201012o67503049laa50f4cb5b8d88de@mail.gmail.com>	 <49ED096E.1000002@anonymous.org.uk>	 <a5cd9eed0904201710j5b05d9cam8a61b50f34eda2c0@mail.gmail.com>	 <49ED18E6.1090301@anonymous.org.uk>	 <a5cd9eed0904201805n1b52aafm206bda5a1afc0b5c@mail.gmail.com>	 <15c92f8bd27d912e292c013fea2467e4.squirrel@neil.brown.name> <a5cd9eed0904201904o29c02a8csb875ae68ba19e681@mail.gmail.com> <49EE16F7.8060406@fatooh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49EE16F7.8060406@fatooh.org>
Sender: linux-raid-owner@vger.kernel.org
To: Corey Hickey <bugfood-ml@fatooh.org>
Cc: Johannes Segitz <johannes.segitz@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Corey Hickey wrote:
> Johannes Segitz wrote:
>   
>> On Tue, Apr 21, 2009 at 3:19 AM, NeilBrown <neilb@suse.de> wrote:
>>     
>>> Have you done any testing without the crypto layer to see what effect
>>> that has?
>>>
>>> Can I suggest:
>>>
>>>  for d in /dev/sd[gjk]1 /dev/md6 /dev/mapper/data bigfile
>>>  do
>>>    dd if=$d of=/dev/null bs=1M count=100
>>>  done
>>>
>>> and report the times.
>>>       
>> tested it with 1gb instead of 100 mb
>>
>> sdg
>> 1048576000 bytes (1.0 GB) copied, 9.89311 s, 106 MB/s
>> sdj
>> 1048576000 bytes (1.0 GB) copied, 10.094 s, 104 MB/s
>> sdk
>> 1048576000 bytes (1.0 GB) copied, 8.53513 s, 123 MB/s
>> /dev/md6
>> 1048576000 bytes (1.0 GB) copied, 11.4741 s, 91.4 MB/s
>> /dev/mapper/data
>> 1048576000 bytes (1.0 GB) copied, 34.4544 s, 30.4 MB/s
>> bigfile
>> 1048576000 bytes (1.0 GB) copied, 26.6532 s, 39.3 MB/s
>>
>> so the crypto indeed slows it down (and i'm surprised that it's that
>> bad because i've read
>> it's not a big hit on current CPUs and the X2 isn't new but not that
>> old) but still read speed
>> from md6 is worse than from one drive alone
>>     
>
> If it helps, some recent dd benchmarks I did indicate that twofish is
> about 25% faster than aes on my Athlon64.
>
> Athlon64 3400+ 2.4 GHz, 64-bit Linux 2.6.28.2
>
> Both aes and twofish are using the asm implementations according to
> /proc/crypto.
>
> All numbers are in MB/s; average of three tests for a 512MB dd
> read/write to the encrypted device.
>
>                                  read       write
> aes                              69.4        61.0
> twofish                          86.8        76.6
> aes-cbc-essiv:sha256             65.1        56.3
> twofish-cbc-essiv:sha256         82.6        73.5
>   

Good info, but was the CPU maxed or was something else the limiting factor?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


