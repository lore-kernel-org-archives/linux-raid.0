From: Axel Christiansen <axel@zedx.org>
Subject: raid5 resync 2.6.10 freez
Date: Sun, 02 Jan 2005 19:03:43 +0100
Message-ID: <41D8377F.2040809@zedx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

i recently upgraded to a 4-IDE-RAID5. Since than the array
is not able to resync itself.

linux 2.6.10 with software-raid
mdadm - v1.5.0 - 22 Jan 2004
4 X IDE DISK WDC WD1600JB-00FUA0 (160 GB)
2 X HPT374 (rev 07) IDE Conroller
Epox 8K5-A3+
Duron 1500 MHz CPU

After 5 to 10 minutes the os freez. The system console does
not show anything.

#
# Kernel hacking
#
CONFIG_DEBUG_KERNEL=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_SCHEDSTATS=y
# CONFIG_DEBUG_SLAB is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
CONFIG_DEBUG_KOBJECT=y
# CONFIG_DEBUG_HIGHMEM is not set
# CONFIG_DEBUG_INFO is not set
CONFIG_FRAME_POINTER=y
CONFIG_EARLY_PRINTK=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_KPROBES is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_4KSTACKS is not set
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y

I tried some 20 Kernels with no success.
Regardless of the resync speed the system freezes
sooner ar later.

10000 Kb/s after some 10 minutes.
1000  Kb/s after 1 to 2 hours.

There is no filesystem involved. The degraded arry without
resyncing works fine.

How do i fugure out whats going on.

Thanks, Axel
