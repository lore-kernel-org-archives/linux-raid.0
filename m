From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: RAID6 dead on the water after Controller failure
Date: Sat, 15 Feb 2014 16:04:45 -0600
Message-ID: <CAKuK5J0jxUUvkAY-U2Q6v5j9hf_nasOQOjvFGe+ThYaDFRt7yA@mail.gmail.com>
References: <7A417EAE-106E-4541-941F-1002696F8735@gmail.com>
 <52FE7E2D.8020308@turmel.org> <5269CCC7-A0A7-479E-9738-88C74CB19435@gmail.com>
 <52FF83F1.3030904@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52FF83F1.3030904@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Florian Lampel <florian.lampel@gmail.com>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Feb 15, 2014 at 9:12 AM, Phil Turmel <philip@turmel.org> wrote:
> Good morning Florian,

I'm very pleased to have observed this interaction. What an excellent
example, and I'm glad you've got your raid running again.

However, I was hoping I might have some questions answered.

...
> Device order has changed, summary:
>
> /dev/sda1: WD-WMC300595440 Device #4 @442
> /dev/sdb1: WD-WMC300595880 Device #5 @442
> /dev/sdc1: WD-WMC1T1521826 Device #6 @442
> /dev/sdd1: WD-WMC300314126 spare
> /dev/sde1: WD-WMC300595645 Device #8 @435
> /dev/sdf1: WD-WMC300314217 Device #9 @435
> /dev/sdg1: WD-WMC300595957 Device #10 @435
> /dev/sdh1: WD-WMC300313432 Device #11 @435
> /dev/sdj1: WD-WMC300312702 Device #0 @442
> /dev/sdk1: WD-WMC300248734 Device #1 @442
> /dev/sdl1: WD-WMC300314248 Device #2 @442
> /dev/sdm1: WD-WMC300585843 Device #3 @442

So there are 7 drives with event count 442, 4 drives with event count
435, and a single spare.
...

> After assembly, your array will be single-degraded but fully functional.
>  That would be a good time to backup any critical data that isn't
> already in a backup.

Out of 12 drives, I thought RAID6 only offered a total of *2* failed devices.
It seems to me that you have 7 devices in sync and 4 *almost* in sync.
It's this "almost" part that has me confused. How can the raid run if
the event count doesn't match? Wouldn't at least 10 out of 12 drives
have to have the same event count to avoid data loss?


-- 
Jon
