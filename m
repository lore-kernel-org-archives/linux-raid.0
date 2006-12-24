From: John McMonagle <johnm@advocap.org>
Subject: Re: Raid corruption problems.
Date: Sun, 24 Dec 2006 08:00:42 -0600
Message-ID: <458E880A.7030400@advocap.org>
References: <4582FD12.90806@advocap.org> <45885C2A.40602@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45885C2A.40602@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:

> John McMonagle wrote:
>
>> Have a raid1  backup server that seems to get corrupted.
>> This is the 3rd time in about a year.
>> Have 2 other backup servers that were cloned from this one that have
>> no problems.
>>
>> Done a couple kernel upgrades recently.
>> Now has 2.6.18-2 kernel.
>> It's based on Debian sarge.
>>
>> It's a low end Intel server motherboard using ata_piix sata driver.
>> Have another mother board just like doing raid1 with sata drives that
>> has had no problems but it has a much lighter disk load.
>> smartctl has never shown any problems.
>> In /sys/block/md2 did
>> echo check > syncaction
>> No error messages but mismatch_cnt  is 1152.
>> rc0/errors and rc1/errors are both 0.
>>
>> I'm guessing a hardware problem.
>> Any suggestions? 
>
>
> Since memory is the easiest to test, I'd try memtest86+ for at least
> 12 hr. If this were PATA I'd suggest replugging the cables, but it's
> lower probability with SATA. Still, probably worth trying.
>
Ran  Memtest86+ for over 18 hours with no errors.
Also have ecc ram.
I can look at the cables next time I'm  there.
Doesn't  sata do some sort of error checking over the cables?
Anything else to try?


Memtest86+ v1.65      | Pass 74% ############################
Pentium 4 (0.09) 2793 MHz   | Test 61% #######################
L1 Cache:   16K 17135MB/s   | Test #7  [Random number sequence]
L2 Cache: 1024K 15179MB/s   | Testing:  112K - 1024M 1024M
Memory  : 1024M  2059MB/s   | Pattern:   189170f4
Chipset : Intel i875P (ECC : Detect / Correct) - PAT : Enabled
Settings: RAM : 199 MHz (DDR398) / CAS : 3-3-3-8 / Dual Channel (128 bits)

 WallTime   Cached  RsvdMem   MemMap   Cache  ECC  Test  Pass  Errors
ECC Errs
 ---------  ------  -------  --------  -----  ---  ----  ----  ------
--------
  18:52:27   1024M     120K  e820-Std    on   off   Std    56       0
 -----------------------------------------------------------------------------

-- 
John McMonagle
IT Manager
Advocap Inc.


