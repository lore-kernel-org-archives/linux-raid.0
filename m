From: Mark Knecht <markknecht@gmail.com>
Subject: tar fails on RAID with timeout, works great on single disk
Date: Thu, 1 Apr 2010 09:43:41 -0700
Message-ID: <t2o5bdc1c8b1004010943mae5d544bkc0452c76f571a2bd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,
   I'm still seeing this timeout error when doing tar xjf portage* on
this new box using RAID. There are 5 of these in /var/log/messages.

INFO: task kjournald:5064 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kjournald     D ffff880028351580     0  5064      2 0x00000000
 ffff8801ac91a190 0000000000000046 0000000000000000 ffffffff81067110
 000000000000dcf8 ffff880180863fd8 0000000000011580 0000000000011580
 ffff88014165ba20 ffff8801ac89a834 ffff8801af920150 ffff8801ac91a418
Call Trace:
 [<ffffffff81067110>] ? __alloc_pages_nodemask+0xfa/0x58c
 [<ffffffff8129174a>] ? md_make_request+0xde/0x119
 [<ffffffff810a9576>] ? sync_buffer+0x0/0x40
 [<ffffffff81334305>] ? io_schedule+0x3e/0x54
 [<ffffffff810a95b1>] ? sync_buffer+0x3b/0x40
 [<ffffffff81334789>] ? __wait_on_bit+0x41/0x70
 [<ffffffff810a9576>] ? sync_buffer+0x0/0x40
 [<ffffffff81334823>] ? out_of_line_wait_on_bit+0x6b/0x77
 [<ffffffff81040a66>] ? wake_bit_function+0x0/0x23
 [<ffffffff8111f400>] ? journal_commit_transaction+0xb56/0x1112
 [<ffffffff81334280>] ? schedule+0x8f4/0x93b
 [<ffffffff81335e3d>] ? _raw_spin_lock_irqsave+0x18/0x34
 [<ffffffff81040a38>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff81335bcc>] ? _raw_spin_unlock_irqrestore+0x12/0x2c
 [<ffffffff8112278c>] ? kjournald+0xe2/0x20a
 [<ffffffff81040a38>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff811226aa>] ? kjournald+0x0/0x20a
 [<ffffffff81040665>] ? kthread+0x79/0x81
 [<ffffffff81002c94>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff810405ec>] ? kthread+0x0/0x81
 [<ffffffff81002c90>] ? kernel_thread_helper+0x0/0x10

   The same operation works fine to one partition (/dev/sda3) disk in
the array (sda/sdb/sdc) but not to the RAID. The tar operation seems
to be completely hung. On a single drive it finishes in under a
minute. On the RAID I gave it 20 minutes before completely giving up.
As usual I had two CPU's sitting at 100% wait but that was true when
untarring to the single drive so I suspect it's just normal operation
to wait for disk I/O when untarring a large file, correct?

   I do see other possible problems in /var/log/messages from a couple
of days but I'm not sure if this is RAID or non-RAID. I suspect it's
non-RAID:

Mar 29 14:07:23 keeper kernel: eix-update(3391): READ block 37401680 on sda3
[many, many repeats...]

Mar 29 14:07:24 keeper kernel: eix-update(3391): WRITE block 47697296 on sda3
[many, many repeats...]

   Layout is:

/dev/sda1 -> boot
/dev/sda2, /dev/sdb2, /dev/sdc2 -> swap
/dev/sda3 - non-RAID Gentoo install

/dev/sda5, /dev/sdb5, dev/sdc5 -> RAID1 Gentoo install - should
eventually duplicate the install on /dev/sda3.

   The kernel is 2.6.33-gentoo. mdadm-3.1.1-r1

   I've tried the default dirty ratio 10/20 settings as well as 3/50
with the same failure.

keeper ~ # sysctl -a | grep dirty
vm.dirty_background_ratio = 3
vm.dirty_background_bytes = 0
vm.dirty_ratio = 50
vm.dirty_bytes = 0
vm.dirty_writeback_centisecs = 500
vm.dirty_expire_centisecs = 3000
error: permission denied on key 'net.ipv4.route.flush'
error: permission denied on key 'net.ipv6.route.flush'
keeper ~ #

   smartctl doesn't seem to show any problems. I've run the long and
short selftests and they seem to pass.

   Using cfq I/O scheduler. Have not tried deadline.

keeper ~ # cat /sys/block/sda/queue/scheduler
noop deadline [cfq]
keeper ~ #


   Any ideas about cause other than the general dislike of the WD
Green drives? I'm not against that being the reason, but if it is then
I want to be very sure before I go to the expense of buying something
else. I'm just an individual at home trying to build a reliable PC and
not a corporation with lots of money. Please don't make me spend $500
without first putting up a good fight to make it work, OK?! ;-)

Thanks,
Mark




keeper ~ # smartctl -A /dev/sda
smartctl 5.39.1 2010-01-28 r3054 [x86_64-pc-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   131   131   021    Pre-fail
Always       -       6441
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       20
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age
Always       -       60
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       18
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       10
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       906
194 Temperature_Celsius     0x0022   109   102   000    Old_age
Always       -       38
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0

keeper ~ # smartctl -A /dev/sdb
smartctl 5.39.1 2010-01-28 r3054 [x86_64-pc-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   130   130   021    Pre-fail
Always       -       6500
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       21
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age
Always       -       60
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       19
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       11
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       300
194 Temperature_Celsius     0x0022   106   098   000    Old_age
Always       -       41
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0

keeper ~ # smartctl -A /dev/sdc
smartctl 5.39.1 2010-01-28 r3054 [x86_64-pc-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   126   126   021    Pre-fail
Always       -       6675
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       21
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age
Always       -       60
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       19
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       11
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       281
194 Temperature_Celsius     0x0022   107   099   000    Old_age
Always       -       40
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0

keeper ~ #
