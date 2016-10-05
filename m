From: Francisco Parada <advanceandconquer@gmail.com>
Subject: Re: RAID6 - CPU At 100% Usage After Reassembly
Date: Wed, 5 Oct 2016 07:12:59 -0400
Message-ID: <CAOW94uuALbxOpfb5Rgzp=Fgvy8zfKt94zCcgs7T=U-m8jWGq3g@mail.gmail.com>
References: <CAOW94ut0uHS8+k0jutOT9bfT__WLbbOJmQC2CFa15HVVe9L4fg@mail.gmail.com>
 <CADEsfxrKeSv5dRNfBoyybHaemPSqCcamTmSZ4P+Yey-rLd8hEg@mail.gmail.com>
 <CAOW94uv4zSGs+6be3zhcQaGZdiAgg-s4ZHZ=mszcURo6pqJyqA@mail.gmail.com>
 <CAOW94ute6CZafnAC6AVauqUGsEgVrnO3B27Gn3eVzdWFBJPCQw@mail.gmail.com>
 <CAOW94utnY1zCR7gUCx1K0p2YfDhi3tXTsE6J_mT6rNz1TuTZEQ@mail.gmail.com>
 <20160913174352.GA43576@kernel.org> <CAOW94us2=5F8BbLhQSN_mC0wghZA8Z6qFQHBP5Y1csJuQ4pfKg@mail.gmail.com>
 <CAOW94utVBcLz191ifzKkjn+nsSthPWDAQF8R-PabcS2uPareag@mail.gmail.com>
 <CAOW94usC2AFt4uGRZRidcXN1Gii0PqSqfGAjL6_2Y1m6GAcZsg@mail.gmail.com> <CAOW94uvFaiL9FO=k=gOsGzH0q1Qhw4X3n7ZFURj9_eTgGa656g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOW94uvFaiL9FO=k=gOsGzH0q1Qhw4X3n7ZFURj9_eTgGa656g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

Just wanted to send one last ping on this.  I didn't hear back and
really don't know where else to turn to before abandoning hope.
Should I just start wiping the drives so I can start from scratch at
this point?

I rebuilt the kernel with debug patch that Shaohua provided and I sent
the list the output of the trace.  Does any one have any other
suggestions?

Thank you once again,
Cisco


On Fri, Sep 30, 2016 at 9:06 AM, Francisco Parada
<advanceandconquer@gmail.com> wrote:
> Hello Shaohua and all,
>
> Was anyone able to take a look at the trace I provided?  Curious if I
> should just give up hope and start from scratch.  Any feedback is
> appreciated.
>
> Thank you,
> Cisco
>
> On Mon, Sep 26, 2016 at 10:29 AM, Francisco Parada
> <advanceandconquer@gmail.com> wrote:
>> Hi all,
>>
>> It doesn't seem like my response from last night, made it to the list:
>>
>>
>> Hi Shaohua and all,
>>
>> I was finally able to upgrade my Ubuntu server to a newer version of
>> the kernel and mdadm:
>> ==========================
>> $ uname -r; mdadm -V
>>
>> 4.8.0-rc7-custom
>>
>> mdadm - v3.4 - 28th January 2016
>> ==========================
>>
>>
>> I rebuilt the kernel with the options that Shaohua asked me to build it with:
>> ======================================
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 5883ef0..db484ca 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -62,6 +62,9 @@
>>  #include "raid0.h"
>>  #include "bitmap.h"
>>
>> +#undef pr_debug
>> +#define pr_debug trace_printk
>> +
>>  #define cpu_to_group(cpu) cpu_to_node(cpu)
>>  #define ANY_GROUP NUMA_NO_NODE
>> ======================================
>>
>>
>> Here's how things look so far, nothing different yet:
>> ======================================
>> $ cat /proc/mdstat
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>> [raid4] [raid10]
>> md127 : inactive sdd[10](S) sdk[0](S) sdj[2](S) sdh[3](S) sde[11](S)
>> sdg[9](S) sdf[7](S) sdb[13](S) sdc[12](S)
>>       26371219608 blocks super 1.2
>>
>> unused devices: <none>
>> ======================================
>>
>>
>> Here's an event snapshot of my array, just keep in mind that
>> "/dev/sdi" is my failed drive, so I omitted it from the examination:
>> ======================================
>> # mdadm -E /dev/sd[b-h,j,k] |grep Events
>>          Events : 280033
>>          Events : 280033
>>          Events : 280033
>>          Events : 280033
>>          Events : 280033
>>          Events : 280033
>>          Events : 280011
>>          Events : 280033
>>          Events : 280033
>> ======================================
>>
>>
>> It's important to note, that since I haven't done anything yet, my CPU is idle:
>> ======================================
>> top - 20:22:00 up  5:56,  2 users,  load average: 0.04, 0.03, 0.00
>>
>> Tasks: 221 total,   1 running, 220 sleeping,   0 stopped,   0 zombie
>>
>> %Cpu(s):  1.0 us,  1.0 sy,  0.0 ni, 97.5 id,  0.5 wa,  0.0 hi,  0.0 si,  0.0 st
>>
>> KiB Mem :  1525400 total,   103836 free,   696208 used,   725356 buff/cache
>>
>> KiB Swap: 25153532 total, 25117380 free,    36152 used.   454808 avail Mem
>>  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
>>  2093 cisco     20   0 1761112 153108  55640 S   1.0 10.0   0:12.61 gnome-shell
>>  4322 root      20   0   40520   3684   3100 R   1.0  0.2   0:00.22 top
>>     1 root      20   0  119692   5540   3992 S   0.0  0.4   0:02.44 systemd
>>     2 root      20   0       0      0      0 S   0.0  0.0   0:00.00 kthreadd
>>     3 root      20   0       0      0      0 S   0.0  0.0   0:00.09 ksoftirqd/0
>>     5 root       0 -20       0      0      0 S   0.0  0.0   0:00.00 kworker/0:
>> ======================================
>>
>>
>> Now onto the fun part.  I stopped "/dev/md127":
>> ======================================
>> # mdadm --stop /dev/md127
>> mdadm: stopped /dev/md127
>> # cat /proc/mdstat
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>> [raid4] [raid10]
>> unused devices: <none>
>> ======================================
>>
>>
>> For completion, here's the trace output after stopping the array, and
>> before reassembling:
>> ======================================
>> # tracer: nop
>> #
>> # entries-in-buffer/entries-written: 0/0   #P:2
>> #
>> #                              _-----=> irqs-off
>> #                             / _----=> need-resched
>> #                            | / _---=> hardirq/softirq
>> #                            || / _--=> preempt-depth
>> #                            ||| /     delay
>> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
>> #              | |       |   ||||       |         |
>> /sys/kernel/debug/tracing/trace (END)
>> ======================================
>>
>>
>> Then I reassembled the array:
>> ======================================
>> # mdadm -Afv /dev/md127 /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf
>> /dev/sdg /dev/sdh /dev/sdj /dev/sdk
>> mdadm: looking for devices for /dev/md127
>> mdadm: /dev/sdb is busy - skipping
>> mdadm: Merging with already-assembled /dev/md/en1
>> mdadm: /dev/sdb is identified as a member of /dev/md/en1, slot 7.
>> mdadm: /dev/sdc is identified as a member of /dev/md/en1, slot 8.
>> mdadm: /dev/sdd is identified as a member of /dev/md/en1, slot 6.
>> mdadm: /dev/sde is identified as a member of /dev/md/en1, slot 9.
>> mdadm: /dev/sdf is identified as a member of /dev/md/en1, slot 4.
>> mdadm: /dev/sdg is identified as a member of /dev/md/en1, slot 1.
>> mdadm: /dev/sdh is identified as a member of /dev/md/en1, slot 3.
>> mdadm: /dev/sdj is identified as a member of /dev/md/en1, slot 2.
>> mdadm: /dev/sdk is identified as a member of /dev/md/en1, slot 0.
>> mdadm: Marking array /dev/md/en1 as 'clean'
>> mdadm: /dev/md/en1 has an active reshape - checking if critical
>> section needs to be restored
>> mdadm: No backup metadata on device-7
>> mdadm: No backup metadata on device-8
>> mdadm: No backup metadata on device-9
>> mdadm: added /dev/sdg to /dev/md/en1 as 1
>> mdadm: added /dev/sdj to /dev/md/en1 as 2
>> mdadm: added /dev/sdh to /dev/md/en1 as 3 (possibly out of date)
>> mdadm: added /dev/sdf to /dev/md/en1 as 4
>> mdadm: no uptodate device for slot 5 of /dev/md/en1
>> mdadm: added /dev/sdd to /dev/md/en1 as 6
>> mdadm: /dev/sdb is already in /dev/md/en1 as 7
>> mdadm: added /dev/sdc to /dev/md/en1 as 8
>> mdadm: added /dev/sde to /dev/md/en1 as 9
>> mdadm: added /dev/sdk to /dev/md/en1 as 0
>> ======================================
>>
>>
>> And of course, CPU shoots to 100%:
>> ======================================
>> top - 20:38:44 up  6:13,  3 users,  load average: 5.05, 3.25, 1.41
>> Tasks: 239 total,   3 running, 236 sleeping,   0 stopped,   0 zombie
>> %Cpu(s):  5.9 us, 52.7 sy,  0.0 ni,  0.0 id, 41.4 wa,  0.0 hi,  0.0 si,  0.0 st
>> KiB Mem :  1525400 total,    73124 free,   739576 used,   712700 buff/cache
>> KiB Swap: 25153532 total, 25111140 free,    42392 used.   415840 avail Mem
>>
>>  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
>>  6423 root      20   0       0      0      0 R  99.0  0.0   4:43.51 md127_raid6
>>  1166 root      20   0  280588   8780   6192 S   3.0  0.6   0:06.56 polkitd
>>  4022 cisco     20   0  394756  32884  26064 S   3.0  2.2   0:08.77 gnome-disks
>>  1903 cisco     20   0  256660  34060  26280 S   2.0  2.2   0:29.56 Xorg
>>  2093 cisco     20   0 1760364 153572  55572 S   2.0 10.1   0:17.96 gnome-shell
>> ======================================
>>
>>
>> Then surely the array reshape speed goes back down to nothing:
>> ======================================
>> # cat /proc/mdstat
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>> [raid4] [raid10]
>> md127 : active raid6 sdk[0] sde[11] sdc[12] sdd[10] sdf[7] sdj[2] sdg[9] sdb[13]
>>       14650675200 blocks super 1.2 level 6, 512k chunk, algorithm 2
>> [10/8] [UUU_U_UUUU]
>>       [=======>.............]  reshape = 39.1% (1146348512/2930135040)
>> finish=22057575.1min speed=1K/sec
>>       bitmap: 0/22 pages [0KB], 65536KB chunk
>>
>> unused devices: <none>
>> ======================================
>>
>>
>> The size of the trace file is gigantic, so hopefully it doesn't get
>> trimmed in the email, but any help would be appreciated, thanks in
>> advance:
>> ================
>> # tracer: nop
>> #
>> # entries-in-buffer/entries-written: 44739/81554230   #P:2
>> #
>> #                              _-----=> irqs-off
>> #                             / _----=> need-resched
>> #                            | / _---=> hardirq/softirq
>> #                            || / _--=> preempt-depth
>> #                            ||| /     delay
>> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
>> #              | |       |   ||||       |         |
>>      md127_raid6-6423  [001] .... 22228.159918: analyse_stripe: check
>> 7: state 0x13 read           (null) write           (null) written
>>       (null)
>>      md127_raid6-6423  [001] .... 22228.159919: analyse_stripe: check
>> 6: state 0xa01 read           (null) write           (null) written
>>        (null)
>>      md127_raid6-6423  [001] .... 22228.159919: analyse_stripe: check
>> 5: state 0x801 read           (null) write           (null) written
>>        (null)
>>      md127_raid6-6423  [001] .... 22228.159920: analyse_stripe: check
>> 4: state 0x811 read           (null) write           (null) written
>>        (null)
>>      md127_raid6-6423  [001] .... 22228.159921: analyse_stripe: check
>> 3: state 0x801 read           (null) write           (null) written
>>        (null)
>>      md127_raid6-6423  [001] .... 22228.159921: analyse_stripe: check
>> 2: state 0x811 read           (null) write           (null) written
>>        (null)
>>      md127_raid6-6423  [001] .... 22228.159922: analyse_stripe: check
>> 1: state 0xa01 read           (null) write           (null) written
>>        (null)
>>      md127_raid6-6423  [001] .... 22228.159923: analyse_stripe: check
>> 0: state 0x811 read           (null) write           (null) written
>>        (null)
>>      md127_raid6-6423  [001] .... 22228.159924: handle_stripe:
>> locked=2 uptodate=10 to_read=0 to_write=0 failed=4 failed_num=6,5
>>      md127_raid6-6423  [001] .... 22228.159925:
>> schedule_reconstruction: schedule_reconstruction: stripe 2292697672
>> locked: 4 ops_request: 10
>>      md127_raid6-6423  [001] .... 22228.159925: raid_run_ops:
>> ops_run_reconstruct6: stripe 2292697672
>>      md127_raid6-6423  [001] .... 22228.159943:
>> ops_complete_reconstruct: ops_complete_reconstruct: stripe 2292697672
>>      md127_raid6-6423  [001] .... 22228.159944: handle_stripe:
>> handling stripe 2292697680, state=0x1401 cnt=1, pd_idx=7, qd_idx=8
>> , check:0, reconstruct:6
>> ===========================================
>>
>> I trimmed it because of the failure to send issue.  However, if
>> someone needs a lengthier snip of the trace, let me know.
>>
>> Thanks,
>>
>> 'Cisco
