From: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>
Subject: Re: mdadm: /dev/md0 has been started with 1 drive (out of 2).
Date: Wed, 6 Nov 2013 09:20:58 +0200
Message-ID: <6BD059D7-DF6F-4185-B1F9-A564ECB3EFBE@gmail.com>
References: <C8EFEBC6-4B43-4B71-AA3F-7DC69480220D@gmail.com> <5278C2A6.7060005@websitemanagers.com.au> <E9509E1D-C8FB-4496-ADD5-C6ACBEFC4007@gmail.com> <5278D84C.4040600@websitemanagers.com.au> <5E756798-9940-4EA9-821A-2A49F92E0B03@gmail.com> <5278E50E.90808@websitemanagers.com.au>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5278E50E.90808@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Nov 5, 2013, at 2:31 PM, Adam Goryachev <mailinglists@websitemanager=
s.com.au> wrote:

>> When you say force the array, does it translate to a different set o=
f commands than what you showed in the very first reply? What would be =
those? I'm just curious to see how these things are done when managing =
the arrays, and examples help a lot!
>=20
> Yes, there are other ways (which I've never used, just seen people on
> this list talk about them) that will force the event count on the old=
er
> device up to the newer one, and then md will accept both drives as be=
ing
> up to date etc. Effectively it just lies and pretends that the data i=
s
> correct, forcing the metadata (MD data) to match, but the actual user
> data (complete content of the drives) may not match and is not checke=
d.
>=20
> I won't provide advise on this because I've never done it=85

Hm, makes one wonder what the advantage of this approach is then. It so=
unds like either of two options let one get access to data immediately,=
 whether they choose to force even count and proceed with recovery or a=
ssemble an array and start a resync. I mean, what is it that makes this=
 strategy worthwhile pursuing then? Even offloading data to a separate =
disk, in case of raid levels that offer data redundancy capability seem=
s unnecessary, as an array disk mirror serve essentially the same purpo=
se.

>=20
> BTW, you haven't mentioned what data is actually on the array (if any=
),
> what you are using it for, or how you got into this state.

Just a personal file storage, some iso images, pictures, music, videos,=
 system backups, virtual machine disk images as well, seeding some torr=
ents and such. Multipurpose, yeah.
The usage pattern is of that occasional heavy writing when making backu=
ps (typically once a week) or copying iso images/video (when needed), a=
nd more frequent reads of average i/o intensity. =20

> Depending on your array usage, you may or may not want to use bitmaps=
,
> and there might be other performance options to tune.

Mind you, this is a raid1 made out of two external USB 3.0 drives conne=
cted to USB 2.0 ports. So, the throughput is not terribly impressive, b=
ut I've been working with this configuration using a single disk for a =
while now and it proved sufficient and stable for my needs. The raid th=
at I've put together some 4-5 days ago is a lazy approach to backups/co=
untermeasure against disk failures. I've had a drive die in my hands sh=
ortly before I assembled the array, and I figured it was silly not to h=
ave a raid1 in place which clearly could have saved me some pain of ext=
racting most important bits of the data from various places (just other=
 disks I have.. it just happens I have a few around) that I used as ext=
ra backup storage locations.

> Depending on the current content of the array (with such low event
> numbers, it looks like you may not have put data on yet, it might be
> easier to just re-create the array (although that will do a resync
> anyway, unless you force that to be skipped).

Actually, prior to the array degradation I had been copying data to it =
for a several days straight (yeah, as I said the throughput is not very=
 good, peaks at 21-27Mb/s for writes when 3 USB disks are involved in a=
ction simultaneously.. that is, copying from one disk to this two disk =
array, all three connected to the same computer=85 which I think is sti=
ll a good number when you think about it!), so it has about 1TB of data=
 that I wouldn't like to lose now :P

>=20
> Finally, it would be a good idea to work out how you reached this poi=
nt.
> You really want to avoid having this problem in 6 months when you hav=
e
> 1.8TB of data on the drives=85.

True. So, my setup is an old Linux laptop that used to be my main works=
tation and as I've said before the array is connected to it via USB int=
erface. This computer being a hybrid server/workstation now, runs GNOME=
 as desktop environment and a VNC server, and most importantly for our =
discussion I treat it as a workstation and never shut it down in the ni=
ght, instead I switch it to sleep mode/hybernate. And that's how the ar=
ray got out of sync, I resumed the laptop from sleep and the array was =
already degraded, event counts mismatch and all.

I will have to figure out how pm-utils treats raid devices when doing s=
leep/resume, maybe intervene and script --stop --scan via a pm user hoo=
ks. I think internal bitmaps will be of great help here, because it may=
 take some trying to get it done right.]

Unfortunately, abandoning this configuration will most probably be very=
 time consuming, because the system is so heavily customized by now it =
will be still easier and quicker to make sure pm plays with the raid ar=
ray nicely than to say install Ubuntu Server (or workstation that I ass=
ume is capable of handling arrays on sleep/resume just nicely).

>=20
> Hope this helps.

Tremendously. I appreciate your help very much!

Ivan--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
