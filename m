From: Alfred Isele <Alfred.Isele@fujitsu-siemens.com>
Subject: Re: raid bug in 2.4.20
Date: Fri, 11 Apr 2003 12:30:35 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3.0.6.32.20030411123035.00adf830@athen>
References: <3.0.6.32.20030411102033.00bafcd0@athen>
 <Pine.LNX.4.44.0304101623300.25209-100000@karma.hagopian.net>
 <3.0.6.32.20030411102033.00bafcd0@athen>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=====================_1050049835==_"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030411091336.GE17163@marowsky-bree.de>
To: Lars Marowsky-Bree <lmb@suse.de>, Paul Clements <Paul.Clements@SteelEye.com>, Rob Hagopian <rob@hagopian.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=====================_1050049835==_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


Hello!
I gathered the information you asked for with the
sysrq-t as an attachment.
Thank you
Alfred Isele

----------------------------------------------------------------
cat /proc/mdstat
----------------------------------------------------------------
Personalities : [raid1]=20
read_ahead 1024 sectors
md0 : active raid1 sdb1[1] sda1[0]
      80256 blocks [2/2] [UU]
     =20
md1 : active raid1 sdb2[1] sda2[0]
      722816 blocks [2/2] [UU]
     =20
md2 : active raid1 sdb3[1]
      2409664 blocks [2/1] [_U]
     =20
md3 : active raid1 sdb4[1]
      1044160 blocks [2/1] [_U]
     =20
md4 : active raid1 sdd2[1] sdd1[0]
      80256 blocks [2/2] [UU]
     =20
unused devices: <none>
----------------------------------------------------------------


----------------------------------------------------------------
top
----------------------------------------------------------------
128 processes: 122 sleeping, 6 running, 0 zombie, 0 stopped
CPU0 states:  1.1% user,  1.1% system,  0.0% nice, 97.1% idle
CPU1 states:  0.0% user, 100.0% system,  0.0% nice,  0.0% idle
Mem:  1162020K av,  703760K used,  458260K free,       0K shrd,   85888K=
 buff
Swap:  722808K av,       0K used,  722808K free                  471184K
cached

  PID USER     PRI  NI  SIZE  RSS SHARE STAT %CPU %MEM   TIME COMMAND
   20 root      19   0     0    0     0 RW   99.9  0.0  15:56 raid1d
 3140 isele     15   0  1112 1112   764 R     2.5  0.0   2:31 top
 1357 solid     15   0  3176 3176  1824 S     0.1  0.2   0:02 RtpSolidD
    1 root      15   0   236  236   204 S     0.0  0.0   0:03 init
    2 root      0K   0     0    0     0 SW    0.0  0.0   0:00 migration_CPU0
    3 root      0K   0     0    0     0 SW    0.0  0.0   0:00 migration_CPU1
    4 root      15   0     0    0     0 SW    0.0  0.0   0:00 keventd
    5 root      34  19     0    0     0 SWN   0.0  0.0   0:00 ksoftirqd_CPU0
---------------------------------------------------------------

---------------------------------------------------------------
sysrq-t output as attachment Z:\aries_stack_trace;
---------------------------------------------------------------

---------------------------------------------------------------
mdadm -D /dev/md2
---------------------------------------------------------------
/dev/md2:
        Version : 00.90.00
  Creation Time : Fri Feb 28 11:03:30 2003
     Raid Level : raid1
     Array Size : 2409664 (2.30 GiB 2.51 GB)
    Device Size : 2409664 (2.30 GiB 2.51 GB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Fri Apr 11 12:04:47 2003
          State : dirty, no-errors
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 1


    Number   Major   Minor   RaidDevice State
       0       0        0        0      faulty removed
       1       8       19        1      active sync   /dev/sdb3
           UUID : a8a7ae0d:4b8ec9c8:7085515a:6a79bba9


---------------------------------------------------------------
 mdadm -D /dev/md3
---------------------------------------------------------------
/dev/md3:
        Version : 00.90.00
  Creation Time : Fri Feb 28 11:03:38 2003
     Raid Level : raid1
     Array Size : 1044160 (1019.69 MiB 1069.22 MB)
    Device Size : 1044160 (1019.69 MiB 1069.22 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 3
    Persistence : Superblock is persistent

    Update Time : Fri Apr 11 12:04:48 2003
          State : dirty, no-errors
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 1


    Number   Major   Minor   RaidDevice State
       0       0        0        0      faulty removed
       1       8       20        1      active sync   /dev/sdb4
           UUID : fcf84cfb:a2f9f586:fd748cdd:79ef7c22
---------------------------------------------------------------


At 11:13 11.04.03 +0200, Lars Marowsky-Bree wrote:
>On 2003-04-11T10:20:33,
>   Alfred Isele <Alfred.Isele@fujitsu-siemens.com> said:
>
>> After rebooting the resynch really starts.
>> Moreover sometimes after detaching (... -f ... -r ...)
>> I have either raid1d or mdrecoveryd=20
>> obviously looping uninterruptible on a CPU.=20
>
>Hrm. I've not had that happen to me, but it would be nice if you could
provide
>sysrq-t output would be helpful.
>
>What happens if you mdadm -S the array? What is the mdadm --detail status?
>
>
>Sincerely,
>    Lars Marowsky-Br=E9e <lmb@suse.de>
>
>--=20
>SuSE Labs - Research & Development, SuSE Linux AG
> =20
>"If anything can go wrong, it will." "Chance favors the prepared (mind)."
>  -- Capt. Edward A. Murphy            -- Louis Pasteur
>
--=====================_1050049835==_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="aries_stack_trace"

19377a19378,20097
 Apr 11 12:39:40 aries kernel: SysRq : Show State
 Apr 11 12:39:40 aries kernel: 
 Apr 11 12:39:40 aries kernel:                          free                =
        sibling
 Apr 11 12:39:40 aries kernel:   task             PC    stack   pid father=
 child younger older
 Apr 11 12:39:40 aries kernel: init          S F7FE8DA0  3232     1      0 =
 9372               (NOTLB)
 Apr 11 12:39:40 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [__pollwait+136/192] [process_timeout+0/16] [do_select+301/592]=
 [sys_select+846/1248]
 Apr 11 12:39:40 aries kernel: Call Trace:    [<c0130abd>] [<c0168ad8>]=
 [<c0130a50>] [<c0168d2d>] [<c01691ce>]
 Apr 11 12:39:40 aries kernel:   [sys_fstat64+73/128] [system_call+51/56]
 Apr 11 12:39:40 aries kernel:   [<c015f119>] [<c01095ef>]
 Apr 11 12:39:40 aries kernel: migration_CPU S F7F73FB0  6080     2      1  =
           3       (L-TLB)
 Apr 11 12:39:40 aries kernel: Call Trace:    [migration_thread+854/864]=
 [migration_thread+0/864] [rest_init+0/96] [kernel_thread+46/64]=
 [migration_thread+0/864]
 Apr 11 12:39:40 aries kernel: Call Trace:    [<c0123e26>] [<c0123ad0>]=
 [<c0105000>] [<c01075de>] [<c0123ad0>]
 Apr 11 12:39:40 aries kernel: migration_CPU S C02CAFD7  6068     3      1  =
           4     2 (L-TLB)
 Apr 11 12:39:40 aries kernel: Call Trace:    [vsprintf+39/48]=
 [migration_thread+854/864] [migration_thread+0/864] [rest_init+0/96]=
 [kernel_thread+46/64]
 Apr 11 12:39:40 aries kernel: Call Trace:    [<c02cafd7>] [<c0123e26>]=
 [<c0123ad0>] [<c0105000>] [<c01075de>]
 Apr 11 12:39:40 aries kernel:   [migration_thread+0/864]
 Apr 11 12:39:40 aries kernel:   [<c0123ad0>]
 Apr 11 12:39:40 aries kernel: keventd       S F7FE8620  5812     4      1  =
           5     3 (L-TLB)
 Apr 11 12:39:40 aries kernel: Call Trace:    [context_thread+321/512]=
 [ret_from_fork+6/32] [rest_init+0/96] [rest_init+0/96]=
 [kernel_thread+46/64]
 Apr 11 12:39:40 aries kernel: Call Trace:    [<c0136441>] [<c01095a2>]=
 [<c0105000>] [<c0105000>] [<c01075de>]
 Apr 11 12:39:40 aries kernel:   [context_thread+0/512]
 Apr 11 12:39:40 aries kernel:   [<c0136300>]
 Apr 11 12:39:40 aries kernel: ksoftirqd_CPU S C03AE9C0  5448     5      1  =
           6     4 (L-TLB)
 Apr 11 12:39:40 aries kernel: Call Trace:    [ksoftirqd+191/288]=
 [rest_init+0/96] [kernel_thread+46/64] [ksoftirqd+0/288]
 Apr 11 12:39:40 aries kernel: Call Trace:    [<c012c6bf>] [<c0105000>]=
 [<c01075de>] [<c012c600>]
 Apr 11 12:39:40 aries kernel: ksoftirqd_CPU S C03AE9C0  5448     6      1  =
           7     5 (L-TLB)
 Apr 11 12:39:40 aries kernel: Call Trace:    [ksoftirqd+191/288]=
 [rest_init+0/96] [kernel_thread+46/64] [ksoftirqd+0/288]
 Apr 11 12:39:40 aries kernel: Call Trace:    [<c012c6bf>] [<c0105000>]=
 [<c01075de>] [<c012c600>]
 Apr 11 12:39:40 aries kernel: kswapd        S 00000000  6356     7      1  =
           8     6 (L-TLB)
 Apr 11 12:39:40 aries kernel: Call Trace:    [kswapd+150/208]=
 [ret_from_fork+6/32] [rest_init+0/96] [kernel_thread+46/64] [kswapd+0/208]
 Apr 11 12:39:40 aries kernel: Call Trace:    [<c014add6>] [<c01095a2>]=
 [<c0105000>] [<c01075de>] [<c014ad40>]
 Apr 11 12:39:40 aries kernel: bdflush       S 00000000  6340     8      1  =
           9     7 (L-TLB)
 Apr 11 12:39:40 aries kernel: Call Trace:   =
 [interruptible_sleep_on+86/128] [bdflush+231/240] [rest_init+0/96]=
 [kernel_thread+46/64] [bdflush+0/240]
 Apr 11 12:39:40 aries kernel: Call Trace:    [<c0122846>] [<c015ad97>]=
 [<c0105000>] [<c01075de>] [<c015acb0>]
 Apr 11 12:39:40 aries kernel: kupdated      S F7FE8620  5340     9      1  =
          10     8 (L-TLB)
 Apr 11 12:39:40 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [process_timeout+0/16] [sync_old_buffers+60/176] [kupdate+163/320]=
 [rest_init+0/96]
 Apr 11 12:39:40 aries kernel: Call Trace:    [<c0130abd>] [<c0130a50>]=
 [<c015ab1c>] [<c015ae43>] [<c0105000>]
 Apr 11 12:39:40 aries kernel:   [rest_init+0/96] [kernel_thread+46/64]=
 [kupdate+0/320]
 Apr 11 12:39:40 aries kernel:   [<c0105000>] [<c01075de>] [<c015ada0>]
 Apr 11 12:39:40 aries kernel: kinoded       S 00000400  6112    10      1  =
          12     9 (L-TLB)
 Apr 11 12:39:40 aries kernel: Call Trace:    [kinoded+220/272]=
 [ret_from_fork+6/32] [rest_init+0/96] [rest_init+0/96]=
 [kernel_thread+46/64]
 Apr 11 12:39:40 aries kernel: Call Trace:    [<c01700dc>] [<c01095a2>]=
 [<c0105000>] [<c0105000>] [<c01075de>]
 Apr 11 12:39:40 aries kernel:   [kinoded+0/272]
 Apr 11 12:39:40 aries kernel:   [<c0170000>]
 Apr 11 12:39:40 aries kernel: mdrecoveryd   S D3EBAD40  4952    12      1  =
          15    10 (L-TLB)
 Apr 11 12:39:40 aries kernel: Call Trace:    [md_thread+439/480]=
 [do_exit+785/880] [ret_from_fork+6/32] [rest_init+0/96] [rest_init+0/96]
 Apr 11 12:39:40 aries kernel: Call Trace:    [<c0259f47>] [<c012a861>]=
 [<c01095a2>] [<c0105000>] [<c0105000>]
 Apr 11 12:39:40 aries kernel:   [kernel_thread+46/64] [md_thread+0/480]
 Apr 11 12:39:40 aries kernel:   [<c01075de>] [<c0259d90>]
 Apr 11 12:39:40 aries kernel: scsi_eh_0     S F7FE8E40  6100    15      1  =
          25    12 (L-TLB)
 Apr 11 12:39:40 aries kernel: Call Trace:    [__down_interruptible+154/256]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-915649792/=
96] [vsprintf+39/48]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-915649792/=
96] [__down_failed_interruptible+7/12]
 Apr 11 12:39:40 aries kernel: Call Trace:    [<c010808a>] [<c245db00>]=
 [<c02cafd7>] [<c245db00>] [<c0108157>]
 Apr 11 12:39:40 aries kernel:   [.text.lock.scsi_error+221/246]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-915649792/=
96] [kernel_thread+46/64] [scsi_error_handler+0/384]
 Apr 11 12:39:40 aries kernel:   [<c023a5c7>] [<c245db00>] [<c01075de>]=
 [<c023a150>]
 Apr 11 12:39:40 aries kernel: raid1d        S F7FB8818  4676    18      1  =
          26    19 (L-TLB)
 Apr 11 12:39:40 aries kernel: Call Trace:    [__run_task_queue+106/128]=
 [md_thread+439/480]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-911841348/=
96] [ret_from_fork+6/32] [kernel_thread+46/64]
 Apr 11 12:39:40 aries kernel: Call Trace:    [<c012c5ea>] [<c0259f47>]=
 [<c27ff7bc>] [<c01095a2>] [<c01075de>]
 Apr 11 12:39:40 aries kernel:   [md_thread+0/480]
 Apr 11 12:39:40 aries kernel:   [<c0259d90>]
 Apr 11 12:39:40 aries kernel: raid1syncd    S 00000000  5396    19      1  =
          18    20 (L-TLB)
 Apr 11 12:39:40 aries kernel: Call Trace:    [md_thread+439/480]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-911841341/=
96] [ret_from_fork+6/32] [kernel_thread+46/64] [md_thread+0/480]
 Apr 11 12:39:40 aries kernel: Call Trace:    [<c0259f47>] [<c27ff7c3>]=
 [<c01095a2>] [<c01075de>] [<c0259d90>]
 Apr 11 12:39:40 aries kernel: raid1d        R F714E4A0  5024    20      1  =
          19    22 (L-TLB)
 Apr 11 12:39:40 aries kernel: raid1d        S F7489218  5280    22      1  =
          20    23 (L-TLB)
 Apr 11 12:39:40 aries kernel: Call Trace:    [__run_task_queue+106/128]=
 [md_thread+439/480]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-911841348/=
96] [ret_from_fork+6/32] [kernel_thread+46/64]
 Apr 11 12:39:40 aries kernel: Call Trace:    [<c012c5ea>] [<c0259f47>]=
 [<c27ff7bc>] [<c01095a2>] [<c01075de>]
 Apr 11 12:39:40 aries kernel:   [md_thread+0/480]
 Apr 11 12:39:40 aries kernel:   [<c0259d90>]
 Apr 11 12:39:40 aries kernel: raid1syncd    S 00000000  5344    23      1  =
          22    24 (L-TLB)
 Apr 11 12:39:40 aries kernel: Call Trace:    [md_thread+439/480]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-911841341/=
96] [ret_from_fork+6/32] [kernel_thread+46/64] [md_thread+0/480]
 Apr 11 12:39:40 aries kernel: Call Trace:    [<c0259f47>] [<c27ff7c3>]=
 [<c01095a2>] [<c01075de>] [<c0259d90>]
 Apr 11 12:39:40 aries kernel: raid1d        S F7489218  5788    24      1  =
          23    25 (L-TLB)
 Apr 11 12:39:40 aries kernel: Call Trace:    [__run_task_queue+106/128]=
 [md_thread+439/480]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-911841348/=
96] [ret_from_fork+6/32] [kernel_thread+46/64]
 Apr 11 12:39:40 aries kernel: Call Trace:    [<c012c5ea>] [<c0259f47>]=
 [<c27ff7bc>] [<c01095a2>] [<c01075de>]
 Apr 11 12:39:40 aries kernel:   [md_thread+0/480]
 Apr 11 12:39:40 aries kernel:   [<c0259d90>]
 Apr 11 12:39:40 aries kernel: raid1syncd    S 00000000  5392    25      1  =
          24    15 (L-TLB)
 Apr 11 12:39:40 aries kernel: Call Trace:    [md_thread+439/480]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-911841341/=
96] [ret_from_fork+6/32] [kernel_thread+46/64] [md_thread+0/480]
 Apr 11 12:39:40 aries kernel: Call Trace:    [<c0259f47>] [<c27ff7c3>]=
 [<c01095a2>] [<c01075de>] [<c0259d90>]
 Apr 11 12:39:40 aries kernel: kreiserfsd    S F7FE8620  5260    26      1  =
         494    18 (L-TLB)
 Apr 11 12:39:40 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [process_timeout+0/16]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-915824012/=
96] [interruptible_sleep_on_timeout+87/128]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-915824008/=
96]
 Apr 11 12:39:40 aries kernel: Call Trace:    [<c0130abd>] [<c0130a50>]=
 [<c2433274>] [<c01228c7>] [<c2433278>]
 Apr 11 12:39:40 aries kernel:  =
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-915824008/=
96]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-915824000/=
96]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-915885384/=
96] [kernel_thread+46/64]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-915885840/=
96]
 Apr 11 12:39:40 aries kernel:   [<c2433278>] [<c2433280>] [<c24242b8>]=
 [<c01075de>] [<c24240f0>]
 Apr 11 12:39:40 aries kernel: cf            D F7FE8120  5436   457      1  =
         528   458 (L-TLB)
 Apr 11 12:39:40 aries kernel: Call Trace:    [__down+131/224]=
 [cf:ens_event_queue_event+0/24] [cf:ens_event_queue_event+8/24]=
 [__down_failed+8/12] [cf:OSD_defer_execution+150/224]
 Apr 11 12:39:40 aries kernel: Call Trace:    [<c0107f93>] [<f8e1a818>]=
 [<f8e1a820>]=20[<c010814c>] [<f8d9b67a>]
 Apr 11 12:39:40 aries kernel:   [cf:ens_event_queue_event+16/24]=
 [cf:ens_event_queue_event+16/24] [cf:ens_event_queue_event+0/24]=
 [cf:ens_event_queue+0/8] [cf:ens_event_daemon+0/124]=
 [cf:ens_select_msg+70/360]
 Apr 11 12:39:40 aries kernel:   [<f8e1a828>] [<f8e1a828>] [<f8e1a818>]=
 [<f8e1a720>] [<f8daa064>] [<f8daa126>]
 Apr 11 12:39:40 aries kernel:   [cf:ens_event_queue_event+0/24]=
 [cf:ens_eqlock+0/8] [vsprintf+39/48] [cf:ens_event_daemon+93/124]=
 [cf:grant_tab+29129/75744] [cf:ens_event_daemon+113/124]
 Apr 11 12:39:40 aries kernel:   [<f8e1a818>] [<f8e1a5e8>] [<c02cafd7>]=
 [<f8daa0c1>] [<f8e08d29>] [<f8daa0d5>]
 Apr 11 12:39:40 aries kernel:   [cf:__OSD_kthread+163/196]=
 [cf:grant_tab+29127/75744] [cf:OSD_log_event_lock+0/8]=
 [cf:OSD_log_event_lock+0/8] [kernel_thread+46/64] [cf:__OSD_kthread+0/196]
 Apr 11 12:39:40 aries kernel:   [<f8d9a407>] [<f8e08d27>] [<f8e1a6e0>]=
 [<f8e1a6e0>] [<c01075de>] [<f8d9a364>]
 Apr 11 12:39:40 aries kernel: cf            D F7FE8940  6132   458      1  =
         457   459 (L-TLB)
 Apr 11 12:39:40 aries kernel: Call Trace:    [__down+131/224]=
 [cf:ens_nd_queue_event+0/24] [cf:ens_nd_queue_event+8/24]=
 [__down_failed+8/12] [cf:OSD_defer_execution+150/224]
 Apr 11 12:39:40 aries kernel: Call Trace:    [<c0107f93>] [<f8e1a800>]=
 [<f8e1a808>] [<c010814c>] [<f8d9b67a>]
 Apr 11 12:39:40 aries kernel:   [cf:ens_nd_queue_event+16/24]=
 [cf:ens_nd_queue_event+16/24] [cf:ens_nd_queue_event+0/24]=
 [cf:ens_nd_daemon+0/480] [cf:ens_nd_daemon+70/480]=
 [cf:ens_nd_queue_event+0/24]
 Apr 11 12:39:40 aries kernel:   [<f8e1a810>] [<f8e1a810>] [<f8e1a800>]=
 [<f8daa248>] [<f8daa28e>] [<f8e1a800>]
 Apr 11 12:39:40 aries kernel:   [cf:ens_ndqlock+0/8]=
 [cf:grant_tab+29129/75744] [cf:__OSD_kthread+163/196]=
 [cf:grant_tab+29127/75744] [cf:OSD_log_event_lock+0/8]=
 [cf:OSD_log_event_lock+0/8]
 Apr 11 12:39:40 aries kernel:   [<f8e1a650>] [<f8e08d29>] [<f8d9a407>]=
 [<f8e08d27>] [<f8e1a6e0>] [<f8e1a6e0>]
 Apr 11 12:39:40 aries kernel:   [kernel_thread+46/64]=
 [cf:__OSD_kthread+0/196]
 Apr 11 12:39:40 aries kernel:   [<c01075de>] [<f8d9a364>]
 Apr 11 12:39:40 aries kernel: cf            D 00000010  5468   459      1  =
         458   460 (L-TLB)
 Apr 11 12:39:40 aries kernel: Call Trace:    [cf:MconnTraceF+420/432]=
 [__down+131/224] [cf:mrpc_req_queue_sleep+0/24]=
 [cf:mrpc_req_queue_sleep+8/24] [__down_failed+8/12]
 Apr 11 12:39:40 aries kernel: Call Trace:    [<f8dc77d0>] [<c0107f93>]=
 [<f8e1a890>] [<f8e1a898>] [<c010814c>]
 Apr 11 12:39:40 aries kernel:   [cf:OSD_defer_execution+150/224]=
 [cf:mrpc_req_queue_sleep+16/24] [cf:mrpc_req_queue_sleep+16/24]=
 [cf:mrpc_req_queue_sleep+0/24] [cf:mconntrace_lock+0/8]=
 [cf:MconnTraceF+93/432]
 Apr 11 12:39:40 aries kernel:   [<f8d9b67a>] [<f8e1a8a0>] [<f8e1a8a0>]=
 [<f8e1a890>] [<f8e1a5c8>] [<f8dc7689>]
 Apr 11 12:39:40 aries kernel:   [cf:mrpc_thread_service+0/368]=
 [cf:mrpc_thread_service+0/368] [cf:mrpc_thread_service+112/368]=
 [cf:mrpc_req_queue_sleep+0/24] [cf:mrpc_req_queue_mplock+0/8]=
 [cf:__OSD_kthread+163/196]
 Apr 11 12:39:40 aries kernel:   [<f8dd32c0>] [<f8dd32c0>] [<f8dd3330>]=
 [<f8e1a890>] [<f8e1a690>] [<f8d9a407>]
 Apr 11 12:39:40 aries kernel:   [cf:grant_tab+29127/75744]=
 [cf:mrpc_reply_inmsg_freelist+0/64] [cf:mrpc_request_inmsg_freelist+0/64]=
 [cf:mrpc_reply_inmsg_freelist+0/64] [cf:mrpc_request_inmsg_freelist+0/64]=
 [kernel_thread+46/64]
 Apr 11 12:39:40 aries kernel:   [<f8e08d27>] [<f8e1af80>] [<f8e1b1c0>]=
 [<f8e1af80>] [<f8e1b1c0>] [<c01075de>]
 Apr 11 12:39:40 aries kernel:   [cf:__OSD_kthread+0/196]=
 [cf:mrpc_reply_icfmsg_freelist+0/64]
 Apr 11 12:39:40 aries kernel:   [<f8d9a364>] [<f8e1b100>]
 Apr 11 12:39:40 aries kernel: cf            D 00000000  5664   460      1  =
         459   461 (L-TLB)
 Apr 11 12:39:40 aries kernel: Call Trace:    [__down+131/224]=
 [cf:sens_dqcv+0/24] [cf:sens_dqcv+8/24] [__down_failed+8/12]=
 [cf:OSD_defer_execution+150/224]
 Apr 11 12:39:40 aries kernel: Call Trace:    [<c0107f93>] [<f8e1a878>]=
 [<f8e1a880>] [<c010814c>] [<f8d9b67a>]
 Apr 11 12:39:41 aries kernel:   [cf:sens_dqcv+16/24] [cf:sens_dqcv+16/24]=
 [cf:sens_dqcv+0/24] [cf:sens_dqlock+0/8] [cf:sens_daemon+0/476]=
 [cf:usens_lock+0/8]
 Apr 11 12:39:41 aries kernel:   [<f8e1a888>] [<f8e1a888>] [<f8e1a878>]=
 [<f8e1a570>] [<f8dbb884>] [<f8e1a600>]
 Apr 11 12:39:41 aries kernel:   [cf:sens_daemon+0/476]=
 [cf:sens_daemon+114/476] [cf:sens_dqcv+0/24] [cf:sens_dqlock+0/8]=
 [cf:grant_tab+29129/75744] [cf:__OSD_kthread+163/196]
 Apr 11 12:39:41 aries kernel:   [<f8dbb884>] [<f8dbb8f6>] [<f8e1a878>]=
 [<f8e1a570>] [<f8e08d29>] [<f8d9a407>]
 Apr 11 12:39:41 aries kernel:   [cf:grant_tab+29127/75744]=
 [kernel_thread+46/64] [cf:__OSD_kthread+0/196]
 Apr 11 12:39:41 aries kernel:   [<f8e08d27>] [<c01075de>] [<f8d9a364>]
 Apr 11 12:39:41 aries kernel: cf            D F7129F00  4352   461      1  =
         460   462 (L-TLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [__down+131/224]=
 [cf:JoinEventOpen+12/64] [cf:JoinEventDaemon+20/64]=
 [cf:JoinEventDaemon+28/64] [__down_failed+8/12]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0107f93>] [<f8e1ad0c>]=
 [<f8e1af14>] [<f8e1af1c>] [<c010814c>]
 Apr 11 12:39:41 aries kernel:   [cf:OSD_defer_execution+150/224]=
 [cf:JoinEventDaemon+36/64] [cf:JoinEventDaemon+36/64]=
 [cf:JoinEventDaemon+20/64] [cf:__insmod_cf_S.rodata_L77792+19040/48768]=
 [cf:MconnTraceF+420/432]
 Apr 11 12:39:41 aries kernel:   [<f8d9b67a>] [<f8e1af24>] [<f8e1af24>]=
 [<f8e1af14>] [<f8dfa740>] [<f8dc77d0>]
 Apr 11 12:39:41 aries kernel:   [cf:mconntrace_lock+0/8]=
 [cf:MconnTraceF+93/432] [cf:JoinEventDaemon+12/64]=
 [cf:JoinEventDaemon+20/64] [cf:JoinEventDaemon+0/64]=
 [cf:OSD_event_wait_timeout+53/88]
 Apr 11 12:39:41 aries kernel:   [<f8e1a5c8>] [<f8dc7689>] [<f8e1af0c>]=
 [<f8e1af14>] [<f8e1af00>] [<f8d9a32d>]
 Apr 11 12:39:41 aries kernel:   [cf:JoinEventDaemon+20/64]=
 [cf:JoinEventDaemon+12/64] [cf:__insmod_cf_S.rodata_L77792+19040/48768]=
 [cf:JoinDaemon+0/756] [cf:JoinDaemon+127/756] [cf:JoinEventDaemon+0/64]
 Apr 11 12:39:41 aries kernel:   [<f8e1af14>] [<f8e1af0c>] [<f8dfa740>]=
 [<f8dbf1b4>] [<f8dbf233>] [<f8e1af00>]
 Apr 11 12:39:41 aries kernel:   [cf:JoinDaemon+621/756]=
 [cf:grant_tab+29129/75744] [cf:__OSD_kthread+163/196]=
 [cf:grant_tab+29127/75744] [cf:clustername+0/32] [cf:clustername+0/32]
 Apr 11 12:39:41 aries kernel:   [<f8dbf421>] [<f8e08d29>] [<f8d9a407>]=
 [<f8e08d27>] [<f8e1a9e0>] [<f8e1a9e0>]
 Apr 11 12:39:41 aries kernel:   [kernel_thread+46/64]=
 [cf:__OSD_kthread+0/196]
 Apr 11 12:39:41 aries kernel:   [<c01075de>] [<f8d9a364>]
 Apr 11 12:39:41 aries kernel: cf            D F7129BE0  6088   462      1  =
         461   463 (L-TLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [__down+131/224]=
 [cf:qsm_daemon_sync+0/24] [cf:qsm_daemon_sync+8/24] [__down_failed+8/12]=
 [cf:OSD_defer_execution+150/224]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0107f93>] [<f8e1a8d8>]=
 [<f8e1a8e0>] [<c010814c>] [<f8d9b67a>]
 Apr 11 12:39:41 aries kernel:   [cf:OSD_defer_execution+176/224]=
 [cf:qsm_daemon_sync+16/24] [cf:qsm_daemon_sync+16/24]=
 [cf:qsm_daemon_sync+0/24] [cf:qsm_daemon+0/160] [cf:qsm_daemon+151/160]
 Apr 11 12:39:41 aries kernel:   [<f8d9b694>] [<f8e1a8e8>] [<f8e1a8e8>]=
 [<f8e1a8d8>] [<f8dbac7c>] [<f8dbad13>]
 Apr 11 12:39:41 aries kernel:   [cf:qsm_daemon_sync+0/24] [cf:qsm_lock+0/8]=
 [cf:__OSD_kthread+163/196] [cf:grant_tab+29127/75744] [kernel_thread+46/64]=
 [cf:__OSD_kthread+0/196]
 Apr 11 12:39:41 aries kernel:   [<f8e1a8d8>] [<f8e1a5f8>] [<f8d9a407>]=
 [<f8e08d27>] [<c01075de>] [<f8d9a364>]
 Apr 11 12:39:41 aries kernel:   [cf:qsm_user_method_tab+56/704]
 Apr 11 12:39:41 aries kernel:   [<f8e1c6b8>]
 Apr 11 12:39:41 aries kernel: cf            D F7FE8940  6132   463      1  =
         462   464 (L-TLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [__down+131/224]=
 [cf:clm_icf_glob+8/96] [cf:clm_icf_glob+16/96] [__down_failed+8/12]=
 [cf:OSD_defer_execution+150/224]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0107f93>] [<f8e1b408>]=
 [<f8e1b410>] [<c010814c>] [<f8d9b67a>]
 Apr 11 12:39:41 aries kernel:   [cf:clm_icf_glob+24/96]=
 [cf:clm_icf_glob+24/96] [cf:clm_icf_glob+8/96]=
 [cf:clm_icf_cmplt_daemon+0/356] [cf:clm_icf_cmplt_daemon+77/356]=
 [cf:clm_icf_glob+8/96]
 Apr 11 12:39:41 aries kernel:   [<f8e1b418>] [<f8e1b418>] [<f8e1b408>]=
 [<f8db023c>] [<f8db0289>] [<f8e1b408>]
 Apr 11 12:39:41 aries kernel:   [cf:clm_icf_glob+32/96]=
 [cf:grant_tab+29129/75744] [cf:__OSD_kthread+163/196]=
 [cf:grant_tab+29127/75744] [kernel_thread+46/64] [cf:__OSD_kthread+0/196]
 Apr 11 12:39:41 aries kernel:   [<f8e1b420>] [<f8e08d29>] [<f8d9a407>]=
 [<f8e08d27>] [<c01075de>] [<f8d9a364>]
 Apr 11 12:39:41 aries kernel: cf            D F8E22F58  4856   464      1  =
         463   466 (L-TLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [cf:lkm+3512/4544]=
 [cf:MconnTraceF+420/432] [cf:mconntrace_lock+0/8] [__down+131/224]=
 [cf:__insmod_cf_S.rodata_L77792+37686/48768]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<f8e22f58>] [<f8dc77d0>]=
 [<f8e1a5c8>] [<c0107f93>] [<f8dff016>]
 Apr 11 12:39:41 aries kernel:   [cf:lkm+3716/4544] [cf:lkm+3724/4544]=
 [__down_failed+8/12] [cf:OSD_defer_execution+150/224] [cf:lkm+3732/4544]=
 [cf:lkm+3732/4544]
 Apr 11 12:39:41 aries kernel:   [<f8e23024>] [<f8e2302c>] [<c010814c>]=
 [<f8d9b67a>] [<f8e23034>] [<f8e23034>]
 Apr 11 12:39:41 aries kernel:   [cf:lkm+3716/4544] [cf:mconntrace_lock+0/8]=
 [cf:MconnTraceF+93/432] [cf:lk_config_daemon+0/548]=
 [cf:lk_config_daemon+0/548] [cf:lk_config_daemon+163/548]
 Apr 11 12:39:41 aries kernel:   [<f8e23024>] [<f8e1a5c8>] [<f8dc7689>]=
 [<f8ddc368>] [<f8ddc368>] [<f8ddc40b>]
 Apr 11 12:39:41 aries kernel:   [cf:lkm+3716/4544] [cf:lkm+3708/4544]=
 [cf:__OSD_kthread+163/196] [cf:grant_tab+29127/75744] [cf:lkm+244/4544]=
 [cf:lkm+244/4544]
 Apr 11 12:39:41 aries kernel:   [<f8e23024>] [<f8e2301c>] [<f8d9a407>]=
 [<f8e08d27>] [<f8e22294>] [<f8e22294>]
 Apr 11 12:39:41 aries kernel:   [kernel_thread+46/64]=
 [cf:__OSD_kthread+0/196]
 Apr 11 12:39:41 aries kernel:   [<c01075de>] [<f8d9a364>]
 Apr 11 12:39:41 aries kernel: cf            D F7FE8620  5900   466      1 =
=20         464   467 (L-TLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [__down+131/224]=
 [call_do_IRQ+5/13] [cf:lkm+3528/4544] [cf:lkm+3536/4544]=
 [__down_failed+8/12]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0107f93>] [<c010e2d8>]=
 [<f8e22f68>] [<f8e22f70>] [<c010814c>]
 Apr 11 12:39:41 aries kernel:   [cf:OSD_defer_execution+150/224]=
 [cf:lkm+3544/4544] [cf:lkm+3544/4544] [cf:lkm+3528/4544]=
 [cf:MconnTraceF+93/432] [cf:lk_icf_send_daemon+91/496]
 Apr 11 12:39:41 aries kernel:   [<f8d9b67a>] [<f8e22f78>] [<f8e22f78>]=
 [<f8e22f68>] [<f8dc7689>] [<f8de0d4b>]
 Apr 11 12:39:41 aries kernel:   [cf:lkm+3528/4544] [cf:lkm+3520/4544]=
 [cf:lk_icf_send_daemon+0/496] [cf:__OSD_kthread+163/196]=
 [cf:grant_tab+29127/75744] [cf:lkm+244/4544]
 Apr 11 12:39:41 aries kernel:   [<f8e22f68>] [<f8e22f60>] [<f8de0cf0>]=
 [<f8d9a407>] [<f8e08d27>] [<f8e22294>]
 Apr 11 12:39:41 aries kernel:   [cf:lkm+244/4544] [kernel_thread+46/64]=
 [cf:__OSD_kthread+0/196]
 Apr 11 12:39:41 aries kernel:   [<f8e22294>] [<c01075de>] [<f8d9a364>]
 Apr 11 12:39:41 aries kernel: cf            D F7FE8940  5992   467      1  =
         466   494 (L-TLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [__down+131/224]=
 [cf:cfngca+32/128] [cf:cfngca+40/128] [__down_failed+8/12]=
 [cf:OSD_defer_execution+150/224]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0107f93>] [<f8e1b480>]=
 [<f8e1b488>] [<c010814c>] [<f8d9b67a>]
 Apr 11 12:39:41 aries kernel:   [cf:cfngca+48/128] [cf:cfngca+48/128]=
 [cf:cfngca+32/128] [cf:mconntrace_lock+0/8] [cf:MconnTraceF+93/432]=
 [cf:cfngca+72/128]
 Apr 11 12:39:41 aries kernel:   [<f8e1b490>] [<f8e1b490>] [<f8e1b480>]=
 [<f8e1a5c8>] [<f8dc7689>] [<f8e1b4a8>]
 Apr 11 12:39:41 aries kernel:   [cf:cfngca+72/128] [cf:ng_eventd+802/948]=
 [cf:cfngca+32/128] [cf:cfngca+84/128] [cf:ng_eventd+0/948]=
 [cf:ng_eventd+0/948]
 Apr 11 12:39:41 aries kernel:   [<f8e1b4a8>] [<f8da5696>] [<f8e1b480>]=
 [<f8e1b4b4>] [<f8da5374>] [<f8da5374>]
 Apr 11 12:39:41 aries kernel:   [vsprintf+39/48] [cf:grant_tab+29129/75744]=
 [cf:__OSD_kthread+163/196] [cf:grant_tab+29127/75744] [kernel_thread+46/64]=
 [cf:__OSD_kthread+0/196]
 Apr 11 12:39:41 aries kernel:   [<c02cafd7>] [<f8e08d29>] [<f8d9a407>]=
 [<f8e08d27>] [<c01075de>] [<f8d9a364>]
 Apr 11 12:39:41 aries kernel:  =
 [cf:__insmod_cf_S.rodata_L77792+4805/48768]
 Apr 11 12:39:41 aries kernel:   [<f8df6fa5>]
 Apr 11 12:39:41 aries kernel: cf            D C2A8E5DC  5052   494      1  =
         467    26 (L-TLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [__down+131/224]=
 [cf:carp_sync+20/64] [cf:carp_sync+28/64] [__down_failed+8/12]=
 [cf:OSD_defer_execution+150/224]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0107f93>] [<f8e1b0d4>]=
 [<f8e1b0dc>] [<c010814c>] [<f8d9b67a>]
 Apr 11 12:39:41 aries kernel:   [cf:carp_sync+36/64] [cf:carp_sync+36/64]=
 [cf:carp_sync+20/64] [cf:ens_notify+1178/1356] [cf:carp_sync+12/64]=
 [cf:carp_sync+20/64]
 Apr 11 12:39:41 aries kernel:   [<f8e1b0e4>] [<f8e1b0e4>] [<f8e1b0d4>]=
 [<f8da8dd6>] [<f8e1b0cc>] [<f8e1b0d4>]
 Apr 11 12:39:41 aries kernel:   [cf:carp_sync+0/64]=
 [cf:OSD_event_wait_timeout+53/88] [cf:carp_sync+20/64] [cf:carp_sync+12/64]=
 [cf:carp_sync+12/64] [cf:carp_icf_ffun+64/360]
 Apr 11 12:39:41 aries kernel:   [<f8e1b0c0>] [<f8d9a32d>] [<f8e1b0d4>]=
 [<f8e1b0cc>] [<f8e1b0cc>] [<f8df4834>]
 Apr 11 12:39:41 aries kernel:   [cf:carp_icf_ffun+97/360]=
 [cf:carp_sync+0/64] [vsprintf+39/48] [cf:grant_tab+29129/75744]=
 [cf:__OSD_kthread+163/196] [cf:grant_tab+29127/75744]
 Apr 11 12:39:41 aries kernel:   [<f8df4855>] [<f8e1b0c0>] [<c02cafd7>]=
 [<f8e08d29>] [<f8d9a407>] [<f8e08d27>]
 Apr 11 12:39:41 aries kernel:   [cf:cip_usrs+3185/3616]=
 [cf:cip_usrs+3164/3616] [cf:cip_usrs+3185/3616] [cf:cip_usrs+3164/3616]=
 [kernel_thread+46/64] [cf:__OSD_kthread+0/196]
 Apr 11 12:39:41 aries kernel:   [<f8e210f1>] [<f8e210dc>] [<f8e210f1>]=
 [<f8e210dc>] [<c01075de>] [<f8d9a364>]
 Apr 11 12:39:41 aries kernel: cfregd        S 00000076  4692   528      1  =
         749   457 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [__up_wakeup+8/12]=
 [__down_interruptible+154/256] [cf:nsi_free+17/64]=
 [__down_failed_interruptible+7/12] [cf:OSD_defer_execution+140/224]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0108170>] [<c010808a>]=
 [<f8dd3fe9>] [<c0108157>] [<f8d9b670>]
 Apr 11 12:39:41 aries kernel:   [cf:cfreg_end_daemon_trans+47/76]=
 [cf:cddi_receive_event+0/660] [cf:uev_ioctl+466/556] [cf:cf_ioctl+158/236]=
 [sys_ioctl+240/720] [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<f8da111b>] [<f8d9f2e0>] [<f8dc4dda>]=
 [<f8d9e45a>] [<c0167c20>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: wvAgent       S C270B160  4944   749      1  =
 763     780   528 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [__pollwait+136/192]=
 [schedule_timeout+173/176] [do_pollfd+91/160] [do_poll+198/288]=
 [sys_poll+370/768]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0168ad8>] [<c0130b0d>]=
 [<c01693bb>] [<c01694c6>] [<c0169692>]
 Apr 11 12:39:41 aries kernel:   [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c01095ef>]
 Apr 11 12:39:41 aries kernel: wvAgent       S F7FE8760  4452   763    749  =
                   (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [process_timeout+0/16] [do_poll+198/288] [sys_poll+370/768]=
 [sys_time+31/112]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130abd>] [<c0130a50>]=
 [<c01694c6>] [<c0169692>] [<c012b77f>]
 Apr 11 12:39:41 aries kernel:   [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c01095ef>]
 Apr 11 12:39:41 aries kernel: klogd         R F7FE8D00  4452   780      1  =
         786   749 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [do_syslog+362/1008]=
 [sock_write+174/192] [sys_read+151/320] [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c012670a>] [<c025c0ce>]=
 [<c0155407>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: wvcnfd        S F7FE8C60  4452   786      1  =
         787   780 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-915908947/=
96] [wait_for_connect+455/512] [tcp_accept+325/608] [inet_accept+53/480]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c241e6ad>]=
 [<c02880a7>] [<c0288225>] [<c02a4f95>]
 Apr 11 12:39:41 aries kernel:   [sys_accept+134/320]=
 [rb_insert_color+210/240] [__vma_link+86/208] [__insert_vm_struct+116/144]=
 [do_munmap+681/736] [sys_socketcall+217/624]
 Apr 11 12:39:41 aries kernel:   [<c025cc76>] [<c02cb782>] [<c013dee6>]=
 [<c013f5d4>] [<c013f099>] [<c025d8c9>]
 Apr 11 12:39:41 aries kernel:   [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c01095ef>]
 Apr 11 12:39:41 aries kernel: syslogd       S F7129F00  4272   787      1  =
         881   786 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [datagram_poll+46/218] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c026299e>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: portmap       S F7129BE0  5080   881      1  =
         912   787 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [do_pollfd+91/160] [do_poll+198/288] [sys_poll+370/768]=
 [sys_munmap+83/160]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c01693bb>]=
 [<c01694c6>] [<c0169692>] [<c013f123>]
 Apr 11 12:39:41 aries kernel:   [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c01095ef>]
 Apr 11 12:39:41 aries kernel: slde          S F7FE8260  4452   912      1  =
         961   881 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [unix_poll+46/160] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c02b39ce>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: rpc.statd     S C014C263  4384   961      1  =
         986   912 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [__alloc_pages+35/192]=
 [schedule_timeout+173/176] [tcp_poll+54/400] [do_select+301/592]=
 [sys_select+846/1248]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c014c263>] [<c0130b0d>]=
 [<c0283566>] [<c0168d2d>] [<c01691ce>]
 Apr 11 12:39:41 aries kernel:   [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c01095ef>]
 Apr 11 12:39:41 aries kernel: sshd          S C03231A0  4452   986      1  =
        1054   961 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [tcp_poll+54/400] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c0283566>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: ypbind        S C3253040  5204  1054      1 =
 1055    1260   986 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [do_pollfd+91/160] [do_poll+198/288] [sys_poll+370/768]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c01693bb>]=
 [<c01694c6>] [<c0169692>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: ypbind        S 000001F0  5676  1055   1054 =
 1057               (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [process_timeout+0/16] [do_poll+198/288] [sys_poll+370/768]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130abd>] [<c0130a50>]=
 [<c01694c6>] [<c0169692>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: ypbind        S F7FE8EE0  4904  1056   1055  =
        1057       (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [sys_rt_sigsuspend+235/272]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c010848b>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: ypbind        S F7FE8EE0  3908  1057   1055  =
              1056 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [process_timeout+0/16] [do_gettimeofday+34/128] [sys_nanosleep+227/528]=
 [sys_rt_sigprocmask+305/448]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130abd>] [<c0130a50>] [<c0=
10ff52>] [<c0130c03>] [<c01324d1>]
 Apr 11 12:39:41 aries kernel:   [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c01095ef>]
 Apr 11 12:39:41 aries kernel: nfsd          S 00000100  4792  1257      1  =
        1261  1258 (L-TLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [lockd+0/720]=
 [schedule_timeout+173/176] [svc_recv+782/1120] [.text.lock.svc+83/127]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-892177576/=
96]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c01b1df0>] [<c0130b0d>]=
 [<c02be3be>] [<c01b23a4>] [<c3ac0358>]
 Apr 11 12:39:41 aries kernel:   [ret_from_fork+6/32]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-892103648/=
96] [kernel_thread+46/64]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-892177920/=
96]
 Apr 11 12:39:41 aries kernel:   [<c01095a2>] [<c3ad2420>] [<c01075de>]=
 [<c3ac0200>]
 Apr 11 12:39:41 aries kernel: nfsd          S C039A980  6180  1258      1  =
        1257  1259 (L-TLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [svc_recv+782/1120] [__down+201/224] [.text.lock.svc+63/127]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-892177576/=
96]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c02be3be>]=
 [<c0107fd9>] [<c01b2390>] [<c3ac0358>]
 Apr 11 12:39:41 aries kernel:   [ret_from_fork+6/32] [kernel_thread+46/64]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-892177920/=
96]
 Apr 11 12:39:41 aries kernel:   [<c01095a2>] [<c01075de>] [<c3ac0200>]
 Apr 11 12:39:41 aries kernel: nfsd          S C039A980  6180  1259      1  =
        1258  1260 (L-TLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [svc_recv+782/1120] [__down+201/224] [.text.lock.svc+63/127]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-892177576/=
96]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c02be3be>]=
 [<c0107fd9>] [<c01b2390>] [<c3ac0358>]
 Apr 11 12:39:41 aries kernel:   [ret_from_fork+6/32] [kernel_thread+46/64]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-892177920/=
96]
 Apr 11 12:39:41 aries kernel:   [<c01095a2>] [<c01075de>] [<c3ac0200>]
 Apr 11 12:39:41 aries kernel: nfsd          S 00000000  6120  1260      1  =
        1259  1054 (L-TLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [schedule+402/784] [svc_recv+782/1120] [__down+201/224]=
 [.text.lock.svc+63/127]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c01222f2>]=
 [<c02be3be>] [<c0107fd9>] [<c01b2390>]
 Apr 11 12:39:41 aries kernel:  =
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-892177576/=
96] [ret_from_fork+6/32]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-892103648/=
96] [kernel_thread+46/64]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-892177920/=
96]
 Apr 11 12:39:41 aries kernel:   [<c3ac0358>] [<c01095a2>] [<c3ad2420>]=
 [<c01075de>] [<c3ac0200>]
 Apr 11 12:39:41 aries kernel: lockd         S C3A7E000  6120  1261      1 =
 1262    1265  1257 (L-TLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [schedule+402/784] [svc_recv+782/1120] [reschedule+5/12]=
 [rpciod_up+94/240]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c01222f2>]=
 [<c02be3be>] [<c010969d>] [<c02ba44e>]
 Apr 11 12:39:41 aries kernel:   [lockd+368/720] [kernel_thread+46/64]=
 [lockd+0/720]
 Apr 11 12:39:41 aries kernel:   [<c01b1f60>] [<c01075de>] [<c01b1df0>]
 Apr 11 12:39:41 aries kernel: rpciod        S F7FE8120  5312  1262   1261  =
                   (L-TLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [rpciod+460/576]=
 [kernel_thread+46/64] [rpciod+0/576]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c02ba2bc>] [<c01075de>]=
 [<c02ba0f0>]
 Apr 11 12:39:41 aries kernel: rpc.mountd    S F71296E0  6000  1265      1  =
        1318  1261 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [do_pollfd+91/160] [do_poll+198/288] [sys_poll+370/768]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c01693bb>]=
 [<c01694c6>] [<c0169692>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: master        S F7129D20  3908  1318      1 =
 9448    1340  1265 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [process_timeout+0/16] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130abd>] [<c0130a50>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: qmgr          S F71298C0  3908  1328   1318  =
        9448       (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [__pollwait+136/192] [process_timeout+0/16] [do_select+301/592]=
 [sys_select+846/1248]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130abd>] [<c0168ad8>]=
 [<c0130a50>] [<c0168d2d>] [<c01691ce>]
 Apr 11 12:39:41 aries kernel:   [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c01095ef>]
 Apr 11 12:39:41 aries kernel: ntpd          S F7FE88A0  4420  1340      1  =
        1352  1318 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [datagram_poll+46/218] [do_select+301/592] [sys_select+846/1248]=
 [restore_sigcontext+296/320]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c026299e>]=
 [<c0168d2d>] [<c01691ce>] [<c0108738>]
 Apr 11 12:39:41 aries kernel:   [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c01095ef>]
 Apr 11 12:39:41 aries kernel: RtpSolidD     S F7FE89E0  3908  1352      1 =
 1353    1363  1340 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [process_timeout+0/16] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130abd>] [<c0130a50>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: RtpSolidD     S F7FE89E0  5340  1353   1352 =
 1359               (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [process_timeout+0/16] [do_poll+198/288] [sys_poll+370/768]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130abd>] [<c0130a50>]=
 [<c01694c6>] [<c0169692>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: RtpSolidD     S 000000A9  4756  1354   1353  =
        1355       (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [generic_file_write+155/208] [process_timeout+0/16]=
 [do_gettimeofday+34/128] [sys_nanosleep+227/528]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130abd>] [<c014399b>]=
 [<c0130a50>] [<c010ff52>] [<c0130c03>]
 Apr 11 12:39:41 aries kernel:   [sys_gettimeofday+59/128]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c012b8ab>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: RtpSolidD     S F7FE89E0  5500  1355   1353  =
        1357  1354 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [process_timeout+0/16] [wake_up_process+22/32] [do_gettimeofday+34/128]=
 [sys_nanosleep+227/528]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130abd>] [<c0130a50>]=
 [<c01214e6>] [<c010ff52>] [<c0130c03>]
 Apr 11 12:39:41 aries kernel:   [sys_gettimeofday+59/128]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c012b8ab>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: RtpSolidD     S F7FE89E0  4648  1357   1353  =
        1358  1355 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [process_timeout+0/16] [do_gettimeofday+34/128] [sys_nanosleep+227/528]=
 [sys_gettimeofday+59/128]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130abd>] [<c0130a50>]=
 [<c010ff52>] [<c0130c03>] [<c012b8ab>]
 Apr 11 12:39:41 aries kernel:   [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c01095ef>]
 Apr 11 12:39:41 aries kernel: RtpSolidD     S C0168D53  4760  1358   1353  =
        1359  1357 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [do_select+339/592]=
 [schedule_timeout+93/176] [process_timeout+0/16] [do_gettimeofday+34/128]=
 [sys_nanosleep+227/528]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0168d53>] [<c0130abd>]=
 [<c0130a50>] [<c010ff52>] [<c0130c03>]
 Apr 11 12:39:41 aries kernel:   [sys_gettimeofday+59/128]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c012b8ab>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: RtpSolidD     S F7FE89E0  4676  1359   1353  =
              1358 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [tcp_transmit_skb+711/1120] [tcp_data_wait+391/448]=
 [tcp_write_xmit+499/640] [tcp_recvmsg+1488/2576]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c0290377>]=
 [<c0286337>] [<c0290fa3>] [<c0286bb0>]
 Apr 11 12:39:41 aries kernel:   [inet_recvmsg+78/112] [sock_recvmsg+88/240]=
 [sockfd_lookup+28/128] [sys_recvfrom+178/288] [switch_mm+150/336]=
 [schedule+402/784]
 Apr 11 12:39:41 aries kernel:   [<c02a521e>] [<c025bed8>] [<c025bc1c>]=
 [<c025d132>] [<c0124006>] [<c01222f2>]
 Apr 11 12:39:41 aries kernel:   [sys_recv+55/64] [sys_socketcall+360/624]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c025d1d7>] [<c025d958>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: solfe         S C3FE2000  4400  1363      1 =
 1373    1376  1352 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [sys_rt_sigsuspend+235/272]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c010848b>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: solfe         S F7129500  5688  1373   1363 =
 1471               (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [process_timeout+0/16] [do_poll+198/288] [sys_poll+370/768]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130abd>] [<c0130a50>]=
 [<c01694c6>] [<c0169692>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: solfe         S C240E3C9  4944  1374   1373  =
        1452       (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:   =
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-915975223/=
96] [sys_rt_sigsuspend+235/272] [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c240e3c9>] [<c010848b>]=
 [<c01095ef>]
 Apr 11 12:39:41 aries kernel: kdm           S F7FE8800  3908  1376      1 =
 1459    1393  1363 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [__pollwait+136/192] [pipe_poll+55/128] [do_select+301/592]=
 [sys_select+846/1248]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c0168ad8>]=
 [<c0161497>] [<c0168d2d>] [<c01691ce>]
 Apr 11 12:39:41 aries kernel:   [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c01095ef>]
 Apr 11 12:39:41 aries kernel: atd           S 00009876  4904  1393      1  =
        1409  1376 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [vfs_readdir+168/272] [process_timeout+0/16] [do_gettimeofday+34/128]=
 [sys_nanosleep+227/528]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130abd>] [<c0167f68>]=
 [<c0130a50>] [<c010ff52>] [<c0130c03>]
 Apr 11 12:39:41 aries kernel:   [sys_rt_sigprocmask+305/448]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c01324d1>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: X             S F71293C0  3908  1408   1376  =
        1459       (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [unix_poll+46/160] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c02b39ce>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: cron          S F7129320  4232  1409      1  =
        1427  1393 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [process_timeout+0/16] [do_gettimeofday+34/128] [sys_nanosleep+227/528]=
 [sys_rt_sigprocmask+102/448]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130abd>] [<c0130a50>]=
 [<c010ff52>] [<c0130c03>] [<c0132406>]
 Apr 11 12:39:41 aries kernel:   [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c01095ef>]
 Apr 11 12:39:41 aries kernel: nscd          S F7129280  4452  1427      1 =
 1429    1442  1409 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [wait_for_packet+307/384] [skb_recv_datagram+141/240] [unix_accept+123/352]=
 [sys_accept+134/320]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c0262013>]=
 [<c02620ed>] [<c02b257b>] [<c025cc76>]
 Apr 11 12:39:41 aries kernel:   [schedule_timeout+103/176]=
 [do_pollfd+91/160] [do_poll+271/288] [poll_freewait+68/80]=
 [sys_socketcall+217/624] [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c0130ac7>] [<c01693bb>] [<c016950f>]=
 [<c0168a44>] [<c025d8c9>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: nscd          S F7129280  5296  1429   1427 =
 1434               (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [process_timeout+0/16] [do_poll+198/288] [sys_poll+370/768]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130abd>] [<c0130a50>]=
 [<c01694c6>] [<c0169692>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: nscd          S F7129280  3908  1430   1429  =
        1431       (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [vsnprintf+519/1104] [wait_for_packet+307/384] [skb_recv_datagram+141/240]=
 [unix_accept+123/352]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c02cad37>]=
 [<c0262013>] [<c02620ed>] [<c02b257b>]
 Apr 11 12:39:41 aries kernel:   [sys_accept+134/320]=
 [schedule_timeout+103/176] [do_pollfd+91/160] [do_poll+271/288]=
 [poll_freewait+68/80] [sys_socketcall+217/624]
 Apr 11 12:39:41 aries kernel:   [<c025cc76>] [<c0130ac7>] [<c01693bb>]=
 [<c016950f>] [<c0168a44>] [<c025d8c9>]
 Apr 11 12:39:41 aries kernel:   [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c01095ef>]
 Apr 11 12:39:41 aries kernel: nscd          S F7129280  5000  1431   1429  =
        1432  1430 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [do_pollfd+91/160] [do_poll+198/288] [sys_poll+370/768]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c01693bb>]=
 [<c01694c6>] [<c0169692>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: nscd          S F7129280  5420  1432   1429  =
        1433  1431 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [do_pollfd+91/160] [do_poll+198/288] [sys_poll+370/768]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c01693bb>]=
 [<c01694c6>] [<c0169692>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: nscd          S F7129280  5576  1433   1429  =
        1434  1432 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-907705743/=
96] [wait_for_packet+307/384] [skb_recv_datagram+141/240]=
 [unix_accept+123/352]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c2bf1271>]=
 [<c0262013>] [<c02620ed>] [<c02b257b>]
 Apr 11 12:39:41 aries kernel:   [sys_accept+134/320]=
 [schedule_timeout+173/176] [do_pollfd+91/160] [poll_freewait+68/80]=
 [sys_socketcall+217/624] [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c025cc76>] [<c0130b0d>] [<c01693bb>]=
 [<c0168a44>] [<c025d8c9>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: nscd          S F7129280  5576  1434   1429  =
              1433 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [do_pollfd+91/160] [do_poll+198/288] [sys_poll+370/768]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c01693bb>]=
 [<c01694c6>] [<c0169692>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: inetd         S C3E46E80  4452  1442      1 =
 6988    1472  1427 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [tcp_poll+54/400] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c0283566>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: solfe         S F7129500  4248  1452   1373  =
        1468  1374 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [process_timeout+0/16] [do_gettimeofday+34/128] [sys_nanosleep+227/528]=
 [sys_gettimeofday+59/128]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130abd>] [<c0130a50>]=
 [<c010ff52>] [<c0130c03>] [<c012b8ab>]
 Apr 11 12:39:41 aries kernel:   [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c01095ef>]
 Apr 11 12:39:41 aries kernel: kdm           S C3E46C00  4264  1459   1376 =
 9286          1408 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [sys_wait4+298/1056]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c012aa2a>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: solfe         S F7129500  5004  1468   1373  =
        1470  1452 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [tcp_poll+54/400] [process_timeout+0/16] [do_select+301/592]=
 [sys_select+846/1248]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130abd>] [<c0283566>]=
 [<c0130a50>] [<c0168d2d>] [<c01691ce>]
 Apr 11 12:39:41 aries kernel:   [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c01095ef>]
 Apr 11 12:39:41 aries kernel: solfe         S F7129500  4580  1470   1373  =
        1471  1468 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [process_timeout+0/16] [do_gettimeofday+34/128] [sys_nanosleep+227/528]=
 [sys_gettimeofday+59/128]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130abd>] [<c0130a50>]=
 [<c010ff52>] [<c0130c03>] [<c012b8ab>]
 Apr 11 12:39:41 aries kernel:   [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c01095ef>]
 Apr 11 12:39:41 aries kernel: solfe         S 00000000  4560  1471   1373  =
              1470 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [sys_socketcall+327/624]=
 [sys_rt_sigsuspend+235/272] [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c025d937>] [<c010848b>]=
 [<c01095ef>]
 Apr 11 12:39:41 aries kernel: snmpdm        S C3E46CA0  4264  1472      1 =
 3317    1486  1442 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [unix_poll+46/160] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c02b39ce>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: mib2agt       S C014C263  4940  1486      1  =
        1489  1472 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [__alloc_pages+35/192]=
 [schedule_timeout+173/176] [unix_poll+46/160] [do_select+301/592]=
 [sys_select+846/1248]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c014c263>] [<c0130b0d>]=
 [<c02b39ce>] [<c0168d2d>] [<c01691ce>]
 Apr 11 12:39:41 aries kernel:   [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c01095ef>]
 Apr 11 12:39:41 aries kernel: naaagt        S C014C263  3908  1489      1  =
        1496  1486 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [__alloc_pages+35/192]=
 [schedule_timeout+173/176] [unix_poll+46/160] [do_select+301/592]=
 [sys_select+846/1248]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c014c263>] [<c0130b0d>]=
 [<c02b39ce>] [<c0168d2d>] [<c01691ce>]
 Apr 11 12:39:41 aries kernel:   [sys_open+162/192] [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c01546f2>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: login         S F71295A0  4384  1496      1 =
 9258    1497  1489 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [sys_wait4+298/1056]=
 [sys_rt_sigaction+160/192] [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c012aa2a>] [<c0132ff0>]=
 [<c01095ef>]
 Apr 11 12:39:41 aries kernel: login         S C3E46F20  4384  1497      1 =
 9375    1498  1496 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [sys_wait4+298/1056]=
 [sys_rt_sigaction+160/192] [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c012aa2a>] [<c0132ff0>]=
 [<c01095ef>]
 Apr 11 12:39:41 aries kernel: mingetty      S C3E06000  4384  1498      1  =
        1499  1497 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176] [co=
n_flush_chars+96/144] [write_chan+370/560] [read_chan+689/1728]=
 [tty_read+276/320]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c01f48a0>]=
 [<c01e65d2>] [<c01e6051>] [<c01e1cd4>]
 Apr 11 12:39:41 aries kernel:   [sys_read+151/320] [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c0155407>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: mingetty      S C3E46D40  4384  1499      1  =
        1500  1498 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [con_flush_chars+96/144] [write_chan+370/560] [read_chan+689/1728]=
 [tty_read+276/320]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c01f48a0>]=
 [<c01e65d2>] [<c01e6051>] [<c01e1cd4>]
 Apr 11 12:39:41 aries kernel:   [sys_read+151/320] [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c0155407>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: mingetty      S F71290A0  4384  1500      1  =
        1501  1499 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [con_flush_chars+96/144] [write_chan+370/560] [read_chan+689/1728]=
 [tty_read+276/320]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c01f48a0>]=
 [<c01e65d2>] [<c01e6051>] [<c01e1cd4>]
 Apr 11 12:39:41 aries kernel:   [sys_read+151/320] [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c0155407>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: mingetty      S C3E46AC0  3908  1501      1  =
        1502  1500 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [con_flush_chars+96/144] [write_chan+370/560] [read_chan+689/1728]=
 [tty_read+276/320]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c01f48a0>]=
 [<c01e65d2>] [<c01e6051>] [<c01e1cd4>]
 Apr 11 12:39:41 aries kernel:   [sys_read+151/320] [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c0155407>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: rcsd_monitor  S C3E46A20  4612  1502      1  =
        6804  1501 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [process_timeout+0/16] [do_gettimeofday+34/128] [sys_nanosleep+227/528]=
 [sys_rt_sigprocmask+102/448]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130abd>] [<c0130a50>]=
 [<c010ff52>] [<c0130c03>] [<c0132406>]
 Apr 11 12:39:41 aries kernel:   [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c01095ef>]
 Apr 11 12:39:41 aries kernel: in.rlogind    S 00000246  3908  1546   1442 =
 1547    2382       (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [tty_poll+133/160] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c01e2f05>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: login         S F7129140  3908  1547   1546 =
 1548               (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [sys_wait4+298/1056]=
 [sys_rt_sigaction+160/192] [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c012aa2a>] [<c0132ff0>]=
 [<c01095ef>]
 Apr 11 12:39:41 aries kernel: bash          S C3E46840  4660  1548   1547  =
                   (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [write_chan+370/560] [read_chan+689/1728] [tty_read+276/320]=
 [sys_read+151/320]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c01e65d2>]=
 [<c01e6051>] [<c01e1cd4>] [<c0155407>]
 Apr 11 12:39:41 aries kernel:   [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c01095ef>]
 Apr 11 12:39:41 aries kernel: in.rlogind    S 00000246  4788  2382   1442 =
 2383    3861  1546 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [tty_poll+133/160] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c01e2f05>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: login         S C4A32000  4392  2383   2382 =
 2384               (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [sys_wait4+298/1056]=
 [sys_rt_sigaction+160/192] [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c012aa2a>] [<c0132ff0>]=
 [<c01095ef>]
 Apr 11 12:39:41 aries kernel: bash          S C4A1EAD4  5036  2384   2383  =
                   (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [write_chan+370/560] [read_chan+689/1728] [tty_read+276/320]=
 [sys_read+151/320]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c01e65d2>]=
 [<c01e6051>] [<c01e1cd4>] [<c0155407>]
 Apr 11 12:39:41 aries kernel:   [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c01095ef>]
 Apr 11 12:39:41 aries kernel: snmpdm        S C3E46CA0  5672  3317   1472 =
 3318               (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [process_timeout+0/16] [do_poll+198/288] [sys_poll+370/768]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130abd>] [<c0130a50>]=
 [<c01694c6>] [<c0169692>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: snmpdm        S C3E46CA0  5256  3318   3317  =
                   (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [sys_rt_sigsuspend+235/272]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c010848b>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: in.rlogind    S 00000246  2384  3861   1442 =
 3862    6988  2382 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [tty_poll+133/160] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c01e2f05>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: login         S D43BA000  4384  3862   3861 =
 3863               (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [sys_wait4+298/1056]=
 [sys_rt_sigaction+160/192] [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c012aa2a>] [<c0132ff0>]=
 [<c01095ef>]
 Apr 11 12:39:41 aries kernel: bash          S D36E7B40  2384  3863   3862 =
 9449               (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [sys_wait4+298/1056]=
 [tty_check_change+68/160] [do_fork+1440/2272] [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c012aa2a>] [<c01e14c4>]=
 [<c0125690>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: httpd         S C560ACC0  2384  6804      1 =
 7100    7059  1502 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [process_timeout+0/16] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130abd>] [<c0130a50>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: httpd         S C3E462A0  4208  6805   6804  =
        6806       (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [sys_semop+834/1328]=
 [tcp_v4_send_check+77/224] [tcp_transmit_skb+711/1120]=
 [tcp_reset_xmit_timer+125/240] [tcp_write_xmit+599/640]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c01bd142>] [<c0295afd>]=
 [<c0290377>] [<c0292b2d>] [<c0291007>]
 Apr 11 12:39:41 aries kernel:   [alloc_skb+196/480] [tcp_send_fin+333/528]=
 [tcp_close+1696/2032]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-907705743/=
96] [clear_inode+16/304] [__kfree_skb+262/368]
 Apr 11 12:39:41 aries kernel:   [<c025fb84>] [<c0291cfd>] [<c02879e0>]=
 [<c2bf1271>] [<c016efd0>] [<c025ff36>]
 Apr 11 12:39:41 aries kernel:   [sys_rt_sigaction+160/192] [sys_ipc+77/576]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c0132ff0>] [<c01109ed>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: httpd         S C03231A0     0  6806   6804  =
        6807  6805 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [tcp_poll+54/400] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0130b0d>] [<c0283566>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: httpd         S 00001000  2384  6807   6804  =
        6826  6806 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [sys_semop+834/1328]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-907705743/=
96] [__kfree_skb+262/368] [net_tx_action+87/320] [sk_free+87/144]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c01bd142>] [<c2bf1271>]=
 [<c025ff36>] [<c0264a67>] [<c025e927>]
 Apr 11 12:39:41 aries kernel:   [tcp_close+813/2032] [inet_recvmsg+78/112]=
 [sock_recvmsg+88/240] [clear_inode+16/304] [destroy_inode+48/64]=
 [dentry_iput+79/160]
 Apr 11 12:39:41 aries kernel:   [<c028766d>] [<c02a521e>] [<c025bed8>]=
 [<c016efd0>] [<c016e700>] [<c016d07f>]
 Apr 11 12:39:41 aries kernel:   [sys_rt_sigaction+160/192] [sys_ipc+77/576]=
 [sys_close+102/128] [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c0132ff0>] [<c01109ed>] [<c0154876>]=
 [<c01095ef>]
 Apr 11 12:39:41 aries kernel: httpd         S C560AF40     0  6826   6804  =
        6827  6807 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [sys_semop+834/1328]=
 [ip_finish_output2+162/272] [ip_output+104/176] [ip_queue_xmit2+363/480]=
 [ip_queue_xmit+528/768]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c01bd142>] [<c0280de2>]=
 [<c027f958>] [<c0280fbb>] [<c027fbb0>]
 Apr 11 12:39:41 aries kernel:   [__kfree_skb+262/368]=
 [tcp_recvmsg+1064/2576] [tcp_v4_send_check+77/224]=
 [tcp_v4_destroy_sock+27/368] [zap_pte_range+742/885] [tcp_close+813/2032]
 Apr 11 12:39:41 aries kernel:   [<c025ff36>] [<c0286a08>] [<c0295afd>]=
 [<c02975db>] [<c013da46>] [<c028766d>]
 Apr 11 12:39:41 aries kernel:   [dput+48/320] [do_munmap+681/736]=
 [sys_ipc+77/576] [sys_munmap+83/160] [system_call+51/56]
 Apr 11 12:39:41 aries kernel:   [<c016d100>] [<c013f099>] [<c01109ed>]=
 [<c013f123>] [<c01095ef>]
 Apr 11 12:39:41 aries kernel: httpd         S C25E1000  4208  6827   6804  =
        6828  6826 (NOTLB)
 Apr 11 12:39:41 aries kernel: Call Trace:    [ip_finish_output2+162/272]=
 [sys_semop+834/1328] [ip_finish_output2+162/272] [ip_output+104/176]=
 [tcp_reset_xmit_timer+125/240]
 Apr 11 12:39:41 aries kernel: Call Trace:    [<c0280de2>] [<c01bd142>] [<c0=
280de2>] [<c027f958>] [<c0292b2d>]
 Apr 11 12:39:41 aries kernel:   [ip_queue_xmit2+363/480]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-907705743/=
96] [__kfree_skb+262/368] [tcp_v4_destroy_sock+27/368] [sk_free+87/144]=
 [tcp_close+813/2032]
 Apr 11 12:39:42 aries kernel:   [<c0280fbb>] [<c2bf1271>] [<c025ff36>]=
 [<c02975db>] [<c025e927>] [<c028766d>]
 Apr 11 12:39:42 aries kernel:   [net_tx_action+87/320] [clear_inode+16/304]=
 [destroy_inode+48/64] [dentry_iput+79/160] [sys_rt_sigaction+160/192]=
 [sys_ipc+77/576]
 Apr 11 12:39:42 aries kernel:   [<c0264a67>] [<c016efd0>] [<c016e700>]=
 [<c016d07f>] [<c0132ff0>] [<c01109ed>]
 Apr 11 12:39:42 aries kernel:   [sys_close+102/128] [system_call+51/56]
 Apr 11 12:39:42 aries kernel:   [<c0154876>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: httpd         S 00001000  4208  6828   6804  =
        7100  6827 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [sys_semop+834/1328]=
 [cf:__insmod_cf_O/opt/SMAW/SMAWcf/modules/SuSE7.2-smp_optim/cf_+-907705743/=
96] [__kfree_skb+262/368] [net_tx_action+87/320] [do_IRQ+251/304]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c01bd142>] [<c2bf1271>]=
 [<c025ff36>] [<c0264a67>] [<c010b66b>]
 Apr 11 12:39:42 aries kernel:   [call_do_IRQ+5/13]=
 [tcp_v4_destroy_sock+27/368] [sk_free+87/144] [tcp_close+813/2032]=
 [inet_recvmsg+78/112] [sock_recvmsg+88/240]
 Apr 11 12:39:42 aries kernel:   [<c010e2d8>] [<c02975db>] [<c025e927>]=
 [<c028766d>] [<c02a521e>] [<c025bed8>]
 Apr 11 12:39:42 aries kernel:   [clear_inode+16/304] [destroy_inode+48/64]=
 [dentry_iput+79/160] [sys_rt_sigaction+160/192] [sys_ipc+77/576]=
 [sys_close+102/128]
 Apr 11 12:39:42 aries kernel:   [<c016efd0>] [<c016e700>] [<c016d07f>]=
 [<c0132ff0>] [<c01109ed>] [<c0154876>]
 Apr 11 12:39:42 aries kernel:   [system_call+51/56]
 Apr 11 12:39:42 aries kernel:   [<c01095ef>]
 Apr 11 12:39:42 aries kernel: in.rlogind    S 00000246     0  6988   1442 =
 6989          3861 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [tty_poll+133/160] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130b0d>] [<c01e2f05>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: login         S C61A7260  4384  6989   6988 =
 6990               (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [sys_wait4+298/1056]=
 [sys_rt_sigaction+160/192] [system_call+51/56]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c012aa2a>] [<c0132ff0>]=
 [<c01095ef>]
 Apr 11 12:39:42 aries kernel: bash          S C4DFE694     0  6990   6989  =
                   (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [write_chan+370/560] [read_chan+689/1728] [tty_read+276/320]=
 [sys_read+151/320]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130b0d>] [<c01e65d2>]=
 [<c01e6051>] [<c01e1cd4>] [<c0155407>]
 Apr 11 12:39:42 aries kernel:   [system_call+51/56]
 Apr 11 12:39:42 aries kernel:   [<c01095ef>]
 Apr 11 12:39:42 aries kernel: RtpJavaStarte S F7129460  4692  7059      1 =
 7060    9302  6804 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [vsnprintf+519/1104] [wait_for_connect+455/512] [tcp_accept+325/608]=
 [inet_accept+53/480]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130b0d>] [<c02cad37>]=
 [<c02880a7>] [<c0288225>] [<c02a4f95>]
 Apr 11 12:39:42 aries kernel:   [sys_accept+134/320]=
 [kill_something_info+217/448] [sys_kill+87/96] [schedule+402/784]=
 [sys_socketcall+217/624] [math_state_restore+30/64]
 Apr 11 12:39:42 aries kernel:   [<c025cc76>] [<c0131fd9>] [<c0132907>]=
 [<c01222f2>] [<c025d8c9>] [<c010abee>]
 Apr 11 12:39:42 aries kernel:   [system_call+51/56]
 Apr 11 12:39:42 aries kernel:   [<c01095ef>]
 Apr 11 12:39:42 aries kernel: RtpJavaStarte S F7129460  2384  7060   7059 =
 7080               (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [process_timeout+0/16] [do_poll+198/288] [sys_poll+370/768]=
 [system_call+51/56]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130abd>] [<c0130a50>]=
 [<c01694c6>] [<c0169692>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: RtpJavaStarte S F7129460     0  7061   7060  =
        7062       (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [__kfree_skb+262/368] [process_timeout+0/16] [do_gettimeofday+34/128]=
 [sys_nanosleep+227/528]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130abd>] [<c025ff36>]=
 [<c0130a50>] [<c010ff52>] [<c0130c03>]
 Apr 11 12:39:42 aries kernel:   [sys_gettimeofday+59/128]=
 [system_call+51/56]
 Apr 11 12:39:42 aries kernel:   [<c012b8ab>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: RtpJavaStarte S F7129460    16  7062   7060  =
        7063  7061 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [sys_rt_sigsuspend+235/272]=
 [system_call+51/56]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c010848b>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: RtpJavaStarte S F7129460  2452  7063   7060  =
        7064  7062 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [sys_rt_sigsuspend+235/272]=
 [system_call+51/56]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c010848b>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: RtpJavaStarte S F7129460   396  7064   7060  =
        7065  7063 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [process_timeout+0/16] [do_gettimeofday+34/128] [sys_nanosleep+227/528]=
 [sys_gettimeofday+59/128]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130abd>] [<c0130a50>]=
 [<c010ff52>] [<c0130c03>] [<c012b8ab>]
 Apr 11 12:39:42 aries kernel:   [system_call+51/56]
 Apr 11 12:39:42 aries kernel:   [<c01095ef>]
 Apr 11 12:39:42 aries kernel: RtpJavaStarte S 00000000     0  7065   7060  =
        7066  7064 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [restore_sigcontext+296/320]=
 [sys_rt_sigsuspend+235/272] [system_call+51/56]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0108738>] [<c010848b>]=
 [<c01095ef>]
 Apr 11 12:39:42 aries kernel: RtpJavaStarte S 4AAD2000     4  7066   7060  =
        7067  7065 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [sys_rt_sigsuspend+235/272]=
 [system_call+51/56]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c010848b>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: RtpJavaStarte S F7129460     0  7067   7060  =
        7068  7066 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [sys_rt_sigsuspend+235/272]=
 [system_call+51/56]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c010848b>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: RtpJavaStarte S C014567C  5988  7068   7060  =
        7080  7067 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [change_protection+236/256]=
 [schedule_timeout+93/176] [mprotect_fixup+176/640] [process_timeout+0/16]=
 [do_gettimeofday+34/128]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c014567c>] [<c0130abd>]=
 [<c0145740>] [<c0130a50>] [<c010ff52>]
 Apr 11 12:39:42 aries kernel:   [sys_nanosleep+227/528]=
 [sys_gettimeofday+59/128] [system_call+51/56]
 Apr 11 12:39:42 aries kernel:   [<c0130c03>] [<c012b8ab>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: RtpJavaStarte S 00000000     0  7080   7060  =
              7068 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [sys_socketcall+360/624]=
 [sys_rt_sigsuspend+235/272] [system_call+51/56]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c025d958>] [<c010848b>]=
 [<c01095ef>]
 Apr 11 12:39:42 aries kernel: httpd         S C25F1000  4916  7100   6804  =
              6828 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [qdisc_restart+22/432]=
 [sys_semop+834/1328] [tcp_v4_send_check+77/224] [tcp_transmit_skb+711/1120]=
 [tcp_reset_xmit_timer+125/240]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c026fcf6>] [<c01bd142>]=
 [<c0295afd>] [<c0290377>] [<c0292b2d>]
 Apr 11 12:39:42 aries kernel:   [tcp_write_xmit+599/640]=
 [alloc_skb+196/480] [tcp_send_fin+333/528] [tcp_close+1696/2032]=
 [do_signal+501/688] [clear_inode+16/304]
 Apr 11 12:39:42 aries kernel:   [<c0291007>] [<c025fb84>] [<c0291cfd>]=
 [<c02879e0>] [<c0109305>] [<c016efd0>]
 Apr 11 12:39:42 aries kernel:   [destroy_inode+48/64] [dentry_iput+79/160]=
 [sys_rt_sigaction+160/192] [sys_ipc+77/576] [system_call+51/56]
 Apr 11 12:39:42 aries kernel:   [<c016e700>] [<c016d07f>] [<c0132ff0>]=
 [<c01109ed>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: bash          S F7FE8B20  3908  9258   1496  =
                   (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [set_cursor+123/160] [con_flush_chars+96/144] [write_chan+370/560]=
 [read_chan+689/1728]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130b0d>] [<c01f06fb>]=
 [<c01f48a0>] [<c01e65d2>] [<c01e6051>]
 Apr 11 12:39:42 aries kernel:   [tty_read+276/320] [sys_read+151/320]=
 [system_call+51/56]
 Apr 11 12:39:42 aries kernel:   [<c01e1cd4>] [<c0155407>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: kde           S C3E46980  3908  9286   1459 =
 9347               (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [sys_wait4+298/1056]=
 [sys_rt_sigaction+160/192] [system_call+51/56]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c012aa2a>] [<c0132ff0>]=
 [<c01095ef>]
 Apr 11 12:39:42 aries kernel: medusa-idled  S D3EBACA0    36  9302      1  =
        9328  7059 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [process_timeout+0/16] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130abd>] [<c0130a50>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: kdeinit       S D3EBAE80     8  9325      1 =
 9423    9349  9346 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [unix_poll+46/160] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130b0d>] [<c02b39ce>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: kdeinit       S F7129820     0  9328      1  =
        9331  9302 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [unix_poll+46/160] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130b0d>] [<c02b39ce>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: kdeinit       S C3E46340  2384  9331      1  =
        9333  9328 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [unix_poll+46/160] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130b0d>] [<c02b39ce>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: kdeinit       S C560A7C0     0  9333      1  =
        9346  9331 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [__pollwait+136/192] [process_timeout+0/16] [do_select+301/592]=
 [sys_select+846/1248]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130abd>] [<c0168ad8>]=
 [<c0130a50>] [<c0168d2d>] [<c01691ce>]
 Apr 11 12:39:42 aries kernel:   [system_call+51/56]
 Apr 11 12:39:42 aries kernel:   [<c01095ef>]
 Apr 11 12:39:42 aries kernel: artsd         S C44407C0     0  9341   9325  =
        9350       (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [__alloc_pages+35/192]=
 [schedule_timeout+93/176] [process_timeout+0/16] [do_select+301/592]=
 [sys_select+846/1248]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c014c263>] [<c0130abd>]=
 [<c0130a50>] [<c0168d2d>] [<c01691ce>]
 Apr 11 12:39:42 aries kernel:   [restore_sigcontext+296/320]=
 [system_call+51/56]
 Apr 11 12:39:42 aries kernel:   [<c0108738>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: kdeinit       S D36E7320  3908  9346      1  =
        9325  9333 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [__pollwait+136/192] [pipe_poll+55/128] [do_select+301/592]=
 [sys_select+846/1248]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130b0d>] [<c0168ad8>]=
 [<c0161497>] [<c0168d2d>] [<c01691ce>]
 Apr 11 12:39:42 aries kernel:   [system_call+51/56]
 Apr 11 12:39:42 aries kernel:   [<c01095ef>]
 Apr 11 12:39:42 aries kernel: kwrapper      S 00000003  3652  9347   9286  =
                   (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [sys_kill+87/96]=
 [schedule_timeout+93/176] [cf:carp_timerid+4/64] [process_timeout+0/16]=
 [do_gettimeofday+34/128]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0132907>] [<c0130abd>]=
 [<f8e1aa04>] [<c0130a50>] [<c010ff52>]
 Apr 11 12:39:42 aries kernel:   [sys_nanosleep+227/528]=
 [sys_rt_sigprocmask+102/448] [system_call+51/56]
 Apr 11 12:39:42 aries kernel:   [<c0130c03>] [<c0132406>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: kdeinit       S D3EBAD40  2384  9349      1  =
        9353  9325 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [unix_poll+46/160] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130b0d>] [<c02b39ce>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: kdeinit       S C3E460C0    44  9350   9325 =
 9351    9423  9341 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [unix_poll+46/160] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130b0d>] [<c02b39ce>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: xconsole      S F7FE8120     0  9351   9350  =
                   (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [__pollwait+136/192] [pipe_poll+55/128] [do_select+301/592]=
 [sys_select+846/1248]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130b0d>] [<c0168ad8>]=
 [<c0161497>] [<c0168d2d>] [<c01691ce>]
 Apr 11 12:39:42 aries kernel:   [system_call+51/56]
 Apr 11 12:39:42 aries kernel:   [<c01095ef>]
 Apr 11 12:39:42 aries kernel: kdeinit       S C560AB80     4  9353      1  =
        9355  9349 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [tty_poll+133/160] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130b0d>] [<c01e2f05>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: kdeinit       S F7129640     0  9355      1  =
        9358  9353 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [__pollwait+136/192] [process_timeout+0/16] [do_select+301/592]=
 [sys_select+846/1248]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130abd>] [<c0168ad8>]=
 [<c0130a50>] [<c0168d2d>] [<c01691ce>]
 Apr 11 12:39:42 aries kernel:   [system_call+51/56]
 Apr 11 12:39:42 aries kernel:   [<c01095ef>]
 Apr 11 12:39:42 aries kernel: kdeinit       S C014C263     0  9358      1 =
 9365    9367  9355 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [__alloc_pages+35/192]=
 [schedule_timeout+173/176] [__pollwait+136/192] [pipe_poll+55/128]=
 [do_select+301/592]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c014c263>] [<c0130b0d>]=
 [<c0168ad8>] [<c0161497>] [<c0168d2d>]
 Apr 11 12:39:42 aries kernel:   [sys_select+846/1248] [system_call+51/56]
 Apr 11 12:39:42 aries kernel:   [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: appletproxy   S C3E467A0     0  9360   9358  =
        9361       (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [unix_poll+46/160] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130b0d>] [<c02b39ce>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: appletproxy   S C560A860     0  9361   9358  =
        9362  9360 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [unix_poll+46/160] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130b0d>] [<c02b39ce>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: appletproxy   S F7FE8620     0  9362   9358  =
        9363  9361 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [process_timeout+0/16] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130abd>] [<c0130a50>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: appletproxy   S D36E76E0     0  9363   9358  =
        9364  9362 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [unix_poll+46/160] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130b0d>] [<c02b39ce>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: appletproxy   S F7FE8300    32  9364   9358  =
        9365  9363 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [unix_poll+46/160] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130b0d>] [<c02b39ce>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: appletproxy   S C3E46700  4660  9365   9358  =
              9364 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [process_timeout+0/16] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130abd>] [<c0130a50>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: kdeinit       S F7129780  4420  9367      1  =
        9372  9358 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [__pollwait+136/192] [process_timeout+0/16] [do_select+301/592]=
 [sys_select+846/1248]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130abd>] [<c0168ad8>]=
 [<c0130a50>] [<c0168d2d>] [<c01691ce>]
 Apr 11 12:39:42 aries kernel:   [system_call+51/56]
 Apr 11 12:39:42 aries kernel:   [<c01095ef>]
 Apr 11 12:39:42 aries kernel: kdeinit       S C3E46520  2388  9372      1  =
              9367 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [__pollwait+136/192] [pipe_poll+55/128] [do_select+301/592]=
 [sys_select+846/1248]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130b0d>] [<c0168ad8>]=
 [<c0161497>] [<c0168d2d>] [<c01691ce>]
 Apr 11 12:39:42 aries kernel:   [system_call+51/56]
 Apr 11 12:39:42 aries kernel:   [<c01095ef>]
 Apr 11 12:39:42 aries kernel: bash          S F7F8FA00     0  9375   1497  =
                   (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [vgacon_cursor+249/512]=
 [schedule_timeout+173/176] [set_cursor+123/160] [con_flush_chars+96/144]=
 [write_chan+370/560]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0246259>] [<c0130b0d>]=
 [<c01f06fb>] [<c01f48a0>] [<c01e65d2>]
 Apr 11 12:39:42 aries kernel:   [read_chan+689/1728] [tty_read+276/320]=
 [sys_read+151/320] [system_call+51/56]
 Apr 11 12:39:42 aries kernel:   [<c01e6051>] [<c01e1cd4>] [<c0155407>]=
 [<c01095ef>]
 Apr 11 12:39:42 aries kernel: kdeinit       S D36E75A0     8  9423   9325 =
 9432          9350 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [tty_poll+133/160] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130b0d>] [<c01e2f05>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: bash          S C560A220  2384  9425   9423 =
 9431    9432       (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [sys_wait4+298/1056]=
 [tty_check_change+68/160] [do_fork+1440/2272] [system_call+51/56]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c012aa2a>] [<c01e14c4>]=
 [<c0125690>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: vi            S C61A7DA0  4788  9431   9425  =
                   (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [tty_poll+133/160] [do_select+301/592] [sys_select+846/1248]=
 [system_call+51/56]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130b0d>] [<c01e2f05>]=
 [<c0168d2d>] [<c01691ce>] [<c01095ef>]
 Apr 11 12:39:42 aries kernel: bash          S D36E78C0     4  9432   9423  =
              9425 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [write_chan+370/560] [read_chan+689/1728] [tty_read+276/320]=
 [sys_read+151/320]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130b0d>] [<c01e65d2>]=
 [<c01e6051>] [<c01e1cd4>] [<c0155407>]
 Apr 11 12:39:42 aries kernel:   [system_call+51/56]
 Apr 11 12:39:42 aries kernel:   [<c01095ef>]
 Apr 11 12:39:42 aries kernel: pickup        S C560AAE0     0  9448   1318  =
              1328 (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+93/176]=
 [__pollwait+136/192] [process_timeout+0/16] [do_select+301/592]=
 [sys_select+846/1248]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130abd>] [<c0168ad8>]=
 [<c0130a50>] [<c0168d2d>] [<c01691ce>]
 Apr 11 12:39:42 aries kernel:   [system_call+51/56]
 Apr 11 12:39:42 aries kernel:   [<c01095ef>]
 Apr 11 12:39:42 aries kernel: su            S F7129B40  3908  9449   3863 =
 9450               (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [sys_wait4+298/1056]=
 [sys_rt_sigaction+130/192] [system_call+51/56]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c012aa2a>] [<c0132fd2>]=
 [<c01095ef>]
 Apr 11 12:39:42 aries kernel: bash          S C560A400   580  9450   9449  =
                   (NOTLB)
 Apr 11 12:39:42 aries kernel: Call Trace:    [schedule_timeout+173/176]=
 [write_chan+370/560] [read_chan+689/1728] [tty_read+276/320]=
 [sys_read+151/320]
 Apr 11 12:39:42 aries kernel: Call Trace:    [<c0130b0d>] [<c01e65d2>]=
 [<c01e6051>] [<c01e1cd4>] [<c0155407>]
 Apr 11 12:39:42 aries kernel:   [system_call+51/56]
 Apr 11 12:39:42 aries kernel:   [<c01095ef>]
 Apr 11 12:40:00 aries /USR/SBIN/CRON[9468]: (root) CMD ( /usr/lib/sa/sa1   =
   ) 

--=====================_1050049835==_
Content-Type: text/plain; charset="us-ascii"



--=====================_1050049835==_--

