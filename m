From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Re: Question about raid robustness when disk fails
Date: Tue, 26 Jan 2010 19:19:11 -0500
Message-ID: <7d86ddb91001261619kbb77697t2660e5b8cc44535d@mail.gmail.com>
References: <1262972385.8962.159.camel@kije>
	 <87hbqeyua9.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87hbqeyua9.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Tim Bock <jtbock@daylight.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 22, 2010 at 11:32 AM, Goswin von Brederlow
<goswin-v-b@web.de> wrote:
> Tim Bock <jtbock@daylight.com> writes:
>
>> Hello,
>>
>> =A0 =A0 =A0 I built a raid-1 + lvm setup on a Dell 2950 in December =
2008. =A0The OS
>> disk (ubuntu server 8.04) is not part of the raid. =A0Raid is 4 disk=
s + 1
>> hot spare (all raid disks are sata, 1TB Seagates).
>>
>> =A0 =A0 =A0 Worked like a charm for ten months, and then had some ki=
nd of disk
>> problem in October which drove the load average to 13. =A0Initially =
tried
>> a reboot, but system would not come all of the way back up. =A0Had t=
o boot
>> single-user and comment out the RAID entry. =A0System came up, I man=
ually
>> failed/removed the offending disk, added the RAID entry back to fsta=
b,
>> rebooted, and things proceeded as I would expect. =A0Replaced offend=
ing
>> drive.
>
> If a drive goes crazy without actualy dying then linux can spend a
> long time trying to get something from the drive. The driver chip can
> go crazy or the driver itself can have a bug and lockup. All those
> things are below the raid level and if they halt your system then rai=
d
> can not do anything about it.
>
> Only when a drive goes bad and the lower layers report an error to th=
e
> raid level can raid cope with the situation, remove the drive and kee=
p
> running. Unfortunately there seems to be a loose correlation between
> cost of the controler (chip) and the likelyhood of a failing disk
> locking up the system. I.e. the cheap onboard SATA chips on desktop
> systems do that more often than expensive server controler. But that
> is just a loose relationship.
>
> MfG
> =A0 =A0 =A0 =A0Goswin
>
> PS: I've seen hardware raid boxes lock up too so this isn't a drawbac=
k
> of software raid.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

You need to be using drives designed for RAID use with TLER (time
limited error recovery). When the drive encounters an error instead of
attempting to read the data for an extended period of time it just
gives up so the RAID can take care of it.

=46or example I had a SAS drive start to fail on a hardware RAID server=
=2E
Every time it hit a bad spot on the drive you could tell the system
would pause for a brief second as only that drive light was on. The
drive gave up and the RAID determined the correct data. It ran fine
like this until I was able to replace the drive the next day.

Ryan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
