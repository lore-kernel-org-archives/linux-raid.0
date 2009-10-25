From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: md: md3 still in use.
Date: Sun, 25 Oct 2009 09:46:01 -0800 (AKDT)
Message-ID: <alpine.LNX.2.01.0910250944060.27885@filesrv1.baby-dragons.com>
References: <alpine.LNX.2.01.0910250932510.27885@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.01.0910250932510.27885@filesrv1.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello All ,  Soory about replying to myself ,  But here is some 
additional info .

On Sun, 25 Oct 2009, Mr. James W. Laferriere wrote:
> 	Hello All ,  What am I doing wrong here ?
>
> root@(none):~ # cat /etc/mdadm.conf | grep -i md3
> # /dev/md3      UUID : f537313e:c87bf407:76d83ddb:96d0fcbc (20081019)
> ARRAY /dev/md3 level=raid6 metadata=0.90 
> UUID=f537313e:c87bf407:76d83ddb:96d0fcbc
>
>
> root@(none):~ # cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] 
> [multipath]
> md10 : active raid1 sda1[0]
>      34298688 blocks [2/1] [U_]
>
> md11 : active raid1 sda2[0] sdb2[1]
>      256896 blocks [2/2] [UU]
>
> md12 : active raid1 sda3[0] sdb3[1]
>      987904 blocks [2/2] [UU]
>
> unused devices: <none>
>
>
> root@(none):~ # mdadm -A /dev/md3
> md: md3 still in use.
> mdadm: no devices found for /dev/md3
>
>
> root@(none):~ # mdadm --manage -S /dev/md3
> md: md3 stopped.
> mdadm: stopped /dev/md3
>
>
> root@(none):~ # mdadm -A /dev/md3
> md: md3 still in use.
> mdadm: no devices found for /dev/md3
>
>
> root@(none):~ # cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] 
> [multipath]
> md10 : active raid1 sda1[0]
>      34298688 blocks [2/1] [U_]
>
> md11 : active raid1 sda2[0] sdb2[1]
>      256896 blocks [2/2] [UU]
>
> md12 : active raid1 sda3[0] sdb3[1]
>      987904 blocks [2/2] [UU]
>
> unused devices: <none>

  root@(none):~ # dmesg | grep -i md3
md: md3 still in use.
--
md: md3 still in use.
md: md3 has zero or unknown size, marking faulty!
md: error, md_import_device() returned -22
--
md: md3 stopped.
md: md3 still in use.
--
md: md3 has zero or unknown size, marking faulty!
md: error, md_import_device() returned -22
--
md: md3 still in use.
md: md3 stopped.
md: md3 still in use.


-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 2133    McCullam Ave |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99701 |   only  on  AXP |
+------------------------------------------------------------------+
