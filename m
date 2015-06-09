From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Migrating a RAID 5 from 4x2TB to 3x6TB ?
Date: Tue, 09 Jun 2015 20:06:00 +0100
Message-ID: <55773918.7020109@youngman.org.uk>
References: <167089395.613.1433791723592.JavaMail.zimbra@wieser.fr> <55767860.5000803@gmail.com> <1222347192.1017.1433875572719.JavaMail.zimbra@wieser.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1222347192.1017.1433875572719.JavaMail.zimbra@wieser.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Pierre Wieser <pwieser@trychlos.org>, Can Jeuleers <can.jeuleers@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/06/15 19:46, Pierre Wieser wrote:
> ---- Original Message -----
>> On 08/06/15 21:28, Pierre Wieser wrote:
>>> Hi all,
>>>
>>> I currently have an almost full RAID 5 built with 4 x 2 TB disks.
>>> I wonder if it would be possible to migrate it to a bigger RAID 5
>>> with 3 x 6TB new disks.
>>
>> I'd recommend against it:
>>
>> https://en.wikipedia.org/wiki/RAID#Unrecoverable_read_errors_during_rebuild
> 
> Oop's! I was not conscious at all of this issue. It happens that I am currenly
> living dangerously as I have another RAID 5 11,5 TB device :( I had already
> seen various administration issues when the size increases to this level, but
> I tought this was only an issue regarding the volumes organization (not tought
> deeply enough, obviously)....
> 
> Starting from your link, and searching a bit, I understand now that the 10TB
> is a maximal limit for desktop-grade disks (regarding the URE at least). And
> thus for any element of a RAID device which needs to be scanned at recovery
> time.
> Apart from my poor english, would you say I'm right with this ?

I don't think so. You may be lucky, and your drives are better than
average. You may be unlucky, and your drives are worse than average.

DON'T USE DESKTOP GRADE DISKS EXCEPT IN RAID 1. That said, I'm using
Seagate Barracudas which I was planning to upgrade to raid 5 - not a
good idea :-(
> 
> Does linux-raid have any recommandation(s) when managing more than 10TB of data ?
> 
> I may imagine:
> - several smaller RAID 5 devices
> - would RAID10 be a valuable solution in your opinion ?

Read the list archive. There's a bunch of stuff about how to mitigate
the problem - mostly by increasing the raid timeout (the problem is,
basically, that the raid software returns with an error before the disk
times out - increase the raid timeout and it will detect the disk error
and retry).
> 
> (as a precision, all my servers have been migrated to CentOS 7.1)
> 
> Nonetheless, I thank you very much for the link, which may prevent me to
> lose a big bunch of data !
> 
"man smartctl" is your friend :-)

You'll have to read up, but try

"smartctl -i /dev/sdx"

That'll tell you if smart is turned on - if it isn't, turn it on.

"smartctl -s on /dev/sdx"

Then do

"smartctl -x /dev/sdx"

and look for anything about ERC or Error Recovery Control. From my
Barracudas I get

SCT Data Table command not supported

SCT Error Recovery Control command not supported

Device Statistics (GP Log 0x04) not supported

OOPS!!! These drives are NOT NOT NOT suitable for raid :-( Everything
will be fine if I increase the raid timeout, but given that the typical
drive timeout is two minutes, the raid timeout needs to be longer than
that which means if I have any soft errors, the rebuild will be horribly
slow.

Looks like my next drives will be WD Reds, they're not much more expensive.

WARNING: If you have to enable smartctl, it's supposed to survive a
cold-boot, but it doesn't look like it has on my drives, and it's
reported a lot of drives don't. You need to make sure you have a boot
script that forces it on, and forces ERC on or sets the timeout.


All that said, as you can see, desktop drives are fine for raid IF
repeat IF you take the necessary precautions. They're probably fine on a
desktop :-)

Cheers,
Wol

