From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: How to un-degrade an array after a totally spurious failure?
Date: Mon, 3 Aug 2009 03:28:14 -0500
Message-ID: <20090803082817660.FILH11508@cdptpa-omta04.mail.rr.com>
References: <fc23eb6a94080ec080aa15d8f843ea8a.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fc23eb6a94080ec080aa15d8f843ea8a.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: 'NeilBrown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> >            UUID : 940ae4e4:04057ffc:5e92d2fb:63e3efb7
> >          Events : 14
> >
> >     Number   Major   Minor   RaidDevice State
> >        0       8       80        0      active sync   /dev/sdf
> >        1       8       96        1      active sync   /dev/sdg
> >        2       8        0        2      active sync   /dev/sda
> >        3       8       16        3      active sync   /dev/sdb
> >        4       0        0        4      removed
> >        5       0        0        5      removed
> >        6       0        0        6      removed
> >
> >        4       8       32        -      faulty spare   /dev/sdc
> >        5       8       48        -      faulty spare   /dev/sdd
> >        6       8       64        -      faulty spare   /dev/sde
> >
> > 	The array did have a bitmap, but mdadm didn't report it.  When I
> > attempt using --assemble and --force, I get:
> >
> > Backup:/# mdadm --assemble --force /dev/md0
> > mdadm: /dev/md0 not identified in config file.
> 
> So try
>   mdadm --assemble --force /dev/md0 /dev/sd[abcdefg]

	Thanks.  I managed to get it working using

-u 940ae4e4:04057ffc:5e92d2fb:63e3efb7

	It take it if I append the output of --examine --scan to the
mdadm.conf file, I won't have the problem in the future?  The output of the
command does not include the bitmap file, but the man page for mdadm.conf
does list the bitmap= parameter.  I'm not quite clear, however, if the
bitmap= parameter is supposed to go on the same line as the output from
--examine --scan, or on a separate line.  I went ahead and put it all one
one line:

ARRAY /dev/md/0 level=raid5 metadata=1.2 num-devices=7
UUID=940ae4e4:04057ffc:5e92d2fb:63e3efb7 name='Backup':0
bitmap=/etc/mdadm/bitmap/md0.map

