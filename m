From: XiaoNi <xni@redhat.com>
Subject: Re: raid5 reshape is stuck
Date: Fri, 29 May 2015 19:13:38 +0800
Message-ID: <556849E2.7030405@redhat.com>
References: <1612858661.15347659.1431671671467.JavaMail.zimbra@redhat.com>	<427651758.4121803.1432637303447.JavaMail.zimbra@redhat.com>	<20150527100253.221ab553@notabene.brown>	<20150527111004.5f136f23@notabene.brown>	<2129908770.5092770.1432726084717.JavaMail.zimbra@redhat.com>	<20150527213449.6e017deb@notabene.brown>	<476656362.5105083.1432728264276.JavaMail.zimbra@redhat.com>	<20150528085958.0f95e323@notabene.brown>	<45685228.5717919.1432794771906.JavaMail.zimbra@redhat.com> <20150528164923.2cd4af02@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150528164923.2cd4af02@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 05/28/2015 02:49 PM, NeilBrown wrote:
> On Thu, 28 May 2015 02:32:51 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:
>
>>
>> ----- Original Message -----
>>> From: "NeilBrown" <neilb@suse.de>
>>> To: "Xiao Ni" <xni@redhat.com>
>>> Cc: linux-raid@vger.kernel.org
>>> Sent: Thursday, May 28, 2015 6:59:58 AM
>>> Subject: Re: raid5 reshape is stuck
>>>
>>> On Wed, 27 May 2015 08:04:24 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:
>>>
>>>>
>>>> ----- Original Message -----
>>>>> From: "NeilBrown" <neilb@suse.de>
>>>>> To: "Xiao Ni" <xni@redhat.com>
>>>>> Cc: linux-raid@vger.kernel.org
>>>>> Sent: Wednesday, May 27, 2015 7:34:49 PM
>>>>> Subject: Re: raid5 reshape is stuck
>>>>>
>>>>> On Wed, 27 May 2015 07:28:04 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:
>>>>>
>>>>>
>>>>>> [root@intel-waimeabay-hedt-01 mdadm]# cat
>>>>>> /usr/lib/systemd/system/mdadm-grow-continue\@.service
>>>>>> #  This file is part of mdadm.
>>>>>> #
>>>>>> #  mdadm is free software; you can redistribute it and/or modify it
>>>>>> #  under the terms of the GNU General Public License as published by
>>>>>> #  the Free Software Foundation; either version 2 of the License, or
>>>>>> #  (at your option) any later version.
>>>>>>
>>>>>> [Unit]
>>>>>> Description=Manage MD Reshape on /dev/%I
>>>>>> DefaultDependencies=no
>>>>>>
>>>>>> [Service]
>>>>>> ExecStart=/usr/sbin/mdadm --grow --continue /dev/%I
>>>>>> --backup-file=/root/tmp0
>>>>> Please remove the ---backup-file=/root/tmp0 for further testing.  The
>>>>> patch I
>>>>> provided should make that unnecessary.
>>>>>
>>>>>> StandardInput=null
>>>>>> StandardOutput=null
>>>>>> StandardError=null
>>>>> Could you try removing these - that might allow error messages to appear.
>>>>> I wonder why I included them - they shouldn't be needed.
>>>>>
>>>>> Thanks,
>>>>> NeilBrown
>>>>>
>>>>>
>>>> [root@intel-waimeabay-hedt-01 mdadm]# mdadm -CR /dev/md0 -l5 -n4
>>>> /dev/loop[0-3] --assume-clean
>>>> mdadm: /dev/loop0 appears to be part of a raid array:
>>>>         level=raid5 devices=5 ctime=Wed May 27 02:45:08 2015
>>>> mdadm: /dev/loop1 appears to be part of a raid array:
>>>>         level=raid5 devices=5 ctime=Wed May 27 02:45:08 2015
>>>> mdadm: /dev/loop2 appears to be part of a raid array:
>>>>         level=raid5 devices=5 ctime=Wed May 27 02:45:08 2015
>>>> mdadm: /dev/loop3 appears to be part of a raid array:
>>>>         level=raid5 devices=5 ctime=Wed May 27 02:45:08 2015
>>>> mdadm: Defaulting to version 1.2 metadata
>>>> mdadm: array /dev/md0 started.
>>>> [root@intel-waimeabay-hedt-01 mdadm]# mdadm /dev/md0 -a /dev/loop4
>>>> mdadm: added /dev/loop4
>>>> [root@intel-waimeabay-hedt-01 mdadm]# mdadm --grow /dev/md0
>>>> --raid-devices=5
>>>> mdadm: Need to backup 6144K of critical section..
>>>> [root@intel-waimeabay-hedt-01 mdadm]# cat /proc/mdstat
>>>> Personalities : [raid6] [raid5] [raid4]
>>>> md0 : active raid5 loop4[4] loop3[3] loop2[2] loop1[1] loop0[0]
>>>>        1532928 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/5]
>>>>        [UUUUU]
>>>>        [>....................]  reshape =  0.0% (0/510976) finish=532.2min
>>>>        speed=0K/sec
>>>>        
>>>> unused devices: <none>
>>>> [root@intel-waimeabay-hedt-01 mdadm]# cat
>>>> /usr/lib/systemd/system/mdadm-grow-continue\@.service
>>>> #  This file is part of mdadm.
>>>> #
>>>> #  mdadm is free software; you can redistribute it and/or modify it
>>>> #  under the terms of the GNU General Public License as published by
>>>> #  the Free Software Foundation; either version 2 of the License, or
>>>> #  (at your option) any later version.
>>>>
>>>> [Unit]
>>>> Description=Manage MD Reshape on /dev/%I
>>>> DefaultDependencies=no
>>>>
>>>> [Service]
>>>> ExecStart=/usr/sbin/mdadm --grow --continue /dev/%I
>>>> #StandardInput=null
>>>> #StandardOutput=null
>>>> #StandardError=null
>>>> KillMode=none
>>>>
>>>>
>>>> The problem still exist. And there are messages in /var/log/messages
>>>>
>>>> May 27 08:03:29 intel-waimeabay-hedt-01 systemd:
>>>> mdadm-grow-continue@md0.service: main process exited, code=exited,
>>>> status=1/FAILURE
>>>> May 27 08:03:29 intel-waimeabay-hedt-01 systemd: Unit
>>>> mdadm-grow-continue@md0.service entered failed state.
>>>>
>>> Does
>>>    systemctl status -l mdadm-grow-continue@md0.service
>>>
>>> report anything different.  That was the result I expected from removing the
>>> Standard*=null lines.
>>>
>>> I assume the new mdadm is installed in /usr/sbin/mdadm.
>>>
>>> Thanks,
>>> NeilBrown
>>>
>> Yes! There are some new messages:
>> [root@intel-waimeabay-hedt-01 ~]# systemctl status -l mdadm-grow-continue@md0.service
>> mdadm-grow-continue@md0.service - Manage MD Reshape on /dev/md0
>>     Loaded: loaded (/usr/lib/systemd/system/mdadm-grow-continue@.service; static)
>>     Active: failed (Result: exit-code) since Thu 2015-05-28 02:30:50 EDT; 2s ago
>>    Process: 26618 ExecStart=/usr/sbin/mdadm --grow --continue /dev/%I (code=exited, status=1/FAILURE)
>>   Main PID: 26618 (code=exited, status=1/FAILURE)
>>
>> May 28 02:30:50 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com systemd[1]: Started Manage MD Reshape on /dev/md0.
>> May 28 02:30:50 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com mdadm[26618]: mdadm: Need to backup 6144K of critical section..
>> May 28 02:30:50 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com mdadm[26618]: mdadm: array: cannot open component /dev/vcs6
>> May 28 02:30:50 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com systemd[1]: mdadm-grow-continue@md0.service: main process exited, code=exited, status=1/FAILURE
>> May 28 02:30:50 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com systemd[1]: Unit mdadm-grow-continue@md0.service entered failed state.
> any idea why it cannot open it?
>
> The message is probably coming from reshape_prepare_fdlist()
> Could you get those "pr_err"s to print out errno as well?
> The device really has to exist, because mdadm has managed to find that name
> in /dev.  Could this be a 'selinux' related issue?  I can only think that it
> might be a permission problem but root shouldn't have those.
>
> Thanks,
> NeilBrown
Sorry for late reply. It can get so much knowledge from one problem. As 
you said, it's really the permission problem.

May 29 06:47:41 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com 
mdadm[28636]: mdadm: array: cannot open component /dev/vcs6
May 29 06:47:41 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com 
mdadm[28636]: mdadm: errno is 13, err is Permission denied

And it's really the problem about selinux. The patch works after the 
command "setenforce 0". It need the patch you gave.  Is it right
to setenforce 0 every time? I'll read the doc about selinux.

Best Regards
Xiao

