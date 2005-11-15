From: Andrew Burgess <aab@cichlid.com>
Subject: Re: Crooked raid
Date: Tue, 15 Nov 2005 10:44:47 -0800
Message-ID: <200511151844.jAFIil2k006410@cichlid.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: gfk@logidac.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>Some time ago, I wanted to setup a software RAID-1 between hdc2 and 
>hdg2. However, not being familiar with mdadm and software raid, I made a 
>couple of bad commands. I don't remember the exact commands, but it's in 
>  the order of setting /dev/hdc, /dev/hdc2, /dev/hdg and /dev/hdg2 in 
>the same RAID. 

Oops

>Because of this, I was getting all sorts of errors in my 
>dmesg (see dmesg-broken below), but otherwise the RAID would work fine.

>After setting my /etc/mdadm/mdadm.conf to:
>DEVICE /dev/hdc2 /dev/hdg2
>ARRAY /dev/md0 level=raid1 num-devices=2 
>UUID=b013e39b:ec629293:98df4657:97255939

>I tried to
>mdadm /dev/md0 --remove /dev/hdc
>but without success:
>mdadm: hot remove failed for /dev/hdc: No such device or address

Look at:
  mdadm -E /dev/hdc
If it has a superblock, zero it with 'mdadm --zero-superblock /dev/hdc'

Same for hdg

Just as a failsafe test, before you zero, compare mdadm -E for hdc2 and hdc,
they should print different things. You want to insure you don't zero hd[cg]2
accidently.

