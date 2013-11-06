From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: mdadm: /dev/md0 has been started with 1 drive (out of 2).
Date: Wed, 06 Nov 2013 18:57:03 +1100
Message-ID: <5279F64F.5000104@websitemanagers.com.au>
References: <C8EFEBC6-4B43-4B71-AA3F-7DC69480220D@gmail.com> <5278C2A6.7060005@websitemanagers.com.au> <E9509E1D-C8FB-4496-ADD5-C6ACBEFC4007@gmail.com> <5278D84C.4040600@websitemanagers.com.au> <5E756798-9940-4EA9-821A-2A49F92E0B03@gmail.com> <5278E50E.90808@websitemanagers.com.au> <6BD059D7-DF6F-4185-B1F9-A564ECB3EFBE@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6BD059D7-DF6F-4185-B1F9-A564ECB3EFBE@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/11/13 18:20, Ivan Lezhnjov IV wrote:
>=20
> On Nov 5, 2013, at 2:31 PM, Adam Goryachev
> <mailinglists@websitemanagers.com.au> wrote:
>=20
>>> When you say force the array, does it translate to a different
>>> set of commands than what you showed in the very first reply?
>>> What would be those? I'm just curious to see how these things are
>>> done when managing the arrays, and examples help a lot!
>>=20
>> Yes, there are other ways (which I've never used, just seen people
>> on this list talk about them) that will force the event count on
>> the older device up to the newer one, and then md will accept both
>> drives as being up to date etc. Effectively it just lies and
>> pretends that the data is correct, forcing the metadata (MD data)
>> to match, but the actual user data (complete content of the drives)
>> may not match and is not checked.
>>=20
>> I won't provide advise on this because I've never done it=85
>=20
> Hm, makes one wonder what the advantage of this approach is then. It
> sounds like either of two options let one get access to data
> immediately, whether they choose to force even count and proceed with
> recovery or assemble an array and start a resync. I mean, what is it
> that makes this strategy worthwhile pursuing then? Even offloading
> data to a separate disk, in case of raid levels that offer data
> redundancy capability seems unnecessary, as an array disk mirror
> serve essentially the same purpose.

The advantage is in RAID5/6. eg, RAID5 with one disk totally dead, and =
a
second disk partially dead which only dropped out of the array recently=
=2E
You might force the event count to current, then you can get most of
your data back.

You are right, there is no advantage for RAID1.

If you just wanted your data back, then you could have done this:
mdadm --assemble /dev/md1 /dev/sdd1
mdadm --manage /dev/md1 --run
(I think it was sdd1 and md1, adjust as appropriate)...
That simply forces the array to run even though all disks are not
present. It will allow you to mount the array and use as normal, right
up to the point there are not enough data disks left.

>> BTW, you haven't mentioned what data is actually on the array (if
>> any), what you are using it for, or how you got into this state.
>=20
> Just a personal file storage, some iso images, pictures, music,
> videos, system backups, virtual machine disk images as well, seeding
> some torrents and such. Multipurpose, yeah. The usage pattern is of
> that occasional heavy writing when making backups (typically once a
> week) or copying iso images/video (when needed), and more frequent
> reads of average i/o intensity.

I don't think you would notice the overhead of the bitmap then... or at
least, it probably won't matter in your scenario...

>> Depending on your array usage, you may or may not want to use
>> bitmaps, and there might be other performance options to tune.
>=20
> Mind you, this is a raid1 made out of two external USB 3.0 drives
> connected to USB 2.0 ports. So, the throughput is not terribly
> impressive, but I've been working with this configuration using a
> single disk for a while now and it proved sufficient and stable for
> my needs. The raid that I've put together some 4-5 days ago is a lazy
> approach to backups/countermeasure against disk failures. I've had a
> drive die in my hands shortly before I assembled the array, and I
> figured it was silly not to have a raid1 in place which clearly could
> have saved me some pain of extracting most important bits of the data
> from various places (just other disks I have.. it just happens I have
> a few around) that I used as extra backup storage locations.

I would definitely use a bitmap.... I've found USB drives can be flaky
from time to time. A bitmap will reduce the resync time to minutes. eg,
today I had a similar issue where one 2TB drive is SATA/internal and on=
e
is USB3/external. After bootup I started the array on just the internal
drive, so adding back the USB drive required a resync. It completed in
less than one minute due to the bitmap functionality.

>> Depending on the current content of the array (with such low event=20
>> numbers, it looks like you may not have put data on yet, it might
>> be easier to just re-create the array (although that will do a
>> resync anyway, unless you force that to be skipped).
>=20
> Actually, prior to the array degradation I had been copying data to
> it for a several days straight (yeah, as I said the throughput is not
> very good, peaks at 21-27Mb/s for writes when 3 USB disks are
> involved in action simultaneously.. that is, copying from one disk to
> this two disk array, all three connected to the same computer=85 whic=
h
> I think is still a good number when you think about it!), so it has
> about 1TB of data that I wouldn't like to lose now :P

You might find you have more than one real USB bus on the computer,
potentially you might get better performance if you move the three
devices to different USB buses. Also, the two members of the RAID1 woul=
d
behave better on different buses if possible. You may need to read your
motherboard manual, or trial and error to find this out.

>> Finally, it would be a good idea to work out how you reached this
>> point. You really want to avoid having this problem in 6 months
>> when you have 1.8TB of data on the drives=85.
>=20
> True. So, my setup is an old Linux laptop that used to be my main
> workstation and as I've said before the array is connected to it via
> USB interface. This computer being a hybrid server/workstation now,
> runs GNOME as desktop environment and a VNC server, and most
> importantly for our discussion I treat it as a workstation and never
> shut it down in the night, instead I switch it to sleep
> mode/hybernate. And that's how the array got out of sync, I resumed
> the laptop from sleep and the array was already degraded, event
> counts mismatch and all.
>=20
> I will have to figure out how pm-utils treats raid devices when doing
> sleep/resume, maybe intervene and script --stop --scan via a pm user
> hooks. I think internal bitmaps will be of great help here, because
> it may take some trying to get it done right.]
>=20
> Unfortunately, abandoning this configuration will most probably be
> very time consuming, because the system is so heavily customized by
> now it will be still easier and quicker to make sure pm plays with
> the raid array nicely than to say install Ubuntu Server (or
> workstation that I assume is capable of handling arrays on
> sleep/resume just nicely).

Have you considered just doing a shutdown instead of sleep/resume?
Presumably it will only sleep at night, and resume in the morning, so i=
t
shouldn't take all that long to startup in the morning. You can probabl=
y
set the bios to automatically power on at a preset time in the morning =
a
few minutes before you would normally want to use it.

Regards,
Adam

--=20
Adam Goryachev
Website Managers
www.websitemanagers.com.au
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
