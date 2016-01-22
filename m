From: Dark Penguin <darkpenguin@yandex.ru>
Subject: Re: md failing mechanism
Date: Sat, 23 Jan 2016 01:50:11 +0300
Message-ID: <56A2B223.7060804@yandex.ru>
References: <56A26E11.2090703@yandex.ru> <56A28309.9080806@turmel.org> <56A2A2C3.9000801@yandex.ru> <56A2AAB1.6070305@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56A2AAB1.6070305@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> C) Suffer with desktop drives without SCTERC support. They cannot be
>> set to appropriate error timeouts. Udev or boot script assistance is
>> needed to set a 120 second driver timeout in sysfs. They do *not* work
>> properly with MD out of the box.

 > the recommended timeout for 'C' has drifted upward to 180.

Yes, I saw this; but, is it really not possible to examine the default 
timeout in a certain desktop drive, rather than follow rough estimates 
like "about two of three minutes should be enough"?.. I wanted to make 
sure it is indeed not possible, because that is hard to believe. Or do 
they not have a specified timeout at all?..


> Since that was written, 'A' would now include almost-enterprise drives
> with RAID ratings like the Western Digital Red family.

Yes, I understand that; always make sure they support it.


>> Still, I don't think it has anything to do with what has happened to my
>> "small file server"...
>
> That's why I asked for the dmesg.  It could have been a bug.  No crisis
> if it's lost, so long as you've accepted one of A through D above.

I've moved all the data to another server, disassembled this one, and 
reused the surviving hard drive, so I'm safe, but sadly, no logs. The 
important thing is, I've confirmed that this is not the expected 
behaviour - I was kind of ready to hear that "that's how it is with 
softraids, faulty drives hang your entire system like they hang Windows".

I've checked all my hard drives in all my RAIDs; all of them support 
"TL;DR" technology. They were all made before the "crippling" tendencies 
took over, and they are mostly Hitachi, so I'm lucky.


-- 
darkpenguin
