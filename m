From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Recovery on new 2TB disk: finish=7248.4min (raid1)
Date: Thu, 27 Apr 2017 21:42:27 +0200
Message-ID: <b74c3cae-a55d-9306-16fe-5b811c20ec89@thelounge.net>
References: <590117CD.1000009@tesco.net>
 <22785.65375.947842.648174@quad.stoffel.home>
 <5492628.c8B43Z4h0G@matkor-lenovo>
 <22786.16524.435313.304834@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22786.16524.435313.304834@quad.stoffel.home>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>, Mateusz Korniak <mateusz-lists@ant.gliwice.pl>
Cc: Ron Leach <ronleach@tesco.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 27.04.2017 um 21:03 schrieb John Stoffel:
> Mateusz> They will be synced one by one, just like one big md device.
> 
> No, big MD devices are sync'd in parallel assuming MD thinks they're
> on seperate devices

if they are on sepearte drives it's no problem and no "seek storm"

> Now in this case I admit I might have jumped the
> gun, but I'm mostly commenting on the use of multiple MD RAID setups
> on a single pair of disks.
> 
> It's inefficient.  It's a pain to manage.  You lose flexibility to
> resize.

which don't matter if you have LVM on top

> Just create a single MD device across the entire disk (or possibly two
> if you want to boot off one mirrored pair) and then use LVM on top to
> carve out storage.  More flexible

but you can't boot from a RAID5/RAID6/RAID10 so you have a single point 
of failure of a single boot disk or need at least two additional disks 
for a redundant boot device

frankly on a proper designed storage machine you have no need for 
flexibility and resize because for it's entire lifetime you have enough 
storage at all and in case of LVM it don't matter how many md-devices 
are underlying the LVM
