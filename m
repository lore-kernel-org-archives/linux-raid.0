From: Andrei Banu <andrei.banu@redhost.ro>
Subject: Re: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840
 PRO
Date: Wed, 24 Apr 2013 11:26:08 +0300
Message-ID: <51779720.6040109@redhost.ro>
References: <5171CBF9.9020701@redhost.ro> <51732E2B.6090607@hardwarefreak.com> <5174501F.80509@redhost.ro> <51747382.1010105@hardwarefreak.com> <5a749bb56c88b6d6b8a806694b163bda@redhost.ro> <5175F71A.8030805@hardwarefreak.com> <51765FD7.8090309@redhost.ro> <51775078.3000500@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51775078.3000500@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I am sorry for the irrelevant feedback. Where I misunderstood your 
request, I filled in the blanks (poorly).

1. SWAP
root [~]# blkid | grep cef1d19d-2578-43db-9ffc-b6b70e227bfa
/dev/md1: UUID="cef1d19d-2578-43db-9ffc-b6b70e227bfa" TYPE="swap"

So yes, swap is on md1. This *md1 has a size of 2GB*. Isn't this way too 
low for a system with 16GB of memory?

2. Let me try again to give you the right test results:

Before the bigfile copy:

root [~]# perf top -U
Samples: 768  of event 'cycles', Event count (approx.): 499088870
  18.58%  [kernel]  [k] port_inb
   6.21%  [kernel]  [k] page_fault
   3.36%  [kernel]  [k] clear_page_c_e
   2.82%  [kernel]  [k] kallsyms_expand_symbol
   1.99%  [kernel]  [k] __mem_cgroup_commit_charge
   1.84%  [kernel]  [k] shmem_getpage_gfp
   1.51%  [kernel]  [k] alloc_pages_vma
   1.51%  [kernel]  [k] __alloc_pages_nodemask
   1.46%  [kernel]  [k] avtab_search_node
   1.45%  [kernel]  [k] format_decode
   1.40%  [kernel]  [k] list_del
   1.36%  [kernel]  [k] get_page_from_freelist
   1.35%  [kernel]  [k] vsnprintf
   1.29%  [kernel]  [k] avc_has_perm_noaudit
   1.28%  [kernel]  [k] number
   1.22%  [kernel]  [k] free_pcppages_bulk
   1.21%  [kernel]  [k] ____pagevec_lru_add
   1.14%  [kernel]  [k] get_page
   1.08%  [kernel]  [k] memcpy
   1.07%  [kernel]  [k] mem_cgroup_update_file_mapped
   1.07%  [kernel]  [k] page_waitqueue
   0.98%  [kernel]  [k] __d_lookup
   0.97%  [kernel]  [k] unmap_vmas
   0.91%  [kernel]  [k] _spin_lock
   0.87%  [kernel]  [k] inode_has_perm
   0.81%  [kernel]  [k] string
   0.77%  [kernel]  [k] page_remove_rmap
   0.73%  [kernel]  [k] __audit_syscall_exit
   0.68%  [kernel]  [k] lookup_page_cgroup
   0.61%  [kernel]  [k] unlock_page
   0.61%  [kernel]  [k] shmem_find_get_pages_and_swap
   0.61%  [kernel]  [k] free_hot_cold_page
   0.61%  [kernel]  [k] release_pages
   0.56%  [kernel]  [k] mem_cgroup_lru_del_list
   0.55%  [kernel]  [k] strncpy_from_user
   0.54%  [kernel]  [k] module_get_kallsym
   0.52%  [kernel]  [k] find_get_page
   0.50%  [kernel]  [k] __do_fault
   0.48%  [kernel]  [k] path_put
   0.46%  [kernel]  [k] __list_add
   0.46%  [kernel]  [k] handle_mm_fault
   0.45%  [kernel]  [k] __wake_up_bit
   0.44%  [kernel]  [k] handle_pte_fault
   0.43%  [kernel]  [k] audit_syscall_entry
   0.43%  [kernel]  [k] thread_return
   0.42%  [kernel]  [k] path_init
   0.41%  [kernel]  [k] dput
   0.40%  [kernel]  [k] task_has_capability
   0.40%  [kernel]  [k] get_task_cred
   0.40%  [kernel]  [k] pointer
   0.40%  [kernel]  [k] _atomic_dec_and_lock
   0.39%  [kernel]  [k] __link_path_walk
   0.38%  [kernel]  [k] memset
   0.37%  [kernel]  [k] do_lookup
   0.34%  [kernel]  [k] radix_tree_lookup_slot
   0.34%  [kernel]  [k] down_read_trylock
   0.33%  [kernel]  [k] kmem_cache_alloc
   0.31%  [kernel]  [k] __set_page_dirty_no_writeback
   0.31%  [kernel]  [k] __inc_zone_state
   0.31%  [kernel]  [k] __mem_cgroup_uncharge_common

root [~]# iotop
Total DISK READ: 0.00 B/s | Total DISK WRITE: 2.33 M/s
   TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN     IO> COMMAND
   541 be/3 root        0.00 B/s    7.83 K/s  0.00 %  2.27 % [jbd2/md2-8]
  8568 be/4 root        0.00 B/s    7.83 K/s  0.00 %  0.00 % lfd - sleeping
  1457 be/3 root        0.00 B/s    7.83 K/s  0.00 %  0.00 % auditd
  1669 be/4 root        0.00 B/s    3.91 K/s  0.00 %  0.00 % rsyslogd -i 
/var/run/syslogd.pid -c 5
  1695 be/4 named       0.00 B/s    3.91 K/s  0.00 %  0.00 % named -u named
31391 be/4 mysql       0.00 B/s   23.48 K/s  0.00 %  0.00 % mysqld 
--basedir=/ --datadir=/var/lib/mysql --user=mysql --log-error=/var~r 
--open-files-limit=50000 --pid-file=/var/lib/mysql/server.pid
     1 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % init
     2 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [kthreadd]
     3 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/0]
     4 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [ksoftirqd/0]
     5 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/0]
     6 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [watchdog/0]
     7 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/1]
     8 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/1]
     9 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [ksoftirqd/1]
    10 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [watchdog/1]
    11 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/2]
    12 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/2]
    13 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [ksoftirqd/2]
    14 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [watchdog/2]
    15 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/3]
    16 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/3]
    17 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [ksoftirqd/3]
    18 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [watchdog/3]
    19 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/4]
    20 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/4]
    21 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [ksoftirqd/4]
    22 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [watchdog/4]
    23 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/5]
    24 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/5]
    25 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [ksoftirqd/5]
    26 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [watchdog/5]
    27 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/6]
    28 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/6]
    29 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [ksoftirqd/6]
    30 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [watchdog/6]
    31 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/7]
    32 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/7]
    33 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [ksoftirqd/7]
    34 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [watchdog/7]
    35 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [events/0]
    36 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [events/1]
    37 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [events/2]
    38 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [events/3]
    39 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [events/4]
    40 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [events/5]
    41 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [events/6]
    42 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [events/7]
    43 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [cgroup]
    44 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [khelper]
    45 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [netns]
    46 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [async/mgr]
    47 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [pm]
    48 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [sync_supers]
    49 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [bdi-default]
    50 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [kintegrityd/0]
    51 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [kintegrityd/1]
    52 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [kintegrityd/2]
    53 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [kintegrityd/3]
    54 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [kintegrityd/4]

Now the file copy with sync:

root [~]# time (cp largefile.tar.gz test05.tmp; sync)

real    1m33.923s
user    0m0.002s
sys     0m0.713s

Large file size: 523MB
BW determination: 523MB / 93.923 seconds = 5.56MB/s

File copy without sync:
root [~]# echo 3 > /proc/sys/vm/drop_caches
root [~]# time cp largefile.tar.gz test07.tmp
real    0m6.452s
user    0m0.007s
sys     0m0.687s
Large file size: 523MB
BW determination: 523MB / 6.452 seconds = 81.06 MB/s

During the copy (near the end: about 70 seconds into the copy - results 
with sync):

Samples: 17K of event 'cycles', Event count (approx.): 5067697991
   7.48%  [kernel]             [k] port_inb
   5.40%  [kernel]             [k] page_fault
   2.92%  [kernel]             [k] clear_page_c_e
   2.29%  [kernel]             [k] list_del
   2.21%  [kernel]             [k] _spin_lock
   1.99%  [kernel]             [k] __d_lookup
   1.92%  [kernel]             [k] avtab_search_node
   1.64%  [kernel]             [k] unmap_vmas
   1.59%  [kernel]             [k] get_page_from_freelist
   1.55%  [kernel]             [k] __mem_cgroup_commit_charge
   1.22%  [kernel]             [k] mem_cgroup_update_file_mapped
   1.21%  [kernel]             [k] copy_page_c
   1.04%  [kernel]             [k] find_vma
   1.00%  [kernel]             [k] _spin_lock_irq
   0.97%  [kernel]             [k] __wake_up_bit
   0.94%  [kernel]             [k] __mem_cgroup_uncharge_common
   0.92%  [kernel]             [k] get_page
   0.91%  [kernel]             [k] __alloc_pages_nodemask
   0.87%  [kernel]             [k] handle_mm_fault
   0.85%  [kernel]             [k] __link_path_walk
   0.84%  [kernel]             [k] avc_has_perm_noaudit
   0.83%  [kernel]             [k] alloc_pages_vma
   0.81%  [kernel]             [k] lookup_page_cgroup
   0.80%  [kernel]             [k] __do_page_fault
   0.80%  [kernel]             [k] free_pcppages_bulk
   0.77%  [kernel]             [k] _spin_lock_irqsave
   0.75%  [kernel]             [k] radix_tree_lookup_slot
   0.73%  [kernel]             [k] kmem_cache_alloc
   0.68%  [ip_tables]          [k] ipt_do_table
   0.66%  [kernel]             [k] _atomic_dec_and_lock
   0.65%  [kernel]             [k] release_pages
   0.62%  [kernel]             [k] find_get_page
   0.61%  [kernel]             [k] schedule
   0.60%  [kernel]             [k] inode_has_perm
   0.56%  [kernel]             [k] sidtab_context_to_sid
   0.54%  [kernel]             [k] handle_pte_fault
   0.53%  [kernel]             [k] _spin_unlock_irqrestore
   0.53%  [kernel]             [k] memset
   0.52%  [kernel]             [k] __inc_zone_state
   0.51%  [kernel]             [k] update_curr
   0.51%  [kernel]             [k] kfree
   0.50%  [kernel]             [k] __list_add
   0.50%  [kernel]             [k] __do_fault
   0.49%  [kernel]             [k] shmem_getpage_gfp
   0.47%  [kernel]             [k] filemap_fault


Total DISK READ: 0.00 B/s | Total DISK WRITE: 0.00 B/s
   TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN     IO> COMMAND
   541 be/3 root        0.00 B/s    0.00 B/s  0.00 % 96.96 % [jbd2/md2-8]
12468 be/4 nobody      0.00 B/s    3.89 K/s  0.00 %  0.00 % httpd -k 
start -DSSL
18818 be/4 mysql       0.00 B/s    3.89 K/s  0.00 %  0.00 % mysqld 
--basedir=/ --da~sql/server.pid
12333 be/4 nobody      0.00 B/s    3.89 K/s  0.00 %  0.00 % httpd -k 
start -DSSL
12560 be/4 nobody      0.00 B/s    3.89 K/s  0.00 %  0.00 % httpd -k 
start -DSSL
12568 be/4 nobody      0.00 B/s    3.89 K/s  0.00 %  0.00 % httpd -k 
start -DSSL
12281 be/4 nobody      0.00 B/s    3.89 K/s  0.00 %  0.00 % [httpd]
     1 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % init
     2 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [kthreadd]
     3 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/0]
     4 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [ksoftirqd/0]
     5 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/0]
     6 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [watchdog/0]
     7 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/1]
     8 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/1]
     9 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [ksoftirqd/1]
    10 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [watchdog/1]
    11 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/2]
    12 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/2]
    13 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [ksoftirqd/2]
    14 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [watchdog/2]
    15 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/3]
    16 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/3]
    17 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [ksoftirqd/3]
    18 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [watchdog/3]
    19 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/4]
    20 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/4]
    21 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [ksoftirqd/4]
    22 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [watchdog/4]
    23 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/5]
    24 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/5]
    25 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [ksoftirqd/5]
    26 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [watchdog/5]
    27 rt/4 root        0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/6]

Please let me know if I messed up again so that I can correct it.


@Adam

3. root [~]# fdisk -lu /dev/sd*

Disk /dev/sda: 512.1 GB, 512110190592 bytes
255 heads, 63 sectors/track, 62260 cylinders, total 1000215216 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00026d59

    Device Boot      Start         End      Blocks   Id  System
/dev/sda1            2048     4196351     2097152   fd  Linux raid 
autodetect
Partition 1 does not end on cylinder boundary.
/dev/sda2   *     4196352     4605951      204800   fd  Linux raid 
autodetect
Partition 2 does not end on cylinder boundary.
/dev/sda3         4605952   814106623   404750336   fd  Linux raid 
autodetect

Disk /dev/sda1: 2147 MB, 2147483648 bytes
255 heads, 63 sectors/track, 261 cylinders, total 4194304 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xfffefffe

Disk /dev/sda2: 209 MB, 209715200 bytes
255 heads, 63 sectors/track, 25 cylinders, total 409600 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

Disk /dev/sda3: 414.5 GB, 414464344064 bytes
255 heads, 63 sectors/track, 50389 cylinders, total 809500672 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

Disk /dev/sdb: 512.1 GB, 512110190592 bytes
255 heads, 63 sectors/track, 62260 cylinders, total 1000215216 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x0003dede

    Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048     4196351     2097152   fd  Linux raid 
autodetect
Partition 1 does not end on cylinder boundary.
/dev/sdb2   *     4196352     4605951      204800   fd  Linux raid 
autodetect
Partition 2 does not end on cylinder boundary.
/dev/sdb3         4605952   814106623   404750336   fd  Linux raid 
autodetect

Disk /dev/sdb1: 2147 MB, 2147483648 bytes
255 heads, 63 sectors/track, 261 cylinders, total 4194304 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xfffefffe

Disk /dev/sdb2: 209 MB, 209715200 bytes
255 heads, 63 sectors/track, 25 cylinders, total 409600 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

Disk /dev/sdb3: 414.5 GB, 414464344064 bytes
255 heads, 63 sectors/track, 50389 cylinders, total 809500672 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

Kind regards!
Andrei Banu

On 4/24/2013 6:24 AM, Stan Hoeppner wrote:
> root [~]# cat /etc/fstab
>> UUID=cef1d19d-2578-43db-9ffc-b6b70e227bfa swap swap    defaults        0 0
> I can't discern from UUID where your swap partition is located.  Is it a
> partition directly on an SSD or is it a partition atop md1?
>
>> root [/]# echo 3 > /proc/sys/vm/drop_caches
>> root [~]# time cp largefile.tar.gz test03.tmp; time sync;
> You're slowing us down here.  Please execute commands as instructed
> without modification.  The above is wrong.  You don't call time twice.
> If you're worried about sync execution being included time, use:
> $ time (cp src.tmp src.temp; sync)
>
> Though it makes little difference as Linux is pretty good about flushing
> the last few write buffers.  But you missed the important part, the math
> for bandwidth determination:  548/real = xx MB/s
>
> This is cp not dd.  It's up to you to do the math.  Using time allows
> you to do so.  548MB is my example using your previous file size in your
> tests.  Modify accordingly if needed.
>
> *Important note*  The job of this list is to provide knowledge transfer,
> advice, and assistance.  You must do the work, and you must learn along
> the way.  We don't fix people's problems, as we don't have access to
> their computers.  What we do is *enable* people to fix their problems
> themselves.
>
>> After about 15 seconds the server load started to increase from 1,
>> spiked to 40 in about a minute and then it started decreasing.
> Please stop telling us this.  Linux load average is irrelevant.
>
>> 5. The perf top -U output during a dd copy:
> This was supposed to be executed before and simultaneously with the cp
> operation above.  Do you know how to use multiple terminal windows?
>
>> 6. iotop
> Again, this was supposed to be run with the cp command, exited toward
> the end of the cp operation, then copy/pasted.
>
> is very dynamic and I am afraid the data I am providing will be
>> unclear but let me give a number of snapshots from during the large file
>> copy and maybe you can make something of it (samples a few seconds apart):
>> !!!!!! 6085 be/4 root        7.69 K/s 1004.85 M/s  0.00 %  0.00 % dd
>> if=largefile.tar.gz of=test10 oflag=sync bs=1G
> This is another example of why you don't use dd for IO testing, and
> especially with a block size of 1GB.  dd buffers into RAM up to
> $block_size bytes before it begins flushing to disk.  So what you're
> seeing here is that massive push at the beginning of the run.  Your SSDs
> in RAID1 peak at ~265MB/s.  iotop is showing 1GB/s, 4 times what the
> drives can do.  This is obviously not real.
>
> You can get away with oflag=sync using 1GB block size.  But if you run
> dd the only way it can be run for realistic results, using bs=4096 which
> matches every filesystem block size including EXTx, XFS, and JFS, then
> using iflag=sync will degrade your performance, an ack is required on
> each block.  That's what sync does.  With SSD it won't be nearly as
> dramatic as rust, where the difference in runtime is 100-200x slower due
> to rotational latency.
>
>> I appologize for such a lengthy email!
> Don't apologize, just don't send more information than needed,
> especially if you don't know it's relevant. ;)  Send only what's
> requested, and as requested, please.
>

