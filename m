From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: [RFT] 2.6.22.1-iop1 for improved sequential write performance
 (stripe-queue)
Date: Sat, 4 Aug 2007 10:54:41 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0708041049420.14065@filesrv1.baby-dragons.com>
References: <e9c3a7c20707191717s4809eab1s4966f7e0c21c6424@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20707191717s4809eab1s4966f7e0c21c6424@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Dan ,

On Thu, 19 Jul 2007, Dan Williams wrote:
> Per Bill Davidsen's request I have made available a 2.6.22.1 based
> kernel with the current raid5 performance changes I have been working
> on:
> 1/ Offload engine acceleration (recently merged for the 2.6.23
> development cycle)
> 2/ Stripe-queue, an evolutionary change to the raid5 queuing model (take4)
>
> The offload engine work only helps platforms with offload engines and
> should not affect performance otherwise.  The stripe-queue work is an
> attempt to increase sequential write performance and should benefit
> most platforms.
>
> The patch series is available on the Xscale(r) IOP SourceForge page:
> 	http://downloads.sourceforge.net/xscaleiop/patches-2.6.22.1-iop1-x86fix.tar.gz
>
> Use quilt to apply the series on top of a fresh 2.6.22.1 source tree:
> $ wget http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.22.1.tar.bz2
> $ tar xjf linux-2.6.22.1.tar.bz2
> $ cd linux-2.6.22.1
> $ tar xzvf patches-2.6.22.1-iop1.tar.gz
> $ cp patches/series.x86 patches/series
> $ quilt push -a
>
> Configure and build the kernel as normal, there are no configuration
> options for stripe-queue.
> Any feedback, bug report, fix, or suggestion is welcome.

 	Following these instructions .  With 2.6.22.1 gets me the below(*) .
 	Undoubtedly I have missed some message that said us a differnat pathset 
or something along those lines .
 		Tia ,  JimL

 	Full log of the build at ...
http://www.baby-dragons.com/linux-2.6.22.1a-reiser-xfs-lmsensors-EMMENSE-DEBUGGING_minus-I_oat-W_iop-patches.log
 	.config at ...
http://www.baby-dragons.com/linux-2.6.22.1a-reiser-xfs-lmsensors-EMMENSE-DEBUGGING_minus-I_oat-W_iop-patches.config

(*)
   gcc -m32 -Wp,-MD,init/.version.o.d  -nostdinc -isystem 
/usr/lib/gcc/i486-slackware-linux/3.4.6/include -D__KERNEL__ -Iinclude  -include 
include/linux/autoconf.h -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs 
-fno-strict-aliasing -fno-common -O2 -pipe -msoft-float -mregparm=3 
-freg-struct-return -mpreferred-stack-boundary=2 -fno-unit-at-a-time -march=i686 
-ffreestanding -maccumulate-outgoing-args -DCONFIG_AS_CFI=1 
-Iinclude/asm-i386/mach-default -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g  -Wdeclaration-after-statement 
-D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(version)" 
-D"KBUILD_MODNAME=KBUILD_STR(version)" -c -o init/version.o init/version.c
    ld -m elf_i386 -m elf_i386  -r -o init/built-in.o init/main.o init/version.o 
init/mounts.o init/initramfs.o init/calibrate.o
   ld -m elf_i386 -m elf_i386  -o .tmp_vmlinux1 -T arch/i386/kernel/vmlinux.lds 
arch/i386/kernel/head.o arch/i386/kernel/init_task.o  init/built-in.o 
--start-group  usr/built-in.o  arch/i386/kernel/built-in.o 
arch/i386/mm/built-in.o  arch/i386/mach-default/built-in.o 
arch/i386/crypto/built-in.o  kernel/built-in.o  mm/built-in.o  fs/built-in.o 
ipc/built-in.o  security/built-in.o  crypto/built-in.o  block/built-in.o 
lib/lib.a  arch/i386/lib/lib.a  lib/built-in.o  arch/i386/lib/built-in.o 
drivers/built-in.o  sound/built-in.o  arch/i386/pci/built-in.o 
arch/i386/power/built-in.o  net/built-in.o --end-group
arch/i386/kernel/built-in.o(.text+0x11e9a): In function `mark_screen_rdonly':
include/asm/page.h:58: undefined reference to `pmd_section'
mm/built-in.o(.text+0xceed): In function `free_pgd_range':
include/asm/page.h:58: undefined reference to `pmd_section'
mm/built-in.o(.text+0xd717): In function `copy_page_range':
include/asm/page.h:58: undefined reference to `pmd_section'
mm/built-in.o(.text+0xdbb5): In function `unmap_page_range':
include/asm/page.h:58: undefined reference to `pmd_section'
mm/built-in.o(.text+0x10c57): In function `do_mincore':
include/asm/page.h:58: undefined reference to `pmd_section'
mm/built-in.o(.text+0x13c4f):include/asm/page.h:58: more undefined references to 
`pmd_section' follow
make: *** [.tmp_vmlinux1] Error 1


-- +-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+
