From: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>
Subject: Re: mdadm: /dev/md0 has been started with 1 drive (out of 2).
Date: Wed, 6 Nov 2013 11:47:35 +0200
Message-ID: <F53E1ABB-E13A-45EC-A27E-5917F54546A5@gmail.com>
References: <C8EFEBC6-4B43-4B71-AA3F-7DC69480220D@gmail.com> <5278C2A6.7060005@websitemanagers.com.au> <E9509E1D-C8FB-4496-ADD5-C6ACBEFC4007@gmail.com> <5278D84C.4040600@websitemanagers.com.au> <5E756798-9940-4EA9-821A-2A49F92E0B03@gmail.com> <5278E50E.90808@websitemanagers.com.au> <6BD059D7-DF6F-4185-B1F9-A564ECB3EFBE@gmail.com> <5279F64F.5000104@websitemanagers.com.au>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5279F64F.5000104@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Nov 6, 2013, at 9:57 AM, Adam Goryachev <mailinglists@websitemanager=
s.com.au> wrote:

> I would definitely use a bitmap.... I've found USB drives can be flak=
y
> from time to time. A bitmap will reduce the resync time to minutes. e=
g,
> today I had a similar issue where one 2TB drive is SATA/internal and =
one
> is USB3/external. After bootup I started the array on just the intern=
al
> drive, so adding back the USB drive required a resync. It completed i=
n
> less than one minute due to the bitmap functionality.

That sounds amazing.

>=20
>>> Depending on the current content of the array (with such low event=20
>>> numbers, it looks like you may not have put data on yet, it might
>>> be easier to just re-create the array (although that will do a
>>> resync anyway, unless you force that to be skipped).
>>=20
>> Actually, prior to the array degradation I had been copying data to
>> it for a several days straight (yeah, as I said the throughput is no=
t
>> very good, peaks at 21-27Mb/s for writes when 3 USB disks are
>> involved in action simultaneously.. that is, copying from one disk t=
o
>> this two disk array, all three connected to the same computer=85 whi=
ch
>> I think is still a good number when you think about it!), so it has
>> about 1TB of data that I wouldn't like to lose now :P
>=20
> You might find you have more than one real USB bus on the computer,
> potentially you might get better performance if you move the three
> devices to different USB buses. Also, the two members of the RAID1 wo=
uld
> behave better on different buses if possible. You may need to read yo=
ur
> motherboard manual, or trial and error to find this out.

Actually, this is a great tip! I will look into this.

>=20
>>> Finally, it would be a good idea to work out how you reached this
>>> point. You really want to avoid having this problem in 6 months
>>> when you have 1.8TB of data on the drives=85.
>>=20
>> True. So, my setup is an old Linux laptop that used to be my main
>> workstation and as I've said before the array is connected to it via
>> USB interface. This computer being a hybrid server/workstation now,
>> runs GNOME as desktop environment and a VNC server, and most
>> importantly for our discussion I treat it as a workstation and never
>> shut it down in the night, instead I switch it to sleep
>> mode/hybernate. And that's how the array got out of sync, I resumed
>> the laptop from sleep and the array was already degraded, event
>> counts mismatch and all.
>>=20
>> I will have to figure out how pm-utils treats raid devices when doin=
g
>> sleep/resume, maybe intervene and script --stop --scan via a pm user
>> hooks. I think internal bitmaps will be of great help here, because
>> it may take some trying to get it done right.]
>>=20
>> Unfortunately, abandoning this configuration will most probably be
>> very time consuming, because the system is so heavily customized by
>> now it will be still easier and quicker to make sure pm plays with
>> the raid array nicely than to say install Ubuntu Server (or
>> workstation that I assume is capable of handling arrays on
>> sleep/resume just nicely).
>=20
> Have you considered just doing a shutdown instead of sleep/resume?
> Presumably it will only sleep at night, and resume in the morning, so=
 it
> shouldn't take all that long to startup in the morning. You can proba=
bly
> set the bios to automatically power on at a preset time in the mornin=
g a
> few minutes before you would normally want to use it.

See, this particular laptop runs on max memory it's motherboard can han=
dle, and for whatever reason the test memory happens very slowly, so it=
 takes about a minute or a minute and a half to just get to boot loader=
=2E Besides, I'm such a fan of sleep/resume because it allows for reall=
y quick suspend in those rare cases when electricity goes out (happens =
sometimes where I live), or when I just need to temporarily power off a=
ll the noisy equipment to have a nice nap lol And resuming from a sleep=
 and having the system in the state where I left it is just so convenie=
nt. I see a lot of value in this functionality. It is perhaps about liv=
ing comfortably, you know?

Ivan

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
