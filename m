From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Fw: Why does one get mismatches?
Date: Sun, 24 Jan 2010 15:52:36 -0600
Message-ID: <4B5CC124.8010302@gmail.com>
References: <65698.36235.qm@web51306.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <65698.36235.qm@web51306.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Hardcastle wrote:
> --- On Fri, 22/1/10, Goswin von Brederlow <goswin-v-b@web.de> wrote:
> 
>> From: Goswin von Brederlow <goswin-v-b@web.de>
>> Subject: Re: Fw: Why does one get mismatches?
>> To: Jon@eHardcastle.com
>> Cc: linux-raid@vger.kernel.org
>> Date: Friday, 22 January, 2010, 18:13
>> Jon Hardcastle <jd_hardcastle@yahoo.com>
>> writes:
>>
>>> --- On Tue, 19/1/10, Jon Hardcastle <jd_hardcastle@yahoo.com>
>> wrote:
>>>> From: Jon Hardcastle <jd_hardcastle@yahoo.com>
>>>> Subject: Why does one get mismatches?
>>>> To: linux-raid@vger.kernel.org
>>>> Date: Tuesday, 19 January, 2010, 10:04
>>>> Hi,
>>>>
>>>> I kicked off a check/repair cycle on my machine
>> after i
>>>> moved the phyiscal ordering of my drives around
>> and I am now
>>>> on my second check/repair cycle and it has kept
>> finding
>>>> mismatches.
>>>>
>>>> Is it correct that the mismatch value after a
>> repair was
>>>> needed should equal the value present after a
>> check? What if
>>>> it doesn't? What does it mean if another check
>> STILL reveals
>>>> mismatches?
>>>>
>>>> I had something similar after i reshaped from raid
>> 5 to 6 i
>>>> had to run check/repair/check/repair several times
>> before i
>>>> got my 0.
>>>>
>>>>
>>> Guys,
>>>
>>> Anyone got any suggestions here? I am now on my ~5
>> check/repair and after a reboot the first check is still
>> returning 8.
>>> All i have done is move the drives around. It is the
>> same controllers/cables/etc 
>>> I really dont like the seeming random nature of what
>> can/does/has caused the mismatches?
>>
>> There is some unknown corruption going on with raid1 that
>> causes
>> mismatches but it is believed that it will never occur on
>> any used
>> block. Swapping is a likely cause.
>>
>> Any swap device on the raid? Try turning that off.
>> If that doesn't help try umounting filesystems or
>> remounting RO.
>>
>> MfG
>>         Goswin
> 
> Hello, my usual savior Goswin!
> 
> The deal is it is a 7 drive raid 6 array. it has LVM on it and is not used for swapping. I have umounted all LV's and still got mismatches, i run smartctl --test=long on all drives - nothing. I have now dismantled the array and am 3/4 the way through 'badblocks -svn' on each of the component drive. I have a hunch that it may be a dodgy SATA cable but have no evidence. No errors in log, nothing on dmesg.
> 
> Is there any way to get more information? I am starting to think this is more happened since i changed from raid 5 to 6..... which i did < 1 month ago.
> 
> The only lead i have is that whilst doing the bad blocks 1 drive ran at ~10~15MB/s whereas the rest are going at ~30 i have another identical model drive coming up so i will see if that one is slow too. But the lack of logging info is not helpful and worrying! and the prospect of silent corruption a big worry!
> 

It is possible that the reads are somehow corrupting sometimes.

I have seen a couple of different controllers fail and result in read 
corruptions, basically you have 50 largish files or so on the disk 
with the same checksum (50xsize needs to be 2x greater than ram), and 
you cksum all of the files and see if the cksum changes, if it does 
the "bad" file will move around, so in this case the data on disk 
should be ok.   I have seen a couple of different companies controller 
fail this way, usually it is from a bad PCI interface chip or a bad 
config (too fast) causing PCI parity errors.  I had one controller 
fail (broken) and cause errors (replaced with spare corrected), and in 
the second case I found that the MB was running the PCI bus too faster 
for the number of cards (two different companies FC card fails--both 
in slightly different ways-one silently corrupted, the other crashed 
the machine about the time an error would have been expected), and had 
to slow the bus down one step (PCIX-133 -> PCIX-100, or PCIX-100 to 
PCIX-66) and the issue went away.

In both cases I did not find any write corruptions, but found read 
corruptions often, if you have this happening with a raid5 device it 
would be bad if you had to use parity (corrupt read would mean 
regenerated parity would be wrong, and restore from parity would lead 
to corrupted data).

I don't know how strong the internal SATA communication is, if it uses 
CRC's errors are almost impossible on the cable, if it uses parity 
errors are easy, the PCI bus uses parity, so it is pretty easy for 
errors to get through, but I have only seen them very rarely, maybe 5 
times in 10,000 years of machine operations (2000+ machines for 
several years).
