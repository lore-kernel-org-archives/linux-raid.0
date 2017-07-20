From: Bogo Mipps <bogo.mipps@gmail.com>
Subject: Re: Advice please re failed Raid6
Date: Thu, 20 Jul 2017 15:59:41 +1200
Message-ID: <84473722-a72a-3da8-fcaa-ae6203b76b1f@gmail.com>
References: <9dca5b7a-b60e-0e93-41fd-49d092d8b27b@gmail.com>
 <22892.649.826246.644975@tree.ty.sabi.co.uk>
 <f79a45b9-590b-4d3c-d387-81abfb02743d@gmail.com>
 <22895.21096.215892.928052@tree.ty.sabi.co.uk>
Reply-To: bogo.mipps@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22895.21096.215892.928052@tree.ty.sabi.co.uk>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.UK>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/20/2017 12:36 AM, Peter Grandi wrote:
>> Did I do it right? (See below)
> 
>> root@keruru:~# mdadm --create --assume-clean --level=6 --raid-devices=4
>> --size=1953382912 /dev/md0 missing /dev/sdc /dev/sdd /dev/sde
>> mdadm: /dev/sdc appears to be part of a raid array:
>>       level=raid6 devices=4 ctime=Tue Jul 11 17:33:12 2017
>> mdadm: /dev/sdd appears to be part of a raid array:
>>       level=raid6 devices=4 ctime=Tue Jul 11 17:33:12 2017
>> mdadm: /dev/sde appears to be part of a raid array:
>>       level=raid6 devices=4 ctime=Tue Jul 11 17:33:12 2017
>> Continue creating array? y
>> mdadm: Defaulting to version 1.2 metadata
>> mdadm: array /dev/md0 started.
> 
> This looks good, but is based on your original '--examine'
> report as to the order of the devices, and whether they are
> still bound to the same names 'sd[bcde]'.
> 
>> root@keruru:~# blkid /dev/md0
> 
>> root@keruru:~# cat /proc/mdstat
>> Personalities : [raid6] [raid5] [raid4]
>> md0 : active (auto-read-only) raid6 sde[3] sdd[2] sdc[1]
>>         3906765824 blocks super 1.2 level 6, 512k chunk, algorithm 2
>> [4/3] [_UUU]
> 
>> unused devices: <none>
> 
> The 'mdstat' actually looks good, but 'blkid' should have
> worked.
> 
> As I was saying, it is not clear to me whether the 'mdadm' daemon
> instance triggered a 'check' or a 'repair' (bad news). I hope
> that you disabled that in the meantime while you try to fix the
> mistake.
> 
> Trigger a 'check' and see if the set is consistent; if it is
> consistent but the content cannot be read/mounted then 'repair'
> rewrote it, if it is not consistent, try a different order or
> 3-way subset of 'sd[bcde]'.

Tried different order: sde, sdc, sdd. blkid worked. Added sdb as you 
suggested.  Currently rebuilding. Log below. Fingers crossed. Will 
report result.

  root@keruru:~# mdadm --create --assume-clean --level=6 
--raid-devices=4 /dev/md0 /dev/sde /dev/sdc /dev/sdd missing
mdadm: /dev/sde appears to be part of a raid array:
     level=raid6 devices=4 ctime=Wed Jul 19 13:40:04 2017
mdadm: /dev/sdc appears to be part of a raid array:
     level=raid6 devices=4 ctime=Wed Jul 19 13:40:04 2017
mdadm: /dev/sdd appears to be part of a raid array:
     level=raid6 devices=4 ctime=Wed Jul 19 13:40:04 2017
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
root@keruru:~# blkid
/dev/sda1: UUID="3a26cce9-4598-4000-a921-1cde5ba78682" TYPE="ext4"
/dev/sda5: UUID="9761c2be-fef2-4ec6-8fff-dd69aa9e4eb2" TYPE="swap"
/dev/sdd: UUID="ca038387-a44e-2bb8-c2fd-abe8e9062ffd" 
UUID_SUB="8e502cd5-74ef-7b15-1bc3-6f2465e7a695" LABEL="keruru:0" 
TYPE="linux_raid_member"
/dev/sdc: UUID="ca038387-a44e-2bb8-c2fd-abe8e9062ffd" 
UUID_SUB="aeb6626b-3dc2-3fa8-0fd5-947081866c49" LABEL="keruru:0" 
TYPE="linux_raid_member"
/dev/sde: UUID="ca038387-a44e-2bb8-c2fd-abe8e9062ffd" 
UUID_SUB="bfff697b-c3ae-9e70-9ca9-ba168a30cbd2" LABEL="keruru:0" 
TYPE="linux_raid_member"

root@keruru:~# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active (auto-read-only) raid6 sdd[2] sdc[1] sde[0]
       3906765824 blocks super 1.2 level 6, 512k chunk, algorithm 2 
[4/3] [UUU_]
unused devices: <none>

root@keruru:~# mdadm --add /dev/md0 /dev/sdb
mdadm: added /dev/sdb

root@keruru:~# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sdb[4] sdd[2] sdc[1] sde[0]
       3906765824 blocks super 1.2 level 6, 512k chunk, algorithm 2 
[4/3] [UUU_]
       [>....................]  recovery =  0.0% (1258088/1953382912) 
finish=413.7min speed=78630K/sec

unused devices: <none>
root@keruru:~#


