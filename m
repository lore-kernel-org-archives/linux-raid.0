From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: Slackware and RAID
Date: Sat, 16 Sep 2006 20:39:09 +0200
Message-ID: <200609162039.09488.Dexter.Filmore@gmx.de>
References: <200609161230.22530.Dexter.Filmore@gmx.de> <200609162032.07509.Dexter.Filmore@gmx.de> <Pine.LNX.4.56.0609161934270.21474@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0609161934270.21474@lion.drogon.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > What's the remaining third?
> > I fumbled it into rc.S and rc.6, reason why I ask is that array degraded
> > about 6 times in the few months I run it and I can't figure why. Only
> > thing I know is that it degrades somewhere in the reboot process, so I
> > suspect it might not properly shutdown.
>
> Have you tried simply setting the partition types to 0xFD and relying on
> the kernel auto-detect?
>
> I read here that there seems to be some resistance to this method though,
> but I've been using it for many years without any issues - however I'm not
> doing any thing "clever" like LVM or RAID on RAID (RAID1+0, etc.)

That's what I actually do: one big 0xFD partition per disk, raid5, lvm2, 3x 
xfs.
I run the array with
mdadm --assemble /dev/md0
and stop it with 
mdadm --stop --scan
after fs are unmounted and LVM is deactivated.


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
