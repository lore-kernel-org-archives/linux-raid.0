From: "Sunpyo Hong" <sunpyo.hong@amac.com>
Subject: Raid 5 Issue, cannot recognize EXT3 File system.
Date: Thu, 17 Sep 2009 16:20:16 -0400
Message-ID: <200909171620688.SM00612@trainer>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I=92ve contacted just about everyone that knows a thing about RAID5, bu=
t no
one is really able to help me. Anyhow I=92ve read up a lot on RAID5 arr=
ays and
how to properly assemble them. However I=92ve run into a problem with a=
 NAS
system from WD that I just can=92t seem to figure out.

I have a =BE disks in the array, 1 went down and is out of commission. =
I=92ve
been able to assemble my array through mdadm using =96assemble =96scan.=
 However
I cannot access the array due to the fact that the array cannot read a
filesystem. Everytime I try to mount I get mount: wrong fs type=85 etc.=
 I know
that the FS is an ext3 FS. However I cannot seem to get this thing goin=
g. I
was wondering if anyone could point me in the right direction with this=
=2E I
can=92t seem to find anyone that is capable of solving this. I would
appreciate any help. Thanks!

-Sunpyo

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
