From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: Drive fails & raid6 array is not self rebuild .
Date: Thu, 8 Sep 2005 20:15:36 -0600 (MDT)
Message-ID: <Pine.LNX.4.63.0509082011460.31748@filesrv1.baby-dragons.com>
References: <60F5F1E2B94AD4119F0B00B0D0215FFF01A69F99@bsc.tt.umist.ac.uk>
 <Pine.LNX.4.63.0509081247060.29776@filesrv1.baby-dragons.com>
 <17184.43156.113155.811612@cse.unsw.edu.au>
 <Pine.LNX.4.63.0509081525380.30261@filesrv1.baby-dragons.com>
 <17184.56377.773388.978710@cse.unsw.edu.au>
 <Pine.LNX.4.63.0509082000030.31748@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.63.0509082000030.31748@filesrv1.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Neil ,
On Thu, 8 Sep 2005, Mr. James W. Laferriere wrote:
> On Fri, 9 Sep 2005, Neil Brown wrote:
>> On Thursday September 8, babydr@baby-dragons.com wrote:
>>>  	When I try to do the remove I get .
>>> root@devel-0:/ # mdadm /dev/md_d0 --remove /dev/sdao
>>> mdadm: hot remove failed for /dev/sdao: Device or resource busy
>>>
>>>  	I should also have 3 other drives that are spares .  I could
>>>  	try hot remove on one of them .  See at bottom the output of
>>>  	mdadm --misc -Q --detail /dev/md_d0
>>>  	Which is showing no spare drives ?  And I built it with 4
>>>  	spares
>> 
>> Yes... /dev/sda[pqrs] are missing.  I wonder why..
>> 
>> What does
>>   mdadm -E /dev/sda[pqrs]
>> show?
> 	See way below .
>
>> What happens if you then
>>  mdadm /dev/md_d0 -a /dev/sda[pqrs]
>> ??
>
> 	Getting stranger & stranger .
>
> root@devel-0:~ # mdadm /dev/md_d0 -a /dev/sda[pqrs]
> mdadm: re-added /dev/sdap

 	Is there any debugging ouptions I can enable from the
 	boot: prompt or compile in ?

 	just some more info ...  Hth ,  JimL

# dmesg | tail -n 43
RAID5 conf printout:
  --- rd:36 wd:35 fd:1
  disk 0, o:1, dev:sdc
  disk 1, o:1, dev:sdd
  disk 3, o:1, dev:sdf
  disk 4, o:1, dev:sdg
  disk 5, o:1, dev:sdh
  disk 6, o:1, dev:sdi
  disk 7, o:1, dev:sdj
  disk 8, o:1, dev:sdk
  disk 9, o:1, dev:sdl
  disk 10, o:1, dev:sdn
  disk 11, o:1, dev:sdo
  disk 12, o:1, dev:sdp
  disk 13, o:1, dev:sdq
  disk 14, o:1, dev:sdr
  disk 15, o:1, dev:sds
  disk 16, o:1, dev:sdt
  disk 17, o:1, dev:sdu
  disk 18, o:1, dev:sdv
  disk 19, o:1, dev:sdw
  disk 20, o:1, dev:sdy
  disk 21, o:1, dev:sdz
  disk 22, o:1, dev:sdaa
  disk 23, o:1, dev:sdab
  disk 24, o:1, dev:sdac
  disk 25, o:1, dev:sdad
  disk 26, o:1, dev:sdae
  disk 27, o:1, dev:sdaf
  disk 28, o:1, dev:sdag
  disk 29, o:1, dev:sdah
  disk 30, o:1, dev:sdaj
  disk 31, o:1, dev:sdak
  disk 32, o:1, dev:sdal
  disk 33, o:1, dev:sdam
  disk 34, o:1, dev:sdan
  disk 35, o:1, dev:sdao
md: cannot remove active disk sdao from md_d0 ...
md: cannot remove active disk sdao from md_d0 ...
md: bind<sdap>
md: bind<sdaq>
md: bind<sdar>
md: bind<sdas>

-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network        Engineer | 3542 Broken Yoke Dr. |  Give me Linux  |
| babydr@baby-dragons.com | Billings , MT. 59105 |   only  on  AXP |
+------------------------------------------------------------------+
