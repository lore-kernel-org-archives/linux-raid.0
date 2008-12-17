From: David Greaves <david@dgreaves.com>
Subject: Re: MD Feature Request: non-degraded component replacement
Date: Wed, 17 Dec 2008 00:20:14 +0000
Message-ID: <494845BE.2090807@dgreaves.com>
References: <49477689.2010208@dgreaves.com> <alpine.DEB.1.10.0812160450080.28063@p34.internal.lan> <49478924.9010004@cgv.tugraz.at> <alpine.DEB.1.10.0812160636390.725@p34.internal.lan> <4947A585.4030203@dgreaves.com> <alpine.DEB.1.10.0812161824040.31132@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812161824040.31132@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Lars Schimmer <l.schimmer@cgv.tugraz.at>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Justin Piszcz wrote:
> Very thanks for this information, have you run other disks in the system
> without issue?  BTW: I have seen this with the Velociraptors as well:

NP

Yes. Historically I had more smaller disks in there. The system disks have also
been fine throughout.


FWIW, do you agree with my assessment of the feature request that started this
thread?
(Especially now you understand why I feel it's of value).

>> In fact each log shows "Completed: read failure" until the next log
>> pushes it
>> down the stack; at that point it shows "Aborted by host". The %
>> remaining is
>> key. Discussion on the smart list suggests that this is a firmware
>> bug. (Inde$
>> this is now fixed on some newer RMA replacements).
> 
> When a drive is about to crap out it will start doing that, it will
> abort the test or run forever..

Yes, this was just a FW bug though as it turned out.


> I take it you are running at RAID6 with these disks?
No :( .... but I'm *very* good at recovering RAID5 now ;)

I'm loathe to buy anymore disks - the Samsungs aren't something I want to spend
money on yet and if anything goes wrong with another brand of drive I can't get
advance RMA.


David


-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
