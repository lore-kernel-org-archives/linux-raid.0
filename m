From: "aboster" <aboster@at-sd.com>
Subject: RE: raid 0+1 and 1+0 with mdadm
Date: Thu, 30 Sep 2004 11:26:00 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000501c4a71a$f27c30b0$cd03a8c0@archnet2.atgsd.com>
References: <1096566962.3539.15.camel@rich>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1096566962.3539.15.camel@rich>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have had much the same problem.  The Red Hat 9 startup scripts find the
first level of raids (the Raid 1's), but then don't do a second pass to
assemble the Raid 0 made from the two sets of Raid 1's.  In my config file,
they are in the order I would expect to work...

Please post any info about this to the list, thanks!

Alex Boster
Software Engineering
Archimedes Technology Group
5660 Eastgate Drive
San Diego CA 92121

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of rich turner
> Sent: Thursday, September 30, 2004 10:56 AM
> To: linux-raid@vger.kernel.org
> Subject: raid 0+1 and 1+0 with mdadm
> 
> my 0+1 and 1+0 raid devices are not getting started on system boot. i
> realize this could be fixed through the sysinit scripts but mdadm -As
> should be able to handle this.
> 
> here is my mdadm.conf
> 
> DEVICE /dev/hdb1 /dev/hdb2 /dev/hdb3 /dev/hda5 /dev/hda6 /dev/hda7
> /dev/hdb5 /dev/hdb6 /dev/hdb7 /dev/hda8 /dev/hda9 /dev/hda10 /dev/md3
> /dev/md4  /dev/md6 /dev/md7
> 
> ARRAY /dev/md3 level=0 num-devices=3
> devices=/dev/hdb1,/dev/hdb2,/dev/hdb3
> 
> ARRAY /dev/md4 level=0 num-devices=3
> devices=/dev/hda5,/dev/hda6,/dev/hda7
> 
> ARRAY /dev/md6 level=1 num-devices=2
> devices=/dev/hdb5,/dev/hdb6,/dev/hdb7
> 
> ARRAY /dev/md7 level=1 num-devices=2
> devices=/dev/hda8,/dev/hda9,/dev/hda10
> 
> ARRAY /dev/md5 level=1 num-devices=2 devices=/dev/md3,/dev/md4
> 
> ARRAY /dev/md8 level=0 num-devices=2 devices=/dev/md6,/dev/md7
> 
> as you can see /dev/md5 is built on /dev/md3 and /dev/md4 and /dev/md8
> is built on /dev/md6 and md7.
> 
> when I run "mdadm -As" i get the following output:
> mdadm: /dev/md3 has been started with 3 drives.
> mdadm: /dev/md4 has been started with 3 drives.
> mdadm: /dev/md6 has been started with 2 drives and 1 spare.
> mdadm: /dev/md7 has been started with 2 drives and 1 spare.
> mdadm: no devices found for /dev/md5
> mdadm: no devices found for /dev/md8
> 
> if i then immediately run "mdadm -As" again it starts /dev/md5 and
> /dev/md8.
> 
> why do i have to run it twice and why does it not start all devices the
> first time?
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

