From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm --assemble --scan not finding devices
Date: Thu, 6 Mar 2003 09:55:19 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15974.32855.282065.392208@notabene.cse.unsw.edu.au>
References: <8075D5C3061B9441944E137377645118012E7F@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Rechenberg, Andrew on Wednesday March 5
To: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday March 5, ARechenberg@shermanfinancialgroup.com wrote:
> OK,
> 
> I'm going to make the switch to mdadm, but I need it to start my arrays
> on boot and it's not doing it.  From what I gather from the man page and
> Googling all I should need to do is:
> 
> mdadm --assemble --scan

Yep, that's right, providing your mdadm.conf is correct.

> 
> Well when I run this command I get the following:
> 
> [root@cinshrinft1 ~]# mdadm --assemble --scan
> mdadm: no devices found for /dev/md0
> mdadm: no devices found for /dev/md1
> 
> Here is some other information you may need:
> 
> [root@cinshrinft1 ~]# cat /etc/mdadm.conf
> DEVICE /dev/sd*
> 
> ARRAY /dev/md0
>         level=raid1
>         devices=/dev/sd[c,d,y,z]1

"glob" patterns are allowed in DEVICE lines but *not* in devices=
words.   Sorry.

>         spare-group=group1
> 
> ARRAY /dev/md1
>         level=raid1
>         devices=/dev/sd[e,f]1
>         spare-group=group1
> 
> [root@cinshrinft1 ~]# mdadm -Es
> ARRAY /dev/md1 level=raid1 num-devices=2
> UUID=64a72aa6:1e47b105:fdb0a304:2e641d44
>    devices=/dev/sdy1,/dev/sdf1,/dev/sde1

I would recommend putting just that "UUID=..." word into mdadm.conf
instead of the devices= lines.
It is dangerous using devices= for scsi drives as scsi device can
easily change names in one fails. (IDE doesn't have the same problem).

> ARRAY /dev/md0 level=raid1 num-devices=2
> UUID=dee56bf5:1b2cc506:61f81aec:21b1a40f
>    devices=/dev/sdz1,/dev/sdd1,/dev/sdc1
> 
> The reason sdy1 is part of md1 is because I was testing the spare-group
> option which worked quite well :)
> 
> I've already created them with 'mdadm --create' but I can't get them to
> start.  I've also tried 'DEVICE partitions' and the UUID of the array in
> the proper place in mdadm.conf and they still won't go.  Can someone
> point out my obvious blunder here please? :)

That should work .. unless you left the erronous 'devices=' word there..
If it still doesn't work when you remove "devices=" let me see the
whol mdadm.conf.

NeilBrown
