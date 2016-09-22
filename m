From: Axel Spallek <axel@spallek.org>
Subject: Re: RAID5 grow interrupted.
Date: Thu, 22 Sep 2016 20:41:59 +0200
Message-ID: <af2cbd12-ba6c-0e39-ba1d-651feda5d07c@spallek.org>
References: <36947ef9-64e2-f084-4949-476107e2771e@spallek.org>
 <9c618b69-1e84-60a8-d25c-55171058c855@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9c618b69-1e84-60a8-d25c-55171058c855@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here the output:


root@s10:~# mdadm --stop /dev/md1
mdadm: stopped /dev/md1
root@s10:~# cat /proc/mdstat
Personalities :
unused devices: <none>
root@s10:~# mdadm --assemble /dev/md1 /dev/sd[a-h]1
mdadm: /dev/md1: Need a backup file to complete reshape of this array.
mdadm: Please provided one with "--backup-file=..."
root@s10:~# mdadm --assemble /dev/md1 /dev/sd[a-h]1 
--backup-file=/var/backups/mdadm.backup
mdadm: /dev/sda1 is busy - skipping
mdadm: /dev/sdb1 is busy - skipping
mdadm: /dev/sdc1 is busy - skipping
mdadm: /dev/sdd1 is busy - skipping
mdadm: /dev/sde1 is busy - skipping
mdadm: /dev/sdf1 is busy - skipping
mdadm: /dev/sdg1 is busy - skipping
mdadm: /dev/sdh1 is busy - skipping
root@s10:~# cat /proc/mdstat
Personalities :
md1 : inactive sdh1[0](S) sda1[5](S) sdb1[6](S) sdc1[7](S) sdd1[8](S) 
sdf1[4](S) sde1[2](S) sdg1[1](S)
       31255059140 blocks super 1.2

unused devices: <none>


Am 22.09.2016 um 16:27 schrieb Adam Goryachev:
>
>
> On 23/09/2016 00:11, Axel Spallek wrote:
>> Hello there.
>>
>> I did something wrong.
>>
>> I tried to get a disk out of a RAID5 with 8 hdds (4TB) to get a 
>> Hotspare to change to RAID6 afterwards.
>>
>> The RAID was clean and not rebuilding before I started.
>>
>> The partition was only 11TB big. Not yet resized, because not created 
>> with 64Bit, which I wanted to do afterwards.
>>
>> Therefore I issued the following commands:
>>
>> mdadm --grow -n7 /dev/md1  <-- just to get the size for the next 
>> command.
>>
>> mdadm --grow /dev/md1 --array-size 23441292288
>>
>> mdadm --grow -n7 /dev/md1 --backup-file /var/backups/mdadm.backup 
>> UST.-ID.: DE290536647
