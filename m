From: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Subject: mdadm --assemble --scan not finding devices
Date: Wed, 5 Mar 2003 17:14:35 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <8075D5C3061B9441944E137377645118012E7F@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

OK,

I'm going to make the switch to mdadm, but I need it to start my arrays
on boot and it's not doing it.  From what I gather from the man page and
Googling all I should need to do is:

mdadm --assemble --scan

Well when I run this command I get the following:

[root@cinshrinft1 ~]# mdadm --assemble --scan
mdadm: no devices found for /dev/md0
mdadm: no devices found for /dev/md1

Here is some other information you may need:

[root@cinshrinft1 ~]# cat /etc/mdadm.conf
DEVICE /dev/sd*

ARRAY /dev/md0
        level=raid1
        devices=/dev/sd[c,d,y,z]1
        spare-group=group1

ARRAY /dev/md1
        level=raid1
        devices=/dev/sd[e,f]1
        spare-group=group1

[root@cinshrinft1 ~]# mdadm -Es
ARRAY /dev/md1 level=raid1 num-devices=2
UUID=64a72aa6:1e47b105:fdb0a304:2e641d44
   devices=/dev/sdy1,/dev/sdf1,/dev/sde1
ARRAY /dev/md0 level=raid1 num-devices=2
UUID=dee56bf5:1b2cc506:61f81aec:21b1a40f
   devices=/dev/sdz1,/dev/sdd1,/dev/sdc1

The reason sdy1 is part of md1 is because I was testing the spare-group
option which worked quite well :)

I've already created them with 'mdadm --create' but I can't get them to
start.  I've also tried 'DEVICE partitions' and the UUID of the array in
the proper place in mdadm.conf and they still won't go.  Can someone
point out my obvious blunder here please? :)

Thanks,
Andy.
