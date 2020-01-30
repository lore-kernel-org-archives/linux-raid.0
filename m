From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Is it possible to break one full RAID-1 to two degraded RAID-1?
Date: Thu, 30 Jan 2020 07:30:11 +0100
Message-ID: <551449ed-49f9-e567-09d3-981f4cf9eea9@thelounge.net>
References: <1120831b-13e6-6a5d-8908-ee6a312e7302@gmail.com>
 <aa41492c-1ad7-070f-9bc6-646977364758@thelounge.net>
 <2c4fedff-a1c9-6ca3-5385-72b542a4a0b4@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2c4fedff-a1c9-6ca3-5385-72b542a4a0b4@gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 29.01.20 um 23:32 schrieb Ram Ramesh:
> On 1/28/20 10:09 PM, Reindl Harald wrote:
>>
>> Am 29.01.20 um 04:17 schrieb Ram Ramesh:
>>> I have my entire debian 9.0 installation (root/usr/home etc) in two nvme
>>> RAID-1 mirror. Is it possible to break them in to two degraded arrays?
>>>
>>> Specifically I want to do this.
>>>
>>> 1. Break current debian 9 full RAID1 into two degraded RAID1 A &
>>> RAID1  B
>>> 2. Boot only A and upgrade to debian 10 and make sure it works
>>> 3. If it works, add B back into A and get Debian 10 in fully complete
>>> RAID1
>>> 4. If it does not work, I boot B and add A back and get back debian 9
>>>     in full working RAID1
>> i would simply remove one disk completly and in case i want to keep the
>> upgraded system wipe it and resync afterwards or when i want back to the
>> old one put it back and wipe the modified
>>
>> full resync, done
> 
> Thanks. I thought of this, but both disk in question are nvme ssd with
> manually added heat sink. It will be a hassle to remove and reinstall. I
> think I will go with the back up rather than remove disk physically. 

why would you remove it phyiscally to remove it rom the array? seriously?
