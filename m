From: Maurice Hilarius <maurice@harddata.com>
Subject: Re: strange RAID5 problem
Date: Tue, 09 May 2006 10:16:25 -0600
Message-ID: <4460C059.3070304@harddata.com>
References: <4460290C.50202@harddata.com> <20060509055824.GB22085@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060509055824.GB22085@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Luca Berra wrote:
> On Mon, May 08, 2006 at 11:30:52PM -0600, Maurice Hilarius wrote:
>> [root@box ~]# mdadm /dev/md3 -a /dev/sdw1
>>
>> But, I get this error message:
>> mdadm: hot add failed for /dev/sdw1: No such device
>>
>> What? We just made the partition on sdw a moment ago in fdisk. It IS
>> there!
>
> I don't believe you, prove it (/proc/partitions)
>
>
I understand. Here we go then. Devices in question bracketed with "**":

[root@box ~]# cat /proc/partitions
major minor  #blocks  name

   3     0  117220824 hda
   3     1     104391 hda1
   3     2    2008125 hda2
   3     3  115105725 hda3
   3    64  117220824 hdb
   3    65     104391 hdb1
   3    66    2008125 hdb2
   3    67  115105725 hdb3
   8     0  390711384 sda
   8     1  390708801 sda1
   8    16  390711384 sdb
   8    17  390708801 sdb1
   8    32  390711384 sdc
   8    33  390708801 sdc1
   8    48  390711384 sdd
   8    49  390708801 sdd1
   8    64  390711384 sde
   8    65  390708801 sde1
   8    80  390711384 sdf
   8    81  390708801 sdf1
   8    96  390711384 sdg
   8    97  390708801 sdg1
   8   112  390711384 sdh
   8   113  390708801 sdh1
   8   128  390711384 sdi
   8   129  390708801 sdi1
   8   144  390711384 sdj
   8   145  390708801 sdj1
   8   160  390711384 sdk
   8   161  390708801 sdk1
   8   176  390711384 sdl
   8   177  390708801 sdl1
   8   192  390711384 sdm
   8   193  390708801 sdm1
   8   208  390711384 sdn
   8   209  390708801 sdn1
   8   224  390711384 sdo
   8   225  390708801 sdo1
   8   240  390711384 sdp
   8   241  390708801 sdp1
  65     0  390711384 sdq
  65     1  390708801 sdq1
  65    16  390711384 sdr
  65    17  390708801 sdr1
  65    32  390711384 sds
  65    33  390708801 sds1
  65    48  390711384 sdt
  65    49  390708801 sdt1
  65    64  390711384 sdu
  65    65  390708801 sdu1
  65    80  390711384 sdv
  65    81  390708801 sdv1
**
  65    96  390711384 sdw
  65    97  390708801 sdw1
**
  65   112  390711384 sdx
  65   113  390708801 sdx1
  65   128  390711384 sdy
  65   129  390708801 sdy1
  65   144  390711384 sdz
  65   145  390708801 sdz1
  65   160  390711384 sdaa
  65   161  390708801 sdaa1
  65   176  390711384 sdab
  65   177  390708801 sdab1
  65   192  390711384 sdac
  65   193  390708801 sdac1
  65   208  390711384 sdad
  65   209  390708801 sdad1
  65   224  390711384 sdae
  65   225  390708801 sdae1
  65   240  390711384 sdaf
  65   241  390708801 sdaf1
**
   9     0     104320 md0
**
   9     2 5860631040 md2
   9     1  115105600 md1



-- 

Regards,
	Maurice

