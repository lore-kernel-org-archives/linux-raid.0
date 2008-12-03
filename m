From: "Ana Paula" <anapaula@cs.rutgers.edu>
Subject: raid1 with possible lock inversion
Date: Wed, 03 Dec 2008 15:33:03 -0500
Message-ID: <web-78543249@dragon.rutgers.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
I've got a fresh copy of the kernel 2.6.27.7 compiled with LOCKDEP (I
am including the .config at the end of this message) on a SMP machine.

After the raid1module is loaded the arrays are assembled and mounted I
get messages of a possible lock inversion.
The machine freezes but as soon as the messages stop I get the machine
back. 
I can stop the arrays and unload the module.

Is this a known issue?

Thanks,
Ana Paula

===============================================================
Messages I get
===============================================================
[  230.999201] md: raid1 personality registered for level 1
[  231.044326] md: md1 stopped.
[  231.069068] md: bind<sdc1>
[  231.071605] md: bind<sdb1>
[  231.080075] raid1: raid set md1 active with 2 out of 2 mirrors
[  231.159077] md1: bitmap initialized from disk: read 18/18 pages, set
1 bits
[  231.162965] created bitmap (272 pages) for device md1
[  231.207940] md: md2 stopped.
[  231.231863] md: bind<sde1>
[  231.235315] md: bind<sdd1>
[  231.243113] raid1: raid set md2 active with 2 out of 2 mirrors
[  231.319036] md2: bitmap initialized from disk: read 18/18 pages, set
1 bits
[  231.322965] created bitmap (272 pages) for device md2
[  231.363237] EXT2-fs warning: mounting unchecked fs, running e2fsck
is recommended
[  231.387076] EXT2-fs warning: mounting unchecked fs, running e2fsck
is recommended
[  261.654976]
[  261.654979]
=========================================================
[  261.658958] [ INFO: possible irq lock inversion dependency detected
]
[  261.658958] 2.6.27.7 #1
[  261.658958]
---------------------------------------------------------
[  261.658958] swapper/0 just changed the state of lock:
[  261.658958]  (&bitmap->lock){.+..}, at: [<f89bd52b>]
bitmap_endwrite+0x34/0x143 [md_mod]
[  261.658958] but this lock took another, soft-irq-unsafe lock in the
past:
[  261.658958]  (dcache_lock){--..}
[  261.658958]
[  261.658958] and interrupts could create inverse lock ordering
between them.
[  261.658958]
[  261.658958]
[  261.658958] other info that might help us debug this:
[  261.658958] no locks held by swapper/0.
[  261.658958]
[  261.658958] the first lock's dependencies:
[  261.658958] -> (&bitmap->lock){.+..} ops: 3333014 {
[  261.658958]    initial-use  at:
[  261.658958]                                        [<c013ac67>]
__lock_acquire+0x5b1/0x75c
[  261.658958]                                        [<c013b90f>]
lock_acquire+0x5a/0x74
[  261.658958]                                        [<f89bd8c1>]
bitmap_set_memory_bits+0x15/0x9c [md_mod]
[  261.658958]                                        [<c02e3e84>]
_spin_lock_irq+0x22/0x4b
[  261.658958]                                        [<f89bd8c1>]
bitmap_set_memory_bits+0x15/0x9c [md_mod]
[  261.658958]                                        [<f89bd8c1>]
bitmap_set_memory_bits+0x15/0x9c [md_mod]
[  261.658958]                                        [<f89bce80>]
bitmap_init_from_disk+0x312/0x3e9 [md_mod]
[  261.658958]                                        [<f89bdba7>]
bitmap_create+0x16c/0x209 [md_mod]
[  261.658958]                                        [<f89b7d85>]
do_md_run+0x3d0/0x6e1 [md_mod]
[  261.658958]                                        [<c013b90f>]
lock_acquire+0x5a/0x74
[  261.658958]                                        [<c0139ba8>]
mark_held_locks+0x47/0x65
[  261.658958]                                        [<c02e33e0>]
mutex_lock_interruptible_nested+0x268/0x27d
[  261.658958]                                        [<c0139cc9>]
trace_hardirqs_on_caller+0xed/0x114
[  261.658958]                                        [<c02e33eb>]
mutex_lock_interruptible_nested+0x273/0x27d
[  261.658958]                                        [<f89b94f0>]
md_ioctl+0x6b/0x3c1 [md_mod]
[  261.658958]                                        [<c0139cc9>]
trace_hardirqs_on_caller+0xed/0x114
[  261.658958]                                        [<f89b97e5>]
md_ioctl+0x360/0x3c1 [md_mod]
[  261.658958]                                        [<c013adb9>]
__lock_acquire+0x703/0x75c
[  261.658958]                                        [<c010739b>]
native_sched_clock+0xa7/0xbc
[  261.658958]                                        [<c013741b>]
lock_release_holdtime+0x77/0x84
[  261.658958]                                        [<c01d017b>]
blkdev_driver_ioctl+0x48/0x60
[  261.658958]                                        [<c01d034e>]
blkdev_ioctl+0x1bb/0x1c9
[  261.658958]                                        [<c01180c9>]
finish_task_switch+0x65/0x99
[  261.658958]                                        [<c0186dbc>]
block_ioctl+0x13/0x16
[  261.658958]                                        [<c0186da9>]
block_ioctl+0x0/0x16
[  261.658958]                                        [<c016f2fb>]
vfs_ioctl+0x23/0x61
[  261.658958]                                        [<c016f59d>]
do_vfs_ioctl+0xf5/0xff
[  261.658958]                                        [<c016f5d2>]
sys_ioctl+0x2b/0x45
[  261.658958]                                        [<c0102b92>]
syscall_call+0x7/0xb
[  261.658958]                                        [<ffffffff>]
0xffffffff
[  261.658958]    in-softirq-W at:
[  261.658958]                                        [<c0139f31>]
mark_irqflags+0x73/0xe4
[  261.658958]                                        [<c013ac50>]
__lock_acquire+0x59a/0x75c
[  261.658958]                                        [<c013b90f>]
lock_acquire+0x5a/0x74
[  261.658958]                                        [<f89bd52b>]
bitmap_endwrite+0x34/0x143 [md_mod]
[  261.658958]                                        [<c02e3e35>]
_spin_lock_irqsave+0x25/0x52
[  261.658958]                                        [<f89bd52b>]
bitmap_endwrite+0x34/0x143 [md_mod]
[  261.658958]                                        [<f89bd52b>]
bitmap_endwrite+0x34/0x143 [md_mod]
[  261.658958]                                        [<f881668e>]
raid1_end_write_request+0x1fa/0x22a [raid1]
[  261.658958]                                        [<c0185a09>]
bio_endio+0x3b/0x3f
[  261.658958]                                        [<c01ccd5a>]
__end_that_request_first+0x16b/0x233
[  261.658958]                                        [<c01cd127>]
blk_end_io+0x1f/0x8b
[  261.658958]                                        [<c01cd19c>]
blk_end_request+0x9/0xc
[  261.658958]                                        [<c024d223>]
scsi_end_request+0x1a/0x69
[  261.658958]                                        [<c024d551>]
scsi_io_completion+0x12f/0x2f7
[  261.658958]                                        [<c024dbab>]
scsi_softirq_done+0xb5/0xba
[  261.658958]                                        [<c01cce7a>]
blk_done_softirq+0x58/0x64
[  261.658958]                                        [<c0122239>]
__do_softirq+0x6c/0xde
[  261.658958]                                        [<c01222e1>]
do_softirq+0x36/0x53
[  261.658958]                                        [<c0122399>]
irq_exit+0x44/0x78
[  261.658958]                                        [<c0104d12>]
do_IRQ+0x52/0x62
[  261.658958]                                        [<c010353c>]
common_interrupt+0x28/0x30
[  261.658958]                                        [<c0107eaf>]
default_idle+0x2f/0x4c
[  261.658958]                                        [<c0101429>]
cpu_idle+0x6b/0x84
[  261.658958]                                        [<ffffffff>]
0xffffffff
[  261.658958]  }
[  261.658958]  ... key      at: [<f89c57d8>] __key.0+0x0/0xffff8552
[md_mod]
[  261.658958]  -> (dcache_lock){--..} ops: 62387 {
[  261.658958]     initial-use  at:
[  261.658958]                                          [<c013a189>]
mark_lock+0x18a/0x26c
[  261.658958]                                          [<c013ac67>]
__lock_acquire+0x5b1/0x75c
[  261.658958]                                          [<c01612c0>]
allocate_slab+0x91/0x99
[  261.658958]                                          [<c013b90f>]
lock_acquire+0x5a/0x74
[  261.658958]                                          [<c0173ee2>]
d_alloc+0x12a/0x15c
[  261.658958]                                          [<c02e40e1>]
_spin_lock+0x1c/0x45
[  261.658958]                                          [<c0173ee2>]
d_alloc+0x12a/0x15c
[  261.658958]                                          [<c0173ee2>]
d_alloc+0x12a/0x15c
[  261.658958]                                          [<c01740de>]
d_alloc_root+0x16/0x36
[  261.658958]                                          [<c019a703>]
sysfs_fill_super+0x53/0x85
[  261.658958]                                          [<c019a6b0>]
sysfs_fill_super+0x0/0x85
[  261.658958]                                          [<c01676df>]
get_sb_single+0x44/0x88
[  261.658958]                                          [<c019a747>]
sysfs_get_sb+0x12/0x17
[  261.658958]                                          [<c019a6b0>]
sysfs_fill_super+0x0/0x85
[  261.658958]                                          [<c016775a>]
vfs_kern_mount+0x37/0x6e
[  261.658958]                                          [<c0167861>]
kern_mount_data+0xd/0x10
[  261.658958]                                          [<c043048c>]
sysfs_init+0x4d/0x96
[  261.658958]                                          [<c042fc87>]
mnt_init+0x84/0xcb
[  261.658958]                                          [<c042f990>]
vfs_caches_init+0x75/0x83
[  261.658958]                                          [<c0423959>]
start_kernel+0x1af/0x1cf
[  261.658958]                                          [<ffffffff>]
0xffffffff
[  261.658958]     softirq-on-W at:
[  261.658958]                                          [<c0139f92>]
mark_irqflags+0xd4/0xe4
[  261.658958]                                          [<c013ac50>]
__lock_acquire+0x59a/0x75c
[  261.658958]                                          [<c01612c0>]
allocate_slab+0x91/0x99
[  261.658958]                                          [<c013b90f>]
lock_acquire+0x5a/0x74
[  261.658958]                                          [<c0173ee2>]
d_alloc+0x12a/0x15c
[  261.658958]                                          [<c02e40e1>]
_spin_lock+0x1c/0x45
[  261.658958]                                          [<c0173ee2>]
d_alloc+0x12a/0x15c
[  261.658958]                                          [<c0173ee2>]
d_alloc+0x12a/0x15c
[  261.658958]                                          [<c01740de>]
d_alloc_root+0x16/0x36
[  261.658958]                                          [<c019a703>]
sysfs_fill_super+0x53/0x85
[  261.658958]                                          [<c019a6b0>]
sysfs_fill_super+0x0/0x85
[  261.658958]                                          [<c01676df>]
get_sb_single+0x44/0x88
[  261.658958]                                          [<c019a747>]
sysfs_get_sb+0x12/0x17
[  261.658958]                                          [<c019a6b0>]
sysfs_fill_super+0x0/0x85
[  261.658958]                                          [<c016775a>]
vfs_kern_mount+0x37/0x6e
[  261.658958]                                          [<c0167861>]
kern_mount_data+0xd/0x10
[  261.658958]                                          [<c043048c>]
sysfs_init+0x4d/0x96
[  261.658958]                                          [<c042fc87>]
mnt_init+0x84/0xcb
[  261.658958]                                          [<c042f990>]
vfs_caches_init+0x75/0x83
[  261.658958]                                          [<c0423959>]
start_kernel+0x1af/0x1cf
[  261.658958]                                          [<ffffffff>]
0xffffffff
[  261.658958]     hardirq-on-W at:
[  261.658958]                                          [<c0139f75>]
mark_irqflags+0xb7/0xe4
[  261.658958]                                          [<c013ac50>]
__lock_acquire+0x59a/0x75c
[  261.658958]                                          [<c01612c0>]
allocate_slab+0x91/0x99
[  261.658958]                                          [<c013b90f>]
lock_acquire+0x5a/0x74
[  261.658958]                                          [<c0173ee2>]
d_alloc+0x12a/0x15c
[  261.658958]                                          [<c02e40e1>]
_spin_lock+0x1c/0x45
[  261.658958]                                          [<c0173ee2>]
d_alloc+0x12a/0x15c
[  261.658958]                                          [<c0173ee2>]
d_alloc+0x12a/0x15c
[  261.658958]                                          [<c01740de>]
d_alloc_root+0x16/0x36
[  261.658958]                                          [<c019a703>]
sysfs_fill_super+0x53/0x85
[  261.658958]                                          [<c019a6b0>]
sysfs_fill_super+0x0/0x85
[  261.658958]                                          [<c01676df>]
get_sb_single+0x44/0x88
[  261.658958]                                          [<c019a747>]
sysfs_get_sb+0x12/0x17
[  261.658958]                                          [<c019a6b0>]
sysfs_fill_super+0x0/0x85
[  261.658958]                                          [<c016775a>]
vfs_kern_mount+0x37/0x6e
[  261.658958]                                          [<c0167861>]
kern_mount_data+0xd/0x10
[  261.658958]                                          [<c043048c>]
sysfs_init+0x4d/0x96
[  261.658958]                                          [<c042fc87>]
mnt_init+0x84/0xcb
[  261.658958]                                          [<c042f990>]
vfs_caches_init+0x75/0x83
[  261.658958]                                          [<c0423959>]
start_kernel+0x1af/0x1cf
[  261.658958]                                          [<ffffffff>]
0xffffffff
[  261.658958]   }   
[  261.658958]   ... key      at: [<c041a9f0>] dcache_lock+0x10/0x20
[  261.658958]   -> (&dentry->d_lock){--..} ops: 156420 {
[  261.658958]      initial-use  at:
[  261.658958]                                            [<c013a189>]
mark_lock+0x18a/0x26c
[  261.658958]                                            [<c013ac67>]
__lock_acquire+0x5b1/0x75c
[  261.658958]                                            [<c013b90f>]
lock_acquire+0x5a/0x74
[  261.658958]                                            [<c01893e0>]
inotify_d_instantiate+0xf/0x36
[  261.658958]                                            [<c02e40e1>]
_spin_lock+0x1c/0x45
[  261.658958]                                            [<c01893e0>]
inotify_d_instantiate+0xf/0x36
[  261.658958]                                            [<c01893e0>]
inotify_d_instantiate+0xf/0x36
[  261.658958]                                            [<c0173fa0>]
d_instantiate+0x3a/0x47
[  261.658958]                                            [<c01740f9>]
d_alloc_root+0x31/0x36
[  261.658958]                                            [<c019a703>]
sysfs_fill_super+0x53/0x85
[  261.658958]                                            [<c019a6b0>]
sysfs_fill_super+0x0/0x85
[  261.658958]                                            [<c01676df>]
get_sb_single+0x44/0x88
[  261.658958]                                            [<c019a747>]
sysfs_get_sb+0x12/0x17
[  261.658958]                                            [<c019a6b0>]
sysfs_fill_super+0x0/0x85
[  261.658958]                                            [<c016775a>]
vfs_kern_mount+0x37/0x6e
[  261.658958]                                            [<c0167861>]
kern_mount_data+0xd/0x10
[  261.658958]                                            [<c043048c>]
sysfs_init+0x4d/0x96
[  261.658958]                                            [<c042fc87>]
mnt_init+0x84/0xcb
[  261.658958]                                            [<c042f990>]
vfs_caches_init+0x75/0x83
[  261.658958]                                            [<c0423959>]
start_kernel+0x1af/0x1cf
[  261.658958]                                            [<ffffffff>]
0xffffffff
[  261.658958]      softirq-on-W at:
[  261.658958]                                            [<c0139f92>]
mark_irqflags+0xd4/0xe4
[  261.658958]                                            [<c013ac50>]
__lock_acquire+0x59a/0x75c
[  261.658958]                                            [<c013b90f>]
lock_acquire+0x5a/0x74
[  261.658958]                                            [<c01893e0>]
inotify_d_instantiate+0xf/0x36
[  261.658958]                                            [<c02e40e1>]
_spin_lock+0x1c/0x45
[  261.658958]                                            [<c01893e0>]
inotify_d_instantiate+0xf/0x36
[  261.658958]                                            [<c01893e0>]
inotify_d_instantiate+0xf/0x36
[  261.658958]                                            [<c0173fa0>]
d_instantiate+0x3a/0x47
[  261.658958]                                            [<c01740f9>]
d_alloc_root+0x31/0x36
[  261.658958]                                            [<c019a703>]
sysfs_fill_super+0x53/0x85
[  261.658958]                                            [<c019a6b0>]
sysfs_fill_super+0x0/0x85
[  261.658958]                                            [<c01676df>]
get_sb_single+0x44/0x88
[  261.658958]                                            [<c019a747>]
sysfs_get_sb+0x12/0x17
[  261.658958]                                            [<c019a6b0>]
sysfs_fill_super+0x0/0x85
[  261.658958]                                            [<c016775a>]
vfs_kern_mount+0x37/0x6e
[  261.658958]                                            [<c0167861>]
kern_mount_data+0xd/0x10
[  261.658958]                                            [<c043048c>]
sysfs_init+0x4d/0x96
[  261.658958]                                            [<c042fc87>]
mnt_init+0x84/0xcb
[  261.658958]                                            [<c042f990>]
vfs_caches_init+0x75/0x83
[  261.658958]                                            [<c0423959>]
start_kernel+0x1af/0x1cf
[  261.658958]                                            [<ffffffff>]
0xffffffff
[  261.658958]      hardirq-on-W at:
[  261.658958]                                            [<c0139f75>]
mark_irqflags+0xb7/0xe4
[  261.658958]                                            [<c013ac50>]
__lock_acquire+0x59a/0x75c
[  261.658958]                                            [<c013b90f>]
lock_acquire+0x5a/0x74
[  261.658958]                                            [<c01893e0>]
inotify_d_instantiate+0xf/0x36
[  261.658958]                                            [<c02e40e1>]
_spin_lock+0x1c/0x45
[  261.658958]                                            [<c01893e0>]
inotify_d_instantiate+0xf/0x36
[  261.658958]                                            [<c01893e0>]
inotify_d_instantiate+0xf/0x36
[  261.658958]                                            [<c0173fa0>]
d_instantiate+0x3a/0x47
[  261.658958]                                            [<c01740f9>]
d_alloc_root+0x31/0x36
[  261.658958]                                            [<c019a703>]
sysfs_fill_super+0x53/0x85
[  261.658958]                                            [<c019a6b0>]
sysfs_fill_super+0x0/0x85
[  261.658958]                                            [<c01676df>]
get_sb_single+0x44/0x88
[  261.658958]                                            [<c019a747>]
sysfs_get_sb+0x12/0x17
[  261.658958]                                            [<c019a6b0>]
sysfs_fill_super+0x0/0x85
[  261.658958]                                            [<c016775a>]
vfs_kern_mount+0x37/0x6e

===============================================================
.CONFIG
==============================================================
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.27.7
# Tue Dec  2 08:35:12 2008
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
# CONFIG_EXPERIMENTAL is not set
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
# CONFIG_CGROUPS is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
# CONFIG_RELAY is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_COMPAT_BRK=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
# CONFIG_MARKERS is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
# CONFIG_HAVE_ARCH_TRACEHOOK is not set
# CONFIG_HAVE_DMA_ATTRS is not set
CONFIG_USE_GENERIC_SMP_HELPERS=y
# CONFIG_HAVE_CLK is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_CLASSIC_RCU=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
# CONFIG_X86_RDC321X is not set
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
CONFIG_MPENTIUMIII=y
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CPU=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_NONFATAL is not set
# CONFIG_X86_MCE_P4THERMAL is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=m
# CONFIG_X86_CPUID is not set
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
# CONFIG_X86_PAE is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
# CONFIG_SPARSEMEM_STATIC is not set
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_X86_RESERVE_LOW_64K=y
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
CONFIG_IRQBALANCE=y
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x100000
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_COMPAT_VDSO=y

#
# Power management options
#
# CONFIG_PM is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
# CONFIG_CPU_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
# CONFIG_INET_LRO is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_IPV6=m
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set

#
# Wireless
#
# CONFIG_CFG80211 is not set
# CONFIG_WIRELESS_EXT is not set
# CONFIG_MAC80211 is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_ISAPNP=y
# CONFIG_PNPACPI is not set
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
# CONFIG_BLK_DEV_XD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_PHANTOM is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_7000FASST is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AHA152X is not set
# CONFIG_SCSI_AHA1542 is not set
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=15000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_IN2000 is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_DTC3280 is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_GENERIC_NCR5380 is not set
# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_NCR53C406A is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_PAS16 is not set
# CONFIG_SCSI_QLOGIC_FAS is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_SYM53C416 is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_T128 is not set
# CONFIG_SCSI_U14_34F is not set
# CONFIG_SCSI_ULTRASTOR is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_DH is not set
# CONFIG_ATA is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=m
# CONFIG_MD_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
# CONFIG_BLK_DEV_DM is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# A new alternative FireWire stack is available with EXPERIMENTAL=y
#
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_DUMMY=m
# CONFIG_BONDING is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_LANCE is not set
# CONFIG_NET_VENDOR_SMC is not set
# CONFIG_NET_VENDOR_RACAL is not set
# CONFIG_NET_TULIP is not set
# CONFIG_DEPCA is not set
# CONFIG_HP100 is not set
# CONFIG_NET_ISA is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_APRICOT is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_CS89x0 is not set
CONFIG_EEPRO100=y
# CONFIG_E100 is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139TOO is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IGB is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=y
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
CONFIG_NETDEV_10000=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_IXGBE is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_NIU is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_TEHUTI is not set
# CONFIG_BNX2X is not set
# CONFIG_SFC is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set
# CONFIG_IWLWIFI_LEDS is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_INPORT is not set
# CONFIG_MOUSE_LOGIBM is not set
# CONFIG_MOUSE_PC110PAD is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_RTC is not set
# CONFIG_GEN_RTC is not set
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
# CONFIG_HWMON is not set
# CONFIG_THERMAL is not set
# CONFIG_THERMAL_HWMON is not set
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_SBC7240_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# ISA-based Watchdog Cards
#
# CONFIG_PCWATCHDOG is not set
# CONFIG_MIXCOMWD is not set
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=y
# CONFIG_AGP_ATI is not set
CONFIG_AGP_AMD=y
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
CONFIG_AGP_SIS=y
# CONFIG_AGP_SWORKS is not set
CONFIG_AGP_VIA=y
# CONFIG_AGP_EFFICEON is not set
CONFIG_DRM=y
CONFIG_DRM_TDFX=y
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
CONFIG_DRM_I810=y
# CONFIG_DRM_I830 is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
# CONFIG_VIDEO_SELECT is not set
# CONFIG_MDA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_SOUND=y
# CONFIG_SND is not set
# CONFIG_SOUND_PRIME is not set
# CONFIG_HID_SUPPORT is not set
# CONFIG_USB_SUPPORT is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_UIO is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
# CONFIG_XFS_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
# CONFIG_ZISOFS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set

#
# Miscellaneous filesystems
#
# CONFIG_HFSPLUS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V3 is not set
CONFIG_NFSD=y
# CONFIG_NFSD_V3 is not set
CONFIG_LOCKD=y
CONFIG_EXPORTFS=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
# CONFIG_SMB_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_NLS is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_FRAME_POINTER is not set
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
CONFIG_HAVE_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
# CONFIG_FTRACE is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_CONTEXT_SWITCH_TRACER is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_4KSTACKS is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_MMIOTRACE is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_MANAGER is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
# CONFIG_CRYPTO_ECB is not set
# CONFIG_CRYPTO_PCBC is not set

#
# Hash modes
#
# CONFIG_CRYPTO_HMAC is not set

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
# CONFIG_CRC_T10DIF is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
