From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: How to backup of large md raid volumes?
Date: Sat, 20 May 2017 20:11:20 +0200
Message-ID: <ecd79046-2f0e-c336-3fc4-7b64ab794d68@thelounge.net>
References: <442a4af0-00d2-853d-5294-84ae0353262b@gmail.com>
 <28a4540b-c5ac-bd8d-c030-6d718a02fdfc@thelounge.net>
 <59208443.7080404@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59208443.7080404@youngman.org.uk>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Ram Ramesh <rramesh2400@gmail.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 20.05.2017 um 20:00 schrieb Wols Lists:
> On 19/05/17 06:49, Reindl Harald wrote:
>>
>>
>> Am 18.05.2017 um 23:37 schrieb Ram Ramesh:
>>> Any one have a method to backup large volumes like md raid6 (16TB)?
>>> Since the backup will not fit in one disk (in many cases and mine too)
>>> I am wondering, if there is a known/easy technique to backup using
>>> multiple usb hard drives. I googed and found a few fancy backup
>>> utils/systems like Amanda etc. They are overkill for me. I am choosing
>>> not to back up simply because of the complexity of setup as the data
>>> in my RAID volume is NOT precious and can be replaced with a week of
>>> effort.
>>>
>>> If any one can think of some thing simple, please point me to it and I
>>> will do the reading to figure out
>>
>> https://www.amazon.com/16TB-Desktop-External-Drive-WDBLWE0160JCH-NESN/dp/B01B6BN1CU
>>
>>
>> 499$ is not that much for a 16 TB external backup disk and whn you
>> format it with BTRFS and enable compression you most likely have a lot
>> fo space and your backup finally is just a single rsync command
> 
> My only reaction to that is it's not a 16TB disk. It's a 16TB raid-0
> array. We had a similar setup ages ago (when 500GB was huge) with a
> 500GB external USB drive. One of the 250GB drives failed and the entire
> array was lost

well, it's a *backup* drive - when it's gone it's gone

we are using a bunch of them with 4 TB since 2011 for offsite-backups of 
the whole company cluster and they are a RAID0 too



