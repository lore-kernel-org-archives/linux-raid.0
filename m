From: Christopher Smith <csmith@nighthawkrad.net>
Subject: Re: Best way to achieve large, expandable, cheap storage?
Date: Fri, 21 Oct 2005 14:40:31 +1000
Message-ID: <4358713F.1080009@nighthawkrad.net>
References: <dhje16$tmq$1@sea.gmane.org> <433F63BB.3020008@nighthawkrad.net> <7f55de720510030933k26608cfsda63326a8438e35d@mail.gmail.com> <43420091.9060601@nighthawkrad.net> <43577022.5010306@robinbowes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43577022.5010306@robinbowes.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Bowes <robin-lists@robinbowes.com>
Cc: Sebastian Kuzminsky <seb.kuzminsky@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Bowes wrote:
> Christopher Smith said the following on 04/10/2005 05:09:
> 
>> Yep, that's pretty much bang on.  The only thing you've missed is 
>> using pvmove to physically move the data off the 
>> soon-to-be-decomissioned PVs(/RAID arrays).
>>
>> Be warned, for those who haven't used it before, pvmove is _very_ slow.
> 
> 
> I've just been re-reading this thread.

[...]

> I use pvmove something like this:
> 
> # pvmove /dev/md1 /dev/md3

It would actually just be 'pvmove <old md device>', but the gist is correct.

Someone else has already responded to your questions, but just something 
else to be aware of with pvmove, is that it might hang your system 
(requiring a hard boot) when you try and use it, although the process 
will proceed and complete without error (in the background) once you 
have restarted.

It's been several months since I last used pvmove, so this bug may have 
been fixed, but it was certainly present on FC4 back then.  Basically 
running pvmove would immediately hang the system (no response to 
keyboard, etc), but after a hard reboot the pvmove process would start 
up and then complete in the background.

Again, this may well have been fixed and you might not see it, but just 
a word of warning so your first reaction isn't something rash ;).  Since 
pvmove appears to do its thing by *copying* everything from one PV to 
another, rather than moving it, even if the machine crashes during the 
process there's no data loss.

CS
