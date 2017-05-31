From: Zhilong Liu <zlliu@suse.com>
Subject: Re: [mdadm PATCH] Create: move STOP_ARRAY to abort_locked
Date: Wed, 31 May 2017 18:25:54 +0800
Message-ID: <92404b1c-fa39-05a1-db09-edd34624fddf@suse.com>
References: <1493190229-14329-1-git-send-email-zlliu@suse.com>
 <430f083a-2501-cb74-4ac1-89d1c4620a03@suse.com>
 <2c1c277c-2fd2-27a8-e6a5-23b1ced3ec90@gmail.com>
 <be1df636-2bbb-2757-7a96-264d2d1a4b65@suse.com>
 <2b947e61-36b6-0c6c-c25c-a9d2831cca11@suse.com>
 <8275d868-ad51-209b-e46f-9d7f1c60d1a3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8275d868-ad51-209b-e46f-9d7f1c60d1a3@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 05/09/2017 01:54 AM, Jes Sorensen wrote:
> On 05/07/2017 09:50 PM, Zhilong Liu wrote:
>>
>>
>> On 05/05/2017 11:31 AM, Liu Zhilong wrote:
>>>
>>>
>>> On 05/04/2017 10:54 PM, Jes Sorensen wrote:
>>>> On 05/04/2017 08:20 AM, Zhilong Liu wrote:
>>>>> Hi Jes,
>>>>>
>>>>> apply for review, this is a bug I ever encountered.
>>>>
>>>> Zhilong,
>>>>
>>>> Under what circumstances do you see this?
>>>>
>>>
>>> Issued the command:
>>> linux-g0sr:/home/test # ./mdadm -CR /dev/md0 -l1 -n2 -b internal
>>> /dev/loop[0-1] --size 63
>>> ... ... ...
>>> mdadm: Given bitmap chunk size not supported.
>>> linux-g0sr:/home/test # ls /dev/md0
>>> /dev/md0
>>> linux-g0sr:/home/test # ls /sys/block/md0/md/
>>> array_size   bitmap      component_size  level metadata_version
>>> raid_disks         reshape_position safe_mode_delay
>>> array_state  chunk_size  layout          max_read_errors
>>> new_dev           reshape_direction  resync_start
>>>
>>> create_mddev() writes the devnm to
>>> /sys/module/md_mod/parameter/new_array,
>>> then in md.c, module_param_call() called the 'set' function of
>>> add_named_array(),
>>> md_alloc() init_and_add the kobject for devm, finally the devnm device
>>> has created
>>> and sysfs has registered after create_mddev executed successfully.
>>> Thus it's better
>>> to STOP_ARRAY in any case after create_mddev() invoked.
>>>
>>
>> this patch depends on the kernel commit:
>> 039b7225e6e9 ("md: allow creation of mdNNN arrays via
>> md_mod/parameters/new_array")
>> Neil's patch has set "mddev->hold_active = UNTIL_STOP", thus the
>> STOP_ARRAY can work
>> well on this situation.
>
> OK now I am confused - are you saying this change will only work after 
> Neil's kernel patch has been applied? That would be no good, mdadm 
> needs to work on older kernels too.
>

Sorry for the late reply for this.

Currently, the creating array method for later kernel(newer than v4.11), 
it can avoid the race problem
via to set 'create_on_open' as N and write the mddev -> 
/sys/module/md_mod/parameters/new_array,
then mdadm can send the ioctl to stop_array directly if creating array 
fail, it won't happen the race.
refer to commit: 78b6350dcaad ("md: support disabling of create-on-open 
semantics.")

And for older kernel, it's difficult to avoid the problem of the race 
when use 'change', 'add' and 'remove'
udev rules in a short period of time via to ioctl commands.
For example, this case tested on my latest Tumbleweed(20170524) with 
latest mdadm source.

Steps:
First part:
-  open one terminal to monitor the udev:
Terminal 1: # udevadm monitor
monitor will print the received events for:
UDEV - the event which udev sends out after rule processing
KERNEL - the kernel uevent

-  type the command in another terminal:
Terminal 2: # ./mdadm -CR /dev/md1 --bitmap=internal -l1 -n2 /dev/loop1 
/dev/loop2 --size 63

    add_internal_bitmap received the abnormal chunk_size( < 64k), and 
return a failure.
    but it left the partially created array and didn't cleanup. For this 
test, the udev monitor prints:

Terminal 1: # udevadm monitor
... ...
KERNEL[146.077168] add      /devices/virtual/bdi/9:1 (bdi)
KERNEL[146.077211] add      /devices/virtual/block/md1 (block)
UDEV  [146.078112] add      /devices/virtual/bdi/9:1 (bdi)
UDEV  [146.084163] add      /devices/virtual/block/md1 (block)

Terminal 2: # ./mdadm -S /dev/md1

Terminal 1: # udevadm monitor
KERNEL[153.276209] remove   /devices/virtual/bdi/9:1 (bdi)
KERNEL[153.276317] remove   /devices/virtual/block/md1 (block)
UDEV  [153.277034] remove   /devices/virtual/bdi/9:1 (bdi)
UDEV  [153.280801] remove   /devices/virtual/block/md1 (block)

Second part:
add the ioctl(stop_array) and compiled to monitor the udevs.
# git diff
diff --git a/Create.c b/Create.c
index 239545f..21568ca 100644
--- a/Create.c
+++ b/Create.c
@@ -1065,7 +1065,9 @@ int Create(struct supertype *st, char *mddev,
         map_remove(&map, fd2devnm(mdfd));
         map_unlock(&map);

-       if (mdfd >= 0)
+       if (mdfd >= 0) {
+               ioctl(mdfd, STOP_ARRAY, NULL);
                 close(mdfd);
+       }
         return 1;
  }

Terminal 2: # ./mdadm -CR /dev/md1 --bitmap=internal -l1 -n2 /dev/loop1 
/dev/loop2 --size 63

Terminal 1: # udevadm monitor
... ...
KERNEL[171.964597] add      /devices/virtual/bdi/9:1 (bdi)
KERNEL[171.965346] add      /devices/virtual/block/md1 (block)
UDEV  [171.965565] add      /devices/virtual/bdi/9:1 (bdi)
KERNEL[171.984195] remove   /devices/virtual/bdi/9:1 (bdi)
KERNEL[171.984555] remove   /devices/virtual/block/md1 (block)
UDEV  [171.984590] remove   /devices/virtual/bdi/9:1 (bdi)
KERNEL[172.004504] add      /devices/virtual/bdi/9:1 (bdi)
KERNEL[172.004890] add      /devices/virtual/block/md1 (block)
UDEV  [172.004923] add      /devices/virtual/bdi/9:1 (bdi)
UDEV  [172.005787] add      /devices/virtual/block/md1 (block)
UDEV  [172.009648] remove   /devices/virtual/block/md1 (block)
UDEV  [172.013232] add      /devices/virtual/block/md1 (block)

So shall give udev a moment to process 'add' events?

mdadm can work as expect when adding usleep(100 * 1000) before perform 
ioctl(STOP_ARRAY).
this is the udev monitor result tested by the following sample.

Terminal 1: # udevadm monitor
KERNEL[5476.780692] add      /devices/virtual/bdi/9:1 (bdi)
KERNEL[5476.780976] add      /devices/virtual/block/md1 (block)
UDEV  [5476.782355] add      /devices/virtual/bdi/9:1 (bdi)
UDEV  [5476.786056] add      /devices/virtual/block/md1 (block)
KERNEL[5476.896255] remove   /devices/virtual/bdi/9:1 (bdi)
KERNEL[5476.896367] remove   /devices/virtual/block/md1 (block)
UDEV  [5476.896895] remove   /devices/virtual/bdi/9:1 (bdi)
UDEV  [5476.900752] remove   /devices/virtual/block/md1 (block)


Such as like this:

diff --git a/Create.c b/Create.c
index 239545f..a07ace8 100644
--- a/Create.c
+++ b/Create.c
@@ -902,10 +902,8 @@ int Create(struct supertype *st, char *mddev,
                                         remove_partitions(fd);
                                 if (st->ss->add_to_super(st, &inf->disk,
                                                          fd, dv->devname,
- dv->data_offset)) {
-                                       ioctl(mdfd, STOP_ARRAY, NULL);
+ dv->data_offset))
                                         goto abort_locked;
-                               }
                                 st->ss->getinfo_super(st, inf, NULL);
                                 safe_mode_delay = inf->safe_mode_delay;

@@ -1006,7 +1004,6 @@ int Create(struct supertype *st, char *mddev,
                         sysfs_set_safemode(&info, safe_mode_delay);
                         if (err) {
                                 pr_err("failed to activate array.\n");
-                               ioctl(mdfd, STOP_ARRAY, NULL);
                                 goto abort;
                         }
                 } else if (c->readonly &&
@@ -1016,7 +1013,6 @@ int Create(struct supertype *st, char *mddev,
                                           "array_state", "readonly") < 0) {
                                 pr_err("Failed to start array: %s\n",
                                        strerror(errno));
-                               ioctl(mdfd, STOP_ARRAY, NULL);
                                 goto abort;
                         }
                 } else {
@@ -1028,7 +1024,6 @@ int Create(struct supertype *st, char *mddev,
                                 if (info.array.chunk_size & 
(info.array.chunk_size-1)) {
                                         cont_err("Problem may be that 
chunk size is not a power of 2\n");
                                 }
-                               ioctl(mdfd, STOP_ARRAY, NULL);
                                 goto abort;
                         }
                         /* if start_ro module parameter is set, array is
@@ -1065,7 +1060,11 @@ int Create(struct supertype *st, char *mddev,
         map_remove(&map, fd2devnm(mdfd));
         map_unlock(&map);

-       if (mdfd >= 0)
+       if (mdfd >= 0) {
+               /* Give udev a moment to finish 'add' events. */
+               usleep(100*1000);
+               ioctl(mdfd, STOP_ARRAY, NULL);
                 close(mdfd);
+       }
         return 1;
  }


Thanks,
-Zhilong

> Jes
>
>
>

