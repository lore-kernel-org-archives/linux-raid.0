From: Niccolo Rigacci <niccolo@rigacci.org>
Subject: Re: IBM xSeries stop responding during RAID1 reconstruction
Date: Sat, 17 Jun 2006 12:01:00 +0200
Message-ID: <200606171201.00531.niccolo@rigacci.org>
References: <20060614085354.GA18106@rigacci.org> <20060615091219.GB2080@rigacci.org> <17553.13020.134589.292543@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17553.13020.134589.292543@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday 15 June 2006 12:13, you wrote:
> If this is causing a lockup, then there is something else wrong, just
> as any single process should not - by writing constantly to disks - be
> able to clog up the whole system.
>
> Maybe if you could get the result of
>   alt-sysrq-P

I tried some kernel changes enabling the HyperThreading on the (single) P4 
processor and enabling CONFIG_PREEMPT_VOLUNTARY=y, but with no success.

During the lookup Alt-SysRq-P constantly says that:

  EIP is at mwait_idle+0x1a/0x2e

While Alt-SysRq-T shows - among other processes - the MD syncing and the bash 
looked-up; this is the hand-copied call traces:

md3_resync
  device_barrier
  default_wake_function
  sync_request
  __generic_unplug_device
  md_do_sync
  schedule
  md_thread
  md_thread
  kthread
  kthread
  kernel_thread_helper

bash
  io_schedule
  sync_buffer
  sync_buffer
  __wait_on_bit_lock
  sync_buffer
  out_of_line_wait_on_bit_lock
  wake_bit_function
  __lock_buffer
  do_get_write_access
  __ext3_get_inode_loc
  jurnal_get_write_access
  ext3_reserve_inode_write
  ext3_mark_inode_dirty
  ext3_dirty_inode
  __mark_inode_dirty
  update_atime
  vfs_readdir
  sys_getdents64
  filldir64
  syscall_call


This is also the top output, which runs regularly during the lookup:

top - 11:40:41 up 7 min,  2 users,  load average: 8.70, 4.92, 2.04
Tasks:  70 total,   1 running,  69 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.2% us,  0.7% sy,  0.0% ni, 98.7% id,  0.0% wa,  0.0% hi,  0.5% si
Mem:    906212k total,    58620k used,   847592k free,     3420k buffers
Swap:  1951736k total,        0k used,  1951736k free,    23848k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
  829 root      10  -5     0    0    0 S    1  0.0   0:01.70 md3_raid1
 2823 root      10  -5     0    0    0 D    1  0.0   0:01.62 md3_resync
    1 root      16   0  1956  656  560 S    0  0.1   0:00.52 init
    2 root      RT   0     0    0    0 S    0  0.0   0:00.00 migration/0
    3 root      34  19     0    0    0 S    0  0.0   0:00.00 ksoftirqd/0
    4 root      RT   0     0    0    0 S    0  0.0   0:00.00 watchdog/0
    5 root      RT   0     0    0    0 S    0  0.0   0:00.00 migration/1
    6 root      34  19     0    0    0 S    0  0.0   0:00.00 ksoftirqd/1
    7 root      RT   0     0    0    0 S    0  0.0   0:00.00 watchdog/1
    8 root      10  -5     0    0    0 S    0  0.0   0:00.01 events/0
    9 root      10  -5     0    0    0 S    0  0.0   0:00.01 events/1
   10 root      10  -5     0    0    0 S    0  0.0   0:00.00 khelper
   11 root      10  -5     0    0    0 S    0  0.0   0:00.00 kthread
   14 root      10  -5     0    0    0 S    0  0.0   0:00.00 kblockd/0
   15 root      10  -5     0    0    0 S    0  0.0   0:00.00 kblockd/1
   16 root      11  -5     0    0    0 S    0  0.0   0:00.00 kacpid
  152 root      20   0     0    0    0 S    0  0.0   0:00.00 pdflush
  153 root      15   0     0    0    0 D    0  0.0   0:00.00 pdflush
  154 root      17   0     0    0    0 S    0  0.0   0:00.00 kswapd0
  155 root      11  -5     0    0    0 S    0  0.0   0:00.00 aio/0
  156 root      11  -5     0    0    0 S    0  0.0   0:00.00 aio/1
  755 root      10  -5     0    0    0 S    0  0.0   0:00.00 kseriod
  796 root      10  -5     0    0    0 S    0  0.0   0:00.00 ata/0
  797 root      11  -5     0    0    0 S    0  0.0   0:00.00 ata/1
  799 root      11  -5     0    0    0 S    0  0.0   0:00.00 scsi_eh_0
  800 root      11  -5     0    0    0 S    0  0.0   0:00.00 scsi_eh_1
  825 root      15   0     0    0    0 S    0  0.0   0:00.00 kirqd
  831 root      10  -5     0    0    0 D    0  0.0   0:00.00 md2_raid1
  833 root      10  -5     0    0    0 S    0  0.0   0:00.00 md1_raid1
  834 root      10  -5     0    0    0 D    0  0.0   0:00.00 md0_raid1
  835 root      15   0     0    0    0 D    0  0.0   0:00.00 kjournald
  932 root      18  -4  2192  584  368 S    0  0.1   0:00.19 udevd
 1698 root      10  -5     0    0    0 S    0  0.0   0:00.00 khubd
 2031 root      22   0     0    0    0 S    0  0.0   0:00.00 kjournald
 2032 root      15   0     0    0    0 D    0  0.0   0:00.00 kjournald
 2142 daemon    16   0  1708  364  272 S    0  0.0   0:00.00 portmap
 2464 root      16   0  2588  932  796 S    0  0.1   0:00.01 syslogd

-- 
Niccolo Rigacci
Firenze - Italy

War against Iraq? Not in my name!
