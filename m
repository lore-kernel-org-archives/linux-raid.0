From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH] md: create new workqueue for object destruction
Date: Fri, 27 Oct 2017 12:44:21 +0200
Message-ID: <169c257d-0ae7-b721-3954-713522dd0ccd@intel.com>
References: <87mv4qjrez.fsf@notabene.neil.brown.name>
 <20171018062137.ssdhwkeoy6fdp7yq@kernel.org>
 <87h8uwj4mz.fsf@notabene.neil.brown.name>
 <6454f28e-4728-a10d-f3c3-b68afedec8d9@intel.com>
 <87376ghyms.fsf@notabene.neil.brown.name>
 <9759b574-2d3f-de45-0840-c84d9cc10528@intel.com>
 <87wp3qg4bi.fsf@notabene.neil.brown.name>
 <06d5ab0c-f669-6c9f-3f0a-930cea5c893b@intel.com>
 <87y3o2ep54.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87y3o2ep54.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/23/2017 01:31 AM, NeilBrown wrote:
> On Fri, Oct 20 2017, Artur Paszkiewicz wrote:
> 
>> On 10/20/2017 12:28 AM, NeilBrown wrote:
>>> On Thu, Oct 19 2017, Artur Paszkiewicz wrote:
>>>
>>>> On 10/19/2017 12:36 AM, NeilBrown wrote:
>>>>> On Wed, Oct 18 2017, Artur Paszkiewicz wrote:
>>>>>
>>>>>> On 10/18/2017 09:29 AM, NeilBrown wrote:
>>>>>>> On Tue, Oct 17 2017, Shaohua Li wrote:
>>>>>>>
>>>>>>>> On Tue, Oct 17, 2017 at 04:04:52PM +1100, Neil Brown wrote:
>>>>>>>>>
>>>>>>>>> lockdep currently complains about a potential deadlock
>>>>>>>>> with sysfs access taking reconfig_mutex, and that
>>>>>>>>> waiting for a work queue to complete.
>>>>>>>>>
>>>>>>>>> The cause is inappropriate overloading of work-items
>>>>>>>>> on work-queues.
>>>>>>>>>
>>>>>>>>> We currently have two work-queues: md_wq and md_misc_wq.
>>>>>>>>> They service 5 different tasks:
>>>>>>>>>
>>>>>>>>>   mddev->flush_work                       md_wq
>>>>>>>>>   mddev->event_work (for dm-raid)         md_misc_wq
>>>>>>>>>   mddev->del_work (mddev_delayed_delete)  md_misc_wq
>>>>>>>>>   mddev->del_work (md_start_sync)         md_misc_wq
>>>>>>>>>   rdev->del_work                          md_misc_wq
>>>>>>>>>
>>>>>>>>> We need to call flush_workqueue() for md_start_sync and ->event_work
>>>>>>>>> while holding reconfig_mutex, but mustn't hold it when
>>>>>>>>> flushing mddev_delayed_delete or rdev->del_work.
>>>>>>>>>
>>>>>>>>> md_wq is a bit special as it has WQ_MEM_RECLAIM so it is
>>>>>>>>> best to leave that alone.
>>>>>>>>>
>>>>>>>>> So create a new workqueue, md_del_wq, and a new work_struct,
>>>>>>>>> mddev->sync_work, so we can keep two classes of work separate.
>>>>>>>>>
>>>>>>>>> md_del_wq and ->del_work are used only for destroying rdev
>>>>>>>>> and mddev.
>>>>>>>>> md_misc_wq is used for event_work and sync_work.
>>>>>>>>>
>>>>>>>>> Also document the purpose of each flush_workqueue() call.
>>>>>>>>>
>>>>>>>>> This removes the lockdep warning.
>>>>>>>>
>>>>>>>> I had the exactly same patch queued internally,
>>>>>>>
>>>>>>> Cool :-)
>>>>>>>
>>>>>>>>                                                   but the mdadm test suite still
>>>>>>>> shows lockdep warnning. I haven't time to check further.
>>>>>>>>
>>>>>>>
>>>>>>> The only other lockdep I've seen later was some ext4 thing, though I
>>>>>>> haven't tried the full test suite.  I might have a look tomorrow.
>>>>>>
>>>>>> I'm also seeing a lockdep warning with or without this patch,
>>>>>> reproducible with:
>>>>>>
>>>>>
>>>>> Thanks!
>>>>> Looks like using one workqueue for mddev->del_work and rdev->del_work
>>>>> causes problems.
>>>>> Can you try with this addition please?
>>>>
>>>> It helped for that case but now there is another warning triggered by:
>>>>
>>>> export IMSM_NO_PLATFORM=1 # for platforms without IMSM
>>>> mdadm -C /dev/md/imsm0 -eimsm -n4 /dev/sd[a-d] -R
>>>> mdadm -C /dev/md/vol0 -l5 -n4 /dev/sd[a-d] -R --assume-clean
>>>> mdadm -If sda
>>>> mdadm -a /dev/md127 /dev/sda
>>>> mdadm -Ss
>>>
>>> I tried that ... and mdmon gets a SIGSEGV.
>>> imsm_set_disk() calls get_imsm_disk() and gets a NULL back.
>>> It then passes the NULL to mark_failure() and that dereferences it.
>>
>> Interesting... I can't reproduce this. Can you show the output from
>> mdadm -E for all disks after mdmon crashes? And maybe a debug log from
>> mdmon?
> 
> The crash happens when I run "mdadm -If sda".
> gdb tell me:
> 
> Thread 2 "mdmon" received signal SIGSEGV, Segmentation fault.
> [Switching to Thread 0x7f5526c24700 (LWP 4757)]
> 0x000000000041601c in is_failed (disk=0x0) at super-intel.c:1324
> 1324		return (disk->status & FAILED_DISK) == FAILED_DISK;
> (gdb) where
> #0  0x000000000041601c in is_failed (disk=0x0) at super-intel.c:1324
> #1  0x00000000004255a2 in mark_failure (super=0x65fa30, dev=0x660ba0, 
>     disk=0x0, idx=0) at super-intel.c:7973
> #2  0x00000000004260e8 in imsm_set_disk (a=0x6635d0, n=0, state=17)
>     at super-intel.c:8357
> #3  0x0000000000405069 in read_and_act (a=0x6635d0, fds=0x7f5526c23e10)
>     at monitor.c:551
> #4  0x0000000000405c8e in wait_and_act (container=0x65f010, nowait=0)
>     at monitor.c:875
> #5  0x0000000000405dc7 in do_monitor (container=0x65f010) at monitor.c:906
> #6  0x0000000000403037 in run_child (v=0x65f010) at mdmon.c:85
> #7  0x00007f5526fcb494 in start_thread (arg=0x7f5526c24700)
>     at pthread_create.c:333
> #8  0x00007f5526d0daff in clone ()
>     at ../sysdeps/unix/sysv/linux/x86_64/clone.S:97
> 
> The super-disks list that get_imsm_dl_disk() looks through contains
> sdc, sdd, sde, but not sda - so get_imsm_disk() returns NULL.
> (the 4 devices I use are sda sdc sde sde).
>  mdadm --examine of sda and sdc after the crash are below.
>  mdmon debug output is below that.

Thank you for the information. The metadata output shows that there is
something wrong with sda. Is there anything different about this device?
The other disks are 10M QEMU SCSI drives, is sda the same? Can you
check its serial e.g. with sg_inq?

Thanks,
Artur

> 
> Thanks,
> NeilBrown
> 
> 
> /dev/sda:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.2.02
>     Orig Family : 0a44d090
>          Family : 0a44d090
>      Generation : 00000002
>      Attributes : All supported
>            UUID : 9897925b:e497e1d9:9af0a04a:88429b8b
>        Checksum : 56aeb059 correct
>     MPB Sectors : 2
>           Disks : 4
>    RAID Devices : 1
> 
> [vol0]:
>            UUID : 89a43a61:a39615db:fe4a4210:021acc13
>      RAID Level : 5
>         Members : 4
>           Slots : [UUUU]
>     Failed disk : none
>       This Slot : ?
>     Sector Size : 512
>      Array Size : 36864 (18.00 MiB 18.87 MB)
>    Per Dev Size : 12288 (6.00 MiB 6.29 MB)
>   Sector Offset : 0
>     Num Stripes : 48
>      Chunk Size : 128 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : normal
>     Dirty State : clean
>      RWH Policy : off
> 
>   Disk00 Serial : 
>           State : active
>              Id : 00000000
>     Usable Size : 36028797018957662
> 
>   Disk01 Serial : QM00002
>           State : active
>              Id : 01000100
>     Usable Size : 14174 (6.92 MiB 7.26 MB)
> 
>   Disk02 Serial : QM00003
>           State : active
>              Id : 02000000
>     Usable Size : 14174 (6.92 MiB 7.26 MB)
> 
>   Disk03 Serial : QM00004
>           State : active
>              Id : 02000100
>     Usable Size : 14174 (6.92 MiB 7.26 MB)
> 
> /dev/sdc:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.2.02
>     Orig Family : 0a44d090
>          Family : 0a44d090
>      Generation : 00000004
>      Attributes : All supported
>            UUID : 9897925b:e497e1d9:9af0a04a:88429b8b
>        Checksum : 56b1b08e correct
>     MPB Sectors : 2
>           Disks : 4
>    RAID Devices : 1
> 
>   Disk01 Serial : QM00002
>           State : active
>              Id : 01000100
>     Usable Size : 14174 (6.92 MiB 7.26 MB)
> 
> [vol0]:
>            UUID : 89a43a61:a39615db:fe4a4210:021acc13
>      RAID Level : 5
>         Members : 4
>           Slots : [_UUU]
>     Failed disk : 0
>       This Slot : 1
>     Sector Size : 512
>      Array Size : 36864 (18.00 MiB 18.87 MB)
>    Per Dev Size : 12288 (6.00 MiB 6.29 MB)
>   Sector Offset : 0
>     Num Stripes : 48
>      Chunk Size : 128 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : degraded
>     Dirty State : clean
>      RWH Policy : off
> 
>   Disk00 Serial : 0
>           State : active failed
>              Id : ffffffff
>     Usable Size : 36028797018957662
> 
>   Disk02 Serial : QM00003
>           State : active
>              Id : 02000000
>     Usable Size : 14174 (6.92 MiB 7.26 MB)
> 
>   Disk03 Serial : QM00004
>           State : active
>              Id : 02000100
>     Usable Size : 14174 (6.92 MiB 7.26 MB)
> 
> mdmon: mdmon: starting mdmon for md127
> mdmon: __prep_thunderdome: mpb from 8:0 prefer 8:48
> mdmon: __prep_thunderdome: mpb from 8:32 matches 8:48
> mdmon: __prep_thunderdome: mpb from 8:64 matches 8:32
> monitor: wake ( )
> monitor: wake ( )
> ....
> monitor: wake ( )
> monitor: wake ( )
> monitor: wake ( )
> mdmon: manage_new: inst: 0 action: 25 state: 26
> mdmon: imsm_open_new: imsm: open_new 0
> 
> mdmon: wait_and_act: monitor: caught signal
> mdmon: read_and_act: (0): 1508714952.508532 state:write-pending prev:inactive action:idle prev: idle start:18446744073709551615
> mdmon: imsm_set_array_state: imsm: mark 'dirty'
> mdmon: imsm_set_disk: imsm: set_disk 0:11
> 
> Thread 2 "mdmon" received signal SIGSEGV, Segmentation fault.
> 0x00000000004168f1 in is_failed (disk=0x0) at super-intel.c:1324
> 1324		return (disk->status & FAILED_DISK) == FAILED_DISK;
> (gdb) where
> #0  0x00000000004168f1 in is_failed (disk=0x0) at super-intel.c:1324
> #1  0x0000000000426bec in mark_failure (super=0x667a30, dev=0x668ba0, 
>     disk=0x0, idx=0) at super-intel.c:7973
> #2  0x000000000042784b in imsm_set_disk (a=0x66b9b0, n=0, state=17)
>     at super-intel.c:8357
> #3  0x000000000040520c in read_and_act (a=0x66b9b0, fds=0x7ffff7617e10)
>     at monitor.c:551
> #4  0x00000000004061aa in wait_and_act (container=0x667010, nowait=0)
>     at monitor.c:875
> #5  0x00000000004062e3 in do_monitor (container=0x667010) at monitor.c:906
> #6  0x0000000000403037 in run_child (v=0x667010) at mdmon.c:85
> #7  0x00007ffff79bf494 in start_thread (arg=0x7ffff7618700)
>     at pthread_create.c:333
> #8  0x00007ffff7701aff in clone ()
>     at ../sysdeps/unix/sysv/linux/x86_64/clone.S:97
> (gdb) quit
> A debugging session is active.
> 
> 	Inferior 1 [process 5774] will be killed.
> 
> Quit anyway? (y or n) ty
> Please answer y or n.
> A debugging session is active.
> 
> 	Inferior 1 [process 5774] will be killed.
> 
> Quit anyway? (y or n) y
> 

