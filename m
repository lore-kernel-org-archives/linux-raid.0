From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re[3]: Issue removing failed drive and re adding on raid 6
Date: Sat, 4 Jul 2015 08:58:13 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1507040854290.11810@uplift.swm.pp.se>
References: <emfb4b5aee-68ba-4089-a763-4e835afefc45@littlez>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <emfb4b5aee-68ba-4089-a763-4e835afefc45@littlez>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Stephenson <justin@evensteveninc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 4 Jul 2015, Justin Stephenson wrote:

> md/raid:md0: not clean -- starting background reconstruction
> md/raid:md0: device sdh1 operational as raid disk 5
> md/raid:md0: device sdg1 operational as raid disk 4
> md/raid:md0: device sdd1 operational as raid disk 1
> md/raid:md0: device sde1 operational as raid disk 2
> md/raid:md0: device sdb1 operational as raid disk 6
> md/raid:md0: device sdc1 operational as raid disk 0
> md/raid:md0: allocated 7470kB
> md/raid:md0: cannot start dirty degraded array.
> RAID conf printout:
> --- level:6 rd:7 wd:6
> disk 0, o:1, dev:sdc1
> disk 1, o:1, dev:sdd1
> disk 2, o:1, dev:sde1
> disk 4, o:1, dev:sdg1
> disk 5, o:1, dev:sdh1
> disk 6, o:1, dev:sdb1
> md/raid:md0: failed to run raid set.
> md: pers->run() failed ...

This is the interesting part. I don't know why this happens, especially 
since it didn't help with --assemble --force (which you said before that 
you did).

I found this:

http://www.devinzuczek.com/anything-at-all/raid5-cannot-start-dirty-degraded-array-for-mdn/

It indicates that you should be able to do "mdadm --manage /dev/md0 
--run". I have never ended up in this situation so I don't know if it'll 
work.

> ***** Parent of /run/mdadm does not exist.  Maybe set different RUN_DIR=
> *****  e.g. make RUN_DIR=/dev/.mdadm
> ***** or set CHECK_RUN_DIR=0
> make: *** [check_rundir] Error 1
> [justin@BigBlue mdad]$

You don't have to do "make install", you can just do "make" and find the 
resulting mdadm binary and use ./mdadm to run it from current dir. You 
probably only need it to actually get the array up and running again, then 
your system mdadm will be fine. Btw, post "mdadm --version" and "uname -a" 
so we know what kernel and mdadm version you're running.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
