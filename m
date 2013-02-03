From: Christoph Nelles <evilazrael@evilazrael.de>
Subject: Re: RAID5 with 2 drive failure at the same time
Date: Sun, 03 Feb 2013 16:56:35 +0100
Message-ID: <510E88B3.8050505@evilazrael.de>
References: <510A4AAE.6000009@evilazrael.de> <20130131113820.GA20536@cthulhu.home.robinhill.me.uk> <510A6E54.5050001@evilazrael.de> <CAF3D534-D907-4A88-AFAF-EA9B97C1D8BF@colorremedies.com> <20130131221007.GA1447@cthulhu.home.robinhill.me.uk> <88758108-9333-4224-9006-8E44E717AB29@colorremedies.com> <20130201133455.GA24375@cthulhu.home.robinhill.me.uk> <9F0E4AF3-4358-425F-8078-C068D5BB9487@colorremedies.com> <20130201195734.GA16573@cthulhu.home.robinhill.me.uk> <510C5E3F.8090807@evilazrael.de> <510C6AB6.8040900@turmel.org> <510D36D7.5050704@evilazrael.de> <510DBBB9.5030300@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090705070306080200030603"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <510DBBB9.5030300@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------090705070306080200030603
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi folks,

the dd_rescue to the new HDD took 14hours. It looks like ddrescue is not
reading and writing in parallel. In the end 8kb couldn't be read after
10 retries.

I just force-assembled the RAID with the new drive, but it failed almost
immediately with an WRITE FPDMA QUEUED error on one of the other drives
(sdj, formerly sdi). I tried immediately again, an this time one disk
was rejected but the RAID started on 8 devices, but xfs_repair failed
when one of the disks failed with an READ FPDMA QUEUED error :( and md
expelled the disk from the RAID.



It looks more like a controller problem as all the messages comming from
the drives on the PCIe Marvell have all the line
ataXX: illegal qc_active transition (00000002->00000003)
I found only one similar report about that problem:
http://marc.info/?l=linux-ide&m=131475722021117

Any recommendations for a decent and affordable SATA Controller with at
least 4 ports and faster than PCIe x1? Looks like there are only
Marvells and more expensive Enterprise RAID controllers.



Currently the RAID is running clean, but degraded. The filesystem is
mounted ro and looks healthy. I attached a mdadm --detail and put the
kernel logs since yesterday at
http://evilazrael.net/bilder2/logs/kernel_20130203.log and
http://evilazrael.net/bilder2/logs/kernel_20130203.log.gz

I think my action plan is:
- Get reliable controller ASAP
- Re-add the missing disk
- Upgrade to RAID 6
- Schedule regularly scrubbing

Thanks for all the help so far, i think i can see the light at the end
of the tunnel :)


Am 03.02.2013 02:22, schrieb Phil Turmel:
>> How do the serial numbers help?
> 
> It is vital to keep track of raid device number (logical position in the
> array) versus drive serial numbers, as device names are not guaranteed
> to be consistent between boots (and certainly not when mucking around
> with cables and connectors).
> 

I am aware of that problem then plugging drives around or adding new
ones during runtime.

> When you are done with dd_rescue, make sure of the mapping again.
> lsdrv[1] gives you both pieces of information in one utility, you might
> find it easier than mapping by hand.

The owner's name sounds familar ;) Will send you a mail later.



Kind regards

Christoph Nelles


-- 
Christoph Nelles

E-Mail    : evilazrael@evilazrael.de
Jabber    : eazrael@evilazrael.net      ICQ       : 78819723

PGP-Key   : ID 0x424FB55B on subkeys.pgp.net
            or http://evilazrael.net/pgp.txt


--------------090705070306080200030603
Content-Type: text/plain;
 name="mdadm_detail.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="mdadm_detail.txt"

L2Rldi9tZDA6CiAgICAgICAgVmVyc2lvbiA6IDEuMgogIENyZWF0aW9uIFRpbWUgOiBGcmkg
QXByIDI3IDIwOjI1OjA0IDIwMTIKICAgICBSYWlkIExldmVsIDogcmFpZDUKICAgICBBcnJh
eSBTaXplIDogMjM0NDIxMTQ1NjAgKDIyMzU2LjE0IEdpQiAyNDAwNC43MyBHQikKICBVc2Vk
IERldiBTaXplIDogMjkzMDI2NDMyMCAoMjc5NC41MiBHaUIgMzAwMC41OSBHQikKICAgUmFp
ZCBEZXZpY2VzIDogOQogIFRvdGFsIERldmljZXMgOiA4CiAgICBQZXJzaXN0ZW5jZSA6IFN1
cGVyYmxvY2sgaXMgcGVyc2lzdGVudAoKICAgIFVwZGF0ZSBUaW1lIDogU3VuIEZlYiAgMyAx
NjozMDowMiAyMDEzCiAgICAgICAgICBTdGF0ZSA6IGNsZWFuLCBkZWdyYWRlZAogQWN0aXZl
IERldmljZXMgOiA4CldvcmtpbmcgRGV2aWNlcyA6IDgKIEZhaWxlZCBEZXZpY2VzIDogMAog
IFNwYXJlIERldmljZXMgOiAwCgogICAgICAgICBMYXlvdXQgOiBsZWZ0LXN5bW1ldHJpYwog
ICAgIENodW5rIFNpemUgOiA2NEsKCiAgICAgICAgICAgTmFtZSA6IHJvdXRlcjowICAobG9j
YWwgdG8gaG9zdCByb3V0ZXIpCiAgICAgICAgICAgVVVJRCA6IDZiMjFiM2VkOmQzOWQ1YTU0
OmQ0OTM5MTEzOjc3ODUxY2I2CiAgICAgICAgIEV2ZW50cyA6IDI3NzcwCgogICAgTnVtYmVy
ICAgTWFqb3IgICBNaW5vciAgIFJhaWREZXZpY2UgU3RhdGUKICAgICAgIDAgICAgICAgOCAg
ICAgICAzMyAgICAgICAgMCAgICAgIGFjdGl2ZSBzeW5jICAgL2Rldi9zZGMxCiAgICAgICAx
ICAgICAgIDAgICAgICAgIDAgICAgICAgIDEgICAgICByZW1vdmVkCiAgICAgICAyICAgICAg
IDggICAgICAxMjkgICAgICAgIDIgICAgICBhY3RpdmUgc3luYyAgIC9kZXYvc2RpMQogICAg
ICAgMyAgICAgICA4ICAgICAgIDQ5ICAgICAgICAzICAgICAgYWN0aXZlIHN5bmMgICAvZGV2
L3NkZDEKICAgICAgIDQgICAgICAgOCAgICAgIDE0NSAgICAgICAgNCAgICAgIGFjdGl2ZSBz
eW5jICAgL2Rldi9zZGoxCiAgICAgICA1ICAgICAgIDggICAgICAgOTcgICAgICAgIDUgICAg
ICBhY3RpdmUgc3luYyAgIC9kZXYvc2RnMQogICAgICAgNiAgICAgICA4ICAgICAgIDE3ICAg
ICAgICA2ICAgICAgYWN0aXZlIHN5bmMgICAvZGV2L3NkYjEKICAgICAgIDcgICAgICAgOCAg
ICAgICA4MSAgICAgICAgNyAgICAgIGFjdGl2ZSBzeW5jICAgL2Rldi9zZGYxCiAgICAgICA4
ICAgICAgIDggICAgICAgNjUgICAgICAgIDggICAgICBhY3RpdmUgc3luYyAgIC9kZXYvc2Rl
MQo=
--------------090705070306080200030603--
