From: Albert Pauw <albert.pauw@gmail.com>
Subject: Re: ddf failed disk disappears after adding spare
Date: Wed, 1 Aug 2012 19:27:19 +0200
Message-ID: <CAGkViCHZxyP-1GdhYs3x=J1=WxECjqskZQcaY2i8uy04Ns_Kpg@mail.gmail.com>
References: <5018E8FF.6030402@gmail.com>
	<CAGkViCGWjF=YZ4BWRxwXRw0ER4XmMPA9HN35twDmEzt+X_uX2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGkViCGWjF=YZ4BWRxwXRw0ER4XmMPA9HN35twDmEzt+X_uX2g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Sorry again,

just noticed that the removing of the slot of the missing drive is
triggered by a rebuild. In fact, even a failed (but not missing) drive
is removed as well.

I noticed this by the following:

- started with 6 disks
- created md0 with 5 disks
- failed one disk in md0
- the mdadm -E table is shown very shortly with 6 disks, one failed,
but when the rebuild kicks in, the failed disk entry is removed, 5
entries remain.



Albert

On 1 August 2012 18:46, Albert Pauw <albert.pauw@gmail.com> wrote:
> Hi Neil,
>
> looking at it again I think the following happened:
>
> When the disk was removed, the entry got the status "missing", which is correct.
> When I re-added the same disk (actually I used add, re-add doesn't
> work with containers) the "missing" status isn't cleared, as can be
> seen.
> But it is recognised as belonging to its original slot, albeit the
> missing status isn't cleared, the other status (failed, offline) can
> stay as they are.
>
> When I now add another disk (a spare) the slot of the missing disk is
> re-used, as it is marked "missing". Only by removing that disk,
> zeroing
> the superblock and adding it again, i.e. effectively adding a new
> disk, the total amount of slots is increased to 6.
>
>
>
> just my two cents,
>
> Albert
>
> On 1 August 2012 10:29, Albert Pauw <albert.pauw@gmail.com> wrote:
>> Hi Neil,
>>
>> here is a procedure which shows you another problem. It has to do with the
>> table produced at the end of the mdadm -E command, showing the disks and
>> their status. Seems when a disk has failed and another added, the failed one
>> disappears.
>>
>> Hope you can find the problem and fix it.
>>
>> Regards,
>>
>> Albert
>>
>> Here is the exact procedure which shows the problem:
>>
>> Create a container with 5 disks:
>>
>> mdadm -CR /dev/md127 -e ddf -l container -n 5 /dev/loop[1-5]
>>
>>  Physical Disks : 5
>>       Number    RefNo      Size       Device      Type/State
>>          0    d1c8c16e    479232K /dev/loop1 Global-Spare/Online
>>          1    6de79cb6    479232K /dev/loop2 Global-Spare/Online
>>          2    b5fd1d6c    479232K /dev/loop3 Global-Spare/Online
>>          3    0be2d310    479232K /dev/loop4 Global-Spare/Online
>>          4    5d8ac3d0    479232K /dev/loop5 Global-Spare/Online
>>
>>
>> Create a RAID 5 set of 3 disks in container:
>>
>> mdadm -CR /dev/md0 -l 5 -n 3 /dev/md127
>>
>> Physical Disks : 5
>>       Number    RefNo      Size       Device      Type/State
>>          0    d1c8c16e    479232K /dev/loop1      active/Online
>>          1    6de79cb6    479232K /dev/loop2      active/Online
>>          2    b5fd1d6c    479232K /dev/loop3      active/Online
>>          3    0be2d310    479232K /dev/loop4 Global-Spare/Online
>>          4    5d8ac3d0    479232K /dev/loop5 Global-Spare/Online
>>
>>
>> Create a RAID 1 set of 2 disks in container:
>>
>> mdadm -CR /dev/md1 -l 1 -n 2 /dev/md127
>>
>> Physical Disks : 5
>>       Number    RefNo      Size       Device      Type/State
>>          0    d1c8c16e    479232K /dev/loop1      active/Online
>>          1    6de79cb6    479232K /dev/loop2      active/Online
>>          2    b5fd1d6c    479232K /dev/loop3      active/Online
>>          3    0be2d310    479232K /dev/loop4      active/Online
>>          4    5d8ac3d0    479232K /dev/loop5      active/Online
>>
>>
>> Fail first disk in RAID 5 set:
>>
>> mdadm -f /dev/md0 /dev/loop1
>>
>> Physical Disks : 5
>>       Number    RefNo      Size       Device      Type/State
>>          0    d1c8c16e    479232K /dev/loop1      active/Offline, Failed
>>          1    6de79cb6    479232K /dev/loop2      active/Online
>>          2    b5fd1d6c    479232K /dev/loop3      active/Online
>>          3    0be2d310    479232K /dev/loop4      active/Online
>>          4    5d8ac3d0    479232K /dev/loop5      active/Online
>>
>>
>> Remove failed disk:
>>
>> mdadm -r /dev/md0 /dev/loop1
>>
>> Physical Disks : 5
>>       Number    RefNo      Size       Device      Type/State
>>          0    d1c8c16e    479232K                 active/Offline, Failed, Missing
>>          1    6de79cb6    479232K /dev/loop2      active/Online
>>          2    b5fd1d6c    479232K /dev/loop3      active/Online
>>          3    0be2d310    479232K /dev/loop4      active/Online
>>          4    5d8ac3d0    479232K /dev/loop5      active/Online
>>
>>
>> Add failed disk back:
>>
>> mdadm -a --force /dev/md0 /dev/loop1
>>
>> Physical Disks : 5
>>       Number    RefNo      Size       Device      Type/State
>>          0    d1c8c16e    479232K /dev/loop1      active/Offline, Failed, Missing
>>          1    6de79cb6    479232K /dev/loop2      active/Online
>>          2    b5fd1d6c    479232K /dev/loop3      active/Online
>>          3    0be2d310    479232K /dev/loop4      active/Online
>>          4    5d8ac3d0    479232K /dev/loop5      active/Online
>>
>>
>> Add spare disk to container:
>>
>> mdadm -a --force /dev/md0 /dev/loop6
>>
>> Physical Disks : 5
>>       Number    RefNo      Size       Device      Type/State
>>          0    6de79cb6    479232K /dev/loop2      active/Online
>>          1    b5fd1d6c    479232K /dev/loop3      active/Online
>>          2    0be2d310    479232K /dev/loop4      active/Online
>>          3    5d8ac3d0    479232K /dev/loop5      active/Online
>>          4    1dcfe3cf    479232K /dev/loop6      active/Online, Rebuilding
>>
>> This is wrong! Physical disks should be 6 now!
>>
>> Removed failed disk (which is missing from list now!) again, zero superblock
>> and add again:
>>
>> mdadm -r /dev/md0 /dev/loop1
>> mdadm --zero-superblock /dev/loop1
>> mdadm -a --force /dev/md0 /dev/loop1
>>
>>
>> Physical Disks : 6
>>       Number    RefNo      Size       Device      Type/State
>>          0    6de79cb6    479232K /dev/loop2      active/Online
>>          1    b5fd1d6c    479232K /dev/loop3      active/Online
>>          2    0be2d310    479232K /dev/loop4      active/Online
>>          3    5d8ac3d0    479232K /dev/loop5      active/Online
>>          4    1dcfe3cf    479232K /dev/loop6      active/Online
>>          5    8147a3ef    479232K /dev/loop1 Global-Spare/Online
>>
>> And there they are, all 6 of them.
>>
>>
