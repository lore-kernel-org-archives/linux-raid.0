From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: Software RAID Stopped Working With Aurora Kernel
Date: Tue, 21 May 2002 07:09:06 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15593.26098.199785.56464@notabene.cse.unsw.edu.au>
References: <15592.56683.75251.569129@notabene.cse.unsw.edu.au>
	<NDBBIAKEEKGGEIKCBKNAEEMHCPAA.kc130iseo@coastalnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Cal Webster on Monday May 20
To: cwebster@ec.rr.com
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday May 20, kc130iseo@coastalnet.com wrote:
> >     I don't know why, but in one instance it tried to load
> >       /lib/raid5.o
> >     and gets :unresolved symbol md_unregister_thread_R4ba824f9
> >
> >     The other time it correctly loads
> >       /lib/modules/2.4.18-0.92sparc/kernel/drivers/md/raid5.o
> >
> >     I suggest removing /lib/raid5.c
> 
> Strangely, the only time this error occurred was when I tried to boot with
> "md0" devices listed in /etc/fstab. I don't know why it reported this path.
> There are no modules directly under /lib. Here's where all the modules are.
> I will remove all but the current kernel modules. In fact, I'll be removing
> all the 2.2 kernels since I can't boot them any more anyway.

Odd.... you could do an "nm" of each raid5.o and see which one
mentions
   md_unregister_thread_R4ba824f9

> 
> Using your source RPM:
...
> gcc -Wall -Werror -Wstrict-prototypes -DCONFFILE=\"/etc/mdadm.conf\" -O2 -m3
> 2 -m
> tune=ultrasparc   -c -o mdadm.o mdadm.c
> cc1: warnings being treated as errors
> In file included from mdadm.h:57,
>                  from mdadm.c:30:
> md_p.h: In function `md_event':
> md_p.h:168: warning: left shift count >= width of type
> make: *** [mdadm.o] Error 1
> error: Bad exit status from /var/tmp/rpm-tmp.90717 (%build)

Even odder.  It seems to think that __u64 is only 32bits wide.
Sounds like a compiler error, or an include file error.
I suspect __u64 is defined in /usr/include/asm/types.h to be
  typedef unsigned long __u64;

where it must need to be "unsigned long long", but I don't know enough
about the different flavours of sparc or the different compilers to
figure out the most likely problem.
Maybe just put
   #define __64 unsigned long long
in mdadm.h and see if that helps.

NeilBrown
