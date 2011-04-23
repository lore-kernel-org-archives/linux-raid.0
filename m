From: "Majed B." <majedb@gmail.com>
Subject: Re: Direct disk access on IBM Server
Date: Sat, 23 Apr 2011 17:05:01 +0300
Message-ID: <BANLkTi=CLD=Cd0Ngj1hXqQtz3Cb6ir4yRg@mail.gmail.com>
References: <iok28i$tp6$1@dough.gmane.org> <4DADEBC3.9060404@hardwarefreak.com>
 <iomfkq$qqr$1@dough.gmane.org> <4DAEC627.3030904@grumpydevil.homelinux.org>
 <iomj0a$e5m$1@dough.gmane.org> <4DAFCDB0.9070609@hardwarefreak.com> <iop4s2$cjp$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <iop4s2$cjp$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I've setup a bunch of software RAID boxes and I've had my main one
running at a friend's place with about 16 disks and 9TB of data.

One time 2 disks had bad sectors and things took a bad turn. It was a
RAID5 array, so I had to salvage everything I could rather than losing
everything we had there (no backups). It took me about 3 weeks of
working daily for about 6 hours a day in cloning disks, recovering
files and validating checksums. It was not fun at all.

If you have critical data, I'd suggest you add a battery and an
sd-card/flash card to your hardware RAID array. At least if the power
goes off, whatever is in the cache will be written to the card and
later on to the disks when power is restored.

A UPS will not help you if your power supply decides to commit seppuku.

If you keep daily backups, or any form of backups, go ahead with
software RAID and keep yourself free from vendor lock.

Regards,

On Thu, Apr 21, 2011 at 2:36 PM, David Brown <david.brown@hesbynett.no>=
 wrote:
> On 21/04/11 08:24, Stan Hoeppner wrote:
>>
>> David Brown put forth on 4/20/2011 7:21 AM:
>>
>>> It's true that boot loaders and software raid can be an awkward
>>> combination.
>>
>> ...
>>>
>>> Yes, it's a few extra steps.
--=20
=C2=A0 =C2=A0 =C2=A0=C2=A0 Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
