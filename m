From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Disk Monitoring
Date: Thu, 29 Jun 2017 12:34:09 +0200
Message-ID: <9d921c24-2b06-6c70-f9d7-b58a913120c9@thelounge.net>
References: <20170628131917.BF1911235B6@gemini.denx.de>
 <CAJH6TXhJ8HoH=tnxreZ4EAFYQYDh05KHAQxwoLqp1f7zQM4N0g@mail.gmail.com>
 <7688279.9aYLlOU3Xu@matkor-lenovo>
 <CAJH6TXgp4CdrJ9a3Ku-R8Tj5Am+zeyRO_Bc_hFidWVLZW1f9vQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXgp4CdrJ9a3Ku-R8Tj5Am+zeyRO_Bc_hFidWVLZW1f9vQ@mail.gmail.com>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, Mateusz Korniak <mateusz-lists@ant.gliwice.pl>
Cc: Wolfgang Denk <wd@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 29.06.2017 um 12:25 schrieb Gandalf Corvotempesta:
> 2017-06-29 12:20 GMT+02:00 Mateusz Korniak <mateusz-lists@ant.gliwice.pl>:
>> Also SMART long test should perform "read/verify scan of all of the user data
>> area", so it is good idea to do it periodically and monitor results.
> 
> I'm already using this, but is not very reliable.
> I had some disks failed by hw raid controller due to unreadable sector
> (3/11) still passing the smart long test
> and some failed smart long test still passing the hw raid check

hence you do both - in any case, software-raid as well as hardware-raid

* scheduled smart check
* scheduled scrub

i had enough cases where while the scrub was running smartd alerted 
about a disk going bad - at the end of the day it don't matter which of 
both cries, the point is that you get (hopefully) a alert that you 
should replace a specific disk before a second one starts to go bad
