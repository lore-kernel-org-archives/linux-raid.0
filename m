From: Luca Berra <bluca@comedia.it>
Subject: Re: md/mdadm fails to properly run on 2.6.15 after upgrading from 2.6.11
Date: Sun, 9 Apr 2006 16:46:25 +0200
Message-ID: <20060409144625.GM24587@percy.comedia.it>
References: <4438FFA9.4030907@debruin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4438FFA9.4030907@debruin.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Apr 09, 2006 at 02:35:53PM +0200, Marc L. de Bruin wrote:
>Hi,
>
>(I just subscribed, sorry if this is a dupe. I did try to match the 
>subject from the archives, but couldn't find any...)
>
>I ran into trouble after upgrading a Debian Sarge system from 2.6.11 to 
>2.6.15. To be more precise, it turned out that md/mdadm seems to not 
>function properly during the boot process of 2.6.15.
>
>My /etc/mdadm/mdadm.conf contains this:
>
> >>>---[mdadm.conf]---
>DEVICE /dev/hdi1 /dev/hdg1 /dev/hdc1
>ARRAY /dev/md1 level=raid5 num-devices=3 
>UUID=09c58ab6:f706e37b:504cf890:1a597046 
>devices=/dev/hdi1,/dev/hdg1,/dev/hdc1
>
>DEVICE /dev/hdg2 /dev/hdc2
>ARRAY /dev/md2 level=raid1 num-devices=2 
>UUID=86210844:6abbf533:dc82f982:fe417066 devices=/dev/hdg2,/dev/hdc2
>
>DEVICE /dev/hda2 /dev/hdb2
>ARRAY /dev/md0 level=raid1 num-devices=2 
>UUID=da619c37:6c072dc8:52e45423:f4a58b7c devices=/dev/hda2,/dev/hdb2
>
>DEVICE /dev/hda1 /dev/hdb1
>ARRAY /dev/md4 level=raid1 num-devices=2 
>UUID=bfc30f9b:d2c21677:c4ae5f90:b2bddb75 devices=/dev/hda1,/dev/hdb1
>
>DEVICE /dev/hdc3 /dev/hdg3
>ARRAY /dev/md3 level=raid1 num-devices=2 
>UUID=fced78ce:54f00a78:8662e7eb:2ad01d0b devices=/dev/hdc3,/dev/hdg3
> >>>---[/mdadm.conf]---

replace all
DEVICE .....
lines
with a single

DEVICE partitions
remove all the device=... part from the array lines.

L.

