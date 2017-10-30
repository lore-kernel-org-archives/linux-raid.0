From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH] md: create new workqueue for object destruction
Date: Mon, 30 Oct 2017 14:02:42 +0100
Message-ID: <c34d2d7f-2740-365f-85e4-7ec9c9c66f1a@intel.com>
References: <87mv4qjrez.fsf@notabene.neil.brown.name>
 <20171018062137.ssdhwkeoy6fdp7yq@kernel.org>
 <87h8uwj4mz.fsf@notabene.neil.brown.name>
 <6454f28e-4728-a10d-f3c3-b68afedec8d9@intel.com>
 <87376ghyms.fsf@notabene.neil.brown.name>
 <9759b574-2d3f-de45-0840-c84d9cc10528@intel.com>
 <87wp3qg4bi.fsf@notabene.neil.brown.name>
 <06d5ab0c-f669-6c9f-3f0a-930cea5c893b@intel.com>
 <87y3o2ep54.fsf@notabene.neil.brown.name>
 <169c257d-0ae7-b721-3954-713522dd0ccd@intel.com>
 <873761d2e4.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <873761d2e4.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/29/2017 11:18 PM, NeilBrown wrote:
> On Fri, Oct 27 2017, Artur Paszkiewicz wrote:
> 
>> On 10/23/2017 01:31 AM, NeilBrown wrote:
>>> On Fri, Oct 20 2017, Artur Paszkiewicz wrote:
>>>
>>>> On 10/20/2017 12:28 AM, NeilBrown wrote:
>>>>> On Thu, Oct 19 2017, Artur Paszkiewicz wrote:
>>>>>
>>>>>> On 10/19/2017 12:36 AM, NeilBrown wrote:
>>>>>>> On Wed, Oct 18 2017, Artur Paszkiewicz wrote:
>>>>>>>
>>>>>>>> On 10/18/2017 09:29 AM, NeilBrown wrote:
>>>>>>>>> On Tue, Oct 17 2017, Shaohua Li wrote:
>>>>>>>>>
>>>>>>>>>> On Tue, Oct 17, 2017 at 04:04:52PM +1100, Neil Brown wrote:
>>>>>>>>>>>
>>>>>>>>>>> lockdep currently complains about a potential deadlock
>>>>>>>>>>> with sysfs access taking reconfig_mutex, and that
>>>>>>>>>>> waiting for a work queue to complete.
>>>>>>>>>>>
>>>>>>>>>>> The cause is inappropriate overloading of work-items
>>>>>>>>>>> on work-queues.
>>>>>>>>>>>
>>>>>>>>>>> We currently have two work-queues: md_wq and md_misc_wq.
>>>>>>>>>>> They service 5 different tasks:
>>>>>>>>>>>
>>>>>>>>>>>   mddev->flush_work                       md_wq
>>>>>>>>>>>   mddev->event_work (for dm-raid)         md_misc_wq
>>>>>>>>>>>   mddev->del_work (mddev_delayed_delete)  md_misc_wq
>>>>>>>>>>>   mddev->del_work (md_start_sync)         md_misc_wq
>>>>>>>>>>>   rdev->del_work                          md_misc_wq
>>>>>>>>>>>
>>>>>>>>>>> We need to call flush_workqueue() for md_start_sync and ->event_work
>>>>>>>>>>> while holding reconfig_mutex, but mustn't hold it when
>>>>>>>>>>> flushing mddev_delayed_delete or rdev->del_work.
>>>>>>>>>>>
>>>>>>>>>>> md_wq is a bit special as it has WQ_MEM_RECLAIM so it is
>>>>>>>>>>> best to leave that alone.
>>>>>>>>>>>
>>>>>>>>>>> So create a new workqueue, md_del_wq, and a new work_struct,
>>>>>>>>>>> mddev->sync_work, so we can keep two classes of work separate.
>>>>>>>>>>>
>>>>>>>>>>> md_del_wq and ->del_work are used only for destroying rdev
>>>>>>>>>>> and mddev.
>>>>>>>>>>> md_misc_wq is used for event_work and sync_work.
>>>>>>>>>>>
>>>>>>>>>>> Also document the purpose of each flush_workqueue() call.
>>>>>>>>>>>
>>>>>>>>>>> This removes the lockdep warning.
>>>>>>>>>>
>>>>>>>>>> I had the exactly same patch queued internally,
>>>>>>>>>
>>>>>>>>> Cool :-)
>>>>>>>>>
>>>>>>>>>>                                                   but the mdadm test suite still
>>>>>>>>>> shows lockdep warnning. I haven't time to check further.
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> The only other lockdep I've seen later was some ext4 thing, though I
>>>>>>>>> haven't tried the full test suite.  I might have a look tomorrow.
>>>>>>>>
>>>>>>>> I'm also seeing a lockdep warning with or without this patch,
>>>>>>>> reproducible with:
>>>>>>>>
>>>>>>>
>>>>>>> Thanks!
>>>>>>> Looks like using one workqueue for mddev->del_work and rdev->del_work
>>>>>>> causes problems.
>>>>>>> Can you try with this addition please?
>>>>>>
>>>>>> It helped for that case but now there is another warning triggered by:
>>>>>>
>>>>>> export IMSM_NO_PLATFORM=1 # for platforms without IMSM
>>>>>> mdadm -C /dev/md/imsm0 -eimsm -n4 /dev/sd[a-d] -R
>>>>>> mdadm -C /dev/md/vol0 -l5 -n4 /dev/sd[a-d] -R --assume-clean
>>>>>> mdadm -If sda
>>>>>> mdadm -a /dev/md127 /dev/sda
>>>>>> mdadm -Ss
>>>>>
>>>>> I tried that ... and mdmon gets a SIGSEGV.
>>>>> imsm_set_disk() calls get_imsm_disk() and gets a NULL back.
>>>>> It then passes the NULL to mark_failure() and that dereferences it.
>>>>
>>>> Interesting... I can't reproduce this. Can you show the output from
>>>> mdadm -E for all disks after mdmon crashes? And maybe a debug log from
>>>> mdmon?
>>>
>>> The crash happens when I run "mdadm -If sda".
>>> gdb tell me:
>>>
>>> Thread 2 "mdmon" received signal SIGSEGV, Segmentation fault.
>>> [Switching to Thread 0x7f5526c24700 (LWP 4757)]
>>> 0x000000000041601c in is_failed (disk=0x0) at super-intel.c:1324
>>> 1324		return (disk->status & FAILED_DISK) == FAILED_DISK;
>>> (gdb) where
>>> #0  0x000000000041601c in is_failed (disk=0x0) at super-intel.c:1324
>>> #1  0x00000000004255a2 in mark_failure (super=0x65fa30, dev=0x660ba0, 
>>>     disk=0x0, idx=0) at super-intel.c:7973
>>> #2  0x00000000004260e8 in imsm_set_disk (a=0x6635d0, n=0, state=17)
>>>     at super-intel.c:8357
>>> #3  0x0000000000405069 in read_and_act (a=0x6635d0, fds=0x7f5526c23e10)
>>>     at monitor.c:551
>>> #4  0x0000000000405c8e in wait_and_act (container=0x65f010, nowait=0)
>>>     at monitor.c:875
>>> #5  0x0000000000405dc7 in do_monitor (container=0x65f010) at monitor.c:906
>>> #6  0x0000000000403037 in run_child (v=0x65f010) at mdmon.c:85
>>> #7  0x00007f5526fcb494 in start_thread (arg=0x7f5526c24700)
>>>     at pthread_create.c:333
>>> #8  0x00007f5526d0daff in clone ()
>>>     at ../sysdeps/unix/sysv/linux/x86_64/clone.S:97
>>>
>>> The super-disks list that get_imsm_dl_disk() looks through contains
>>> sdc, sdd, sde, but not sda - so get_imsm_disk() returns NULL.
>>> (the 4 devices I use are sda sdc sde sde).
>>>  mdadm --examine of sda and sdc after the crash are below.
>>>  mdmon debug output is below that.
>>
>> Thank you for the information. The metadata output shows that there is
>> something wrong with sda. Is there anything different about this device?
>> The other disks are 10M QEMU SCSI drives, is sda the same? Can you
>> check its serial e.g. with sg_inq?
> 
> sdc, sdd, and sde are specified to qemu with
> 
>        -hdb /var/tmp/mdtest10 \
>        -hdc /var/tmp/mdtest11 \
>        -hdd /var/tmp/mdtest12 \
> 
> sda comes from
>        -drive file=/var/tmp/mdtest13,if=scsi,index=3,media=disk -s
> 
> /var/tmp/mdtest* are simple raw images, 10M each.
> 
> sg_inq report sd[cde] as
>   Vendor: ATA
>   Product: QEMU HARDDISK
>   Serial: QM0000[234]
> 
> sda is
>   Vendor: QEMU
>   Product: QEMU HARDDISK
>   no serial number.
> 
> 
> If I change my script to use
>        -drive file=/var/tmp/mdtest13,if=scsi,index=3,serial=QM00009,media=disk -s
> 
> for sda, mdmon doesn't crash.  It may well be reasonable to refuse to
> work with a device that has no serial number.  It is not very friendly
> to crash :-(

OK, this explains a lot. Can you try the same with this patch? It looks
like there was insufficient error checking when retrieving the scsi
serial. Mdadm should now abort when creating the container.
IMSM_DEVNAME_AS_SERIAL can be used to create an array with disks that
don't have a serial number.

Thanks,
Artur

diff --git a/sg_io.c b/sg_io.c
index 42c91e1e..7889a95e 100644
--- a/sg_io.c
+++ b/sg_io.c
@@ -46,6 +46,9 @@ int scsi_get_serial(int fd, void *buf, size_t buf_len)
        if (rv)
                return rv;

+       if ((io_hdr.info & SG_INFO_OK_MASK) != SG_INFO_OK)
+               return -1;
+
        rsp_len = rsp_buf[3];

        if (!rsp_len || buf_len < rsp_len)
