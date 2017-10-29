From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: create new workqueue for object destruction
Date: Mon, 30 Oct 2017 09:18:11 +1100
Message-ID: <873761d2e4.fsf@notabene.neil.brown.name>
References: <87mv4qjrez.fsf@notabene.neil.brown.name> <20171018062137.ssdhwkeoy6fdp7yq@kernel.org> <87h8uwj4mz.fsf@notabene.neil.brown.name> <6454f28e-4728-a10d-f3c3-b68afedec8d9@intel.com> <87376ghyms.fsf@notabene.neil.brown.name> <9759b574-2d3f-de45-0840-c84d9cc10528@intel.com> <87wp3qg4bi.fsf@notabene.neil.brown.name> <06d5ab0c-f669-6c9f-3f0a-930cea5c893b@intel.com> <87y3o2ep54.fsf@notabene.neil.brown.name> <169c257d-0ae7-b721-3954-713522dd0ccd@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <169c257d-0ae7-b721-3954-713522dd0ccd@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Shaohua Li <shli@kernel.org>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 27 2017, Artur Paszkiewicz wrote:

> On 10/23/2017 01:31 AM, NeilBrown wrote:
>> On Fri, Oct 20 2017, Artur Paszkiewicz wrote:
>>=20
>>> On 10/20/2017 12:28 AM, NeilBrown wrote:
>>>> On Thu, Oct 19 2017, Artur Paszkiewicz wrote:
>>>>
>>>>> On 10/19/2017 12:36 AM, NeilBrown wrote:
>>>>>> On Wed, Oct 18 2017, Artur Paszkiewicz wrote:
>>>>>>
>>>>>>> On 10/18/2017 09:29 AM, NeilBrown wrote:
>>>>>>>> On Tue, Oct 17 2017, Shaohua Li wrote:
>>>>>>>>
>>>>>>>>> On Tue, Oct 17, 2017 at 04:04:52PM +1100, Neil Brown wrote:
>>>>>>>>>>
>>>>>>>>>> lockdep currently complains about a potential deadlock
>>>>>>>>>> with sysfs access taking reconfig_mutex, and that
>>>>>>>>>> waiting for a work queue to complete.
>>>>>>>>>>
>>>>>>>>>> The cause is inappropriate overloading of work-items
>>>>>>>>>> on work-queues.
>>>>>>>>>>
>>>>>>>>>> We currently have two work-queues: md_wq and md_misc_wq.
>>>>>>>>>> They service 5 different tasks:
>>>>>>>>>>
>>>>>>>>>>   mddev->flush_work                       md_wq
>>>>>>>>>>   mddev->event_work (for dm-raid)         md_misc_wq
>>>>>>>>>>   mddev->del_work (mddev_delayed_delete)  md_misc_wq
>>>>>>>>>>   mddev->del_work (md_start_sync)         md_misc_wq
>>>>>>>>>>   rdev->del_work                          md_misc_wq
>>>>>>>>>>
>>>>>>>>>> We need to call flush_workqueue() for md_start_sync and ->event_=
work
>>>>>>>>>> while holding reconfig_mutex, but mustn't hold it when
>>>>>>>>>> flushing mddev_delayed_delete or rdev->del_work.
>>>>>>>>>>
>>>>>>>>>> md_wq is a bit special as it has WQ_MEM_RECLAIM so it is
>>>>>>>>>> best to leave that alone.
>>>>>>>>>>
>>>>>>>>>> So create a new workqueue, md_del_wq, and a new work_struct,
>>>>>>>>>> mddev->sync_work, so we can keep two classes of work separate.
>>>>>>>>>>
>>>>>>>>>> md_del_wq and ->del_work are used only for destroying rdev
>>>>>>>>>> and mddev.
>>>>>>>>>> md_misc_wq is used for event_work and sync_work.
>>>>>>>>>>
>>>>>>>>>> Also document the purpose of each flush_workqueue() call.
>>>>>>>>>>
>>>>>>>>>> This removes the lockdep warning.
>>>>>>>>>
>>>>>>>>> I had the exactly same patch queued internally,
>>>>>>>>
>>>>>>>> Cool :-)
>>>>>>>>
>>>>>>>>>                                                   but the mdadm t=
est suite still
>>>>>>>>> shows lockdep warnning. I haven't time to check further.
>>>>>>>>>
>>>>>>>>
>>>>>>>> The only other lockdep I've seen later was some ext4 thing, though=
 I
>>>>>>>> haven't tried the full test suite.  I might have a look tomorrow.
>>>>>>>
>>>>>>> I'm also seeing a lockdep warning with or without this patch,
>>>>>>> reproducible with:
>>>>>>>
>>>>>>
>>>>>> Thanks!
>>>>>> Looks like using one workqueue for mddev->del_work and rdev->del_work
>>>>>> causes problems.
>>>>>> Can you try with this addition please?
>>>>>
>>>>> It helped for that case but now there is another warning triggered by:
>>>>>
>>>>> export IMSM_NO_PLATFORM=3D1 # for platforms without IMSM
>>>>> mdadm -C /dev/md/imsm0 -eimsm -n4 /dev/sd[a-d] -R
>>>>> mdadm -C /dev/md/vol0 -l5 -n4 /dev/sd[a-d] -R --assume-clean
>>>>> mdadm -If sda
>>>>> mdadm -a /dev/md127 /dev/sda
>>>>> mdadm -Ss
>>>>
>>>> I tried that ... and mdmon gets a SIGSEGV.
>>>> imsm_set_disk() calls get_imsm_disk() and gets a NULL back.
>>>> It then passes the NULL to mark_failure() and that dereferences it.
>>>
>>> Interesting... I can't reproduce this. Can you show the output from
>>> mdadm -E for all disks after mdmon crashes? And maybe a debug log from
>>> mdmon?
>>=20
>> The crash happens when I run "mdadm -If sda".
>> gdb tell me:
>>=20
>> Thread 2 "mdmon" received signal SIGSEGV, Segmentation fault.
>> [Switching to Thread 0x7f5526c24700 (LWP 4757)]
>> 0x000000000041601c in is_failed (disk=3D0x0) at super-intel.c:1324
>> 1324		return (disk->status & FAILED_DISK) =3D=3D FAILED_DISK;
>> (gdb) where
>> #0  0x000000000041601c in is_failed (disk=3D0x0) at super-intel.c:1324
>> #1  0x00000000004255a2 in mark_failure (super=3D0x65fa30, dev=3D0x660ba0=
,=20
>>     disk=3D0x0, idx=3D0) at super-intel.c:7973
>> #2  0x00000000004260e8 in imsm_set_disk (a=3D0x6635d0, n=3D0, state=3D17)
>>     at super-intel.c:8357
>> #3  0x0000000000405069 in read_and_act (a=3D0x6635d0, fds=3D0x7f5526c23e=
10)
>>     at monitor.c:551
>> #4  0x0000000000405c8e in wait_and_act (container=3D0x65f010, nowait=3D0)
>>     at monitor.c:875
>> #5  0x0000000000405dc7 in do_monitor (container=3D0x65f010) at monitor.c=
:906
>> #6  0x0000000000403037 in run_child (v=3D0x65f010) at mdmon.c:85
>> #7  0x00007f5526fcb494 in start_thread (arg=3D0x7f5526c24700)
>>     at pthread_create.c:333
>> #8  0x00007f5526d0daff in clone ()
>>     at ../sysdeps/unix/sysv/linux/x86_64/clone.S:97
>>=20
>> The super-disks list that get_imsm_dl_disk() looks through contains
>> sdc, sdd, sde, but not sda - so get_imsm_disk() returns NULL.
>> (the 4 devices I use are sda sdc sde sde).
>>  mdadm --examine of sda and sdc after the crash are below.
>>  mdmon debug output is below that.
>
> Thank you for the information. The metadata output shows that there is
> something wrong with sda. Is there anything different about this device?
> The other disks are 10M QEMU SCSI drives, is sda the same? Can you
> check its serial e.g. with sg_inq?

sdc, sdd, and sde are specified to qemu with

       -hdb /var/tmp/mdtest10 \
       -hdc /var/tmp/mdtest11 \
       -hdd /var/tmp/mdtest12 \

sda comes from
       -drive file=3D/var/tmp/mdtest13,if=3Dscsi,index=3D3,media=3Ddisk -s

/var/tmp/mdtest* are simple raw images, 10M each.

sg_inq report sd[cde] as
  Vendor: ATA
  Product: QEMU HARDDISK
  Serial: QM0000[234]

sda is
  Vendor: QEMU
  Product: QEMU HARDDISK
  no serial number.


If I change my script to use
       -drive file=3D/var/tmp/mdtest13,if=3Dscsi,index=3D3,serial=3DQM00009=
,media=3Ddisk -s

for sda, mdmon doesn't crash.  It may well be reasonable to refuse to
work with a device that has no serial number.  It is not very friendly
to crash :-(

Thanks,
NeilBrown

>
> Thanks,
> Artur
>
>>=20
>> Thanks,
>> NeilBrown
>>=20
>>=20
>> /dev/sda:
>>           Magic : Intel Raid ISM Cfg Sig.
>>         Version : 1.2.02
>>     Orig Family : 0a44d090
>>          Family : 0a44d090
>>      Generation : 00000002
>>      Attributes : All supported
>>            UUID : 9897925b:e497e1d9:9af0a04a:88429b8b
>>        Checksum : 56aeb059 correct
>>     MPB Sectors : 2
>>           Disks : 4
>>    RAID Devices : 1
>>=20
>> [vol0]:
>>            UUID : 89a43a61:a39615db:fe4a4210:021acc13
>>      RAID Level : 5
>>         Members : 4
>>           Slots : [UUUU]
>>     Failed disk : none
>>       This Slot : ?
>>     Sector Size : 512
>>      Array Size : 36864 (18.00 MiB 18.87 MB)
>>    Per Dev Size : 12288 (6.00 MiB 6.29 MB)
>>   Sector Offset : 0
>>     Num Stripes : 48
>>      Chunk Size : 128 KiB
>>        Reserved : 0
>>   Migrate State : idle
>>       Map State : normal
>>     Dirty State : clean
>>      RWH Policy : off
>>=20
>>   Disk00 Serial :=20
>>           State : active
>>              Id : 00000000
>>     Usable Size : 36028797018957662
>>=20
>>   Disk01 Serial : QM00002
>>           State : active
>>              Id : 01000100
>>     Usable Size : 14174 (6.92 MiB 7.26 MB)
>>=20
>>   Disk02 Serial : QM00003
>>           State : active
>>              Id : 02000000
>>     Usable Size : 14174 (6.92 MiB 7.26 MB)
>>=20
>>   Disk03 Serial : QM00004
>>           State : active
>>              Id : 02000100
>>     Usable Size : 14174 (6.92 MiB 7.26 MB)
>>=20
>> /dev/sdc:
>>           Magic : Intel Raid ISM Cfg Sig.
>>         Version : 1.2.02
>>     Orig Family : 0a44d090
>>          Family : 0a44d090
>>      Generation : 00000004
>>      Attributes : All supported
>>            UUID : 9897925b:e497e1d9:9af0a04a:88429b8b
>>        Checksum : 56b1b08e correct
>>     MPB Sectors : 2
>>           Disks : 4
>>    RAID Devices : 1
>>=20
>>   Disk01 Serial : QM00002
>>           State : active
>>              Id : 01000100
>>     Usable Size : 14174 (6.92 MiB 7.26 MB)
>>=20
>> [vol0]:
>>            UUID : 89a43a61:a39615db:fe4a4210:021acc13
>>      RAID Level : 5
>>         Members : 4
>>           Slots : [_UUU]
>>     Failed disk : 0
>>       This Slot : 1
>>     Sector Size : 512
>>      Array Size : 36864 (18.00 MiB 18.87 MB)
>>    Per Dev Size : 12288 (6.00 MiB 6.29 MB)
>>   Sector Offset : 0
>>     Num Stripes : 48
>>      Chunk Size : 128 KiB
>>        Reserved : 0
>>   Migrate State : idle
>>       Map State : degraded
>>     Dirty State : clean
>>      RWH Policy : off
>>=20
>>   Disk00 Serial : 0
>>           State : active failed
>>              Id : ffffffff
>>     Usable Size : 36028797018957662
>>=20
>>   Disk02 Serial : QM00003
>>           State : active
>>              Id : 02000000
>>     Usable Size : 14174 (6.92 MiB 7.26 MB)
>>=20
>>   Disk03 Serial : QM00004
>>           State : active
>>              Id : 02000100
>>     Usable Size : 14174 (6.92 MiB 7.26 MB)
>>=20
>> mdmon: mdmon: starting mdmon for md127
>> mdmon: __prep_thunderdome: mpb from 8:0 prefer 8:48
>> mdmon: __prep_thunderdome: mpb from 8:32 matches 8:48
>> mdmon: __prep_thunderdome: mpb from 8:64 matches 8:32
>> monitor: wake ( )
>> monitor: wake ( )
>> ....
>> monitor: wake ( )
>> monitor: wake ( )
>> monitor: wake ( )
>> mdmon: manage_new: inst: 0 action: 25 state: 26
>> mdmon: imsm_open_new: imsm: open_new 0
>>=20
>> mdmon: wait_and_act: monitor: caught signal
>> mdmon: read_and_act: (0): 1508714952.508532 state:write-pending prev:ina=
ctive action:idle prev: idle start:18446744073709551615
>> mdmon: imsm_set_array_state: imsm: mark 'dirty'
>> mdmon: imsm_set_disk: imsm: set_disk 0:11
>>=20
>> Thread 2 "mdmon" received signal SIGSEGV, Segmentation fault.
>> 0x00000000004168f1 in is_failed (disk=3D0x0) at super-intel.c:1324
>> 1324		return (disk->status & FAILED_DISK) =3D=3D FAILED_DISK;
>> (gdb) where
>> #0  0x00000000004168f1 in is_failed (disk=3D0x0) at super-intel.c:1324
>> #1  0x0000000000426bec in mark_failure (super=3D0x667a30, dev=3D0x668ba0=
,=20
>>     disk=3D0x0, idx=3D0) at super-intel.c:7973
>> #2  0x000000000042784b in imsm_set_disk (a=3D0x66b9b0, n=3D0, state=3D17)
>>     at super-intel.c:8357
>> #3  0x000000000040520c in read_and_act (a=3D0x66b9b0, fds=3D0x7ffff7617e=
10)
>>     at monitor.c:551
>> #4  0x00000000004061aa in wait_and_act (container=3D0x667010, nowait=3D0)
>>     at monitor.c:875
>> #5  0x00000000004062e3 in do_monitor (container=3D0x667010) at monitor.c=
:906
>> #6  0x0000000000403037 in run_child (v=3D0x667010) at mdmon.c:85
>> #7  0x00007ffff79bf494 in start_thread (arg=3D0x7ffff7618700)
>>     at pthread_create.c:333
>> #8  0x00007ffff7701aff in clone ()
>>     at ../sysdeps/unix/sysv/linux/x86_64/clone.S:97
>> (gdb) quit
>> A debugging session is active.
>>=20
>> 	Inferior 1 [process 5774] will be killed.
>>=20
>> Quit anyway? (y or n) ty
>> Please answer y or n.
>> A debugging session is active.
>>=20
>> 	Inferior 1 [process 5774] will be killed.
>>=20
>> Quit anyway? (y or n) y
>>=20
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAln2U6UACgkQOeye3VZi
gbkkXA//UXEraZT5Vre71b4VetmRCXOTD/wOk5n5i9s/hjBy79D0Wpefeh2xWbis
7wim1FuKFRh6YpnCMm48GpfyVTHL02iw+4KbwUfsNWghAIrUAEmg4+nmkx+h0hRy
3Y0mWk6Vjkxg4tBu6UjlnZ1oCHGssWC263BeuIh/T5F7Fylgco2QhA7G2pAX1sAP
q/8TFNDr+6dWJlPCcDmVLtif14LiwIV9d2XbjZ8SU11dQUAc+70IDBiVwFjHO/Ce
JcEbu/qyTOhAaerd7eihZSP4C63HZDBA7dBgFvt68mzHf3i4rPTsgdkNBb1/5KSn
Ydl0oAqXI0BrHSlJvaZIpOtQIfSB2w7osRuidHCYR17Vfg3HAjKNeZLygXMELLzS
zZRc1hUxOh/o4Pimx/nAd9W7yiY4k1I+9Mza5USuJ9vhniWxJJxuOjcNp8BjhR3Q
yFNwHl2LjIzk70gRIMwkZ4AsT71hjEA09gcXNxFZR/2DLhoYAqU/N0EwBcyQ7j6B
dRV+vVPQrm+0IvryWdXebFlodpp9Bt/wHrJX5BIgqy+G8n2GfXZKtECpAmnbWx8J
XGndUUjd0K7h1FJJiUdkjHDh7YelKuLkomio0pKwhrKLUps1ldpBwi5ykRdGerSF
eVB4fHsHYdtbECMGxJ/H3LBwVNcTY64GE4xtaQ0DsrcuYa04j84=
=ZFjD
-----END PGP SIGNATURE-----
--=-=-=--
