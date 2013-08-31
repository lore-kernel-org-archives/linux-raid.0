From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: question about mdmon --takeover
Date: Sat, 31 Aug 2013 22:21:36 +0200
Message-ID: <CAC9WiBgunq0nHC2s1sOk=2zdTwDCJZN_5VOUgqA27r1s+0PNKQ@mail.gmail.com>
References: <CAC9WiBgFPSeKGBYxYCkw8DHk4dS6=aBhCeiMGgkj2eNgtY0asw@mail.gmail.com>
	<20130805165908.2d1e291b@notabene.brown>
	<CAC9WiBhab-Acx+U0NWAxki+M9sXccdEPBj=LyLPYQv3XQ_Nnxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBhab-Acx+U0NWAxki+M9sXccdEPBj=LyLPYQv3XQ_Nnxg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hello Martin,

I'm adding you in the discussion because you might have an idea on
what's going on with my array which is using DDF metadata.

On Wed, Aug 28, 2013 at 7:14 PM, Francis Moreau <francis.moro@gmail.com> wrote:
> Hello Neil,
>
>
> Sorry for the late reply.
>
> On Mon, Aug 5, 2013 at 8:59 AM, NeilBrown <neilb@suse.de> wrote:
>> On Wed, 31 Jul 2013 16:30:34 +0200 Francis Moreau <francis.moro@gmail.com>
>> wrote:
>>
>>> Hello list,
>>>
>>> I thought that using "--takeover" would hint mdmon to replace existing
>>> mdmon process, and therefore the old one would exit somehow.
>>>
>>> However after several "mdmon --takeover" I can see this:
>>>  $ ps aux | grep dmon
>>> root       233  0.0  0.2  80388 10752 ?        SLsl 14:02   0:00 @dmon
>>> --offroot md127
>>> root      3326  0.0  0.2  14920 10820 ?        SLsl 15:16   0:00 mdmon
>>> --takeover md127
>>> root      3343  0.0  0.2  14920 10820 ?        SLsl 15:17   0:00 mdmon
>>> --takeover md127
>>>
>>> Is this expected ?
>>>
>>> Thanks.
>>
>> Nope.  That's not expected.
>>
>> mdmon should send SIGTERM to the old mdmon and then wait for it to exit.
>>
>> If the new and old mdmon were compiled different and look for the pid file in
>> different directories that might explain what you see.
>>
>> If you compile mdadm from source it will use /run/mdadm.  However if your
>> distro doesn't have /run the the distro-provided mdadm will be compiled
>> differently.
>>
>
> It doesn't to be the case.
>
> Actually sending SIGTERM manually to mdmon has no effects.
>
>
> # mdadm --version
> mdadm - v3.2.6 - 25th October 2012
>
> # ps aux | grep dmon
> root       235  0.1  1.0  80612 10976 ?        SLsl 19:08   0:00 @dmon
> --offroot md127
> root       339  0.0  1.0  15044 10944 ?        SLsl 19:08   0:00
> /sbin/mdmon --takeover md127
>
> # cat /run/mdadm/md127.pid
> 339
>
> # kill -SIGTERM 339
> # ps aux | grep dmon
> root       235  0.0  1.0  80612 10976 ?        SLsl 19:08   0:00 @dmon
> --offroot md127
> root       339  0.0  1.0  15044 10944 ?        SLsl 19:08   0:00
> /sbin/mdmon --takeover md127
>
> # ps aux | grep dmon
> root       235  0.0  1.0  80612 10976 ?        SLsl 19:08   0:00 @dmon
> --offroot md127
> root       339  0.0  1.0  15044 10944 ?        SLsl 19:08   0:00
> /sbin/mdmon --takeover md127
> root      2352  0.1  1.0  15076 10976 ?        SLsl 19:12   0:00 mdmon
> --takeover /dev/md127
>
> # cat /run/mdadm/md127.pid
> 2352
>
> # pkill -SIGTERM mdmon
> [root@localhost ~]# ps aux | grep dmon
> root       235  0.0  1.0  80612 10976 ?        SLsl 19:08   0:00 @dmon
> --offroot md127
> root       339  0.0  1.0  80580 10944 ?        SLsl 19:08   0:00
> /sbin/mdmon --takeover md127
> root      2352  0.0  1.0  80612 10976 ?        SLsl 19:12   0:00 mdmon
> --takeover /dev/md127
>
> Can't you reproduce ?
>

Here are some additionnal information:

# cat /proc/mdstat
Personalities : [raid1]
md126 : active raid1 sda[1] sdb[0]
      2064384 blocks super external:/md127/0 [2/2] [UU]

md127 : inactive sda[1](S) sdb[0](S)
      65536 blocks super external:ddf

unused devices: <none>


# mdadm -E /dev/md126
/dev/md126:
   MBR Magic : aa55
Partition[0] :       367447 sectors at         2048 (type 82)
Partition[1] :      3755997 sectors at       372708 (type 05)
[root@localhost ~]# mdadm -E /dev/md127
/dev/md127:
          Magic : de11de11
        Version : 01.02.00
Controller GUID : 4C696E75:782D4D44:20202020:2020206C:6F63616C:686F7374
                  (Linux-MD       localhost)
 Container GUID : 4C696E75:782D4D44:DEADBEEF:00000000:3F4FB732:8435623D
                  (Linux-MD 08/28/13 22:27:30)
            Seq : 00000001
  Redundant hdr : no
  Virtual Disks : 1

      VD GUID[0] : 4C696E75:782D4D44:DEADBEEF:00000000:3F4FB739:E0C8B16E
                  (Linux-MD 08/28/13 22:27:37)
         unit[0] : 126
        state[0] : Optimal, Not Consistent
   init state[0] : Fully Initialised
       access[0] : Read/Write
         Name[0] : array1
 Raid Devices[0] : 2 (0 1)
   Raid Level[0] : RAID1
  Device Size[0] : 2064384
   Array Size[0] : 2064384

 Physical Disks : 2
      Number    RefNo      Size       Device      Type/State
         0    2cf00056   2064384K /dev/sda        active/Online
         1    b342fbdc   2064384K /dev/sdb        active/Online

I used GDB to trace what's going on in the monitor (thread) when
sending a SIGTERM to the mdmon process:

Breakpoint 1, wait_and_act (container=0x141a2c0, nowait=0) at monitor.c:634
634        for (a = *aap; a ; a = a->next) {
(gdb) n
632        rv = 0;
(gdb)
633        dirty_arrays = 0;
(gdb)
634        for (a = *aap; a ; a = a->next) {
(gdb)
649                int ret = read_and_act(a);
(gdb) p *a
$2 = {
  info = {
    array = {
      major_version = 0,
      minor_version = 0,
      patch_version = 0,
      ctime = 0,
      level = 1,
      size = 0,
      nr_disks = 0,
      raid_disks = 2,
      md_minor = 0,
      not_persistent = 0,
      utime = 0,
      state = 0,
      active_disks = 0,
      working_disks = 0,
      failed_disks = 0,
      spare_disks = 0,
      layout = 0,
      chunk_size = 0
    },
    disk = {
      number = 0,
      major = 0,
      minor = 0,
      raid_disk = 0,
      state = 0
    },
    events = 0,
    uuid = {0, 0, 0, 0},
    name = '\000' <repeats 32 times>,
    data_offset = 0,
    component_size = 4128768,
    custom_array_size = 0,
    reshape_active = 0,
    reshape_progress = 0,
    recovery_blocked = 0,
    {
      resync_start = 18446744073709551615,
      recovery_start = 18446744073709551615
    },
    bitmap_offset = 0,
    safe_mode_delay = 0,
    new_level = 0,
    delta_disks = 0,
    new_layout = 0,
    new_chunk = 0,
    errors = 0,
    cache_size = 0,
    mismatch_cnt = 0,
    text_version = '\000' <repeats 49 times>,
    container_member = 0,
    container_enough = 0,
    sys_name = "md126", '\000' <repeats 14 times>,
    devs = 0x14213c0,
    next = 0x0,
    recovery_fd = 0,
    state_fd = 12,
    prev_state = 0,
    curr_state = 0,
    next_state = 0
  },
  container = 0x141a2c0,
  next = 0x0,
  replaces = 0x0,
  to_remove = 0,
  action_fd = 11,
  resync_start_fd = 13,
  metadata_fd = 14,
  sync_completed_fd = 15,
  last_checkpoint = 3872640,
  prev_state = active,
  curr_state = active,
  next_state = bad_word,
  prev_action = idle,
  curr_action = idle,
  next_action = bad_action,
  check_degraded = 0,
  check_reshape = 0,
  devnum = 126
}

(gdb) n
636            if (a->replaces && !discard_this) {
(gdb)
648            if (a->container && !a->to_remove) {
(gdb)
649                int ret = read_and_act(a);
(gdb)
656                if (sigterm && !(ret & ARRAY_DIRTY))
(gdb) p ret
$3 = 1

It seems that the array is dirty, and that's the reason why the
monitor never terminates.

I got the same behaviour if I'm starting a new mdmon process on this
array using --takeover switch. It seems weird since in my
understanding --takeover indicate mdmon to replace the current mdmon
process even if the array is dirty, no ?

Do you have any idea on this behaviour ?
-- 
Francis
