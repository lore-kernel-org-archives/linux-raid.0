From: Bogo Mipps <bogo.mipps@gmail.com>
Subject: Re: Advice please re failed Raid6
Date: Fri, 21 Jul 2017 12:44:18 +1200
Message-ID: <ea81b594-9da1-4efb-2c6d-3bf50cf9e3e9@gmail.com>
References: <9dca5b7a-b60e-0e93-41fd-49d092d8b27b@gmail.com>
 <22892.649.826246.644975@tree.ty.sabi.co.uk>
 <f79a45b9-590b-4d3c-d387-81abfb02743d@gmail.com>
 <22895.21096.215892.928052@tree.ty.sabi.co.uk>
 <cf9aac00-91b3-3cb5-bceb-df5d7113b933@gmail.com>
Reply-To: bogo.mipps@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cf9aac00-91b3-3cb5-bceb-df5d7113b933@gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.UK>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/20/2017 03:55 PM, Bogo Mipps wrote:
> On 07/20/2017 12:36 AM, Peter Grandi wrote:
>>> Did I do it right? (See below)
>>
>>> root@keruru:~# mdadm --create --assume-clean --level=6 --raid-devices=4
>>> --size=1953382912 /dev/md0 missing /dev/sdc /dev/sdd /dev/sde
>>> mdadm: /dev/sdc appears to be part of a raid array:
>>>       level=raid6 devices=4 ctime=Tue Jul 11 17:33:12 2017
>>> mdadm: /dev/sdd appears to be part of a raid array:
>>>       level=raid6 devices=4 ctime=Tue Jul 11 17:33:12 2017
>>> mdadm: /dev/sde appears to be part of a raid array:
>>>       level=raid6 devices=4 ctime=Tue Jul 11 17:33:12 2017
>>> Continue creating array? y
>>> mdadm: Defaulting to version 1.2 metadata
>>> mdadm: array /dev/md0 started.
>>
>> This looks good, but is based on your original '--examine'
>> report as to the order of the devices, and whether they are
>> still bound to the same names 'sd[bcde]'.
>>
>>> root@keruru:~# blkid /dev/md0
>>
>>> root@keruru:~# cat /proc/mdstat
>>> Personalities : [raid6] [raid5] [raid4]
>>> md0 : active (auto-read-only) raid6 sde[3] sdd[2] sdc[1]
>>>         3906765824 blocks super 1.2 level 6, 512k chunk, algorithm 2
>>> [4/3] [_UUU]
>>
>>> unused devices: <none>
>>
>> The 'mdstat' actually looks good, but 'blkid' should have
>> worked.
>>
>> As I was saying, it is not clear to me whether the 'mdadm' daemon
>> instance triggered a 'check' or a 'repair' (bad news). I hope
>> that you disabled that in the meantime while you try to fix the
>> mistake.
>>
>> Trigger a 'check' and see if the set is consistent; if it is
>> consistent but the content cannot be read/mounted then 'repair'
>> rewrote it, if it is not consistent, try a different order or
>> 3-way subset of 'sd[bcde]'.
> 
> Tried different order: sde, sdc, sdd and blkid worked. Added sdb as you 
> suggested.  Currently rebuilding. Log below. Fingers crossed. Will 
> report result.

Peter, here is where I come unstuck.  Where to from here? Raid6 has 
rebuilt, apparently successfully, but I can't mount. I hesitate to make 
another move without advice ...

root@keruru:~# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sdb[4] sdd[2] sdc[1] sde[0]
       3906765824 blocks super 1.2 level 6, 512k chunk, algorithm 2 
[4/3] [UUU_]
       [=============>.......]  recovery = 69.3% (1353992192/1953382912) 
finish=162.5min speed=61440K/sec

unused devices: <none>

root@keruru:~# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sdb[4] sdd[2] sdc[1] sde[0]
       3906765824 blocks super 1.2 level 6, 512k chunk, algorithm 2 
[4/4] [UUUU]

unused devices: <none>

root@keruru:/# mount /dev/md0 /mnt/md0
mount: you must specify the filesystem type

root@keruru:/# mount -t ext4 /dev/md0 /mnt/md0
mount: wrong fs type, bad option, bad superblock on /dev/md0,
        missing codepage or helper program, or other error
        In some cases useful info is found in syslog - try
        dmesg | tail  or so

root@keruru:/# dmesg | tail
[29458.547966] RAID conf printout:
[29458.547981]  --- level:6 rd:4 wd:4
[29458.547989]  disk 0, o:1, dev:sde
[29458.547995]  disk 1, o:1, dev:sdc
[29458.548001]  disk 2, o:1, dev:sdd
[29458.548007]  disk 3, o:1, dev:sdb
[48138.300934] EXT4-fs (md0): VFS: Can't find ext4 filesystem
[48138.301411] EXT4-fs (md0): VFS: Can't find ext4 filesystem
[48138.301856] EXT4-fs (md0): VFS: Can't find ext4 filesystem
[48155.451147] EXT4-fs (md0): VFS: Can't find ext4 filesystem

