From: David Chow <davidchow@shaolinmicro.com>
Subject: Re: RAID-1 does not rebuild after hot-add
Date: Tue, 05 Aug 2003 19:58:39 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F2F9BEF.7080104@shaolinmicro.com>
References: <3F2D1FAC.9030905@shaolinmicro.com>	<16173.43804.617586.906225@gargle.gargle.HOWL>	<3F2E8CAE.7090208@shaolinmicro.com>	<16175.4992.765886.291774@gargle.gargle.HOWL>	<3F2F4F7F.6010801@shaolinmicro.com> <16175.21583.621336.653083@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
>
>>
>>OK, I find out there is a problem in the superblock which is descrbed as 
>>follows. The "Total Devices" is wrong. It should be 2 instead of 3. This 
>>is probably a bug of the mkraid (from raidtools) which when I created 
>>the array with a "failed-disk" in degraded mode. mkraid incorrectly made 
>>a wrong superblock even I put "nr-raid-disk 2" and "nr-spare-disks 0" in 
>>the raidtab. Ok, the superblock is incorrect, but how can I change the 
>>total devices and spare device pramaters without re-initialize the
>>array?
>>    
>>
>
>It is actuallt "Active Devices" that is the problem.  As this is the
>same as "Raid Devices", it doesn't bother doing a reconstruction.
>
>The following patch adds --update=summaries to mdadm-1.3.0, which
>updates the various summary fields in the superblock (Total, Active,
>Working, Failed, Spare - Devices).
>It is untested but should work.
>If you patch mdadm-1.3.0 and compile it, then
>
>  mdadm --assemble /dev/md2 --update=summaries /dev/sda3 /dev/sdb3
>
>then it should update these fields and start the array (you might need
>a --run as well).
>
>Let me know how it goes.
>
>  
>
The point is my root is on  md2 . I can never reassemble the RAID 
devices. This is just the same of using a --force with mkraid of mdadm 
with reassemble . There seems no other way to update buggy superblocks 
online or even do something with reboot? Can I just modify the field and 
reset the machine after a "sync"?

David

