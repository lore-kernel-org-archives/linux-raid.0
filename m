From: David Chow <davidchow@shaolinmicro.com>
Subject: Re: RAID-1 does not rebuild after hot-add
Date: Tue, 05 Aug 2003 00:34:22 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F2E8B0E.6060007@shaolinmicro.com>
References: <3F2D1FAC.9030905@shaolinmicro.com> <1059929757.6751.60.camel@ralph.plexio.private>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Stephen Lee <splee@plexio.com>
Cc: Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>
>
>>[root@www2 root]# cat /proc/mdstat
>>Personalities : [raid1]
>>read_ahead 1024 sectors
>>md0 : active raid1 sdb1[1] sda1[0]
>>      104320 blocks [2/2] [UU]
>>     
>>md1 : active raid1 sdb2[1] sda2[0]
>>      1052160 blocks [2/2] [UU]
>>     
>>md2 : active raid1 sdb3[1]
>>      3076352 blocks [2/1] [_U]
>>     
>>md3 : active raid1 sdb5[1]
>>      1052160 blocks [2/1] [_U]
>>     
>>md4 : active raid1 sdb6[1]
>>      12635008 blocks [2/1] [_U]
>>    
>>
><snip>
>
>Did you try:
>mdadm /dev/md2 -a /dev/sda3
>mdadm /dev/md3 -a /dev/sda5
>mdadm /dev/md4 -a /dev/sda6
>  
>
Already tried. I notice this problem happens in Redhat distributions 
since 7.3 to 9 . When attempting to hot add disks, it doesn't rebuild. I 
am wondering are there ioctls that I can call the md to start rebuild 
without having to wait for an auto rebuild action.

My previous experience is the only way to fix is to freshly mkraid the 
array. I guess something wrong with the super block.

If I can manually dd a superblock into the new disks, I am fool the md 
driver to make it look like already in the array. However, I think I 
have to edit the event count and reboot the machine. Please suggests 
directions.

regards,
David Chow

>If this doesn't work then what are the exact error messages?
>
>Stephen
>  
>

