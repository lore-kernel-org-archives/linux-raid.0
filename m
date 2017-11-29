From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: New setup: partitions or raw devices
Date: Wed, 29 Nov 2017 21:02:12 +0100
Message-ID: <3654cb70-9d7c-dfc0-f57d-c57004f11f92@thelounge.net>
References: <CAJH6TXj4wp-k2QQ0O8W2PDQEg9QHcWwPkOEOSzMgvtbV6b21Cw@mail.gmail.com>
 <7f6abcbc-7dfa-0252-e9df-984e7e637936@thelounge.net>
 <CAJH6TXjbAFjP66HN54kiUffd=zt0HUgyQmcvsU-mYpJRUaQafw@mail.gmail.com>
 <e62ea493-3fae-5c3e-5578-f426dc3d254e@thelounge.net>
 <CAJH6TXgtn7Gqryvs1HKfFCodEqXCaHvy+kXX8kRxWgS25ZUDYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXgtn7Gqryvs1HKfFCodEqXCaHvy+kXX8kRxWgS25ZUDYQ@mail.gmail.com>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 29.11.2017 um 20:51 schrieb Gandalf Corvotempesta:
> 2-5% ? With current hdd size (ie, 8TB), 2% is about 160GB.
> I don't have disks with that size, but only 2 or 4TB. Are hundreds of
> GB needed ? Why not 100MB ?

in case of 2 TB disks it's 40 GB per disk

because 100 MB IMHO don't help that much for SSD overprovisioning and 
given how it may extend the lifetime versus the price and you don't have 
your disks typically filled completly

in a 4 drive RAID10 it's 80 GB missing useable disk space for 
overprovisioning out of around 3.6 TB (1000 versus 1024) while you have 
a lightning fast array which should last as long as possible without 
replace terrible expensive drives

why not RAID5/6? besides 
https://www.askdbmgt.com/why-raid5-should-be-avoided-at-all-costs.html 
the parity data are additional writes wearing out the drives

> 2017-11-29 19:28 GMT+01:00 Reindl Harald <h.reindl@thelounge.net>:
>>
>>
>> Am 29.11.2017 um 18:38 schrieb Gandalf Corvotempesta:
>>>
>>> 2017-11-29 17:44 GMT+01:00 Reindl Harald <h.reindl@thelounge.net>:
>>>>
>>>> * leave some space free in case a replacement disk has
>>>>     a slighty different usebale size - some SSD's do
>>>>     this instead overprovisioning for wear leveling
>>>
>>>
>>> Good reason.
>>> How much space would you reserve ? 100MB? 1GB ?
>>
>>
>> if i would be in the position without create arrays from scratch these das i
>> would leave 2-5% of the disks for overprovisioning instead only 20 MB as i
>> did in 2011 because i am about to replace with SSD which i did not consider
>> that days
