From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: RAID 1 | Test Booting from /dev/sdb
Date: Tue, 5 May 2020 10:34:54 +0100
Message-ID: <5EB1333E.1010801@youngman.org.uk>
References: <221092f3-5b8a-5d95-01d9-261e6449f747@peter-speer.de>
 <5EB12900.3030505@youngman.org.uk>
 <608e4d08-a99d-97f3-0476-3a880096f858@peter-speer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <608e4d08-a99d-97f3-0476-3a880096f858@peter-speer.de>
Sender: linux-raid-owner@vger.kernel.org
To: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/05/20 10:25, Stefanie Leisestreichler wrote:
> 
> On 05.05.20 10:51, Wols Lists wrote:
>>> Change boot medium to /dev/sdb
>>> and do a "mdadm /dev/md0 --add /dev/sda1" to get it recovered again
>>> without loosing the "added" data (i.e. in /var/log) from booting? Also
>>> device identifiers could change I guess. Even if I am fine with loosing
>>> the "added" data from booting with /dev/sdb, will - when booting again
>>> from /dev/sda - /dev/sda be the master in the array again?
>>>
>>> It is not clear to me if I understood correctly in which case which
>>> array member will be the master which will be the base for recovery. Is
>>> it always the HD one booted from?
>>>
>> The "master" if recovery is required will be the "older" one - in this
>> case sda because it was disconnected. HOWEVER. Just check whether you
>> have a bitmap or journal enabled. You can't have both at once, but the
>> result should be that sda rejoins the array cleanly, raid has a record
>> of which writes occurred while it was offline, and it will be updated.
>>
> 
> Does this mean in my scenario /dev/sda1 will come up again and will held
> data in /var/log/ where I can see i.e. log entries which are written
> when the system booted up using /dev/sdb as boot device?

No. The journal or bitmap are stored as part of the array, not the
filesystem. sdb will have a load of "flags" set to say "these blocks
were written to while the array was degraded". So when sda is added back
in, these delayed writes will be copied from sdb to sda.
> 
> I try to be prepared, just in case :-)

Don't we all :-)
> 
> Thanks again for sharing your knowledge, Wols.
> It is highly appreciated.

It's not that deep, but I do try to be clear what I do and don't know
:-) I'm lucky I have a very good memory.

Cheers,
Wol
