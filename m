From: XiaoNi <xni@redhat.com>
Subject: Re: RAID1 removing failed disk returns EBUSY
Date: Wed, 10 Jun 2015 14:26:41 +0800
Message-ID: <5577D8A1.9060605@redhat.com>
References: <20141027162748.593451be@jlaw-desktop.mno.stratus.com> <20150115082210.31bd3ea5@jlaw-desktop.mno.stratus.com> <2054919975.10444188.1421385612513.JavaMail.zimbra@redhat.com> <20150116101031.30c04df3@jlaw-desktop.mno.stratus.com> <1924199853.11308787.1421634830810.JavaMail.zimbra@redhat.com> <20150129145217.1cb31d5c@notabene.brown> <371504811.2053160.1422533656432.JavaMail.zimbra@redhat.com> <20150202173601.1ab02927@notabene.brown> <1914953233.3814567.1422951056539.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1914953233.3814567.1422951056539.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Joe Lawrence <joe.lawrence@stratus.com>, linux-raid@vger.kernel.org, Bill Kuzeja <william.kuzeja@stratus.com>
List-Id: linux-raid.ids



On 02/03/2015 04:10 PM, Xiao Ni wrote:
>
> ----- Original Message -----
>> From: "NeilBrown" <neilb@suse.de>
>> To: "Xiao Ni" <xni@redhat.com>
>> Cc: "Joe Lawrence" <joe.lawrence@stratus.com>, linux-raid@vger.kerne=
l.org, "Bill Kuzeja" <william.kuzeja@stratus.com>
>> Sent: Monday, February 2, 2015 2:36:01 PM
>> Subject: Re: RAID1 removing failed disk returns EBUSY
>>
>> On Thu, 29 Jan 2015 07:14:16 -0500 (EST) Xiao Ni <xni@redhat.com> wr=
ote:
>>
>>>
>>> ----- Original Message -----
>>>> From: "NeilBrown" <neilb@suse.de>
>>>> To: "Xiao Ni" <xni@redhat.com>
>>>> Cc: "Joe Lawrence" <joe.lawrence@stratus.com>,
>>>> linux-raid@vger.kernel.org, "Bill Kuzeja" <william.kuzeja@stratus.=
com>
>>>> Sent: Thursday, January 29, 2015 11:52:17 AM
>>>> Subject: Re: RAID1 removing failed disk returns EBUSY
>>>>
>>>> On Sun, 18 Jan 2015 21:33:50 -0500 (EST) Xiao Ni <xni@redhat.com> =
wrote:
>>>>
>>>>>
>>>>> ----- Original Message -----
>>>>>> From: "Joe Lawrence" <joe.lawrence@stratus.com>
>>>>>> To: "Xiao Ni" <xni@redhat.com>
>>>>>> Cc: "NeilBrown" <neilb@suse.de>, linux-raid@vger.kernel.org, "Bi=
ll
>>>>>> Kuzeja" <william.kuzeja@stratus.com>
>>>>>> Sent: Friday, January 16, 2015 11:10:31 PM
>>>>>> Subject: Re: RAID1 removing failed disk returns EBUSY
>>>>>>
>>>>>> On Fri, 16 Jan 2015 00:20:12 -0500
>>>>>> Xiao Ni <xni@redhat.com> wrote:
>>>>>>> Hi Joe
>>>>>>>
>>>>>>>     Thanks for reminding me. I didn't do that. Now it can remov=
e
>>>>>>>     successfully after writing
>>>>>>> "idle" to sync_action.
>>>>>>>
>>>>>>>     I thought wrongly that the patch referenced in this mail is
>>>>>>>     fixed
>>>>>>>     for
>>>>>>>     the problem.
>>>>>> So it sounds like even with 3.18 and a new mdadm, this bug still
>>>>>> persists?
>>>>>>
>>>>>> -- Joe
>>>>>>
>>>>>> --
>>>>> Hi Joe
>>>>>
>>>>>     I'm a little confused now. Does the patch
>>>>>     45eaf45dfa4850df16bc2e8e7903d89021137f40 from linux-stable
>>>>> resolve the problem?
>>>>>
>>>>>     My environment is:
>>>>>
>>>>> [root@dhcp-12-133 mdadm]# mdadm --version
>>>>> mdadm - v3.3.2-18-g93d3bd3 - 18th December 2014  (this is the new=
est
>>>>> upstream)
>>>>> [root@dhcp-12-133 mdadm]# uname -r
>>>>> 3.18.2
>>>>>
>>>>>
>>>>>     My steps are:
>>>>>
>>>>> [root@dhcp-12-133 mdadm]# lsblk
>>>>> sdb                       8:16   0 931.5G  0 disk
>>>>> =E2=94=94=E2=94=80sdb1                    8:17   0     5G  0 part
>>>>> sdc                       8:32   0 186.3G  0 disk
>>>>> sdd                       8:48   0 931.5G  0 disk
>>>>> =E2=94=94=E2=94=80sdd1                    8:49   0     5G  0 part
>>>>> [root@dhcp-12-133 mdadm]# mdadm -CR /dev/md0 -l1 -n2 /dev/sdb1
>>>>> /dev/sdd1
>>>>> --assume-clean
>>>>> mdadm: Note: this array has metadata at the start and
>>>>>      may not be suitable as a boot device.  If you plan to
>>>>>      store '/boot' on this device please ensure that
>>>>>      your boot-loader understands md/v1.x metadata, or use
>>>>>      --metadata=3D0.90
>>>>> mdadm: Defaulting to version 1.2 metadata
>>>>> mdadm: array /dev/md0 started.
>>>>>
>>>>>     Then I unplug the disk.
>>>>>
>>>>> [root@dhcp-12-133 mdadm]# lsblk
>>>>> sdc                       8:32   0 186.3G  0 disk
>>>>> sdd                       8:48   0 931.5G  0 disk
>>>>> =E2=94=94=E2=94=80sdd1                    8:49   0     5G  0 part
>>>>>    =E2=94=94=E2=94=80md0                   9:0    0     5G  0 rai=
d1
>>>>> [root@dhcp-12-133 mdadm]# echo faulty >
>>>>> /sys/block/md0/md/dev-sdb1/state
>>>>> [root@dhcp-12-133 mdadm]# echo remove >
>>>>> /sys/block/md0/md/dev-sdb1/state
>>>>> -bash: echo: write error: Device or resource busy
>>>>> [root@dhcp-12-133 mdadm]# echo idle > /sys/block/md0/md/sync_acti=
on
>>>>> [root@dhcp-12-133 mdadm]# echo remove >
>>>>> /sys/block/md0/md/dev-sdb1/state
>>>>>
>>>> I cannot reproduce this - using linux 3.18.2.  I'd be surprised if=
 mdadm
>>>> version affects things.
>>> Hi Neil
>>>
>>>     I'm very curious, because it can reproduce in my machine 100%.
>>>
>>>> This error (Device or resoource busy) implies that rdev->raid_disk=
 is >=3D
>>>> 0
>>>> (tested in state_store()).
>>>>
>>>> ->raid_disk is set to -1 by remove_and_add_spares() providing:
>>>>    1/ it isn't Blocked (which is very unlikely)
>>>>    2/ hot_remove_disk succeeds, which it will if nr_pending is zer=
o, and
>>>>    3/ nr_pending is zero.
>>>     I remember I have tired to check those reasons. But it's really=
 is the
>>>     reason 1
>>> which is very unlikely.
>>>
>>>     I add some code in the function array_state_show
>>>
>>>      array_state_show(struct mddev *mddev, char *page) {
>>>          enum array_state st =3D inactive;
>>>          struct md_rdev *rdev;
>>>
>>>          rdev_for_each_rcu(rdev, mddev) {
>>>                  printk(KERN_ALERT "search for %s\n",
>>>                  rdev->bdev->bd_disk->disk_name);
>>>                  if (test_bit(Blocked, &rdev->flags))
>>>                          printk(KERN_ALERT "rdev is Blocked\n");
>>>                  else
>>>                          printk(KERN_ALERT "rdev is not Blocked\n")=
;
>>>      }
>>>
>>>    When I echo 1 > /sys/block/sdc/device/delete, then I ran command=
:
>>>
>>> [root@dhcp-12-133 md]# cat /sys/block/md0/md/array_state
>>> read-auto
>>    ^^^^^^^^^
>>
>> I think that is half the explanation.
>> You must have the md_mod.start_ro parameter set to '1'.
>>
>>
>>> [root@dhcp-12-133 md]# dmesg
>>> [ 2679.559185] search for sdc
>>> [ 2679.559189] rdev is Blocked
>>> [ 2679.559190] search for sdb
>>> [ 2679.559190] rdev is not Blocked
>>>    =20
>>>    So sdc is Blocked
>> and that is the other half - thanks.
>> (yes, I was wrong.  Sometimes it is easier than being right, but sti=
ll
>> yields results).
>>
>> When a device fails, it is Blocked until the metadata is updated to =
record
>> the failure.  This ensures that no writes succeed without writing to=
 that
>> device, until we a certain that no read will try reading from that d=
evice,
>> even after a crash/restart.
>>
>> Blocked is cleared after the metadata is written, but read-auto (and
>> read-only) devices never write out their metadata.  So blocked doesn=
't get
>> cleared.
>>
>> When you "echo idle > .../sync_action" one of the side effects is to=
 with
>> from 'read-auto' to fully active.  This allows the metadata to be wr=
itten,
>> Blocked to be cleared, and the device to be removed.
>>
>> If you
>>    echo none > /sys/block/md0/md/dev-sdc/slot
>>
>> first, then the remove will work.
>>
>> We could possibly fix it with something like the following, but I'm =
not sure
>> I like it.  There is no guarantee that I can see which would ensure =
the
>> superblock got updated before the first write if the array switch to
>> read/write.
>>
>> NeilBrown
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 9233c71138f1..b3d1e8e5e067 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -7528,7 +7528,7 @@ static int remove_and_add_spares(struct mddev =
*mddev,
>>   	rdev_for_each(rdev, mddev)
>>   		if ((this =3D=3D NULL || rdev =3D=3D this) &&
>>   		    rdev->raid_disk >=3D 0 &&
>> -		    !test_bit(Blocked, &rdev->flags) &&
>> +		    (!test_bit(Blocked, &rdev->flags) || mddev->ro) &&
>>   		    (test_bit(Faulty, &rdev->flags) ||
>>   		     ! test_bit(In_sync, &rdev->flags)) &&
>>   		    atomic_read(&rdev->nr_pending)=3D=3D0) {
>>
>>
>>
> Hi Neil
>
>     I have tried the patch and the problem can be fixed by it. But I'=
m sorry that I can't
> give more advices for better idea about this. I'm not familiar with t=
he metadata part about
> the md. I'll try to get more time to read the code about md.
>
Hi Neil

     I don't see the patch in linux-stable, do you miss this?

Best Regards
Xiao
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
