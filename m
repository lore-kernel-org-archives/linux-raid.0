From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: mdadm create error
Date: Thu, 23 Sep 2004 14:34:53 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200409231834.i8NIYwj16603@www.watkins-home.com>
References: <1095961346.3465.29.camel@rich>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1095961346.3465.29.camel@rich>
To: 'rich turner' <rich@storix.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It works for me with RAID5.  Maybe RAID6 does not support all of the parity
options.  My version of md does not support RAID6, so I can't even try it.

Oh!  When I "play" with md and mdadm I use the ram disks.  But don't expect
the data to be there after a re-boot!  You can fail a drive and hot add and
remove.

Guy

root]# mdadm --create /dev/md3 --chunk=64 --level=5 --raid-devices=4
--parity=right-asymmetric --spare-devices=2 /dev/ram0 /dev/ram1 /dev/ram2
/dev/ram3 /dev/ram4 /dev/ram5
mdadm: array /dev/md3 started.
[root@watkins-home root]# cat /proc/mdstat
Personalities : [raid1] [raid5]
read_ahead 1024 sectors
md3 : active raid5 [dev 01:03][3] [dev 01:05][5] [dev 01:04][4] [dev
01:02][2] [dev 01:01][1] [dev 01:00][0]
      12096 blocks level 5, 64k chunk, algorithm 1 [4/4] [UUUU]

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of rich turner
Sent: Thursday, September 23, 2004 1:42 PM
To: linux-raid@vger.kernel.org
Subject: mdadm create error

i cant figure out what is wrong with the following command. when i
remove the "parity=right-asymmetric" command option it does not fail.
but i need to be able to create the raid device with different parity
algorithms. it also fails on --level=5 and using the short forms of the
flags.

mdadm --create /dev/md2 --chunk=64 --level=6 --raid-devices=4 
--parity=right-asymmetric --spare-devices=2 /dev/vg0/turnerlv1
/dev/vg0/turnerlv2 /dev/vg0/turnerlv3 /dev/vg0/turnerlv4
/dev/vg0/turnerlv5 /dev/vg0/turnerlv6

mdadm: layout may only be sent once.  Second value was right-asymmetric

rich:/tmp # mdadm --version
mdadm - v1.5.0 - 22 Jan 2004

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

