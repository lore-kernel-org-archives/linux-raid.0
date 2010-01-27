From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Question about raid robustness when disk fails
Date: Tue, 26 Jan 2010 20:22:56 -0800
Message-ID: <4877c76c1001262022p369eac60s639d87cad743ff94@mail.gmail.com>
References: <1262972385.8962.159.camel@kije>
	 <87hbqeyua9.fsf@frosties.localdomain>
	 <7d86ddb91001261619kbb77697t2660e5b8cc44535d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7d86ddb91001261619kbb77697t2660e5b8cc44535d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ryan Wagoner <rswagoner@gmail.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Tim Bock <jtbock@daylight.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 26, 2010 at 4:19 PM, Ryan Wagoner <rswagoner@gmail.com> wro=
te:
> On Fri, Jan 22, 2010 at 11:32 AM, Goswin von Brederlow
> <goswin-v-b@web.de> wrote:
>> Tim Bock <jtbock@daylight.com> writes:
>>
>>> Hello,
>>>
>>> =A0 =A0 =A0 I built a raid-1 + lvm setup on a Dell 2950 in December=
 2008. =A0The OS
>>> disk (ubuntu server 8.04) is not part of the raid. =A0Raid is 4 dis=
ks + 1
>>> hot spare (all raid disks are sata, 1TB Seagates).
>>>
>>> =A0 =A0 =A0 Worked like a charm for ten months, and then had some k=
ind of disk
>>> problem in October which drove the load average to 13. =A0Initially=
 tried
>>> a reboot, but system would not come all of the way back up. =A0Had =
to boot
>>> single-user and comment out the RAID entry. =A0System came up, I ma=
nually
>>> failed/removed the offending disk, added the RAID entry back to fst=
ab,
>>> rebooted, and things proceeded as I would expect. =A0Replaced offen=
ding
>>> drive.
>>
>> If a drive goes crazy without actualy dying then linux can spend a
>> long time trying to get something from the drive. The driver chip ca=
n
>> go crazy or the driver itself can have a bug and lockup. All those
>> things are below the raid level and if they halt your system then ra=
id
>> can not do anything about it.
>>
>> Only when a drive goes bad and the lower layers report an error to t=
he
>> raid level can raid cope with the situation, remove the drive and ke=
ep
>> running. Unfortunately there seems to be a loose correlation between
>> cost of the controler (chip) and the likelyhood of a failing disk
>> locking up the system. I.e. the cheap onboard SATA chips on desktop
>> systems do that more often than expensive server controler. But that
>> is just a loose relationship.
>>
>> MfG
>> =A0 =A0 =A0 =A0Goswin
>>
>> PS: I've seen hardware raid boxes lock up too so this isn't a drawba=
ck
>> of software raid.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
> You need to be using drives designed for RAID use with TLER (time
> limited error recovery). When the drive encounters an error instead o=
f
> attempting to read the data for an extended period of time it just
> gives up so the RAID can take care of it.
>
> For example I had a SAS drive start to fail on a hardware RAID server=
=2E
> Every time it hit a bad spot on the drive you could tell the system
> would pause for a brief second as only that drive light was on. The
> drive gave up and the RAID determined the correct data. It ran fine
> like this until I was able to replace the drive the next day.
>
> Ryan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Why doesn't the kernel issue a pessimistic alternate 'read' path (on
the other drives needed to obtain the data) if the ideal method is
late.  It would be more useful for time-sensitive/worst case buffering
to be able to customize when to 'give up' dynamically.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
