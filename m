From: Sharif Islam <mislam@uiuc.edu>
Subject: recreate superblock? (was Re: mdadm: failed to RUN_ARRAY)
Date: Mon, 11 Oct 2004 11:16:33 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <416AB1E1.1070605@uiuc.edu>
References: <4168064D.3050903@uiuc.edu> <4168140A.6070300@uiuc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4168140A.6070300@uiuc.edu>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is there any way to regain the superblock? I mistakenly did a 
--zero-superblock on /dev/hdi and /dev/hdk
/dev/hdi is one of the bad one, but I think it is not totally gone. So I 
was trying to force it.

[root@pep root]# mdadm -A /dev/md0 --force /dev/hd[efghi]1
mdadm: no RAID superblock on /dev/hdi1
mdadm: /dev/hdi1 has no superblock - assembly aborted

I would appreciate some hints. Thanks.
-Sharif


Sharif Islam wrote:

> Ok, more on this. I think two of my RAID drives failed. and after  I
> posted the email below, I did something that I am guessign I shouldn't 
> have.
>
> mdadm --zero-superblock /dev/hdk1
> mdadm --zero-superblock /dev/hdi1
>
> Should I try recreating the array in degrading mode.
>
> mdadm --create /dev/md0 --level=5 /dev/hde1 /dev/hdf1 /dev/hdg1 
> /dev/hdh1 missing
>
> But I think that only works with one failed device.
> -Sharif
>
>
> Sharif Islam wrote:
>
>> One of my RAID 5 stopped last night.  I get this when I try to
>> restart it:
>> [root@pep raid]# mdadm -A /dev/md0
>> mdadm: device 5 in /dev/md0 has wrong state in superblock, but 
>> /dev/hdk1 seems ok
>> mdadm: failed to RUN_ARRAY /dev/md0: Invalid argument
>>
>> Is my hdk1 gone. Should I try to replace that?
>>
>> from dmesg:
>>
>> Oct  9 10:36:04 pep kernel: md: export_rdev(hdf1)
>> Oct  9 10:36:04 pep kernel:  [events: 0000000b]
>> Oct  9 10:36:04 pep kernel: md: bind<hdf1,1>
>> Oct  9 10:36:04 pep kernel:  [events: 0000000b]
>> Oct  9 10:36:04 pep kernel: md: bind<hdg1,2>
>> Oct  9 10:36:04 pep kernel:  [events: 0000000b]
>> Oct  9 10:36:04 pep kernel: md: bind<hdh1,3>
>> Oct  9 10:36:04 pep kernel:  [events: 00000009]
>> Oct  9 10:36:04 pep kernel: md: bind<hdi1,4>
>> Oct  9 10:36:04 pep kernel:  [events: 0000000a]
>> Oct  9 10:36:04 pep kernel: md: bind<hdk1,5>
>> Oct  9 10:36:04 pep kernel:  [events: 0000000b]
>> Oct  9 10:36:04 pep kernel: md: bind<hde1,6>
>> Oct  9 10:36:04 pep kernel: md: hde1's event counter: 0000000b
>> Oct  9 10:36:04 pep kernel: md: hdk1's event counter: 0000000a
>> Oct  9 10:36:04 pep kernel: md: hdi1's event counter: 00000009
>> Oct  9 10:36:04 pep kernel: md: hdh1's event counter: 0000000b
>> Oct  9 10:36:04 pep kernel: md: hdg1's event counter: 0000000b
>> Oct  9 10:36:04 pep kernel: md: hdf1's event counter: 0000000b
>> Oct  9 10:36:04 pep kernel: md: superblock update time inconsistency 
>> -- using the most recent one
>> Oct  9 10:36:04 pep kernel: md: freshest: hde1
>> Oct  9 10:36:04 pep kernel: md: kicking non-fresh hdi1 from array!
>> Oct  9 10:36:04 pep kernel: md: unbind<hdi1,5>
>> Oct  9 10:36:04 pep kernel: md: export_rdev(hdi1)
>> Oct  9 10:36:04 pep kernel: md0: removing former faulty hdi1!
>> Oct  9 10:36:04 pep kernel: md0: kicking faulty hdk1!
>> Oct  9 10:36:04 pep kernel: md: unbind<hdk1,4>
>> Oct  9 10:36:04 pep kernel: md: export_rdev(hdk1)
>> Oct  9 10:36:04 pep kernel: md: md0: raid array is not clean -- 
>> starting background reconstruction
>> Oct  9 10:36:04 pep kernel: md0: max total readahead window set to 2560k
>> Oct  9 10:36:04 pep kernel: md0: 5 data-disks, max readahead per 
>> data-disk: 512k
>> Oct  9 10:36:04 pep kernel: raid5: device hde1 operational as raid 
>> disk 0
>> Oct  9 10:36:04 pep kernel: raid5: device hdh1 operational as raid 
>> disk 3
>> Oct  9 10:36:04 pep kernel: raid5: device hdg1 operational as raid 
>> disk 2
>> Oct  9 10:36:04 pep kernel: raid5: device hdf1 operational as raid 
>> disk 1
>> Oct  9 10:36:04 pep kernel: raid5: not enough operational devices for 
>> md0 (2/6 failed)
>> Oct  9 10:36:04 pep kernel: RAID5 conf printout:
>> Oct  9 10:36:04 pep kernel:  --- rd:6 wd:4 fd:2
>> Oct  9 10:36:04 pep kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:hde1
>> Oct  9 10:36:04 pep kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:hdf1
>> Oct  9 10:36:04 pep kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:hdg1
>> Oct  9 10:36:04 pep kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:hdh1
>> Oct  9 10:36:04 pep kernel:  disk 4, s:0, o:0, n:4 rd:4 us:1 dev:[dev 
>> 00:00]
>> Oct  9 10:36:04 pep kernel:  disk 5, s:0, o:0, n:5 rd:5 us:1 dev:[dev 
>> 00:00]
>> Oct  9 10:36:04 pep kernel: raid5: failed to run raid set md0
>> Oct  9 10:36:04 pep kernel: md: pers->run() failed ...
>> Oct  9 10:36:04 pep kernel: md: md0 stopped.
>> Oct  9 10:36:04 pep kernel: md: unbind<hde1,3>
>> Oct  9 10:36:04 pep kernel: md: export_rdev(hde1)
>> Oct  9 10:36:04 pep kernel: md: unbind<hdh1,2>
>> Oct  9 10:36:04 pep kernel: md: export_rdev(hdh1)
>> Oct  9 10:36:04 pep kernel: md: unbind<hdg1,1>
>> Oct  9 10:36:04 pep kernel: md: export_rdev(hdg1)
>> Oct  9 10:36:04 pep kernel: md: unbind<hdf1,0>
>> Oct  9 10:36:04 pep kernel: md: export_rdev(hdf1)
>>
>> [root@pep raid]# cat /proc/mdstat
>> Personalities : [raid5]
>> read_ahead not set
>> unused devices: <none
>>
>> Thanks.
>> -Sharif
>>
>>
>
>

