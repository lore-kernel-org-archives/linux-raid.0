From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: doubts about sdd raid1 and cfs
Date: Sat, 13 Jun 2015 22:14:04 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1506132211560.9487@uplift.swm.pp.se>
References: <CAH3kUhFLHdJ6T_RHaL2AyFHuH3Ta90DLhj8TKM5jZ_31mY2OCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhFLHdJ6T_RHaL2AyFHuH3Ta90DLhj8TKM5jZ_31mY2OCw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 13 Jun 2015, Roberto Spadim wrote:

> hi guys, i`m setting up a new server, it have
> 1) 2x 256gb sdd
> Samsung SSD 850 PRO 256GB, EXM02B6Q
> 500118192 sectors, multi 1: LBA48 NCQ (depth 31/32)
> 2)1tb hdd
> Hitachi HUA722010CLA330, JP4OA3EA
> 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32)
>
> i`m plannig a raid1 with ssd and hdd, hdd being a "write-mostly", and
> 750gb of hdd i will use to backup or other useless files
>
> i have somedoubts about the setup..
> i use xfs at filesystem, should i consider TRIM command at filesystem?
> the problem is hdd being part of raid1 setup with others ssd, could
> the ssd receive the TRIM and the hdd too?
> any idea is wellcome

Frankly, reading about the firmware problems on Samsung SSDs in 
combination with TRIM, I would recommend against using TRIM on samsung 
drives.

https://bugs.launchpad.net/ubuntu/+source/fstrim/+bug/1449005

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
