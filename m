From: Tim Moore <linux-raid@nsr500.net>
Subject: dd with bytes/sec patch [was: non-optimal RAID 5 performance with
 8 drive array]
Date: Wed, 02 Mar 2005 15:08:22 -0800
Message-ID: <42264766.5070700@nsr500.net>
References: <42246D1F.3070407@variant.ch> <d029u5$65p$1@sea.gmane.org> <6.2.1.2.2.20050301190313.053f5d60@mail.tekno-soft.it> <d02b09$9ud$1@sea.gmane.org> <6.2.1.2.2.20050301193656.05fb3720@mail.tekno-soft.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <6.2.1.2.2.20050301193656.05fb3720@mail.tekno-soft.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> 1. Grab coreutils 5.2.1 from gnu.org and the debian patch from
>    http://packages.debian.org/unstable/base/coreutils
> 
> 2. Extract the 2 dd patches which start with the line
> 
> +--- coreutils-5.0/src/dd.c.orig        2003-02-07 07:39:20.000000000 -0500
 >
> through, but not including, the line
 >
> --- coreutils-5.2.1.orig/debian/patches/19_ipv6
 >
 > You can see all the patch headers with
 > zcat coreutils_5.2.1-2.diff.gz | grep '^---'
> 
> 3. Get rid of the extra leading '+' (sed 's/^\+//').  You now have a working dd patch
> 
> 4. Apply the patch and compile:
> 
> [tim@tim-linux ~/Kits]$ cd coreutils-5.2.1
> [tim@tim-linux coreutils-5.2.1]$ patch -p1 < ../coreutils-5.2.1.dd-performance-counter.patch
> patching file src/dd.c
> Hunk #1 succeeded at 149 (offset -1 lines).
> Hunk #2 succeeded at 377 (offset 11 lines).
> Hunk #3 succeeded at 380 (offset -1 lines).
> Hunk #4 succeeded at 494 (offset 11 lines).
> Hunk #5 succeeded at 1069 (offset -2 lines).
> Hunk #6 succeeded at 1144 (offset 11 lines).
> Hunk #7 succeeded at 1166 with fuzz 2 (offset -2 lines).
> Hunk #8 succeeded at 1268 (offset 12 lines).
> patching file tests/dd/skip-seek
> Hunk #1 succeeded at 20 (offset -1 lines).
> [tim@tim-linux coreutils-5.2.1]$ ./configure -q
> checking how to get filesystem space usage...
> config.status: creating po/POTFILES
> config.status: creating po/Makefile
> [tim@tim-linux coreutils-5.2.1]$ /usr/bin/time make -j2 > /dev/null
> 26.17user 2.23system 0:30.16elapsed 94%CPU (0avgtext+0avgdata 0maxresident)k
> 0inputs+0outputs (410381major+274056minor)pagefaults 0swaps
> [tim@tim-linux coreutils-5.2.1]$ ls -l src/dd
> -rwxrwxr-x    1 tim      tim         68574 Mar  2 11:18 src/dd
> [tim@tim-linux coreutils-5.2.1]$ su
> Password: 
> [tim@tim-linux coreutils-5.2.1]# src/dd if=/dev/hda1 of=/dev/zero bs=4k
> 126504+0 records in
> 126504+0 records out
> 518160384 bytes transferred in 21.705705 seconds (23872083 bytes/sec)

-- 

